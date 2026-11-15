# ADPLL 频率 / 分频比参数化与上限分析

本文回答两个问题：

1. 频率和分频比在 RTL / 宏里是怎么参数化的；
2. 以当前实现和当前 STA 证据，`REF` 与 DCO 输出最多能推到多高。

结论先说：**完整 PLL 有参数化，当前 `PLL_ANALOG_MACRO` 没有**。硬宏只暴露
DCO 控制、`REF` 和注入接口，没有 `FCW`、`SET_DIV`、`OUT_DIV`。所以现在
不能在硬宏上直接验证频率除法；频率除法只在尚未集成的完整 `pll` top 里。

## 1. 参数化入口

### 1.1 反馈分频比 / 频率字

`src/pll.v` 和 `src/pll_logic.v`：

```verilog
parameter integer FCW_BITS = 8;
input [FCW_BITS-1:0] FCW;
```

`src/pll_freq_lock.v`：

```verilog
parameter integer CNT_BITS = 8;
input [CNT_BITS-1:0] FCW;
```

`pll_logic` 把 `FCW_BITS` 传给 freq-lock 的 `CNT_BITS`。freq-lock 在
`MID_OUT` 上计数、每个 `REF` 周期捕获一次，然后和 `FCW` 比较：

```text
cnt_cap ≈ f_MID_OUT / f_REF
target  = FCW
```

因此按 RTL 的真实行为：

```text
N_fb = f_MID_OUT / f_REF = FCW
f_MID_OUT = FCW · f_REF
```

**注意：`src/dlf_design.py` 写的是 `F_VCO=(FCW+1+alpha)·F_REF`，和 RTL 的
`FCW` 作为整数比较目标不一致。** 目前以 RTL 为准：`FCW=16` 才表示 16 倍；
`FCW=15` 是 15 倍。若设计意图是 `FCW+1`，应在 `pll_freq_lock` 里改成
`FCW+1`，或者在顶层把 `FCW` 加一；这两种不能混用。

### 1.2 输出分频

`src/conf_div.v`：

```verilog
module pll_mod_divider #(parameter integer W = 8) (
    input [W-1:0] set_div,
    input load_div,
    output reg out
);
```

`src/pll_logic.v`：

```verilog
parameter integer DIV_BITS = 8;
input [DIV_BITS-1:0] SET_DIV;
output OUT_DIV;
```

`OUT_DIV = OUT / SET_DIV`（名义上）。实际行为有两个边界问题：

- `SET_DIV=0` 被 sanitize 成 1，但 `div==1` 分支是 `out <= ~out`，
  所以 **0 和 1 实际都表现为 /2**；
- `SET_DIV=255` 是 8-bit 最大有效值；`256` 会回绕到 0，再变成 /2。

因此当前 8-bit 的**有效输出分频范围是 2..255**，不是 1..255。
`DIV_BITS` 可以加宽，例如 `DIV_BITS=9` 时最大 511；代价是
`SET_DIV` 端口、比较器/计数器面积增加。

### 1.3 DCO 调谐

`src/pll.v` / `src/pll_analog.v` / `PLL_ANALOG_MACRO`：

```verilog
parameter integer COARSE_NDELS = 15;  // 15 个 coarse 延迟单元
parameter integer MID_NDELS    = 15;  // 15 个 mid 延迟单元
parameter integer FINE_NDELS   = 31;  // 31 个 fine 延迟单元
parameter integer IL_NDELS     = 4;   // 注入链 4 级
```

- `COARSE_MUX` / `MID_MUX` 是 thermometer/移位控制；
- `FINE_MUX` 由 `pll_term_decoder_with_zero` 生成 thermometer 码；
- `FINE_NDELS` 还决定 `$clog2(FINE_NDELS)`，影响
  `FILTER_DEC` 的位宽和 `FILTER_OUT` 的切片；
- 推荐 `NDELS = 2^k - 1`（15、31、63），否则 term decoder 的码可能
  超过实际延迟级数，导致非单调或截断；
