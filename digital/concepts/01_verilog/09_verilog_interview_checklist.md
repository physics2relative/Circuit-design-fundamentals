# Verilog Interview Checklist

## Verilog를 RTL 관점에서 설명하기

Verilog는 software처럼 순차 실행되는 절차를 쓰기 위한 언어가 아니라, clock과 signal 사이의 hardware 동작을 기술하는 HDL이다. 면접에서는 문법 자체보다 “이 코드가 어떤 회로로 합성되는가”를 중심으로 설명해야 한다.

## `wire`와 `reg`의 차이

- `wire`는 continuous assignment나 module connection으로 구동되는 net이다.
- `reg`는 procedural block 안에서 값을 대입받을 수 있는 variable이다.
- `reg`라는 이름이 항상 flip-flop을 의미하지는 않는다.

답변 포인트는 다음과 같다.

```text
reg가 clocked always block에서 update되면 flip-flop으로 합성될 수 있고,
combinational always block에서 assign되면 조합논리로 합성될 수 있다.
```

## Blocking과 non-blocking

- Blocking `=`은 procedural block 안에서 문장 순서대로 즉시 반영되는 것처럼 동작한다.
- Non-blocking `<=`은 RHS를 먼저 평가하고 time step 끝에서 LHS를 갱신한다.

일반 원칙은 다음과 같다.

```text
조합논리: blocking assignment
순차논리: non-blocking assignment
```

면접에서는 clocked block에서 blocking을 잘못 쓰면 pipeline 동작이 simulation에서 의도와 다르게 보일 수 있다는 점까지 말하면 좋다.

## `always @(*)`를 쓰는 이유

`always @(*)`는 조합논리 block의 sensitivity list를 자동으로 구성한다. 직접 sensitivity list를 쓰다가 입력을 빠뜨리면 simulation과 synthesis mismatch가 생길 수 있다.

## 조합논리 RTL 작성 시 체크할 점

- 모든 output에 default assignment를 준다.
- 모든 branch에서 output이 결정되게 한다.
- `case`에는 필요한 경우 `default`를 둔다.
- 의도하지 않은 latch inference를 피한다.

## 순차논리 RTL 작성 시 체크할 점

- `always @(posedge clk ...)` 구조를 명확히 사용한다.
- sequential update에는 non-blocking assignment를 사용한다.
- reset value와 normal update path를 명확히 구분한다.
- enable이 있을 경우 hold 동작이 의도한 것인지 확인한다.

## Bit width와 signed 처리

Verilog에서는 width mismatch, signed/unsigned 혼용, truncation이 bug를 만들기 쉽다. 산술 연산에서는 operand width와 signed 해석을 명확히 해야 한다.

답변 포인트는 다음과 같다.

```text
같은 bit pattern도 signed/unsigned 해석에 따라 값이 달라진다.
따라서 datapath RTL에서는 width extension, truncation, signed casting을 의도적으로 작성해야 한다.
```

## Parameterization

Parameter는 같은 RTL 구조를 width나 depth만 바꿔 재사용할 때 사용한다. 단, parameter 변경 시 counter width, address width, overflow condition, generate 범위가 함께 맞는지 확인해야 한다.

## Simulation과 synthesis mismatch

대표 원인은 다음과 같다.

- sensitivity list 누락
- blocking/non-blocking 오용
- incomplete assignment로 인한 latch inference
- `initial` block에 의존한 합성 불가능 초기화
- `x`, `z`를 실제 hardware처럼 오해하는 경우

## 핵심 답변 문장

- Verilog RTL은 실행 순서가 아니라 합성될 hardware 구조를 의식해서 작성해야 한다.
- `reg`는 procedural assignment 대상이지 항상 physical register를 의미하지는 않는다.
- 조합논리는 blocking, 순차논리는 non-blocking을 쓰는 것이 일반적인 안전한 coding style이다.
- 의도하지 않은 latch와 simulation/synthesis mismatch를 피하는 것이 Verilog 면접의 핵심이다.
