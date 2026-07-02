# Latch and Flip-Flop

## Latch

Latch는 level-sensitive storage element이다.

```text
enable = 1 → transparent
enable = 0 → hold
```

enable이 active인 동안 input 변화가 output으로 전달될 수 있다. 의도적으로 사용할 수도 있지만, 일반적인 synchronous RTL에서는 unintended latch를 피하는 것이 기본이다.

## Flip-flop

Flip-flop은 edge-sensitive storage element이다. clock edge에서 input을 capture하고 다음 clock edge까지 값을 유지한다.

```verilog
always @(posedge clk) begin
    q <= d;
end
```

Synchronous digital design의 기본 state element이다.

## 차이

```text
Latch     → level-sensitive
Flip-flop → edge-sensitive
```

Latch는 transparency 때문에 timing 분석과 검증이 어려워질 수 있다. 의도하지 않은 latch는 RTL bug로 본다.