- `COARSE_NDELS` / `MID_NDELS` 至少为 2，因为 `pll_freq_lock` 里有
  `MID_NDELS-2` 的复制；
- 改这些参数需要**重新生成模拟宏**（`PLL_ANALOG_MACRO` 的端口宽度、
  LEF/Liberty/GDS 都变），不是运行时寄存器配置。

### 1.4 DSM / 锁定参数

`IS_DSM`、`DSM_DIV`、`DSM_ORDER` 控制 MASH DSM；`DSM_DIV` 只是 DSM 的
时钟分频，不是反馈分频比。`pll_fix_divider` 在 `DIV=1` 时同样执行
`out <= ~out`，所以 `DSM_DIV=1` 实际也是 /2；建议只用 `DSM_DIV>=2`。

`LOCKED_WAIT`（默认 64）、`LOCK_LIMIT`（默认 64）、`ERR_LIMIT`（64）、
`LOCK_TOL`（0）和 `FILTER_ILL`（16）控制锁定判定，不改变 DCO 频率上限。
`LOCKED_WAIT=64` 是 `INJ_EDGE` 周期数；100 MHz REF 时最小 0.64 µs，
REF 越高该等待时间越短。

## 2. 上限公式

对完整 `pll`：

```text
N = FCW,                   1 <= N <= 2^FCW_BITS - 1
f_MID = N · f_REF
f_OUT_DIV = f_OUT / max(2, SET_DIV)
```

实际可用上限不是只有位宽，还要同时满足：

```text
f_REF  <= min(F_REF_domain_max, F_INJ_domain_max, f_MID_max / N)
f_MID  <= min(F_MID_domain_max, F_DCO_analog_max)
N      <= 2^FCW_BITS - 1
```

其中：

- `F_REF_domain_max`：`pll_freq_lock` 的 `REF` 域逻辑最大频率；
- `F_INJ_domain_max`：`INJ_EDGE` 域（状态机、DLF、SS-BBPD 采样）最大频率；
- `F_MID_domain_max`：`MID_OUT` / `OUT` 域数字逻辑最大频率；
- `F_DCO_analog_max`：DCO 延迟链在最短 mux 路径下的模拟上限（未实测）。

## 3. 当前 ics55 证据下的实际上限

来自 `flow/canary/ics55_h7cr_core_a` 的 post-route clock report
（`RUN_2026-10-29_10-21-16`，数字控制 `pll_logic`，TT/SS）：

| 时钟域 | TT Fmax | SS Fmax | 说明 |
|---|---:|---:|---|
| `REF` | 994.87 MHz | 580.16 MHz | freq-lock 的 REF 域 |
| `OUT` | 835.87 MHz | 478.71 MHz | DCO 输出域 / 输出分频器输入 |
| `MID_OUT` | 1002.43 MHz | 640.30 MHz | freq-lock 计数域 |
| `INJ_EDGE` | 452.09 MHz | 243.86 MHz | 状态机 / DLF / SS-BBPD 采样域 |

因此对**当前 ics55 数字控制**：

```text
REF 实际上限 ≈ 452 MHz (TT) / 244 MHz (SS)   # 由 INJ_EDGE 域卡住
DCO/OUT 数字上限 ≈ 836 MHz (TT) / 479 MHz (SS)
MID_OUT 数字上限 ≈ 1002 MHz (TT) / 640 MHz (SS)
```

这里的 `DCO/OUT` 是**数字逻辑能接收的频率上限**，不是 DCO 模拟延迟链的
实测上限；模拟 DCO 可能在硬宏里更高，但目前没有 DCO 频率/调谐范围实测。

### 3.1 1.6 GHz 目标意味着什么

如果 `FCW=16`、`REF=100 MHz`，目标是：

```text
f_MID = 1.6 GHz
```

但当前 ics55 数字 canary 的 `OUT` 域只有 **836 MHz TT / 479 MHz SS**，
`MID_OUT` 也只有 **1002 MHz TT / 640 MHz SS**。所以：

