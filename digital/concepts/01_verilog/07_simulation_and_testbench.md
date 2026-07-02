# Simulation and Testbench

## 핵심 관점

Testbench는 RTL을 검증하기 위한 simulation 환경입니다. 합성 대상 RTL과 다르게 delay, display task, waveform dump 같은 simulation 전용 문법을 사용할 수 있습니다.

## 기본 구조

```verilog
module tb_counter;

reg clk;
reg rst_n;
wire [7:0] count;

counter u_dut (
    .clk   (clk),
    .rst_n (rst_n),
    .count (count)
);

initial begin
    clk = 1'b0;
    forever #5 clk = ~clk;
end

initial begin
    rst_n = 1'b0;
    #20;
    rst_n = 1'b1;
    #200;
    $finish;
end

endmodule
```

## DUT

DUT는 Design Under Test의 약자입니다. testbench는 DUT에 clock, reset, input stimulus를 넣고 output을 확인합니다.

## 확인해야 할 것

- reset 직후 상태
- 정상 입력 sequence
- boundary condition
- invalid input 또는 corner case
- output timing
- expected result와 실제 result 비교

## Waveform vs Self-checking

Waveform 확인은 디버깅에 유용하지만, 모든 case를 눈으로 확인하기 어렵습니다. 가능한 경우 expected output을 testbench에서 비교하는 self-checking 구조가 좋습니다.

```verilog
if (count !== expected_count) begin
    $display("ERROR: count mismatch. expected=%0d actual=%0d", expected_count, count);
end
```

## Testbench 전용 문법

일반적으로 다음은 testbench에서 사용합니다.

- `#delay`
- `$display`
- `$monitor`
- `$finish`
- waveform dump task
- file I/O

## 면접 질문

### Q. Testbench의 목적은?

면접 답변:

> Testbench는 DUT가 specification대로 동작하는지 simulation으로 검증하기 위한 환경입니다. clock/reset을 만들고, stimulus를 넣고, output을 expected behavior와 비교합니다. 단순히 waveform을 보는 것보다 corner case와 self-checking을 포함하는 것이 좋습니다.

### Q. Testbench 코드는 합성되는가?

면접 답변:

> 일반적으로 testbench는 합성 대상이 아닙니다. delay, display task, file I/O 같은 simulation 전용 문법을 사용할 수 있고, 실제 hardware로 만들 RTL과는 구분해야 합니다.
