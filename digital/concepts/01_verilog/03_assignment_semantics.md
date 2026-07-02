# Assignment Semantics

## 핵심 관점

Verilog assignment는 “값을 넣는다” 이상의 의미를 갖습니다. 어떤 assignment를 쓰느냐에 따라 조합 연결, 조합 always block, clocked register update가 달라집니다.

## Continuous assignment: `assign`

`assign`은 net을 지속적으로 drive합니다. 보통 `wire`에 사용합니다.

```verilog
wire y;
assign y = a & b;
```

입력이 바뀌면 출력도 조합논리 delay 이후 바뀌는 구조로 해석됩니다.

## Procedural assignment

`always` block 내부에서 사용하는 assignment입니다.

```verilog
reg y;

always @(*) begin
    y = a & b;
end
```

## Blocking assignment `=`

blocking assignment는 procedural block 안에서 문장 순서대로 즉시 반영되는 것처럼 동작합니다. 조합논리 모델링에 주로 사용합니다.

```verilog
always @(*) begin
    tmp = a & b;
    y   = tmp | c;
end
```

## Non-blocking assignment `<=`

non-blocking assignment는 우변을 먼저 평가하고, 같은 time step의 끝에서 좌변을 갱신합니다. clocked sequential logic에 주로 사용합니다.

```verilog
always @(posedge clk) begin
    q1 <= d;
    q2 <= q1;
end
```

위 코드는 `q2`가 이전 cycle의 `q1` 값을 받는 pipeline 구조로 해석됩니다.

## 기본 규칙

```text
assign              → continuous combinational connection
always @(*) + =     → combinational procedural logic
always @(posedge) + <= → sequential register update
```

## Multiple driver 주의

하나의 signal을 여러 block에서 drive하면 의도하지 않은 회로가 되거나 합성 오류가 발생합니다.

나쁜 예:

```verilog
assign y = a & b;

always @(*) begin
    y = c | d;
end
```

## 면접 질문

### Q. Blocking과 non-blocking의 차이는?

면접 답변:

> Blocking assignment는 procedural block 안에서 순서대로 즉시 반영되는 것처럼 동작하고, non-blocking assignment는 우변 평가 후 time step 끝에서 좌변이 갱신됩니다. 그래서 조합논리에는 blocking, clocked 순차논리에는 non-blocking을 쓰는 것이 일반적인 RTL coding rule입니다.

### Q. Clocked block에서 blocking을 쓰면 왜 위험한가?

면접 답변:

> pipeline register처럼 cycle 간 값 전달을 표현해야 하는데 blocking을 쓰면 같은 block 안에서 값이 즉시 전파되는 것처럼 simulation될 수 있습니다. 그러면 의도한 flip-flop chain과 simulation behavior가 달라질 수 있습니다.
