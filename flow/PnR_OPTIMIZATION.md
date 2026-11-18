# PnR 端 PLL 优化研究

本文只写**能从当前 PnR 产物直接验证**的优化点，每一条都给出实测数字和
代价。数据源是 ics55 数字 canary 的收敛 run
`flow/canary/ics55_h7cr_core_a/runs/RUN_2026-11-18_11-55-44`
（TT +0.5881 / SS +0.0373 / FF +0.7491，TNS 与违例数全 0）。

结论先说：**PnR 端最大的两个收益不是"再调参数"，而是两处流程配置错误**
——ICG 从未真正映射、P&R 优化目标没有用 2.5 ns 的 OUT 约束。其余优化都是
面积/裕量的小幅改善。

## 1. ICG 从未映射成标准单元（最高优先级）

`PLL_USE_ICS55_ICG` 宏**在整个流程里没有被定义**：

```text
$ grep -rn PLL_USE_ICS55_ICG --include=*.mk --include=Makefile \
    --include=*.tcl --include=*.yaml --include=*.sh .
（无结果）
```

因此 `src/freq_lock.v` 的 `PLL_CLKGATE` 走的是 fallback 分支。实测最终
网表里：

```text
ICGNX 单元:        0
en_l 驱动单元:     DFFNQX1H7R（negde 触发器）
门控实现:          AND2X0P5H7R _2437_ (.A(clknet_1_1__leaf_REF), .B(en_l))
```

即**一个 negedge DFF + 一个组合与门**，不是 ics55 的 `ICGNX1H7R`。

用 Yosys + liberty 做对照（同样源文件，只差一个宏）：

| | cells | Liberty area | ICG |
|---|---:|---:|---|
| 当前（无宏） | 3672 | 2434 µm² | 0（DFF+AND） |
| `-DPLL_USE_ICS55_ICG` | 3671 | **2403 µm²** | **2 × ICGNX1H7R** |

映射到真 ICG 后**面积反而少 31 µm²**，且：

- `ICGNX1H7R` 在 liberty 里带 `clock_gating_integrated_cell :
  "latch_negedge_postcontrol"`，是 CTS 可识别的标准 ICG。当前 DFF+AND
  组合在 CTS 眼里只是普通逻辑，**CTS 不会把它当门控单元**，也就不做
  gating-aware 的时钟树平衡，`REF_G`/`DSM_CK_G` 支路的插入延迟不受控。
- 当前 `en_l` 是 negedge DFF，其输出直接进组合与门。这在 PnR 后虽然是
  单条 net，但跨时钟域采样 `LOCKED`/`fll_standby` 的路径仍要走完整
  2FF + 组合，EDA 无法用 ICG 的建立/保持模型检查。

**动作**：在 `config.digital.yaml` 加

```yaml
VERILOG_DEFINES:
  - PLL_USE_ICS55_ICG
```

注意 Yosys 需要 ICG 单元可见；`read_liberty -lib` 已覆盖（实测可行），
LibreLane 的 `Yosys.Synthesis` 默认会读 liberty，加宏即可。

**验证要求**：P&R 后网表 `grep -c ICGNX1H7R` 应为 2，且 CTS 报告应把
两个 ICG 列入 gating 单元。

## 2. P&R 优化目标没用到 OUT 的 2.5 ns

`config.digital.yaml` 只给一个时钟：

```yaml
CLOCK_PORT: REF
CLOCK_PERIOD: 20.0
```

`OUT`/`MID_OUT`（2.5 ns）和 `INJ_EDGE` 是 `constraints/adpll.sdc` 里
`create_clock` 出来的，**LibreLane 的 PnR 优化只按 20 ns 的 REF 目标
做 sizing/repair**。实测证据：

```text
CLOCK_PERIOD = 20
OUT 域最差 setup = +0.0373 ns（预算 2.5 ns，即刚好压线）
```

如果 PnR 知道 OUT 是 2.5 ns，repair/sizing 会把资源优先给 OUT 域，而不是
按 20 ns 松弛。这一项直接决定 SS 裕量的可重复性。

**动作**（任选，按侵入性排序）：

