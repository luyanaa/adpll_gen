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
