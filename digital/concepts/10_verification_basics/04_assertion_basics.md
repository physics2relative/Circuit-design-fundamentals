# 10-04. Assertion Basics

Assertion은 설계가 반드시 만족해야 하는 조건을 코드로 표현한 check이다. Testbench checker가 end-to-end 결과를 확인한다면, assertion은 protocol violation이나 illegal state를 발생 지점 근처에서 잡는 데 유용하다.

## Assertion의 목적

Assertion은 다음 질문에 답한다.

```text
이 상황은 절대 발생하면 안 되는가?
이 신호 관계는 항상 지켜져야 하는가?
이 protocol rule은 깨지면 안 되는가?
```

예를 들어 FIFO에서는 다음 rule을 assertion으로 표현할 수 있다.

```text
full 상태에서 단독 push가 발생하면 안 된다.
empty 상태에서 단독 pop이 발생하면 안 된다.
```

## Immediate assertion 개념

Immediate assertion은 procedural block 안에서 즉시 조건을 검사하는 형태이다.

```verilog
always @(posedge clk) begin
    if (rst_n) begin
        assert (!(full && push && !pop));
    end
end
```

Verilog-only 스타일에서는 직접 `if`와 `$fatal`로 작성해도 assertion과 비슷한 효과를 낼 수 있다.

```verilog
if (full && push && !pop) begin
    $display("ERROR: overflow");
    $fatal;
end
```

## Concurrent assertion 개념

Concurrent assertion은 clock을 기준으로 시간 관계를 표현하는 SystemVerilog Assertion이다.

```systemverilog
property valid_hold_until_ready;
    @(posedge clk) disable iff (!rst_n)
    valid && !ready |=> valid;
endproperty

assert property (valid_hold_until_ready);
```

이 예시는 `valid`가 올라갔는데 `ready`가 아직 0이면 다음 cycle에도 valid가 유지되어야 한다는 rule을 표현한다.

## Protocol rule check

Assertion은 protocol 검증에 특히 유용하다.

Valid-ready interface에서 자주 보는 rule은 다음이다.

- valid가 올라간 뒤 transfer 전까지 data가 안정적이어야 한다.
- ready가 늦게 올라와도 valid를 임의로 내리면 안 되는 protocol이 있을 수 있다.
- full 상태에서 write transaction이 발생하면 안 된다.
- empty 상태에서 read transaction이 발생하면 안 된다.

CDC/FIFO 같은 block에서는 다음도 중요하다.

- reset 후 empty가 1이어야 한다.
- Gray pointer는 한 번에 한 bit만 바뀌어야 한다.
- count는 0과 depth 사이에 있어야 한다.

## Assertion과 checker의 차이

Checker는 보통 “최종 결과가 맞는가”를 본다. Assertion은 “중간 과정에서 깨지면 안 되는 rule이 깨졌는가”를 본다.

```text
checker: output data sequence가 맞는지 확인
assertion: overflow/underflow/protocol violation 즉시 확인
```

둘은 경쟁 관계가 아니라 보완 관계이다.

## 설계자 관점의 assertion

RTL 설계자가 모든 SVA를 깊게 다룰 필요는 없지만, 자신이 만든 block의 핵심 assumption은 assertion으로 표현할 수 있어야 한다.

예를 들어 다음 rule은 설계자가 직접 넣기 좋다.

- FSM state가 정의된 값 안에 있는가
- FIFO overflow/underflow가 발생하지 않는가
- one-hot state가 정말 one-hot인가
- request가 들어오면 일정 조건에서 eventually acknowledge가 오는가

## 핵심 정리

Assertion은 설계의 rule을 실행 중에 검사하는 장치이다. Self-checking testbench가 결과 비교라면, assertion은 protocol violation과 illegal state를 발생 지점 근처에서 잡는 수단이다.
