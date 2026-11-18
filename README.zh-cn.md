# ADPLL Generator — 实现与特性表征

本仓库包含一个全数字锁相环（ADPLL）生成器、其标准单元映射、硬宏 P&R 流程、
库筛选实验以及版图后特性表征。项目有意支持多 PDK：ics55、GF180mcu、sky130、
IHP SG13G2 和 ETRI050。

当前状态是**实现特性表征**，不是产品签核。完整的模拟 DCO/PLL 特性（相位噪声、
注入范围、锁定抖动、全顶层功耗）尚未完成。

> 英文版（默认）：[`README.md`](README.md)

## 1. 架构与参数化

| 项目 | 值 |
|---|---|
| 参考时钟 | 标称 100 MHz |
| 反馈比 | RTL（`pll_freq_lock`）中 `N = FCW` |
| `FCW` 位宽 | 8 bit；合法 `N = 1..255` |
| 输出分频 | `SET_DIV`，8 bit；有效分频 `2..255` |
| DCO coarse/mid/fine | 15 / 15 / 31 个温度计延迟单元 |
| 注入链 | 4 级延迟 |
| 数字环路滤波器目标 | 1 MHz 截止 |
| `LOCKED` 等待 | 64 个 `INJ_EDGE` 周期（100 MHz REF 下 0.64 µs） |

要点：RTL 直接锁定到 `FCW`，`src/dlf_design.py` 使用同一整数目标
（`F_VCO = FCW * F_REF`）。`FCW=15` 是 15 倍，`FCW=16` 是 16 倍。
旧的 `(FCW + 1 + alpha)` 编号已废弃。

硬宏（`PLL_ANALOG_MACRO`）**不**暴露 `FCW`、`SET_DIV`、`OUT_DIV` 或
`PLL_LOGIC`；它只含 DCO/PDN/注入的模拟视图。因此分频比特性表征是完整顶层的任务。

详细的参数与上限分析：

- `flow/P0_A.md`
- `flow/characterization/ics55_sim/README.md`
- `flow/characterization/ihp_l3/README.md`
- `flow/characterization/ics55_l3/README.md`
- `flow/characterization/ics55_l3_dense/README.md`
- `flow/characterization/ihp_l3_dense/README.md`
- `flow/characterization/pex_ics55/README.md`
- `flow/characterization/pex_ihp/README.md`
- `flow/characterization/JITTER_PHASE_NOISE.md`
- `flow/generator/README.md`
- `flow/ADPLL_FREQ_DIV.md`
- `flow/PERFORMANCE.md`
- `flow/PDK_ESTIMATES.md`
- `flow/PnR_OPTIMIZATION.md`
- `flow/IHP130_TAPEOUT_GAPS.md`

## 2. 功能验证状态

第一批 P0-A RTL 已实现并通过回归测试：