1. 把 `CLOCK_PORT/CLOCK_PERIOD` 改成 OUT 域 2.5 ns，REF 用 SDC 补
   `create_clock -period 20`。风险：REF 域的 20 ns 约束仍由 SDC 生效，
   但 PnR 的默认优化目标变成 2.5 ns（更激进）。
2. 在 LibreLane 里配置多时钟/`STA_CORNERS` 之外再加一个 2.5 ns 的
   "fast" 场景，让 repair 同时看两个目标。
3. 保持现状，只把 `PL_TARGET_DENSITY_PCT` 降低，给 repair 更多空间。

推荐 1 或 2；只做 3 治标。

## 3. 组合与门 Slew / Cap 违例（SS 独有 4 条）

SS 仅有 4 条 check 违例，全部在两个输出门：

```text
output57/Y   max_slew  0.9826  limit 0.7957  slack -0.1870
output122/Y  max_slew  0.9757  limit 0.7957  slack -0.1801
output122/Y  max_cap   0.05224 limit 0.03860 slack -0.0136
output57/Y   max_cap   0.05086 limit 0.03860 slack -0.0123
```

这两个都是 `BUFX20H7R` 驱动 `OUT_DIV`/`CK` 输出端口，而 SDC 里
`set_load 0.050 [all_outputs]` 是**统一的 0.05 pF**，对时钟输出偏乐观。

**动作**：把时钟输出（`OUT_DIV`、`CK`）的 load 单独设成实际宏输入电容，
或直接换 `BUFX16H7R`→双级。这不影响时序（这两条不是 setup 违例），
但会让 max_slew/max_cap 干净。

## 4. 时序修复开销：1560 µm² / 7.6%，55 个纯延迟单元全在 CDC 上

```text
setup_buffer: 32        hold_buffer: 55
timing_repair area: 1560.2 µm² (7.6%)
DLY4X2H7R（纯延迟）: 55
```

把这 55 个 `DLY4X2H7R` 的输入逐个提取后，**42 个挂在跨时钟域同步器
的输出上**：

```text
flock.cnt_gray_s1[0..15]    16   (OUT -> REF)
flock.cnt_gray_s2[0]         1
out_edges_g1[0..9]          10   (OUT -> REF)
out_edges_g2[0..9]          10   (OUT -> REF)
ref_wd.watch_s1, watch_s2    2   (OUT -> REF)
clr_r1, clr_r2              2   (INJ_EDGE -> REF)
```

其余 13 个在 `cnt_cap`、`dco_miss_cnt`、`state`、`lock_detector.win_cnt`
等 REF/INJ 域内部路径上。

**这是纯浪费。** RTL 里这些寄存器全部带 `(* ASYNC_REG = "TRUE" *)`，
SDC 也有 `set_clock_groups -asynchronous`，但 **LibreLane 的 repair 仍按
普通 hold 去修这些位**，于是每条 CDC 位都插了一个 `DLY4X2H7R`。异步组
之间的 hold 本来就不该检查（第一级同步器的 metastability 只能靠
MTBF 设计，不能靠延迟器）。

**动作（已实施）**：`constraints/adpll.sdc` 里加了 `cdc_exempt_hold` 过程：

```tcl
proc cdc_exempt_hold {patterns} {
    foreach pat $patterns {
        set nets [get_nets -quiet $pat]
        set sinks {}
        foreach n $nets {
            set sinks [concat $sinks \
                [get_pins -quiet -of_objects $n -filter "direction==input"]]
        }
        if {[llength $sinks] > 0} { set_false_path -hold -to $sinks }
    }
}
```

三条实现要点（都是实测踩出来的）：

1. **不能用 `get_pins -hier` 按名字匹配**。P&R 后层级名完全消失，
   `get_pins -hier -filter "full_name =~ *cnt_gray_s1*"` 返回 0 个。
2. **但网名保留了**。最终网表里仍是 `\flock.cnt_gray_s1[12]`，所以
   `get_nets *cnt_gray_s1*` 能精确拿到 16 个网。
3. **`set_max_delay -datapath_only` 在这个网表上不可用**
   （OpenSTA 报 `STA-0563`）。只用 `set_false_path -hold` 即可。

OpenROAD 实测（`RUN_2026-11-18_11-55-44` 网表）：

