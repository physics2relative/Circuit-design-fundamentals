# 10-02. Testbench Structure

Testbench는 DUT에 input을 넣고 output을 관찰해서 RTL 동작을 검증하는 환경이다. 좋은 testbench는 단순히 signal을 흔드는 것이 아니라, clock/reset, stimulus, monitor, checker가 역할별로 나뉘어 있다.

## 기본 구성

일반적인 testbench 구조는 다음과 같다.

```text
             stimulus
                |
                v
clock/reset -> DUT -> monitor -> checker/pass-fail
                |
             waveform
```

핵심 block은 다음이다.

- DUT instance
- clock/reset generation
- stimulus driver
- monitor
- checker
- optional reference model / scoreboard

## DUT instance

DUT는 검증 대상 module이다. Testbench에서는 DUT의 input/output을 wire/reg로 선언하고 instance로 연결한다.

```verilog
sync_fifo dut (
    .clk(clk),
    .rst_n(rst_n),
    .in_valid(in_valid),
    .in_ready(in_ready),
    .in_data(in_data),
    .out_valid(out_valid),
    .out_ready(out_ready),
    .out_data(out_data)
);
```

DUT port를 연결할 때는 width와 active polarity를 확인해야 한다. 특히 reset이 active-low인지 active-high인지 혼동하기 쉽다.

## Clock / reset generation

Clock은 보통 `always` block으로 만든다.

```verilog
initial clk = 1'b0;
always #5 clk = ~clk;
```

Reset은 초기 몇 cycle 동안 assert한 뒤 release한다.

```verilog
initial begin
    rst_n = 1'b0;
    repeat (3) @(posedge clk);
    rst_n = 1'b1;
end
```

검증에서는 reset 직후 state를 반드시 확인해야 한다. FIFO라면 empty가 1인지, FSM이라면 IDLE state인지 확인하는 식이다.

## Stimulus

Stimulus는 DUT input을 구동하는 부분이다. 단순한 test에서는 task로 push/pop 같은 동작을 묶는 것이 좋다.

```verilog
task push_byte;
    input [7:0] data;
    begin
        @(negedge clk);
        in_data  = data;
        in_valid = 1'b1;
        @(negedge clk);
        in_valid = 1'b0;
    end
endtask
```

Stimulus는 DUT의 protocol을 지켜야 한다. valid-ready interface라면 `valid && ready`가 실제 transaction이라는 점을 기준으로 작성해야 한다.

## Monitor

Monitor는 DUT output이나 interface transaction을 관찰하는 역할이다. 예를 들어 FIFO에서는 `out_valid && out_ready`가 발생할 때 output data를 capture한다.

```text
if out_valid && out_ready:
    observed_data = out_data
```

Monitor는 DUT를 drive하지 않고 관찰만 해야 한다.

## Checker

Checker는 expected result와 actual result를 비교한다.

```verilog
if (out_data !== expected) begin
    $display("ERROR: data mismatch");
    errors = errors + 1;
end
```

좋은 testbench는 사람이 waveform을 열지 않아도 PASS/FAIL이 log로 명확히 나와야 한다.

## Testbench 작성 포인트

- clock edge 기준으로 drive/check timing을 분리한다.
- reset 이후 초기 상태를 확인한다.
- transaction 조건을 명확히 정의한다.
- output check를 자동화한다.
- 실패 시 어떤 조건에서 실패했는지 log를 남긴다.

## 핵심 정리

Testbench는 DUT를 둘러싼 작은 검증 환경이다. Clock/reset, stimulus, monitor, checker를 분리해서 생각하면 directed test도 구조적으로 작성할 수 있다.