```text
DSM 饱和/位宽                                         PASS
分频器 /2,/3,/4 及切换后的首个高电平                   PASS
DDR CK 门控：锁定前静默、偶数分频占空比、失效关闭        PASS
DDR 时钟 PHY 路径（DCC -> 选择器，200 MHz）：占空比 50.0%、抽头 240 ps、pad 占空比 50.0% / 相位 375 ps，失效关闭 PASS
DDR 时钟 PHY 真实 ics55 单元：elaboration + Yosys PASS；抽头步进 35.3/60.7/24.0 ps TT/SS/FF
DDR 时钟 PHY 真实 ics55 IO pad：IO 模型 50.0% / 240 ps；OpenSTA TT/SS/FF 单端占空比 47.4/52.6、50/50、48.0/52.0%
ADPLL 分频器 -> DCC -> DLL -> 选择器 冒烟：full LOCKED=1、DLL_LOCKED=1，但 DLL 相位 0.843 ns/4.870 ns 且 CK_PHY 占空比 41.4% -> DLL 路径 FAIL（电平 PD 假锁）
ADPLL full LOCKED：宏 P=200/N=200、ILL=0、稳态 16.5/REF（+3.1%）
ics55 真实 DCDL 范围：TT 4.71-5.55 ns、SS 6.43-7.98 ns、FF 3.97-4.52 ns；SS/FF 下 5 ns 不可达
SS-BBPD 锁定检测器（P/N 窗口，无不可达静默码）        PASS
SS-BBPD 四态契约（00 不可达，DLF 仅边沿 P/N）         PASS
LOCKED / PHASE_LOCK / LOCK_LOST 状态机                PASS（同时要求 P/N 窗口与实时 FCW 窗口）
频率锁定捕获与 FCW 重捕获                             PASS（桩 DCO；是捕获范围，非 SoC 精度）
频率计数 CDC（独立时钟）                              PASS
CDC 生成器：每通道 Gray/电平契约                      PASS
ref_watchdog：正常/停止/非整数                        PASS；精确 1:1 混叠已记录
时钟 IR：DSM_CK / CK / INJ_EDGE / CKR 关系            PASS
pll_macro_top 行为级全锁定                            PASS（LOCKED=1、PHASE_LOCK=1、FCW=16、528 MID_OUT 边沿 / 32 REF；稳态 16.5/REF，约 +3.1%；P=200/N=200、ILL=0）。不是 PEX 或抖动结果。
```

运行：

```sh
cd sim
make test_p0 PDK=ihp-sg13g2 USE_DOCKER=0
```

细节与待办见 `flow/P0_A.md`；符号表与实测流见
`flow/SSBBPD_SYMBOL_CONTRACT.md`。锁定结果仍是行为级，不是 PEX/晶体管级
或抖动签核。

DCO 特性表征状态：

- **ics55**：完整 L1 行为网格（8192 点）与能力清单。
- **IHP SG13G2**：27 点稀疏 L3 晶体管扫描（PSP103 经 OpenVAF OSDI +
  ngspice），另有 `c8/m0` 处 32 点 100 ns fine bank 检查。30 ns 启动离群点
  在 100 ns 下消失，但 fine bank 仍存在 15 个上升步进；不是 PEX/PVT/抖动签核。
- **ics55 L3**：展平 CDL 并转换为 BSIM4 foundry 子电路后，27 点稀疏扫描与
  110 点密集轴扫描；范围 703..1896 MHz。`.ic` 启动使低频 `coarse=15` 点收敛；
  密集扫描覆盖 `c0/m0`、`c0/m15`、`c8/m0` 的完整 fine bank。
- IHP 的 Xyce PSP 模型装配在此安装下仍不适用；可用的 IHP L3 路径是
  PSP103 Verilog-A -> OpenVAF OSDI -> ngspice。

两个 L3 基线都已注册进生成器（`ics55-l3`、`ics55-l3-dense` 与 `ihp-sg13g2`），
但都不是 PEX/PVT/抖动签核。生产请求返回 `FAIL_UNCHARACTERIZED`。
下面的物理宏结果不意味着 DCO/噪声签核。

物理 `PLL_RING_DCO_PHYS` / `PLL_COUNTER_DCO_PHYS` 宏特性现在可用
`flow/characterization/macro_char.py` 复现（TT/SS/FF 门级 STA、环形瞬态 PVT、
确定性周期离散度、精确计数器 NCO 量化）。sky130 环形在构建后的网表中不起振，
sky130 计数器在 SS 100 MHz TICK 下 setup 失败；两者都记为失败而非签核。
不声称随机抖动或相位噪声签核。见 `flow/characterization/macro_char/CHARACTERIZATION.md`。

两个宏的最终数据库现已用 OpenROAD RCX 提取布线寄生。DCO 网络电容回标到单一码：

```text
ics55     958.12 MHz -> 362.84 MHz  (121 DCO nets, 0.188 pF)
IHP       287.85 MHz -> 178.97 MHz  (125 DCO nets, 0.845 pF)
```

该码下的 PVT 频率（TT/SS/FF）：