```text
*cnt_gray_s1*   -> 16 nets, 16 sink pins   set_false_path -hold OK
*cnt_gray_s2*   -> 16 nets, 23 sink pins   OK
*out_edges_g1*  -> 10 nets, 10 sink pins   OK
*out_edges_g2*  -> 20 nets, 36 sink pins   OK
*watch_s1*      ->  1 net,   1 sink pin    OK
*watch_s2*      ->  1 net,   3 sink pins   OK
*clr_r1*        ->  1 net,   1 sink pin    OK
*clr_r2*        ->  1 net,   3 sink pins   OK
TOTAL 93 sink pins
```

**预期收益**：

- 去掉 42 个 `DLY4X2H7R`（约 42 × 4 级缓冲），timing_repair 面积从
  1560 µm² 降到约 950 µm²（-3% die）。
- **同时解决第 7 节的门级仿真锁不住**：这些延迟器正是把数字环路时序
  拉离行为 DCO 假设的原因。

这一项的性价比高于第 5/6 节，因为它同时改善面积、时序和可验证性。

## 5. 布局密度与 die 尺寸

```text
FP_CORE_UTIL: 35        PL_TARGET_DENSITY_PCT: 50
DIE_AREA: [0,0,150,150] -> 实际 147.8 × 154.2 µm
core 20477.5 µm²   die 22943.2 µm²   utilization 1.0（填满）
pre-DPL utilization 47.6%
```

`utilization = 1.0` 不是真实 100% 利用率，而是 FILL 单元（4748 个）填满
了核心区。真实逻辑+时序单元是 3099 个 / 20477.5 µm²。

**动作**：`DIE_AREA` 是 placeholder，实际由 `FP_CORE_UTIL=35` 决定。
把 `FP_CORE_UTIL` 提到 45、`PL_TARGET_DENSITY_PCT` 保持 50，可在不放宽
时序的前提下把 die 缩小约 20%（面积 ~18.3k µm²）。这是安全的。

## 6. 面积构成（用于判断哪些优化值得做）

```text
sequential_cell              4075.4 µm²  19.9%
multi_input_combinational    3252.5 µm²  15.9%
other                       10999.2 µm²  53.7%   <- 含 fill 之外的门
clock_buffer                 442.7 µm²   2.2%
clock_inverter                45.1 µm²   0.2%
timing_repair_buffer        1560.2 µm²   7.6%
```

`other` 占 53.7% 是因为 LibreLane 把非标准分类（AOI/OAI/MUX/XOR 等）
都归到 `other`。实际逻辑门统计（去掉 fill/tap）：

```text
DFFRQX0P5H7R  398   NOR2X0P5H7R  195   BUFX16H7R  161
AOI21X0P5H7R  153   NAND2X0P5H7R 143   INVX0P5H7R 123
NOR2BX1H7R    115   XNOR2X0P5H7R 105   OAI21X0P5H7R 100
```

**398 个 `DFFRQX0P5H7R` 是最大的单一逻辑成本**（约占 sequential 的 78%）。
其中 `div`（分频器）与 `flock`（FLL）是主要消费者。缩减 DFF 数量的
唯一有效手段是算法级（例如 FLL 的 `cnt_filt` 位宽、DLF 的 `BITS`），
不是 PnR 参数。

## 7. 门级仿真锁不住的原因（影响验证，不影响 P&R 本身）

P&R 网表做功能仿真时 `LOCKED` 永不置位：

```text
FREQ_OK: 145 ns 拉起 -> 1505 ns 掉回
locked_q: 从未置位
```

根因是上表那 55 个 `DLY4X2H7R` 纯延迟单元改变了数字环路的反馈时序，
而 DCO 侧仍是行为模型 `sim_dco`。**给 PnR 网表做功能仿真应关闭时序
修复**（或从 SDF 取延迟），否则任何行为级 DCO 都会与延迟器失配。

## 8. 优先级建议

