# Assignment Semantics

## 핵심 관점

Verilog assignment는 단순히 값을 넣는 문법이 아니다. 어떤 assignment를 쓰느냐에 따라 조합 연결, 조합 always block, clocked register update가 달라진다.

## Continuous assignment: `assign`

`assign`은 net을 지속적으로 drive한다. 보통 `wire`에 사용한다.

```verilog
wire y;
assign y = a & b;
```

입력이 바뀌면 출력도 조합논리 delay 이후 바뀌는 구조로 해석된다.

## Procedural assignment

`always` block 내부에서 사용하는 assignment이다.

```verilog
reg y;

always @(*) begin
    y = a & b;
end
```

## Blocking assignment `=`

blocking assignment는 procedural block 안에서 문장 순서대로 즉시 반영되는 것처럼 동작한다. 조합논리 모델링에 주로 사용한다.

```verilog
always @(*) begin
    tmp = a & b;
    y   = tmp | c;
end
```

## Non-blocking assignment `<=`

non-blocking assignment는 우변을 먼저 평가하고 같은 time step의 끝에서 좌변을 갱신한다. clocked sequential logic에 주로 사용한다.

```verilog
always @(posedge clk) begin
    q1 <= d;
    q2 <= q1;
end
```

위 코드는 `q2`가 이전 cycle의 `q1` 값을 받는 pipeline 구조로 해석된다.

## 기본 규칙

```text
assign                    → continuous combinational connection
always @(*) + =           → combinational procedural logic
always @(posedge clk) + <= → sequential register update
```

## Multiple driver

하나의 signal을 여러 block에서 drive하면 의도하지 않은 회로가 되거나 합성 오류가 발생한다.

나쁜 예:

```verilog
assign y = a & b;

always @(*) begin
    y = c | d;
end
```

## 정리

조합논리는 현재 입력으로 출력이 결정되도록 작성하고, 순차논리는 clock edge에서 state가 갱신되도록 작성한다. assignment 선택은 simulation behavior와 synthesis result를 모두 결정하므로 일관된 coding rule이 필요하다.
