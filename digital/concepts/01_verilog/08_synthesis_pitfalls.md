# Synthesis Pitfalls

## 핵심 관점

Verilog RTL은 simulation에서 맞아 보이더라도 synthesis 결과가 의도와 다를 수 있다. warning을 무시하지 않고, 코드가 어떤 hardware로 해석되는지 확인해야 한다.

## 1. Latch inference

조합 always block에서 모든 path에 값을 assign하지 않으면 이전 값을 유지해야 하는 것으로 해석되어 latch가 생길 수 있다.

```verilog
always @(*) begin
    if (sel)
        y = a;
    // sel == 0일 때 y가 assign되지 않음
end
```

해결:

```verilog
always @(*) begin
    y = 1'b0;
    if (sel)
        y = a;
end
```

## 2. Multiple driver

하나의 signal을 여러 assignment나 always block에서 drive하면 안 된다.

```verilog
assign y = a & b;

always @(*) begin
    y = c | d;
end
```

## 3. Width mismatch

```verilog
wire [3:0] a;
wire [7:0] y;

assign y = a + 8'd1;
```

자동 extension이나 truncation이 의도와 맞는지 확인해야 한다.

## 4. Signed/unsigned mismatch

signed 연산이 필요한데 unsigned로 선언하면 비교나 산술 결과가 달라질 수 있다.

## 5. Blocking/non-blocking 혼용

같은 sequential logic에서 blocking과 non-blocking을 섞으면 simulation behavior가 직관과 달라질 수 있다. 일반적으로 clocked always block에서는 non-blocking으로 통일한다.

## 6. Sensitivity list 누락

조합논리에서 직접 sensitivity list를 작성하다가 입력을 누락하면 simulation과 synthesis가 다르게 보일 수 있다. 조합논리에는 `always @(*)`를 사용한다.

## 7. Combinational loop

조합논리 출력이 다시 자기 입력으로 feedback되면 combinational loop가 생길 수 있다. 의도하지 않은 oscillation이나 timing 분석 문제가 발생한다.

## 8. Incomplete reset or initialization assumption

Simulation에서는 초기값이 특정 값처럼 보일 수 있지만 실제 hardware reset 후 값이 정의되지 않을 수 있다. reset이 필요한 state는 명확히 reset한다.

## 정리

많은 warning은 width mismatch, latch inference, multiple driver, unused signal처럼 실제 hardware bug로 이어질 수 있는 문제를 알려준다. warning-free를 목표로 하거나, 남기는 warning은 이유를 명확히 알고 있어야 한다.
