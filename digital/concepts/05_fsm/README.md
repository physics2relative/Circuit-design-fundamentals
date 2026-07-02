# Finite State Machine

## 핵심 관점

FSM은 control logic을 state와 state transition으로 표현하는 방법이다. 복잡한 조건문을 무작정 나열하는 대신, 가능한 상태와 전이 조건을 명확히 정의해 동작을 구조화한다.

## 기본 구성

FSM은 다음 요소로 구성된다.

- state
- input
- output
- next-state logic
- state register
- output logic

일반적인 구조는 다음과 같다.

```text
current_state + inputs → next_state
current_state + inputs → outputs
clock edge → current_state update
```

## Moore machine

Moore machine은 output이 current state에만 의존하는 FSM이다.

```text
output = f(state)
```

장점은 output이 state register를 기준으로 안정적이라는 점이다. timing 분석과 glitch 관리가 상대적으로 쉽다. 단점은 input 변화에 대한 반응이 한 cycle 늦어질 수 있고, state 수가 증가할 수 있다는 점이다.

## Mealy machine

Mealy machine은 output이 current state와 input에 함께 의존하는 FSM이다.

```text
output = f(state, input)
```

장점은 input 변화에 빠르게 반응할 수 있고 state 수를 줄일 수 있다는 점이다. 단점은 input glitch나 timing path에 더 민감할 수 있다는 점이다.

## State encoding

State encoding은 상태를 어떤 bit pattern으로 표현할지 정하는 것이다.

### Binary encoding

적은 bit 수로 상태를 표현한다.

```text
N states → ceil(log2(N)) bits
```

flop 수는 적지만 next-state logic이 복잡해질 수 있다.

### One-hot encoding

각 state를 하나의 bit로 표현한다.

```text
N states → N bits
```

flop 수는 늘어나지만 next-state logic이 단순해질 수 있다. FPGA에서는 one-hot encoding이 유리한 경우가 있다.

### Gray encoding

인접 state transition에서 한 bit만 바뀌도록 하는 encoding이다. 특정 counter나 crossing 관련 설계에서 유용할 수 있다.

## FSM RTL 구조

일반적인 FSM RTL은 next-state logic과 state register를 분리한다.

```verilog
always @(*) begin
    next_state = state;

    case (state)
        IDLE: begin
            if (start)
                next_state = RUN;
        end
        RUN: begin
            if (done)
                next_state = DONE;
        end
        DONE: begin
            next_state = IDLE;
        end
        default: begin
            next_state = IDLE;
        end
    endcase
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        state <= IDLE;
    else
        state <= next_state;
end
```

## Output logic

Moore style output은 state에 따라 결정된다.

```verilog
always @(*) begin
    busy = 1'b0;
    done_pulse = 1'b0;

    case (state)
        RUN:  busy = 1'b1;
        DONE: done_pulse = 1'b1;
        default: begin
            busy = 1'b0;
            done_pulse = 1'b0;
        end
    endcase
end
```

Mealy style output은 state와 input에 함께 의존한다.

```verilog
always @(*) begin
    accept = 1'b0;

    if (state == IDLE && valid)
        accept = 1'b1;
end
```

## Illegal state recovery

FSM이 정의되지 않은 state에 들어갈 가능성을 고려해야 한다. reset, soft error, X propagation, coding mistake 등으로 illegal state가 발생할 수 있다.

일반적으로 `default` branch에서 safe state로 복구한다.

```verilog
default: begin
    next_state = IDLE;
end
```

## FSM 설계 절차

1. 입력과 출력 정의
2. reset state 정의
3. 가능한 state 나열
4. state transition 조건 정리
5. Moore/Mealy 선택
6. state encoding 선택
7. next-state logic 작성
8. output logic 작성
9. illegal state 처리
10. transition coverage 확인

## 검증 포인트

- reset 후 initial state
- 모든 state transition
- 모든 output condition
- illegal state recovery
- 동시에 들어오는 input condition
- state가 stuck되지 않는지 여부
- one-cycle pulse output의 길이

## 정리

FSM은 control logic을 state 중심으로 구조화하는 방법이다. 좋은 FSM은 state 정의가 명확하고, transition 조건이 빠짐없으며, output timing과 illegal state recovery가 설계에 포함되어 있다.