- **1.6 GHz 不能由当前 ics55 `pll_logic` 直接时序收敛**；
- 当前宏级 STA 的 2.5 ns `OUT` 约束（400 MHz）是能收敛的口径，
  不是 1.6 GHz 口径；
- 若要 1.6 GHz，需要更快的标准单元库、对数字控制做流水/重定时，
  或把高频计数/比较拆到更快的域；仅改 `FCW` 不够。

### 3.2 REF 与 DCO 的组合边界

在 ics55 TT 数字上限下：

| 目标 | 可行 N | 说明 |
|---|---:|---|
| `REF=100 MHz`，`OUT<=836 MHz` | `N<=8` | 800 MHz；`N=16` 需要 1.6 GHz，超限 |
| `REF=200 MHz`，`OUT<=836 MHz` | `N<=4` | 800 MHz |
| `REF=400 MHz`，`OUT<=836 MHz` | `N<=2` | 800 MHz |
| `REF=452 MHz`，`N=1` | 452 MHz | `INJ_EDGE` 上限附近 |
| `REF=452 MHz`，`N=2` | 904 MHz | 超过 `OUT` 836 MHz，不可靠 |

所以“REF 和 DCO 同时尽量高”没有无限空间：`f_MID=N·f_REF`，而 `N`、
`REF`、`DCO` 都被 `FCW` 位宽、`INJ_EDGE`/`OUT` 数字 Fmax 和模拟 DCO
上限共同限制。当前最宽的组合是 **低 N、较高 REF**，不是高 REF + 高 N。

### 3.3 输出分频器不改变这些上限

`OUT_DIV` 只把 `OUT` 再分频：

```text
OUT_DIV = OUT / max(2, SET_DIV)
```

它能把输出降到 `OUT/255`，但**不能降低 `MID_OUT`/`OUT` 内部频率**，
也不能让 1.6 GHz 的 DCO 被 836 MHz 的数字逻辑接住。若要低频输出，应该
让 DCO 本身在低频，或把分频器放在数字控制之前/使用独立的慢时钟域。

## 4. 参数扫描面积代价（仅 synthesis）

`flow/experiments/param_sweep.py` 在 `sky130_fd_sc_hd` 上扫描参数，结果是
**mapped cell count / Liberty area**，不是 P&R 或 STA：

| 配置 | cells | area (µm²) | vs default |
|---|---:|---:|---:|
| 默认 `FCW_BITS=8, DIV_BITS=8` | 1402 | 13,809.49 | — |
| `FCW_BITS=10, DIV_BITS=10` | 1436 | 14,523.93 | +34 cells / +714 µm² |
| `FCW_BITS=12, DIV_BITS=12` | 1468 | 15,066.95 | +66 / +1,257 |
| `FINE_NDELS=63, FILTER_BITS=20` | 1651 | 16,339.42 | +249 / +2,530 |
| `COARSE_NDELS=31, MID_NDELS=31` | 1528 | 15,911.51 | +126 / +2,102 |

结论：把 `FCW_BITS` 从 8 加到 12 的纯数字面积代价不大（约 +5%），但
计数器/比较器路径更深，会降低 Fmax；`FINE_NDELS=63` 的代价主要在模拟
延迟级和 term decoder，不在几个触发器上。具体时序必须重新跑 STA。

## 5. 当前硬宏的限制

`flow/macro/*/PLL_ANALOG_MACRO` 的端口只有：

```text
COARSE_MUX, MID_MUX, FINE_MUX, DCO_EN, REF, INJ_EN,
SS_BBPD, OUT, MID_OUT, INJ_EDGE
```

没有：

```text
FCW, SET_DIV, LOAD_DIV, OUT_DIV, LOCKED, ERR
```

因此：

- 在硬宏上只能直接调 `COARSE/MID/FINE` 和 `INJ_EN`，不能做数字反馈分频；
- `REF` 在硬宏里是**注入参考**，不是 freq-lock 的反馈参考；
- 硬宏的 `OUT`/`MID_OUT` 是自由运行的 DCO 输出，其最大频率只能由
  DCO 模拟延迟链决定，当前没有实测；
