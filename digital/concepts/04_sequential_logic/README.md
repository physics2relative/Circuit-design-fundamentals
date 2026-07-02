# Sequential Logic

## 핵심 관점

Sequential logic은 현재 입력뿐 아니라 저장된 state에 의해 출력이나 다음 state가 결정되는 logic이다. 대부분 clock edge에서 state가 update되는 flip-flop 기반 구조로 설계한다.

## 기본 성질

```text
next_state = f(current_state, current_inputs)
output     = g(current_state, current_inputs)
```

Sequential logic의 핵심은 state를 저장한다는 점이다. 이 state는 clock edge를 기준으로 update된다.

## Latch

Latch는 level-sensitive storage element이다. enable이 active인 동안 input 변화가 output으로 전달될 수 있다.

```text
enable = 1 → transparent
enable = 0 → hold
```

Latch는 의도적으로 사용할 수도 있지만, 일반적인 synchronous RTL에서는 unintended latch를 피하는 것이 기본이다. latch는 timing 분석과 검증을 어렵게 만들 수 있다.

## Flip-flop

Flip-flop은 edge-sensitive storage element이다. clock edge에서 input을 capture하고 다음 clock edge까지 값을 유지한다.

```verilog
always @(posedge clk) begin
    q <= d;
end
```

Synchronous digital design의 기본 state element이다.

## Register

Register는 하나 이상의 flip-flop으로 구성된 storage이다. datapath value, valid bit, FSM state, counter value 등을 저장한다.

```verilog
always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        data_q <= 8'b0;
    else
        data_q <= data_d;
end
```

## Counter

Counter는 현재 값에 1을 더하거나 빼는 sequential circuit이다.

```verilog
always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        count <= 8'b0;
    else if (en)
        count <= count + 1'b1;
end
```

Counter 설계 시 width, overflow, wrap-around, enable, reset behavior를 명확히 해야 한다.

## Shift register

Shift register는 매 clock마다 data를 한 방향으로 이동시키는 sequential circuit이다.

```verilog
always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        shift <= 4'b0;
    else
        shift <= {shift[2:0], din};
end
```

Serial-to-parallel, delay line, simple filter, synchronizer 등에 사용된다.

## Enable

Enable은 clock은 계속 공급하되 register update 여부를 제어하는 signal이다.

```verilog
always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        q <= 1'b0;
    else if (en)
        q <= d;
end
```

`en`이 0이면 register는 이전 값을 유지한다. Clock gating과 달리 clock 자체를 직접 가공하지 않는다.

## Pipeline register

Pipeline register는 긴 combinational path를 여러 stage로 나누기 위해 삽입하는 register이다.

```text
logic A → reg → logic B → reg → logic C
```

Pipeline은 clock frequency를 높일 수 있지만 latency가 증가한다. data와 control signal의 cycle alignment가 중요하다.

## Reset

Sequential logic은 reset 이후 state가 명확해야 한다. 특히 FSM state, valid bit, control register는 reset이 필요한 경우가 많다. 모든 datapath register를 무조건 reset하는 것은 area/timing 부담이 될 수 있다.

## 정리

Sequential logic은 state를 저장하고 clock edge에서 update되는 구조이다. 설계 시 reset, enable, width, update condition, pipeline alignment를 명확히 해야 한다. Unintended latch를 피하고 flip-flop 기반 synchronous design을 유지하는 것이 기본이다.