```text
ics55     362.9 / 184.4 / 582.0 MHz
IHP       179.0 / 115.4 / 274.1 MHz
```

这些是 **L3_PEX_CAP** 结果：总网络电容接地。ics55 的集中串联电阻扩展
（`L3_PEX_RC_LUMPED`）在同码下给出 335.23 MHz；耦合与相位噪声仍未闭合。细节见
`flow/characterization/pex_ics55/README.md` 与 `flow/characterization/pex_ihp/README.md`。

## 3. 已实现的硬宏

| PDK | 库 | Die (µm) | 面积 (mm²) | 组件数 | P&R | DRC | LVS |
|---|---|---:|---:|---:|---|---|---|
| ics55 | `ics55_LLSC_H7CR` | 160 × 100 | 0.0160 | 1207 | 完成 | 顶层 0；305 个单元内部已豁免，其余 0 | **PASS** |
| GF180mcu | `gf180mcu_as_sc_mcu7t3v3` | 85.64 × 103.56 | 0.008869 | 452（304 stdcells） | 完成 | **0** | **PASS**（fill-marker shim） |
| sky130 | `sky130_as_sc_hs` | 80.21 × 90.93 | 0.007293 | 653（517 stdcells） | 完成 | **0** | 单元子电路 LVS 未闭合 |
| sky130 | `sky130_fd_sc_hd` | 79.665 × 90.385 | 0.007200 | 实验性 | route/fill | **0** | 单元子电路 LVS 未闭合 |
| IHP SG13G2 | `sg13g2_stdcell` | 160 × 105 | 0.0168 | 805 | 完成 | **0**（含密度规则） | **PASS**（fill 剥离视图） |
| GF180mcu FD (`gf180mcuD`) | `gf180mcu_fd_sc_mcu7t5v0` | 483.4 × 501.3 | 0.2423 | 3421（1790 stdcells） | **完成** | **0**（Magic + KLayout） | **PASS**（Netgen） |
| GF180mcu FD 9T (`gf180mcuD`) | `gf180mcu_fd_sc_mcu9t5v0` | 534.4 × 561.3 | 0.3000 | 8515（1744 stdcells） | **完成** | **0**（Magic + KLayout） | **PASS**（Netgen） |
| GF180mcuD 3.3 V 7T | `gf180mcu_as_sc_mcu7t3v3` | 416.8 × 434.7 | 0.1812 | 8945（1598 stdcells） | **完成** | **0**（Magic + KLayout） | **PASS**（Netgen） |
| ETRI050 12T | `ETRI050_fd_sc_12t` | 3050 × 3262 | 9.95 die / 1.521 instance | P&R 后 2428 | **route/fill 完成** | 636 个 deck 标记 | 严格 pin-map 失败 |

### 3.1 版图后时序

宏约束使用 `REF=20 ns`、`OUT/MID_OUT=2.5 ns`、`INJ_EDGE=20 ns`；
这些是 P&R 规划约束，不是 1.6 GHz 签核。

| PDK / 库 | 来源 | Setup slack | Hold slack | 功耗 |
|---|---|---:|---:|---:|
| ics55 H7CR | OpenSTA + P&R SPEF | **+3.34 ns** | **+0.64 ns** | 47.9 µW* |
| GF180 AS 3.3 V | P&R 时序报告 | **+0.487 ns** | **+0.306 ns** | 未提取 |
| sky130 as_sc_hs | P&R 时序报告 | **+2.463 ns** | **+0.158 ns** | 未提取 |
| IHP SG13G2 | OpenSTA + P&R SPEF | **+2.35 ns** | **+0.65 ns** | 251 µW* |

`*` OpenSTA `report_power`，默认翻转率；不是矢量驱动，也不是功耗签核。

ics55 与 IHP 的 SPEF 读取在装配网表中报告大量未匹配的层级实例/网络名。
时序值是有用的版图后证据，但在 SPEF/网表命名一致之前**不是干净签核 STA**。