- 要做频率/分频参数化验证，必须先集成完整 `pll` top（`pll_logic` +
  `PLL_ANALOG_MACRO`），目前仓库还没有这个集成视图。

## 6. 建议

1. **先统一 FCW 语义**：RTL 是 `N=FCW`，设计脚本是 `N=FCW+1+alpha`；
   在仿真/硅前选择一种，修正 `pll_freq_lock` 或顶层。
2. **1.6 GHz 不作为当前 ics55 数字控制的已收敛指标**；若要保留，需做
   流水/重定时或换更快库，并重新跑 post-route STA。
3. **宽分频比**：8-bit `FCW/DIV_BITS` 最大 255；需要更大 N 时先把
   `FCW_BITS`/`DIV_BITS` 加到 10-12，但必须重跑 STA。
4. **输出分频器边界**：把 `SET_DIV=0/1` 的 /2 行为修成明确的语义；
   当前有效范围按 2..255 使用。
5. **硬宏重新生成**：改 `COARSE/MID/FINE_NDELS` 必须重新生成宏的
   LEF/Liberty/GDS，不可只改顶层参数。
6. **下一步实测**：硬宏 DCO 频率/调谐、REF 注入锁定范围、完整 PLL 的
   lock time、jitter；没有这些数据前，不要给出相位噪声或 fmax 产品指标。

## 7. DDR 颗粒 CK

`src/ddr_ck.v` 的 `ddr_ck_gate` 是 pad 时钟，不是环路时钟。
`OUT` 和原始 `OUT_DIV` 继续跑，锁定检测才能做完。`CK` 在下列条件
同时成立之前保持为 0：

- `LOCKED` 为 1；失锁后重新拉低。
- 整数分频比为偶数且 ≥ 2。`pll_mod_divider` 对偶数 N 的高/低相位
  各计 N/2 个 DCO 周期，周期数上 tCH == tCL（占空比 0.50）。奇数比
  的高相位多一个 DCO 周期，落在这里用的 0.45–0.55 窗口外，`CK` 保持静默。

使能在分频时钟的下降沿采样，避免半个脉冲。

合同仿真是 `src/ddr_ck_tb.v`：锁定前 `CK` 为 0；800 MHz 的 /8 是
100 MHz、占空比 0.500；/5 保持为 0；失锁后再次为 0。这是数字门控，
不是 pad 的模拟占空比或抖动。

## 8. DCO 频率表

这张表只收已跑完的点。下面的 ps 数是无噪声瞬态的周期散布，
不是随机抖动，也不是相位噪声。

锁定后频率和到 pad 的抖动四个工艺都是未测。仓库里没有可跑的闭环晶体管网表，
也没有 pad 网表：

- `src/test_pll.sp` 引用 `models.inc` 和 `pll.sp`。仓库里没有 `pll.sp`。
  `models.inc` 只在 `sim/outputs/ics55/` 和 `sim/outputs/ihp-sg13g2/`，不是 PLL 网表。
  `src/pll_inst_declr.sp` 的实例只有 `REF`、`LOCKED`、`OUT`、`OUT_DIV`，没有 `CK`。
  负载是 `PLL_CELL_BUFFX0` 加 `Cdigload=2e-15`，不是 DDR pad。
- `sim/post_pnr/` 是 ics55 门级 SDF 冒烟，宏本身，不是晶体管闭环，也没有 pad。
  README 写明整颗 `pll` 还没有装上这块硬宏。
- 仓库里没有 `*pad*.sp` / `*pad*.spice` / `*pad*.cir`。已有的 spice 顶层是
  环振、计数器 DCO 和 IL-DCO 宏，不是到 pad 的时钟。
- gf180 和 sky130 有 `PLL_ANALOG_MACRO_extracted.cir`。那是抽取网表，
  不是闭环，也没有 pad，这次没跑。

