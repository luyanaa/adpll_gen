# PDK 侧 ADPLL 可行性估算

本文只给**基于现有实现的估算**，并明确区分：

- **pre-layout**：Yosys 映射后、无走线延时、2.5 ns `OUT` / 10 ns `REF`；
- **post-route**：已有 canary 的 OpenROAD 时钟报告；
- **macro**：`PLL_ANALOG_MACRO` 的 P&R 局部时序；
- **unknown**：没有 DCO 模拟表征，不能从数字 STA 反推。

## 1. 快速结论

| PDK / 库 | 当前可支撑的 DCO/OUT 数字上限 | REF 侧上限 | 1.6 GHz 可行性 |
|---|---:|---:|---|
| ics55 H7CR | **836 MHz TT / 479 MHz SS**（post-route） | **452 MHz TT / 244 MHz SS**（`INJ_EDGE`） | **否** |
| GF180 AS 3.3 V | **约 196 MHz SS post-route**；pre-layout TT 约 0.33 GHz | **约 97–176 MHz SS**；TT 未单独保存 | **否** |
| sky130 `fd_sc_hd` | **约 0.57 GHz pre-layout**；没有 post-route 数字 canary | 未测；macro 只证明 400 MHz 口径 | **没有证据支持** |
| IHP SG13G2 | **525 MHz TT / <400 MHz SS**（post-route） | **237–250 MHz TT**（`INJ_EDGE`） | **否** |
| ETRI050 12T 5 V | **约 90 MHz pre-layout**；P&R route 完成，20 ns OUT 下 setup -158.85 ns | 未测；5 V/0.5 µm，估计同量级 | **否** |
| GF180mcuD FD 5 V | **49.6 MHz TT / 40.8 MHz SS**（post-route） | 未单独测；同量级 | **否**（50 MHz SS 未闭合） |

表中的“DCO/OUT”是**数字控制域**能接收的频率，不包含 DCO 模拟延迟链本身；模拟 DCO
可能更高，但当前没有实测。

## 2. 按 PDK 的细节

### GF180mcu

**AS 3.3 V**

- 宏：85.64 × 103.56 µm，0.00887 mm²；macro setup **+0.487 ns** / hold **+0.306 ns**
  @ REF 20 ns / OUT 2.5 ns；DRC 0；LVS PASS（fill-marker shim）。
- 数字 canary 的 SS 3.0 V post-route clock report：
  - `REF` 163.53 MHz，`OUT` **196.37 MHz**，`MID_OUT` **306.87 MHz**，
    `INJ_EDGE` **96.70 MHz**。
- 另一个 pre-layout TT 3.3 V 结果（同一 `pll_logic`，无走线延时）：
  - 2.5 ns `OUT` 下 worst setup **-0.50 ns**，即约 **0.33 GHz** 量级。
- 结论：GF180 3.3 V 数字控制适合 **100–300 MHz**，不是 1.6 GHz；高速宏需要
  流水/重定时或更快的库。

**FD `gf180mcu_fd_sc_mcu7t5v0`**

- 两个 FD PDK view 必须区分：
  - CIEL `gf180mcuA`：3-metal，FD tech LEF 只有 2×2 Via2 default；
    DRT 报 `DRT-0234 Via2 does not have single-cut via`。
  - wafer-space `gf180mcuD`：5-metal，tech LEF 自带
    `Via2_HH/HV/VH/VV` single-cut default；同一个 flow 可以完成 route。
- `gf180mcuD` canary：1588 synthesis cells / 44,167 µm²；P&R 后
  1,790 standard cells；die 483.375 × 501.295 µm，0.2423 mm²；
  stdcell 61,410.7 µm²，利用率 28.0%。
- route：**11,180 single-cut vias，0 multi-cut**；OpenROAD route DRC 0；
  Magic DRC 0；KLayout DRC 0；Netgen LVS PASS；antenna PASS。
- post-route SPEF STA @ 20 ns：setup WNS **-0.169 ns TT / -4.516 ns SS /
  +1.719 ns FF**；hold **+0.662 / +1.071 / +0.390 ns**；setup violation
  3 (TT) / 25 (SS) / 0 (FF)，hold 0。50 MHz 在 TT/SS 未闭合；等效约
  **49.6 MHz TT / 40.8 MHz SS**。
- 功耗 35.3 mW（default activity），worst IR drop 7.01 mV。
- 结论：FD 5 V 可用于 **几十 MHz** 级数字控制；当前 50 MHz 仍需修
  SS path 或改用约 25 ns 周期，不能把它当成 50 MHz signoff。

### sky130

**`sky130_fd_sc_hd`**

- pre-layout TT 1.8 V，同一 `pll_logic`、2.5 ns `OUT`：
  - worst setup **+0.75 ns**（约 **0.57 GHz** 等效）
  - worst hold **+0.05 ns**
