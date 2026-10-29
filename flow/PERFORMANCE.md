# ADPLL 当前性能与实现指标

本文件只汇总**目前仓库中可追溯的测量/STA 结果**。它不是完整 ADPLL 的
characterization report。完整 top-level `pll` 还没有和硬宏一起集成，DCO
频率范围、相位噪声、抖动、锁定范围和模拟功耗都还没有实测。

## 1. 架构与设计目标

| 指标 | 值 | 来源 / 性质 |
|---|---|---|
| 参考时钟 `REF` | 100 MHz | `src/dlf_design.py`、数字 testbench |
| 标称分频比 `N` | RTL 为 `N=FCW`；`FCW=15` 即 15×，`FCW=16` 才 16×。`dlf_design.py` 写的是 `FCW+1+alpha`，与 RTL 不一致 | `src/pll_freq_lock.v` / `src/dlf_design.py` |
| 标称输出频率 | RTL `FCW=15` 时 1.5 GHz，`FCW=16` 时 1.6 GHz；`alpha=0.0875` 的 1.609 GHz 是设计脚本口径 | 设计目标，不是实测 |
| 参考/输出关系 | RTL：`F_MID=FCW·F_REF`；设计脚本：`(FCW+1+alpha)·F_REF` | 需统一 |
| DCO 调谐 | 4-bit coarse / 4-bit mid / 5-bit fine，15/15/31 个延迟单元 | `src/pll.v` |
| 注入锁定 | 4 级 injection delay | `src/pll_analog.v` |
| 数字环路滤波器 | 目标截止频率 1 MHz | `src/dlf_design.py` |
| `LOCKED` 最小等待 | 64 个 REF 周期 = 0.64 µs | `LOCKED_WAIT=64` |
| 供电 | ics55 1.2 V / GF180 3.3 V / GF180 FD 5 V / sky130 1.8 V / IHP 1.2 V | 各 PDK 宏/数字 canary 配置 |

> `OUT` 在宏 P&R 约束里被当作 2.5 ns（400 MHz）时钟处理；这和标称
> 1.6 GHz DCO 不是同一个数。400 MHz 只是当前 P&R 的时序约束口径，不能
> 当作 DCO 实测上限。

## 2. 四个硬宏的面积与实现

| PDK / 库 | Die (µm × µm) | Die area (mm²) | Macro Liberty area (µm²) | 面积利用率 | 实例数 | 时序 / 签核 |
|---|---:|---:|---:|---:|---:|---|
| ics55 H7CR | 160 × 100 | 0.0160 | 1485.96 | 9.3% | 1207 DEF objects（README 统计 181 个 P&R 实例） | top DRC 0（305 cell-internal waived）；**LVS PASS**；宏级 setup/hold 未单独保存 |
| GF180mcu AS 3.3 V | 85.64 × 103.56 | 0.00887 | 5057.73 | 57.0% | 452（304 stdcells） | setup **+0.487 ns** / hold **+0.306 ns** @ REF 20 ns / OUT 2.5 ns；DRC 0；LVS PASS（fill-marker shim） |
| sky130 as_sc_hs 1.8 V | 80.21 × 90.93 | 0.00729 | 3912.51 | 53.6% | 653（517 stdcells） | setup **+2.463 ns** / hold **+0.158 ns** @ REF 20 ns / OUT 2.5 ns；DRC 0；LVS 仍卡在 cell-CDL/device 比较 |
| IHP SG13G2 1.2 V | 160 × 105 | 0.0168 | 7865.39 | 46.8% | 805 DEF objects | route DRC 0；minimal-deck DRC **0**（含 density）；LVS PASS（fill-stripped view）；宏级 setup/hold 未单独保存 |

面积利用率的定义是 `Liberty macro area / die area`，不是布线利用率。

## 3. 数字控制 canary（不是完整 PLL）