### 3.2 DRC/LVS 细节

- **ics55**：顶层 DRC 0。剩余 305 个 KLayout 项全部是 `7T-cell-internal`；
  `drc_waiver.json` 已记录，`waive_drc.py` 拒绝豁免任何顶层项。LVS 以扁平参考通过。
- **GF180mcu**：die 收缩与标记金属填充后 KLayout DRC 0。LVS 仅以
  `check_ports=false` 加流程本地 fill-marker 排除才通过；未修改的 deck 会看到浮空 fill 网。
- **sky130 `as_sc_hs`**：DRC 0。PDN 电源引脚映射已修（`VPWR/VPB` 为 power，
  `VGND/VNB` 为 ground），但 LVS 仍在单元子电路引脚/器件比较上失败。
- **sky130 `fd_sc_hd`**：DRC 0。使用完整 PDK CDL 与 `tapvpwrvgnd_1`；
  PDN PSM 错误已消除，但 KLayout LVS 仍在单元子电路比较上失败。
- **IHP**：最小 deck DRC 0（含密度规则）；LVS 在 fill 剥离的
  `PLL_ANALOG_MACRO_lvs.gds` 上通过。
- **ETRI050**：无 P&R 签核；见下文阻塞项。

## 4. 数字控制 canary

这些只是 `pll_logic`，不是完整 PLL。

| PDK / 库 | 单元数 | 面积 (µm²) | 角 | `REF` Fmax | `OUT` Fmax | `MID_OUT` Fmax | `INJ_EDGE` Fmax |
|---|---:|---:|---|---:|---:|---:|---:|
| ics55 H7CR | 1571 | 4321.8 | TT 1.2 V | 994.87 | **835.87** | 1002.43 | 452.09 |
| GF180 AS 3.3 V | 1690 | 49069.3 | SS 3.0 V | 163.53 | **196.37** | 306.87 | 96.70 |
| GF180mcuD FD 5 V | 3421（1790 stdcells） | 61,410.7 | 版图后 TT/SS | — | **49.6 / 40.8** | — | — |
| GF180mcuD FD 9T 5 V | 8515（1744 stdcells） | 77,381.7 | 版图后 TT/SS | — | **52.0 / 44.2** | — | — |
| GF180mcuD 3.3 V 7T | 8945（1598 stdcells） | 59,360.4 | 版图后三 corner | — | **≥50** | — | — |
| IHP SG13G2 | 1587 | 26243.2 | TT 1.2 V | 379.10 | **525.42** | 653.44 | 237.33 |
| ETRI050 12T | 1654 | 1,206,913.6 | TT 5 V | — | **~90 MHz** 版图前 | — | — |

Fmax 是 canary 时钟报告中 OpenROAD `report_clock_min_period` 的值。
它是数字逻辑上限，不是模拟 DCO 上限。

- **ics55** 数字 canary setup/hold 为 0。
- **GF180 AS 3.3 V** 无版图后 SPEF/STA；SS 时钟报告是可得的最佳数字时序。
  在 `ff/n40C/3.6 V` 报告过一条 -0.092 ns 的 r2r setup 违例。
- **GF180mcuD FD** 是完整 P&R/DRC/LVS/天线流程，含提取后的版图后 STA：
  setup WNS **-0.169 ns TT / -4.516 ns SS / +1.719 ns FF**，
  hold **+0.662 / +1.071 / +0.390 ns**；11,180 个单切 via、0 个多切；
  DRC 0、LVS PASS、35.3 mW 默认翻转功耗、7.01 mV 最差 IR drop。
  20 ns（50 MHz）约束在 TT/SS 未闭合；SS 约 40.8 MHz。
  该运行使用 5 层金属的 wafer-space `gf180mcuD` 视图，不是 3 层
  `gf180mcuA` 视图。
- **GF180mcuD FD 9T** 完成同一完整流程：11,121 个单切 via、DRC 0、
  LVS PASS、43.3 mW、7.01 mV IR；setup +0.752 ns TT / -2.646 ns SS。