- 没有 post-route 数字 canary；不能把这个值当成 P&R 后 Fmax。
- 现有 sky130 宏有两套：`sky130_as_sc_hs` 80.21 × 90.93 µm，LVS 卡在
  Magic cell-CDL/device；新 `sky130_fd_sc_hd` 实验 79.665 × 90.385 µm，
  **KLayout DRC 0**，PDN 已修，但 LVS 仍在 cell-subcircuit 比较。
- 结论：sky130 数字控制**可能**在 0.4–0.6 GHz 量级，需 P&R canary 确认；
  不支持 1.6 GHz。

### IHP SG13G2

- 宏：160 × 105 µm，0.0168 mm²；minimal-deck DRC 0（含 density）；
  LVS PASS（fill-stripped view）。
- 数字 canary TT 1.2 V post-route：
  - `REF` 379.10 MHz，`OUT` **525.42 MHz**，`MID_OUT` **653.44 MHz**，
    `INJ_EDGE` **237.33 MHz**。
- SS 1.08 V 在名义 2.5 ns `OUT` 下 setup **-0.316 ns**（10 paths，TNS -2.534 ns），
  所以 SS 不能按 400 MHz 签核。
- 结论：IHP 1.2 V 数字控制约 **0.5 GHz TT / 0.35–0.4 GHz SS** 量级；
  不支持 1.6 GHz。

### ETRI050

- `ETRI050_fd_sc_12t`：5 V、0.5 µm、单 TT corner、无温度模型；synthesis 1654 cells，
  1,206,913 µm²（数字控制本身约 1.2 mm²）。
- pre-layout TT 5 V、2.5 ns `OUT`：worst setup **-8.66 ns**，等效约 **90 MHz**。
- 没有 P&R canary，也没有 macro；5 V 大单元 + 长走线会进一步降低。
- 结论：ETRI050 只适合 **tens of MHz 到约 100 MHz** 的慢速/研究用途，
  不适合当前 ADPLL 的 1.6 GHz 目标，也不适合面积敏感设计。

### ETRI050 PnR blockers

- **Core A 缺 `nand2b`**：原始库 `core_support.core_a_il_dco = no`；canary
  已用 NAND2/NOR2 + INV 做等价映射，但这是 flow-level 等价，不是 vendor cell。
- **PDN/power-terminal**：默认 rail+MET2/MET3 strap 让
  `RepairDesignPostGPL` 失败；rails-only 能让 placement/CTS/DRT 完成（route
  DRC 0），但 PSM 仍看不到 VDD/VSS terminal；加 MET2/MET3 strap 又回到
  placement 失败。当前 canary 跳过 power checker，不是 power signoff。
- **单 corner**：只有 TT/5 V/25 °C，没有 SS/FF 或温度模型；不能做 setup/hold
  签核。
- **5 V / 0.5 µm / 1.2 mm² 数字面积**：面积和功耗都不适合高频 ADPLL；
  与 1.2 V/1.8 V 数字混合还需要 level shifter。
- **Liberty 质量**：12T vendor Liberty 没有 setup/hold/RCX 签核；9T 是
  research-only。
- **库端**：`ETRI050_fd_sc_12t` 的 38 cells 可综合，但 Core A 的 missing
  `nand2b` 是硬 blocker；不能靠改 flow 参数解决。

## 3. 对 1.6 GHz 目标的判断

所有 PDK 的现有数字控制都达不到 1.6 GHz：

```text
ics55  OUT 836 MHz TT / 479 MHz SS
GF180  OUT ~196 MHz SS / ~330 MHz TT pre-layout
sky130 OUT ~570 MHz pre-layout (no P&R)
IHP    OUT 525 MHz TT / <400 MHz SS
ETRI   OUT ~90 MHz pre-layout
```

1.6 GHz 需要的是**数字控制架构改造**（流水、重定时、拆高频计数器），不是简单
调大 `FCW=16`。模拟 DCO 可以在硬宏里单独跑更高频率，但完整 PLL 的反馈计数器、
DLF 和 SS-BBPD 采样也必须跟上。

## 4. 估算的可信度

| 数据 | 可信度 |
|---|---|
| ics55 post-route clock report | 较高，同一数字 canary，有 SDF/布线 |
| IHP post-route TT clock report | 较高，同一数字 canary；SS 另见 setup 违例 |
| GF180 AS SS post-route clock report | 较高，但只有 SS；TT 另用 pre-layout |
| sky130 pre-layout | 只作筛选，不是 P&R 后 Fmax |
| ETRI pre-layout | 只作量级估计 |
| DCO 模拟上限、jitter、lock range | **未测，不能给数字** |
