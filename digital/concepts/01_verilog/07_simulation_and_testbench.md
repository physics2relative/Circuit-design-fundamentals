# Simulation and Testbench

## 핵심 관점

Testbench는 RTL을 검증하기 위한 simulation 환경이다. 합성 대상 RTL과 다르게 delay, display task, waveform dump 같은 simulation 전용 문법을 사용할 수 있다.

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

DUT는 Design Under Test의 약자이다. testbench는 DUT에 clock, reset, input stimulus를 넣고 output을 확인한다.

## 확인 항목

- reset 직후 상태
- 정상 입력 sequence
- boundary condition
- invalid input 또는 corner case
- output timing
- expected result와 실제 result 비교

## Waveform vs Self-checking

Waveform 확인은 디버깅에 유용하지만 모든 case를 눈으로 확인하기 어렵다. 가능한 경우 expected output을 testbench에서 비교하는 self-checking 구조가 좋다.

```verilog
if (count !== expected_count) begin
    $display("ERROR: count mismatch. expected=%0d actual=%0d", expected_count, count);
end
```

## Testbench 전용 문법

일반적으로 다음은 testbench에서 사용한다.

- `#delay`
- `$display`
- `$monitor`
- `$finish`
- waveform dump task
- file I/O

## 정리

Testbench는 DUT가 specification대로 동작하는지 검증하는 환경이다. 단순 waveform 확인보다 expected behavior를 비교하는 구조가 더 견고하다. Testbench 코드는 일반적으로 합성 대상이 아니다.