| PDK / 库 | 数字控制综合 | 时序 / 功耗 |
|---|---|---|
| ics55 H7CR | 1571 cells，4321.80 µm² | TT post-route clock report：REF 994.87 MHz、OUT 835.87 MHz、MID_OUT 1002.43 MHz、INJ_EDGE 452.09 MHz；SS 分别约 580/479/640/244 MHz。setup/hold 0 |
| GF180mcu AS 3.3 V | 1690 cells，49,069.31 µm² | 数字 P&R 80/80（signoff skips）；无 post-PnR STA / RCX；一个 r2r setup 违例 -0.092 ns @ ff/n40C/3.6 V |
| GF180mcuD FD 5 V | 1588 synth cells；P&R 后 1790 stdcells；61,410.7 µm² | 完整 P&R/DRC/LVS/antenna：route DRC 0（11,180 single-cut vias）；Magic/KLayout DRC 0；LVS PASS；post-route SPEF：setup **-0.169 ns TT / -4.516 ns SS / +1.719 ns FF**，hold **+0.662 / +1.071 / +0.390 ns**；35.3 mW default activity；IR 7.01 mV |
| GF180mcuD FD 9T 5 V | 1588 synth；P&R 后 1744 stdcells；77,381.7 µm² | 完整 P&R/DRC/LVS/antenna：11,121 single-cut vias；setup **+0.752/-2.646/+2.219 ns**，hold **+0.396/+0.732/+0.249 ns**；43.3 mW；IR 6.78 mV |
| GF180mcuD 3.3 V 7T | 1690 synth；P&R 后 1598 stdcells；59,360.4 µm² | 完整 P&R/DRC/LVS：11,001 single-cut vias；setup **+1.478/+0.283/+2.205 ns**，hold **+0.123/+0.147/+0.103 ns**；12.9 mW；IR 2.03 mV |
| IHP SG13G2 1.2 V | 1587 cells，26,243.18 µm² | TT power **5.62 mW**；SS setup **-0.316 ns / TNS -2.534 ns**（10 paths）@ 名义 2.5 ns OUT；REF 20 ns 域仍有 +11.15 ns 余量 |

IHP 的 5.62 mW 是 **Core A 数字控制 canary** 的 TT 功耗，不是硬宏或完整
ADPLL 的功耗。

## 4. Post-PnR smoke simulation（ics55 宏）

`sim/post_pnr` 用 ics55 P&R gate netlist + SDF，200 ns，REF 5 ps 翻转用于
注入 kick-start；**不是** 100 MHz 系统参考，也不是校准后的 DCO 周期：

| 情况 | edges | last period | avg period |
|---|---:|---:|---:|
| SDF annotated | 38 | 2284 ps | 4926 ps |
| No SDF | 52 | 5000 ps | 3568 ps |

能确认的是 SDF 被消费、gate-level 行为随 P&R 延时变化；不能把它当作
`fmax`、相位噪声或锁定时间。

## 5. 目前没有的指标

以下项目尚未完成，不能给出可信数字：

- DCO 实测频率 / 调谐范围 / coarse-mid-fine 单调性
- injection lock range、注入锁定时间和失锁行为
- DCO 相位噪声（ISF 流程未产出结果）
- 完整 ADPLL 的 RMS jitter / integrated phase noise
- 完整 top-level `pll` 的功耗、面积、锁定时间和 BER
- 硬宏在真实负载/封装/电源网络下的 timing signoff

`flow/compare/summary.csv` 目前只有表头，没有填满 QoR sweep；上面的宏时序
是各宏 P&R 的局部结果，不能直接横向当作同一约束下的 fmax 排名。

## 6. GF180 FD route/timing 状态

`flow/canary/gf180mcu_fd_core_a` 的 FD canary 现在使用 wafer-space
`gf180mcuD` 的 5-metal FD view，而不是 CIEL `gf180mcuA` 的 3-metal view：

- `gf180mcuA` 的 tech LEF 只有 2×2 Via2 default；DPL workaround 后仍会
  在 detailed route 报 `DRT-0234 Via2 does not have single-cut via`。
- `gf180mcuD` 的 FD tech LEF 自带 `Via2_HH/HV/VH/VV` single-cut default；
  route 使用 **11,180 个 single-cut via、0 个 multi-cut**，route DRC 0。
- Magic DRC 0；KLayout DRC 0；Netgen LVS PASS；antenna PASS。
- die 483.375 × 501.295 µm（0.2423 mm²）；stdcell 61,410.7 µm²；
  P&R 后 1,790 个 standard cell；35.3 mW default activity；worst IR 7.01 mV。
- post-route SPEF STA @ 20 ns：setup WNS **-0.169 ns TT / -4.516 ns SS /
  +1.719 ns FF**；hold **+0.662 / +1.071 / +0.390 ns**；setup violation
  3/25/0，hold 0。50 MHz 在 TT/SS 未闭合，等效约 **49.6 MHz TT /
  40.8 MHz SS**；hold 已闭合。

因此 FD 已不再是 route/DRC/LVS blocker，剩余是 slow-corner setup；需要
修 SS path 或接受约 25 ns 的周期。该 canary 仍不是完整 PLL 或 DCO 表征。