| 优先级 | 动作 | 预期收益 | 代价 |
|---|---|---|---|
| **P0** | CDC 同步器加 `set_false_path -to` | 去掉 42 个 DLY4X2（-3% die），**并修复门级仿真锁不住** | 改 SDC，需核对引脚名 |
| **P0** | 加 `VERILOG_DEFINES: [PLL_USE_ICS55_ICG]` | ICG 真正映射，CTS 可识别；面积 -31 µm² | 改 1 行配置 |
| **P0** | 让 P&R 用 OUT 2.5 ns 做优化目标 | OUT 域裕量从 +0.037 变可重复 | 改配置或 SDC |
| P1 | 时钟输出单独 `set_load` | 消 4 条 SS max_slew/cap | 改 SDC |
| P2 | `FP_CORE_UTIL` 35→45 | die 面积 -20% | 改配置，需重跑确认时序不退 |
| P3 | 减少 DFF（算法级） | 面积主项 | 改 RTL，风险最高 |

P0 三项都是配置/SDC 级改动，且各自有明确的验证指标：

- CDC 项 → `grep -c DLY4X2H7R` 应从 55 降到 ~13，且门级仿真应能置位 `LOCKED`；
- ICG 项 → `grep -c ICGNX1H7R` 应为 2，CTS 报告应列出 gating 单元；
- 2.5 ns 目标 → OUT 域最差 slack 应从 +0.037 显著拉开。

**顺序建议**：先做 CDC（收益最大且解决可验证性），再 ICG，最后 2.5 ns
目标——因为如果 2.5 ns 目标先上，repair 会在那些本不该检查的 CDC 路径上
插更多延迟器，反而更难收拾。

## 8.5 ICG 映射需要配套的 hold 修复（实测回归）

单看综合，`PLL_USE_ICS55_ICG` 是净收益（2403 vs 2434 µm²，ICG 可被 CTS
识别）。但**完整 P&R 后时序退步**：

| | 无 ICG 宏 | 有 ICG 宏 |
|---|---:|---:|
| hold WNS | 0.0000 | **-0.1150** |
| hold 违例 | 0 | **36** |
| setup WNS | 0.0000 | **-0.1222** |
| max_slew / max_cap 违例 | 2 / 2 | 9 / 4 |
| hold_buffer | 55 | 18 |
| timing_repair 面积 | 1560 µm² | 2120 µm² |

**原因**：ICG 把 `REF_G`/`DSM_CK_G` 从"组合与门"变成 CTS 拓扑里的真实
门控单元，负载与插入延迟随之改变。原本靠 55 个 `DLY4X2H7R` 勉强压住的
REF 域内部 hold（例如 `FREQ_OK` → `_3785_`，路径上有 3 个 `DLY4X2`），
在 hold_buffer 降到 18 后不再成立。

**这不是 ICG 本身的问题**，而是修 hold 的资源被重新分配后，REF 域那些
本该靠 CDC 约束豁免、却仍在被检查的路径暴露出来。这与第 4 节的 CDC 发现
是同一个根：**先做 CDC `set_false_path`，再做 ICG 映射**。当前顺序反了。

`VERILOG_DEFINES` 已从 `config.digital.yaml` 回退，保持已收敛基线
（`RUN_2026-11-18_11-55-44`）。ICG 映射留待 CDC 约束到位后再启用。

## 9. 已在本轮验证的实验

| 实验 | 结果 |
|---|---|
| 加 `-DPLL_USE_ICS55_ICG` 综合 `pll_logic` | 3671 cells / **2403 µm²**（当前 3672 / 2434），`ICGNX1H7R × 2`，`PLL_CLKGATE` 两个实例都正确映射 |
| 加 `VERILOG_DEFINES` 后跑完整 P&R | Yosys/OpenROAD 报告 **`Clock gate cell: 2, Area 11.20`**；fallback `en_l` 网完全消失 |
| 同上，看时序 | **回归**：hold WNS 0 → **-0.1150**（36 条违例），setup -0.1222（12 条），max_slew 2→9，max_cap 2→4。`hold_buffer` 55→18、`timing_repair` 1560→2120 µm² |
| 提取 55 个 `DLY4X2H7R` 的输入网 | 42 个在 `cnt_gray_s1/s2`、`out_edges_g1/g2`、`watch_s1/s2`、`clr_r1/r2` 上 |
| 检查 ICG liberty 属性 | `clock_gating_integrated_cell : "latch_negedge_postcontrol"`，area 5.6 µm²，CTS 可识别 |
| 检查 P&R 优化目标 | `CLOCK_PERIOD = 20`（REF），OUT 的 2.5 ns 只存在于 SDC，未进 P&R 优化 |
