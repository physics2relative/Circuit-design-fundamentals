# Combinational Logic Model

## 기본 성질

Combinational logic은 현재 입력만으로 출력이 결정되는 logic이다.

```text
output = f(current inputs)
```

내부에 memory가 없어야 하며 clock edge를 기다리지 않는다.

## RTL 표현

Verilog에서는 보통 `assign` 또는 `always @(*)`로 표현한다.

```verilog
assign y = a & b;
```

```verilog
always @(*) begin
    y = a & b;
end
```

## Latch와의 경계

조합논리는 어떤 입력 조합에서도 출력이 완전히 결정되어야 한다. 일부 조건에서 값이 assign되지 않으면 이전 값을 유지해야 하는 것으로 해석되어 latch가 생길 수 있다.

## Timing 관점

Combinational logic에는 propagation delay가 존재한다. 입력이 바뀐 뒤 출력이 안정되기까지 시간이 필요하며, 긴 조합 경로는 critical path가 될 수 있다.