- **GF180mcuD 3.3 V 7T**（`gf180mcu_as_sc_mcu7t3v3`）是已完成的
  `/grid` 3.3 V 车道：20 ns 在全部 corner 闭合（SS setup +0.283 ns、
  hold +0.147 ns），DRC 0、LVS PASS、12.9 mW、2.03 mV IR。
- **IHP** 数字 canary TT 功耗 **5.62 mW**；在标称 2.5 ns `OUT` 下 SS setup
  为 **-0.316 ns / TNS -2.534 ns**，而 20 ns `REF` 域约有 +11.15 ns 余量。
- **ETRI050** 现已 **route/fill 完成**：2428 实例、9.95 mm² die、
  1.521 mm² 实例面积、OpenROAD 详细布线 DRC **0**。20 ns `OUT` 下时序
  仍远未闭合（setup **-158.85 ns**、hold **-16.73 ns**），KLayout DRC 报告
  636 个 NWL/NSD/PSD 标记，KLayout LVS 在严格顶层引脚映射上失败。
  这是流程结果，不是签核。

## 5. 版图后 SDF 冒烟仿真

`sim/post_pnr` 运行 ics55 门级 P&R 网表，可选 SDF：

| 情况 | 边沿数 | 最后周期 | 平均周期 |
|---|---:|---:|---:|
| SDF 标注 | 38 | 2284 ps | 4926 ps |
| 无 SDF | 52 | 5000 ps | 3568 ps |

激励每 5 ps 翻转一次 `REF` 以启动注入锁定；它不是 100 MHz 系统参考。
这是冒烟测试，不是校准后的 DCO 周期或抖动测量。Icarus 只使用 SDF 文件/实例参数，
忽略 corner 选择。

## 6. 频率边界

使用上表实测逻辑上限：

```text
N = FCW, f_MID = N * f_REF
f_REF <= min(F_REF_domain, F_INJ_domain, f_MID_max/N)
f_MID <= min(F_MID_domain, F_DCO_analog)
```

当前证据**不**支持 1.6 GHz 完整环路：

- ics55：`OUT` 836 MHz TT / 479 MHz SS；`REF` 受 `INJ_EDGE` 限制约
  452/244 MHz
- GF180 AS：`OUT` 约 196 MHz SS / 约 330 MHz TT 版图前
- GF180mcuD FD：`OUT` 约 49.6 MHz TT / 约 40.8 MHz SS 版图后；SS 下 50 MHz 未闭合
- GF180mcuD FD 9T：`OUT` 约 52.0 MHz TT / 约 44.2 MHz SS 版图后；SS setup 未闭合
- GF180mcuD 3.3 V 7T：20 ns 在全部 corner 闭合（>50 MHz）
- sky130：版图前约 570 MHz，无版图后数字 canary
- IHP：525 MHz TT / <400 MHz SS
- ETRI050：版图前约 90 MHz

对 100 MHz REF，ics55 `N=16` 需要 1.6 GHz，高于当前 `OUT` 域。
当前宏 P&R 的 2.5 ns `OUT`（400 MHz）是已闭合的时序点，不是 1.6 GHz。

## 7. 当前待办与阻塞项

### GF180 FD

原始的 CIEL `gf180mcuA` FD 视图是 3 层金属，且只有 2×2 的 Via2 默认。
其 DPL 失败（`DPL-0036`，OpenROAD #11511）曾以仅轨道的 PDN 规避，但详细布线
仍停在 `DRT-0234 Via2 does not have single-cut via`。

切换到 wafer-space 的 `gf180mcuD` 5 层金属 FD 视图修复了布线：
技术 LEF 有单切 Via2 默认，TritonRoute 使用 11,180 个单切 via / 0 个多切，
完整流程以 Magic/KLayout DRC 0、Netgen LVS PASS 与天线 PASS 完成。
这不再是布线阻塞。剩余 FD 问题是时序：20 ns（50 MHz）setup 为
**-0.169 ns TT / -4.516 ns SS**，hold 在所有 corner 为正。