| 项 | gf180mcu | sky130 | ihp130 | ics55 |
|---|---|---|---|---|
| 锁定后频率 | 未测 | 未测 | 未测 | 未测 |
| 到 pad 的抖动 | 未测 | 未测 | 未测 | 未测 |
| 偶数整数比正好 100 MHz | 没有 | 没有 | 没有 | L3 记录有一格，见下；不是 PEX，也不是锁定后 |

### 8.1 带 `BASE_NDELS=256` 的环振

单元级自由振荡，无走线 RC。数字在 `flow/characterization/macro_char/ring_pvt.csv`。
最小码 TT/SS/FF：

| 工艺 | TT | SS | FF |
|---|---:|---:|---:|
| gf180mcu | 21.07 MHz | 15.74 MHz | 26.60 MHz |
| sky130 | 27.64 MHz | 13.48 MHz（只有一个周期） | 43.08 MHz |
| ihp130 | 33.21 MHz | 20.95 MHz | 47.58 MHz |
| ics55 | 无环振 spice 视图 | — | — |

这些频率整数分频后更低，到不了 100 MHz。TT 上 coarse/mid/fine 各加 1 的调谐
只有 gf180mcu 和 ihp130（`ring_tuning.csv`），步进都在 0.2 MHz 以内，不是全码单调性。
sky130 没有这一行。

### 8.2 无基延迟 IL-DCO，本次 TT 五点

单元级，无走线 RC，`DCO_EN=1`、`INJ_EN=1`，码为 0 或指定低热码为 1。
周期峰峰值是这一段窗口里的确定性散布。

| 码 coarse/mid/fine | gf180mcu，3.3 V，40 ns | sky130 HS，1.8 V，30 ns |
|---|---|---|
| 0/0/0 | 642.06 MHz，周期 1.557 ns，峰峰值 2.7 ps | 1237.96 MHz，0.808 ns，7.2 ps |
| 1/0/0 | 548.20 MHz，1.824 ns，2.1 ps | 1075.40 MHz，0.930 ns，8.7 ps |
| 0/1/0 | 640.39 MHz，1.562 ns，0.83 ps | 1235.54 MHz，0.809 ns，6.7 ps |
| 0/0/1 | 641.07 MHz，1.560 ns，0.40 ps | 1234.79 MHz，0.810 ns，6.1 ps |
| 8/0/0 | 263.07 MHz，3.801 ns，3.4 ps。这是 150 ns 里 60 ns 之后的 24 个周期；40 ns 窗口末尾还在 1.1–3.7 ns 之间跳，那个 664 MHz 不用 | 557.38 MHz，1.794 ns，10.0 ps，13 个周期，从头到尾都在 1.79 ns |

sky130 这一列不是已提交网表的结果。已提交的 `PLL_ANALOG_MACRO.spice` 把使能门
接成 `Y=!DCO_EN & INJ_WIN`，自由振荡时输出为 0。上表是把这一处对调成源码里的
`Y=DCO_EN & !INJ_WIN` 之后重跑的。宏还没有按这个源码重新生成。

这五个点上，加码都把频率压低：gf180 的 coarse 是 642 → 548 → 263，
sky130 是 1238 → 1075 → 557；mid 和 fine 只走了一步。这不是全码单调性。
更密的抽样在 8.4。

最近的偶数比：gf180 642/6 = 107 MHz，sky130 1238/12 = 103 MHz。都不是 100。
8.4 里 gf180 coarse=12 的 203.62/2 = 101.8 MHz，比这两个更近，仍不是 100。

ihp130 的 `flow/macro/ihp130_sg13g2/` 没有 spice。
`signoff/outputs/ihp-sg13g2-sg13g2_stdcell/PLL_ANALOG_MACRO.spice` 是 LVS 用的
单元级顶层，这次没跑。不是闭环，也没有 pad。

### 8.3 已有的晶体管扫描

