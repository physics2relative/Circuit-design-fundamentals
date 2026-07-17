# 2-3. Propagation Delay and Load Capacitance

Propagation delay는 input transition이 output transition으로 나타나기까지 걸리는 시간이다. CMOS gate에서는 output node의 capacitance를 충전하거나 방전하는 시간이 delay를 만든다.

## 기본 모델

가장 단순하게는 다음처럼 볼 수 있다.

```text
tpd ≈ Ron * CL
```

- Ron: 켜진 transistor network의 effective resistance
- CL: output node가 구동해야 하는 load capacitance

## Load capacitance의 구성

Load capacitance는 단순히 wire capacitance만 의미하지 않는다.

```text
CL = 다음 gate들의 input capacitance + wire capacitance + diffusion capacitance
```

## Large gate input과 fanout

Fanout은 하나의 output이 몇 개의 gate input을 구동하는지이다. Large gate input은 그중 하나의 gate 자체가 큰 input capacitance를 갖는 경우이다.

```text
fanout 증가       -> 연결된 gate input 개수가 많아짐
large gate input  -> 연결된 gate 하나의 input capacitance가 큼
```

둘 다 load capacitance를 증가시키지만 원인은 다르다.

## Rise / fall delay

Output rise는 PMOS network가 load capacitance를 충전하는 과정이고, output fall은 NMOS network가 방전하는 과정이다.

PMOS mobility가 NMOS보다 낮기 때문에 같은 width라면 PMOS pull-up이 더 약한 경우가 많다. 그래서 rise/fall delay를 맞추기 위해 PMOS를 더 크게 sizing한다.

## RTL 설계 관점

RTL 단계에서 transistor-level delay를 직접 계산하지는 않지만 다음은 중요하다.

- 큰 fanout signal은 timing 문제가 되기 쉽다.
- enable, reset, valid 같은 control signal은 넓게 퍼져 load가 커질 수 있다.
- pipeline register를 추가하면 combinational depth와 load를 줄일 수 있다.
- registered output은 다음 datapath로 가는 combinational path를 줄여 timing에 유리할 수 있다.