### GF180 3.3 V 9T / 12T

7T AS 车道已完成。OSU 9T/12T 车道**未**签核干净：

- 9T 布线 + Netgen LVS 完成，但 TritonCTS 在 OSU buffer 特性表征中崩溃
  （`dbMaster::staCell()`），fill 无法闭合 162 dbu 间隙（无 `__fill_1`），
  且 KLayout DRC 有 1445 个单元边界 well/implant 项，因为 OSU 库不提供
  tap/endcap 单元。
- 12T（OSU）停在 `DRT-0085` 访问模式错误；OCD 12T 替代方案在 Yosys/ABC 失败，
  且无单一合并 Liberty。
- 这些是库视图/邻接限制，不是流程参数。见
  `flow/canary/gf180mcu_3v3_core_a/README.md`。

### sky130 LVS

两个 sky130 宏都是 **KLayout DRC 0**，但器件级 LVS 未闭合：

- `sky130_fd_sc_hd`：KLayout LVS 失败，因为其参考读取器把 Magic `X0` 器件
  当作子电路、把裸 `w=0.15` 当作米；用 PDK `sky130_fd_sc_hd.spice` 的 netgen
  使所有单元器件类别等价，但顶层引脚列表与 `special_nfet_01v8` tap 器件仍不同。
  器件类别等价；仍需一条干净的顶层引脚/blackbox 规则。
- `as_sc_hs`：同样的 KLayout 读取器/单位问题，且无随附 CDL；netgen 是唯一
  可行路径，但顶层 CDL 引脚顺序与提取器不匹配。

不声称任何 sky130 LVS PASS。`fd_sc_hd` 的版图后 STA 证据为 20 ns 下
setup +2.71 ns / hold +0.143 ns。

### ETRI050

- 636 个 DRC 标记是单元边界 well/implant 上下文，不是顶层布线错误：
  `1.NWL.S.2` 267、`1.NWL.S.1` 156、`5.NSD.S1` 110、`6.PSD.S1` 103。
  12T GDS 在 LEF 之外有 1.3/1.4 µm 光晕，导致邻接单元违反 NW/NSD/PSD 间距。
  PDK `ACCEPTANCE.md` 已将该 12T 库排除在验收门之外。
- LVS 顶层引脚缺失，因为 DEF→GDS 标签在层 13/1，而 ETRI deck 读取 42/44/46；
  全部 26 个 stdcell 子电路也在 bulk/tap 提取上失败。没有干净的 GDS/label +
  单元视图修复，无法实现严格 pin-map LVS。
- 20 ns 下时序为 setup -158.85 ns / hold -16.73 ns；约 250 ns 可闭合 setup
  但 hold 仍约 -16.7 ns。这是流程 canary，不是签核。
- Core A 原本缺少 `nand2b`；canary 将 `NAND2BX1`/`NOR2BX1` 映射为
  NAND/NOR + INV。Core B/C 仍是完整单元配置。
- 仅轨道的 PDN 让 route/fill 完成，但没有顶层 VDD/VSS 端子；PSM 报告
  `PSM-0038/0069` 且电源检查被跳过。
- 20 ns `OUT` 下时序未闭合：setup -158.85 ns、hold -16.73 ns。
- 无干净 KLayout DRC/LVS：636 个 NWL/NSD/PSD 标记，LVS deck 无法建立
  严格顶层引脚映射。
- 只有单一 TT/5 V/25 °C corner；无 SS/FF 或温度模型。
- 5 V、0.5 µm、约 1.2 mm² 综合数字面积 / 9.95 mm² die；不适合高频、
  面积敏感的 ADPLL。

### 完整 PLL

完整的 `pll` 顶层尚未与硬宏和数字控制视图装配。目前没有全顶层锁定时间、
抖动、相位噪声或功耗特性。