| 来源 | 范围 | 单调 | 偶数比到 100 MHz |
|---|---|---|---|
| ics55 L3 稀疏 27 点，`ics55_l3/dco_tuning_l3.csv` | 703–1897 MHz，TT，无 PEX | 三个轴上已测步的频率都不回升（18+18+18 步，0 次上升） | 没有正好 100 |
| ics55 L3 加密 110 点，`ics55_l3_dense/dco_tuning_l3.csv` | 703–1896 MHz，TT，无 PEX | 已测步不回升（fine 101 步，0 次上升） | c8/m0/f6 记录周期 1.000000 ns，即 1000.000 MHz，/10 = 100.0 MHz。邻点是 0.999500 ns 和 1.000500 ns，格点是 0.5 ps，所以“正好”只到这一格 |
| ihp L3 稀疏 27 点，`ihp_l3/dco_tuning_l3.csv` | 212–624 MHz，TT，无 PEX | 不单调。mid 18 步里 4 次频率回升，fine 18 步里 5 次 | 没有。最近是 c0/m8/f0 的 592.7 MHz，/6 = 98.8 MHz |
| ihp L3 fine 全扫，`ihp_l3_dense/`，c8/m0 | 276–354 MHz | fine 31 步里 15 次回升 | 没有 |
| ihp PEX 电容，c8/m8/f8 | TT 179 / SS 115 / FF 274 MHz | 单码，不能说单调 | 179/2 = 89 MHz |
| ics55 PEX 电容，c8/m8/f8 | TT 363 / SS 184 / FF 582 MHz | 单码 | 363/4 = 91 MHz。这不是上面那个 1000 MHz 的码 |

ics55 的 L1 行为模型（0.78–4.19 GHz，8192 点单调）不进这张表。

### 8.4 无基延迟 IL-DCO，轴抽样

还是单元级、TT、无走线 RC、`DCO_EN=1`、`INJ_EN=1`。码是热码：
指定个数的低位为 1。宏引脚是 coarse 0..14、mid 0..14、fine 0..30，
所以 15 和 31 是该轴全部拉高。频率只用稳态窗口：后半段与前半段
相差不到 0.2 MHz。周期峰峰值仍是无噪声散布。

| 码 | gf180mcu，3.3 V | 窗口 |
|---|---:|---|
| 2/0/0 | 478.58 MHz，2.0895 ns，峰峰值 2.0 ps，15 个周期 | 50 ns，15 ns 之后 |
| 4/0/0 | 374.72 MHz，2.6687 ns，5.9 ps，22 | 100 ns，40 ns 之后 |
| 12/0/0 | 203.62 MHz，4.9112 ns，13.2 ps，18 | 160 ns，70 ns 之后 |
| 15/0/0 | 177.54 MHz，5.6325 ns，28.6 ps，15 | 160 ns，70 ns 之后 |
| 0/4/0 | 635.32 MHz，1.5740 ns，3.3 ps，21 | 50 ns，15 ns 之后 |
| 0/8/0 | 628.80 MHz，1.5903 ns，2.9 ps，21 | 同上 |
| 0/15/0 | 617.62 MHz，1.6191 ns，2.2 ps，20 | 同上 |
| 0/0/4 | 638.09 MHz，1.5672 ns，2.7 ps，21 | 同上 |
| 0/0/8 | 634.12 MHz，1.5770 ns，2.7 ps，21 | 同上 |
| 0/0/16 | 626.46 MHz，1.5963 ns，2.6 ps，21 | 同上 |
| 0/0/31 | 612.78 MHz，1.6319 ns，3.0 ps，21 | 同上 |
| 8/8/0 | 260.55 MHz，3.8381 ns，23.8 ps，23 | 160 ns，70 ns 之后 |
| 4/4/4 | 371.88 MHz，2.6890 ns，24.0 ps，22 | 100 ns，40 ns 之后 |

和 8.2 的五点合在一起，gf180 已测步都是加码降频，没有回升：

