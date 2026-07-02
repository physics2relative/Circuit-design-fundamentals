# Registered Output FSM

## 핵심 관점

Registered output FSM은 FSM의 output을 조합논리 결과로 바로 내보내지 않고, clock edge에서 register에 저장해 출력하는 방식이다.

```text
next_output = f(state, input)
output <= next_output at clock edge
```

출력이 clock edge에서만 바뀌므로 downstream logic 입장에서 안정적인 control signal을 받을 수 있다.

## 기본 구조

State와 output을 같은 clock edge에서 함께 update한다.

```verilog
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= IDLE;
        out   <= 1'b0;
    end else begin
        state <= next_state;
        out   <= next_out;
    end
end
```

`next_state`와 `next_out`은 조합논리에서 계산한다.

```verilog
always @(*) begin
    next_state = state;
    next_out   = 1'b0;

    case (state)
        IDLE: begin
            if (start) begin
                next_state = RUN;
                next_out   = 1'b1;
            end
        end

        RUN: begin
            next_state = DONE;
            next_out   = 1'b0;
        end

        DONE: begin
            next_state = IDLE;
            next_out   = 1'b0;
        end

        default: begin
            next_state = IDLE;
            next_out   = 1'b0;
        end
    endcase
end
```

## Moore / Mealy와의 관계

Moore FSM은 output이 state에만 의존한다.

```text
output = f(state)
```

Mealy FSM은 output이 state와 input에 함께 의존한다.

```text
output = f(state, input)
```

Registered output FSM은 output function이 Moore형이든 Mealy형이든, 최종 output을 register에 한 번 저장해서 내보내는 구조이다.

```text
next_output = f(state)          또는 f(state, input)
output <= next_output
```

따라서 registered output은 Moore/Mealy와 별개의 output timing 선택으로 볼 수 있다.

## 장점

### Glitch 감소

조합 output은 state decode delay나 input 변화 때문에 glitch가 생길 수 있다. Registered output은 clock edge에서만 바뀌므로 output glitch를 줄일 수 있다.

### Timing 분석 단순화

Output이 register에서 나오므로 downstream logic 입장에서는 register-to-register path가 된다.

```text
FSM output register → downstream combinational logic → downstream register
```

### Interface signal에 적합

다른 block으로 나가는 control signal은 registered output이 안정적인 경우가 많다.

예시는 다음과 같다.

- `valid`
- `done`
- `busy`
- `enable`
- `write_en`
- `read_en`
- `grant`

## 단점

### Latency 증가

Output을 register에 저장하므로 조합 output보다 1 cycle 늦어질 수 있다.

```text
condition 발생
→ next_out 계산
→ 다음 clock edge에서 out update
```

### Cycle alignment 필요

State, data, control signal의 cycle 관계를 명확히 맞춰야 한다. output이 state보다 한 cycle 늦거나 빠르게 보이면 protocol bug가 될 수 있다.

## Moore output을 한 번 더 register하는 방식

State만 먼저 update하고, 현재 state decode 결과를 output register에 저장하는 방식도 있다.

```verilog
always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        out <= 1'b0;
    else begin
        case (state)
            IDLE: out <= 1'b0;
            RUN:  out <= 1'b1;
            DONE: out <= 1'b0;
            default: out <= 1'b0;
        endcase
    end
end
```

이 방식은 output이 안정적이지만, 조합 Moore output보다 1 cycle 늦을 수 있다.

## 사용 기준

Registered output이 적합한 경우는 다음과 같다.

- output glitch를 줄여야 하는 경우
- 다른 block으로 나가는 control signal인 경우
- downstream timing을 register-to-register path로 만들고 싶은 경우
- interface protocol에서 output이 clock boundary에 맞춰야 하는 경우

조합 output이 필요한 경우는 다음과 같다.

- 같은 cycle response가 반드시 필요한 경우
- latency가 매우 중요한 짧은 control path인 경우
- output이 내부 combinational decision으로만 쓰이고 timing 여유가 충분한 경우

## 검증 포인트

- output이 의도한 cycle에 assert/deassert되는지 확인한다.
- state transition과 output update cycle이 맞는지 확인한다.
- one-cycle pulse output이 정확히 한 cycle 유지되는지 확인한다.
- reset 이후 output default value가 안전한지 확인한다.
- downstream block이 기대하는 valid/control timing과 맞는지 확인한다.

## 정리

Registered output FSM은 output을 clock edge에서 update하는 FSM coding style이다. Glitch를 줄이고 timing을 안정화하는 장점이 있지만, output latency와 cycle alignment를 반드시 고려해야 한다.