**IHP SG13G2 投片就绪度评估见 [`flow/IHP130_TAPEOUT_GAPS.md`](flow/IHP130_TAPEOUT_GAPS.md)。**

## 8. 复现

```sh
# 库筛选 / 综合矩阵
python3 flow/experiments/synth_multi_lib.py

# 参数扫描（FCW/DIV/NDELS，仅综合）
python3 flow/experiments/param_sweep.py

# 版图后宏 STA
STA=/usr/bin/sta
$STA -exit flow/characterization/sta_ics55.tcl
$STA -exit flow/characterization/sta_ihp.tcl

# GF180mcuD FD 数字 canary（完整 P&R + DRC/LVS/天线）
cd flow/canary/gf180mcu_fd_core_a
./fetch_gf180mcuD.sh /tmp/gf180mcu-wafer
librelane --manual-pdk --pdk-root /tmp/gf180mcu-wafer \
  --pdk gf180mcuD --scl gf180mcu_fd_sc_mcu7t5v0 \
  -S Checker.SetupViolations -S Checker.HoldViolations \
  -S Checker.MaxSlewViolations -S Checker.MaxCapViolations \
  config.digital_gf180mcuD.yaml

# GF180mcuD 3.3 V 7T canary（已完成车道）
cd flow/canary/gf180mcu_3v3_core_a
librelane --manual-pdk --pdk-root /tmp/pdk_gf180mcuD_3v3 \
  --pdk gf180mcuD --scl gf180mcu_as_sc_mcu7t3v3 \
  -S Checker.SetupViolations -S Checker.HoldViolations \
  -S Checker.MaxSlewViolations -S Checker.MaxCapViolations \
  config.digital_gf180mcuD_7t.yaml

# ETRI050 route/fill 资格验证
cd flow/canary/ETRI050_fd_sc_core_a
librelane --manual-pdk --pdk-root /grid --pdk ETRI050 \
  --scl ETRI050_fd_sc_12t \
  -S OpenROAD.CheckAntennas -S Checker.PowerGridViolations \
  -S Checker.DisconnectedPins -S OpenROAD.RepairDesignPostGPL \
  --to OpenROAD.DetailedRouting config.digital.yaml

# 版图后 SDF 冒烟
ROOT=/opt/adpll_gen PDK_ROOT=/grid bash sim/post_pnr/run.sh
```

机器可读的特性数据：

```text
flow/characterization/post_layout.json
flow/characterization/macro_char/sta_summary.json
flow/characterization/macro_char/ring_pvt.json
flow/characterization/macro_char/ring_tuning.json
flow/characterization/macro_char/counter_nco.json
flow/characterization/macro_char/CHARACTERIZATION.md
```

宏构建与签核命令在各目录的 `README.md`：

```text
flow/macro/ics55_h7cr/
flow/macro/gf180mcu/
flow/macro/sky130_as_sc_hs/
flow/macro/sky130_fd_sc_hd/
flow/macro/ihp130_sg13g2/
flow/canary/gf180mcu_fd_core_a/
flow/canary/gf180mcu_3v3_core_a/
flow/canary/ETRI050_fd_sc_core_a/
```

## 9. 尚未表征的项目

- DCO 全范围实测频率、调谐范围、单调性（宏 TT/SS/FF 与局部码步进现已覆盖）；
  随机抖动与相位噪声
- 注入锁定范围、锁定时间、假锁行为
- DCO 相位噪声 / ISF 分析
- 完整 ADPLL RMS 抖动与积分相位噪声
- 全顶层功耗、面积、锁定时间、BER
- 封装/板级/PDN 签核
- GF180、sky130、IHP 或 ETRI050 的 foundry 级 DRC/LVS

生成的 GDS/OASIS、SPEF/SDF、提取 SPICE、运行目录与签核数据库有意排除在 git 之外
（见 `flow/.gitignore`）；复现所需的配置、脚本、小型报告与特性表已纳入版本控制。