- coarse，mid=0、fine=0：642.06、548.20、478.58、374.72、263.07、203.62、177.54，码 0/1/2/4/8/12/15，6 步 0 次上升。
- mid，coarse=0、fine=0：642.06、640.39、635.32、628.80、617.62，码 0/1/4/8/15，4 步 0 次。
- fine，coarse=0、mid=0：642.06、641.07、638.09、634.12、626.46、612.78，码 0/1/4/8/16/31，5 步 0 次。
- 8/8/0 的 260.55 低于 8/0/0 的 263.07，也低于 0/8/0 的 628.80。4/4/4 的 371.88 低于 4/0/0 的 374.72。

没量的码不能算进单调性。coarse 还缺 3、5–7、9–11、13、14；mid 缺 2、3、5–7、9–14；
fine 缺 2、3、5–7、9–15、17–30。这不是 15×15×31 全码。

偶数比最近 100 MHz 的是 203.62/2 = 101.81。其次是 612.78/6 = 102.13。
没有一个已测码整除到 100。

sky130 这一轮用的仍是使能对调后的临时网表，不是已提交的 spice。窗口 40 ns，8 ns 之后；coarse 12 和 15 是 70 ns，只取启动段结束之后的周期。

| 码 | sky130 HS，1.8 V |
|---|---|
| 2/0/0 | 948.51 MHz，1.0543 ns，峰峰值 8.4 ps，30 个周期 |
| 4/0/0 | 767.50 MHz，1.3029 ns，8.6 ps，23 |
| 12/0/0 | 437.09 MHz，2.2879 ns，10.6 ps，14。稳态从 37.3 ns 开始；这之前周期在 0.15–0.95 ns 之间跳。把 15 ns 之后整段平均成 794 MHz 是错的，那个数不用 |
| 15/0/0 | 383.13 MHz，2.6101 ns，14.1 ps，8 个周期，从 47.8 ns 开始。只有 8 个周期；这之前同样在跳。整段平均的 832 MHz 不用 |
| 0/4/0 | 1227.73 MHz，0.8145 ns，7.2 ps，39 |
| 0/8/0 | 1216.77 MHz，0.8218 ns，8.8 ps，38 |
| 0/15/0 | 1199.22 MHz，0.8339 ns，7.0 ps，37 |
| 0/0/4 | 1231.02 MHz，0.8123 ns，5.4 ps，39 |
| 0/0/8 | 1226.23 MHz，0.8155 ns，8.0 ps，38 |
| 0/0/16 | 1215.01 MHz，0.8230 ns，7.6 ps，38 |
| 0/0/31 | 1194.96 MHz，0.8368 ns，9.8 ps，37。后半窗是 1193.8 MHz，前半窗是 1196.1 MHz，差 2.3 MHz；上一档 0/0/16 是 1215.01，差距大于这个漂移 |
| 8/8/0 | 553.08 MHz，1.8081 ns，7.3 ps，17 |
| 4/4/4 | 761.55 MHz，1.3131 ns，8.5 ps，23 |

除 fine=31 那 2.3 MHz 之外，后半窗对前半窗的移动都在 1 MHz 以内。和 8.2 合在一起，已测步都是加码降频：

- coarse，mid=0、fine=0：1237.96、1075.40、948.51、767.50、557.38、437.09、383.13，码 0/1/2/4/8/12/15，6 步 0 次上升。
- mid，coarse=0、fine=0：1237.96、1235.54、1227.73、1216.77、1199.22，码 0/1/4/8/15，4 步 0 次。
- fine，coarse=0、mid=0：1237.96、1234.79、1231.02、1226.23、1215.01、1194.96，码 0/1/4/8/16/31，5 步 0 次。
- 8/8/0 的 553.08 低于 8/0/0 的 557.38，也低于 0/8/0 的 1216.77。4/4/4 的 761.55 低于 4/0/0 的 767.50。

缺的码和 gf180 一样：不是 15×15×31 全码。偶数比最近 100 MHz 的是 0/15/0 的 1199.22/12 = 99.935。其次是 0/0/31 的 1194.96/12 = 99.58。都不是 100。

锁定后频率和到 pad 的抖动仍是未测，原因在本节开头。全码单调性也没有：上面只是抽样步。
