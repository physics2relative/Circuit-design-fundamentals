# RTL Interview Study Guide

이 문서는 Digital Design/RTL 면접 대비용 핵심 정리입니다. 목표는 질문을 외우는 것이 아니라, 짧은 시간 안에 **설계 의도, 구현 방식, trade-off, 검증 방법**을 말할 수 있게 만드는 것입니다.

참고한 방향성: Hardware Interview의 Digital Design/RTL study guide에서 강조하는 Verilog/SystemVerilog, FSM, FIFO, arbiter, STA, protocol/interface, CDC, RTL coding challenge 범위를 바탕으로 재구성했습니다.

## 1. Behavioral Preparation

기술 질문 전후로 프로젝트 설명을 요구받는 경우가 많습니다. 프로젝트는 아래 순서로 준비합니다.

```text
문제 정의 → 요구사항 → architecture 선택 → trade-off → 구현 → 검증 → 성능/개선점
```

### 준비할 답변

- 왜 이 architecture를 선택했는가?
- 속도, 면적, 전력, 구현 난이도 중 무엇을 우선했는가?
- 병목은 무엇이었고 어떻게 개선했는가?
- 어떤 testbench와 corner case로 검증했는가?
- simulation/synthesis 후 어떤 warning을 확인했는가?

### 좋은 답변 형태

> UART TX를 FSM으로 구현했습니다. IDLE, START, DATA, STOP 상태로 나누고 baud tick마다 상태를 전이했습니다. 검증은 reset, 단일 byte 전송, 연속 전송, busy 상태에서 start 요청이 들어오는 경우를 확인했습니다. 개선한다면 RX와 FIFO를 붙여 backpressure까지 다룰 수 있게 확장하겠습니다.

---

## 2. Verilog/SystemVerilog 핵심

### `wire`, `reg`, `logic`

- `wire`: continuous assignment나 module 연결에 쓰이는 net 타입입니다.
- `reg`: Verilog에서 procedural block 안에서 값을 대입받는 변수 타입입니다. 이름 때문에 실제 register만 의미하지는 않습니다.
- `logic`: SystemVerilog의 4-state 변수 타입으로, 일반 RTL에서는 `wire/reg` 혼동을 줄이기 위해 자주 씁니다.

면접 답변:

> Verilog의 `reg`는 flip-flop을 뜻하는 것이 아니라 procedural assignment 대상이라는 의미입니다. SystemVerilog에서는 대부분 `logic`을 사용하고, 여러 driver가 필요한 net 연결에는 `wire`를 사용합니다.

### Blocking `=` vs Non-blocking `<=`

- Blocking `=`: 현재 procedural block 안에서 즉시 값이 갱신되는 것처럼 동작합니다.
- Non-blocking `<=`: RHS를 먼저 평가하고 time step 끝에 LHS가 갱신됩니다.

일반 원칙:

```systemverilog
// 조합논리
always_comb begin
  y = a & b;
end

// 순차논리
always_ff @(posedge clk or negedge rst_n) begin
  if (!rst_n) q <= '0;
  else        q <= d;
end
```

면접 포인트:

- Clocked block에서 blocking을 쓰면 pipeline stage가 한 cycle씩 지연되지 않고 같은 cycle에 전파되는 것처럼 simulation될 수 있습니다.
- 조합논리에서는 blocking을 써서 식의 순서를 명확히 합니다.

### `always_comb` vs `always_ff`

- `always_comb`: 조합논리 의도를 명확히 표현하고 sensitivity list 누락을 방지합니다.
- `always_ff`: clock/reset event 기반 순차논리 의도를 명확히 합니다.

면접 답변:

> SystemVerilog에서는 의도 표현과 tool check를 위해 조합논리는 `always_comb`, 순차논리는 `always_ff`로 분리합니다. 이렇게 하면 latch inference, multiple driver, sensitivity list 실수를 줄일 수 있습니다.

---

## 3. 조합논리 설계

### Universal gates와 MUX 구현

NAND/NOR는 universal gate이므로 모든 boolean logic을 구현할 수 있습니다. MUX도 select에 따라 입력을 선택하므로 truth table 기반의 임의 logic 구현에 사용할 수 있습니다.

예: 2:1 MUX로 XOR 구현

```text
Y = A ? ~B : B
```

즉 `sel=A`, `d0=B`, `d1=~B`로 두면 `Y=A xor B`가 됩니다.

### Glitch/Hazard

조합논리에서 입력 경로 delay가 다르면 짧은 pulse가 생길 수 있습니다. clocked logic에서는 setup/hold window에 걸리지 않으면 문제가 안 될 수 있지만, clock/reset/enable처럼 민감한 신호에 glitch가 들어가면 위험합니다.

완화 방법:

- hazard-free logic cover 추가
- 신호를 register로 받기
- clock gating 대신 enable 사용
- CDC/async 신호는 synchronizer 사용

---

## 4. 순차논리와 Reset

### Latch가 기피되는 이유

Latch는 level-sensitive라 enable이 열려 있는 동안 입력 변화가 출력으로 전달됩니다. 의도하지 않은 latch는 timing 분석을 어렵게 하고, hold 문제와 race 가능성을 키웁니다.

Latch inference 방지:

```systemverilog
always_comb begin
  y = '0;      // default assignment
  unique case (sel)
    2'd0: y = a;
    2'd1: y = b;
    2'd2: y = c;
    default: y = '0;
  endcase
end
```

### Reset deassertion timing

Reset assertion은 asynchronous로 허용해도, deassertion은 clock에 동기화하는 경우가 많습니다. reset release가 clock edge 근처에서 발생하면 metastability나 recovery/removal violation이 생길 수 있기 때문입니다.

Synchronous deassertion 예:

```systemverilog
logic rst_sync1, rst_sync2;

always_ff @(posedge clk or negedge rst_n) begin
  if (!rst_n) begin
    rst_sync1 <= 1'b0;
    rst_sync2 <= 1'b0;
  end else begin
    rst_sync1 <= 1'b1;
    rst_sync2 <= rst_sync1;
  end
end

assign local_rst_n = rst_sync2;
```

Reset tree가 너무 커서 timing이 안 맞는 경우:

- reset domain을 나누고 local reset synchronizer 사용
- reset이 꼭 필요한 flop만 reset
- datapath register는 valid bit로 초기화 상태 관리
- reset release sequence를 설계
- reset tree buffering/physical constraint 검토

---

## 5. FSM

### Moore vs Mealy

- Moore: 출력이 현재 state에만 의존합니다. 출력이 안정적이고 timing 분석이 상대적으로 쉽습니다.
- Mealy: 출력이 state와 input에 함께 의존합니다. 상태 수를 줄이거나 반응을 빠르게 만들 수 있지만 input glitch/timing에 더 민감합니다.

면접 답변:

> Mealy는 입력 변화에 같은 cycle 안에서 반응할 수 있어 latency가 작을 수 있습니다. Moore는 출력이 state register를 거치므로 안정적입니다. Mealy를 Moore로 바꾸려면 입력 조건에 의해 달라지는 출력을 별도 state로 분리해 출력이 state에만 의존하게 만듭니다.

### FSM 설계 순서

1. 입력/출력과 reset 상태 정의
2. state diagram 작성
3. state encoding 선택
4. next-state logic 작성
5. output logic 작성
6. illegal state 복구와 default 처리
7. transition coverage 검증

### Binary vs One-hot

- Binary encoding: state bit 수가 적어 면적에 유리할 수 있습니다.
- One-hot encoding: state bit 수는 많지만 next-state logic이 단순해져 FPGA나 고속 FSM에 유리할 수 있습니다.

---

## 6. FIFO

### Synchronous FIFO

같은 clock에서 read/write가 일어나므로 pointer 비교나 count 방식으로 full/empty를 판단할 수 있습니다.

검증 항목:

- reset 후 empty 상태
- empty에서 read 요청
- full에서 write 요청
- simultaneous read/write
- pointer wrap-around
- depth 경계값
- data ordering 유지

### Asynchronous FIFO

서로 다른 clock domain 사이에서 데이터를 전달합니다. 일반적으로 read/write pointer를 gray code로 변환하고, 상대 domain으로 2-flop synchronizer를 거친 후 full/empty를 판단합니다.

핵심 이유:

- Binary pointer는 여러 bit가 동시에 바뀔 수 있어 CDC 중 잘못된 중간값을 볼 수 있습니다.
- Gray code는 인접 값 사이에서 1 bit만 바뀌므로 pointer crossing에 유리합니다.

면접 답변:

> Asynchronous FIFO에서는 data memory는 각 domain에서 접근하고, full/empty 판단을 위해 pointer만 crossing합니다. 이 pointer는 gray code로 변환한 뒤 2-flop synchronizer를 통과시킵니다. 검증은 서로 다른 clock ratio, burst write/read, full/empty boundary, reset skew를 포함해야 합니다.

---

## 7. Arbiter

### Priority Arbiter

고정 우선순위 방식입니다. 구현이 단순하지만 낮은 우선순위 request가 starvation될 수 있습니다.

### Round-robin Arbiter

마지막 grant 이후 다음 requester부터 우선순위를 주는 방식입니다. fairness가 좋지만 pointer 상태와 wrap-around 처리가 필요합니다.

면접 답변:

> Priority arbiter는 단순하고 빠르지만 starvation 문제가 있습니다. Round-robin arbiter는 grant pointer를 유지해 공정성을 높입니다. 검증 시에는 동시에 여러 request가 들어오는 경우, request가 유지되는 경우, grant 후 pointer update, no-request 상태를 확인합니다.

---

## 8. Pipeline과 Handshake

### Pipelining

긴 combinational path를 register로 나누어 clock frequency를 높이는 방법입니다. 대신 latency와 register 수가 증가합니다.

면접 답변:

> Pipeline은 throughput을 높이기 위해 critical path를 여러 stage로 나누는 기법입니다. 각 stage 사이에 register를 넣어 clock period를 줄일 수 있지만, 전체 latency는 증가하고 valid/control 신호도 data와 함께 맞춰야 합니다.

### Valid-Ready Handshake

전송 조건:

```text
transfer = valid && ready
```

원칙:

- source는 보낼 데이터가 있으면 `valid`를 올리고, handshake 전까지 data를 유지합니다.
- sink는 받을 수 있으면 `ready`를 올립니다.
- backpressure는 downstream ready가 낮아지는 방식으로 upstream에 전달됩니다.

Pipe stage 삽입 시 고려사항:

- data와 valid를 함께 register 처리
- ready 경로가 길어지면 skid buffer 고려
- bubble과 stall 상황 검증

---

## 9. Static Timing Analysis 기초

### Setup/Hold

- Setup: capture clock edge 전에 data가 충분히 일찍 도착해야 하는 조건입니다.
- Hold: capture clock edge 후 data가 너무 빨리 바뀌면 안 되는 조건입니다.

Setup violation 해결:

- clock period 증가
- combinational logic depth 감소
- pipelining
- faster cell 사용
- placement/routing 개선

Hold violation 해결:

- data path delay 추가
- buffer 삽입
- clock skew 조정
- 너무 빠른 short path 확인

### Critical Path

가장 긴 delay를 가진 timing path입니다. 최대 동작 주파수를 제한합니다.

면접 답변:

> Setup은 데이터가 늦게 도착하는 문제이고, hold는 데이터가 너무 빨리 바뀌는 문제입니다. Setup은 logic을 줄이거나 pipeline을 추가해 해결하고, hold는 data path에 delay를 추가하는 방식으로 해결하는 경우가 많습니다.

---

## 10. CDC

### 1-bit signal crossing

2-flop synchronizer를 사용합니다. metastability 가능성을 줄일 수 있지만 0으로 만들 수는 없습니다.

```systemverilog
always_ff @(posedge dst_clk or negedge dst_rst_n) begin
  if (!dst_rst_n) begin
    sync1 <= 1'b0;
    sync2 <= 1'b0;
  end else begin
    sync1 <= async_in;
    sync2 <= sync1;
  end
end
```

### Pulse crossing

빠른 clock에서 느린 clock으로 짧은 pulse를 보낼 경우 pulse가 놓칠 수 있습니다. toggle synchronizer, handshake, async FIFO 등을 고려합니다.

### Multi-bit crossing

여러 bit를 독립적으로 synchronizing하면 서로 다른 cycle 값이 섞일 수 있습니다. 해결책은 다음과 같습니다.

- Gray code pointer
- valid/ack handshake
- asynchronous FIFO
- data stable 후 control만 synchronizing

---

## 11. 자주 나오는 RTL Coding Challenge 유형

### 기본 구현

- counter / up-down counter
- edge detector
- sequence detector
- parity detector
- one-hot encoder/decoder
- population count
- N:1 mux

### 중급 구현

- FIFO
- fixed priority arbiter
- round-robin arbiter
- valid-ready pipeline stage
- traffic light controller
- SRAM behavioral model
- configurable pattern detector

### 풀이 습관

1. 요구사항을 input/output으로 다시 씁니다.
2. reset behavior를 정의합니다.
3. latency와 throughput을 명확히 합니다.
4. corner case를 먼저 적습니다.
5. state/register/datapath를 나눠 설계합니다.
6. RTL 작성 후 latch, multiple driver, width mismatch warning을 확인합니다.

---

## 12. 빠른 면접 체크리스트

- [ ] `wire/reg/logic` 차이를 설명할 수 있다.
- [ ] Blocking/non-blocking timing table을 그릴 수 있다.
- [ ] Moore/Mealy 변환을 설명할 수 있다.
- [ ] Counter와 sequence detector를 손코딩할 수 있다.
- [ ] FIFO full/empty 조건을 설명할 수 있다.
- [ ] valid-ready pipe stage의 stall 동작을 설명할 수 있다.
- [ ] setup/hold violation 해결책을 말할 수 있다.
- [ ] CDC에서 1-bit, pulse, multi-bit crossing 방법을 구분할 수 있다.
- [ ] 프로젝트 하나를 architecture/trade-off/verification 중심으로 설명할 수 있다.
