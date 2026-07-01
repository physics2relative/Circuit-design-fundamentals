# Digital Design Interview Questions

이 문서는 Digital Design/RTL 면접 대비용 질문과 짧은 답변 가이드입니다. 실제 면접에서는 한 문장 정의에서 멈추지 말고, **RTL 구현 방식, timing 영향, 검증 방법**까지 연결해서 답합니다.

## 1. Verilog/SystemVerilog

### Q1. `wire`, `reg`, `logic`의 차이는 무엇인가?

- `wire`: net 타입입니다. continuous assignment나 module 간 연결에 사용합니다.
- `reg`: Verilog procedural block에서 값을 저장하는 변수 타입입니다. 이름과 달리 항상 flop을 의미하지는 않습니다.
- `logic`: SystemVerilog의 4-state 변수 타입입니다. 일반 RTL에서는 `reg` 대신 많이 사용합니다.

면접 답변:

> `reg`는 실제 register를 뜻하는 것이 아니라 procedural assignment 대상이라는 뜻입니다. SystemVerilog에서는 대부분 `logic`을 사용해 혼동을 줄이고, 여러 driver가 필요한 net에는 `wire`를 사용합니다.

### Q2. Blocking assignment와 non-blocking assignment의 차이는?

- Blocking `=`: procedural block 안에서 순차적으로 즉시 반영되는 것처럼 동작합니다.
- Non-blocking `<=`: RHS를 먼저 평가하고 time step 끝에 LHS를 갱신합니다.

면접 답변:

> 조합논리에는 blocking, 순차논리에는 non-blocking을 쓰는 것이 일반적입니다. Clocked block에서 blocking을 쓰면 pipeline register가 같은 cycle에 전파되는 것처럼 simulation될 수 있어 의도와 다른 RTL이 됩니다.

### Q3. `always_comb`과 `always_ff`의 차이는?

- `always_comb`: 조합논리 표현. sensitivity list를 자동으로 처리하고 latch inference를 줄입니다.
- `always_ff`: clock/reset 기반 순차논리 표현. flop 의도를 명확히 합니다.

### Q4. `bit`와 `logic`의 차이는?

- `bit`: 2-state 타입입니다. 0/1만 표현합니다.
- `logic`: 4-state 타입입니다. 0/1/X/Z를 표현합니다.

면접에서는 RTL debug 관점에서 X-propagation 확인이 필요하므로 `logic`을 주로 사용한다고 답하면 좋습니다.

---

## 2. 조합논리

### Q5. 조합논리와 순차논리의 차이는?

- 조합논리: 현재 입력만으로 출력이 결정됩니다.
- 순차논리: 현재 입력과 과거 상태, 즉 register state에 의해 출력이 결정됩니다.

### Q6. MUX로 XOR를 구현해보라.

2:1 MUX에서 `sel=A`, `d0=B`, `d1=~B`로 두면 출력은 `A xor B`입니다.

```text
Y = A ? ~B : B
```

### Q7. Latch inference는 왜 생기며 어떻게 막는가?

원인:

- `always_comb` 안에서 모든 branch가 output을 assign하지 않음
- `case`에 default가 없음
- if/else 일부 경로에서 값이 유지되어야 하는 것처럼 작성함

해결:

- block 시작에 default assignment 작성
- 모든 branch assign
- `unique case`, `default` 사용

### Q8. Glitch는 왜 생기고 언제 문제가 되는가?

입력들이 서로 다른 delay 경로를 거쳐 reconvergent logic으로 들어오면 짧은 pulse가 생길 수 있습니다. 일반 data path에서는 register가 sampling하지 않으면 괜찮을 수 있지만, clock/reset/enable/CDC 신호에 glitch가 들어가면 위험합니다.

---

## 3. 순차논리와 Reset

### Q9. Latch와 flip-flop의 차이는?

- Latch: level-sensitive입니다. enable이 active인 동안 입력이 출력으로 전달될 수 있습니다.
- Flip-flop: edge-sensitive입니다. clock edge에서만 값을 capture합니다.

### Q10. Latch가 기피되는 이유는?

Latch는 timing 분석과 검증이 어렵고, 의도하지 않은 transparency 때문에 race나 hold 문제가 생길 수 있습니다. 의도한 latch가 아니라면 대부분 RTL bug로 봅니다.

### Q11. Synchronous reset과 asynchronous reset의 차이는?

- Synchronous reset: clock edge에서 reset이 반영됩니다. STA가 상대적으로 단순합니다.
- Asynchronous reset: clock 없이도 reset assertion이 가능합니다. reset release timing에 주의해야 합니다.

### Q12. Reset deassertion은 왜 동기화해야 하는가?

Reset이 clock edge 근처에서 해제되면 recovery/removal violation이나 metastability가 발생할 수 있습니다. 그래서 assertion은 async로 하더라도 deassertion은 clock domain별 synchronizer를 거치는 방식이 자주 사용됩니다.

### Q13. Reset tree가 너무 커서 timing이 안 맞으면?

- reset이 필요한 register만 reset합니다.
- local reset synchronizer를 둡니다.
- datapath는 valid bit로 초기화 상태를 관리합니다.
- reset domain을 나눕니다.
- physical implementation에서 buffer/tree를 조정합니다.

---

## 4. FSM

### Q14. Moore machine과 Mealy machine의 차이는?

- Moore: output이 state에만 의존합니다.
- Mealy: output이 state와 input에 의존합니다.

Mealy는 빠르게 반응할 수 있고 state 수가 줄 수 있지만, input glitch나 timing에 민감할 수 있습니다. Moore는 출력이 안정적이고 timing 분석이 쉽습니다.

### Q15. Mealy를 Moore로 바꾸려면?

입력 조건에 따라 바로 달라지는 출력을 별도 state로 분리해, 출력이 state에만 의존하게 만듭니다. 보통 state 수와 latency가 증가합니다.

### Q16. Binary encoding과 one-hot encoding의 trade-off는?

- Binary: state bit 수가 적습니다. 면적에 유리할 수 있습니다.
- One-hot: flop 수는 많지만 next-state logic이 단순합니다. FPGA나 고속 FSM에 유리할 수 있습니다.

### Q17. FSM 검증에서 중요한 것은?

- reset state
- 모든 state transition
- illegal state recovery
- input corner case
- output timing
- unreachable state 여부

---

## 5. Timing / STA

### Q18. Setup time과 hold time을 설명하라.

- Setup time: capture clock edge 전에 data가 안정적으로 유지되어야 하는 최소 시간입니다.
- Hold time: capture clock edge 후 data가 안정적으로 유지되어야 하는 최소 시간입니다.

### Q19. Setup violation 해결 방법은?

- clock period 증가
- combinational logic depth 감소
- pipeline stage 추가
- faster cell 사용
- placement/routing 개선

### Q20. Hold violation 해결 방법은?

- data path delay 추가
- buffer 삽입
- clock skew 조정
- 너무 짧은 path 확인

### Q21. Critical path란 무엇인가?

clock period를 제한하는 가장 긴 timing path입니다. 보통 flop-to-flop path에서 clock-to-Q, combinational delay, setup time을 포함해 분석합니다.

### Q22. Pipelining이란?

긴 combinational logic을 여러 stage로 나누고 stage 사이에 register를 넣어 clock frequency를 높이는 방법입니다. 대신 latency와 register area가 증가합니다.

---

## 6. CDC

### Q23. Metastability란 무엇인가?

flip-flop input이 setup/hold 조건을 만족하지 못하면 출력이 일정 시간 0/1로 안정되지 못하는 상태입니다. 완전히 제거할 수는 없고 확률을 낮춥니다.

### Q24. 1-bit CDC는 어떻게 처리하는가?

목적지 clock domain에서 2-flop synchronizer를 사용합니다. MTBF를 높이기 위한 방식이며, latency가 2 cycle 정도 추가됩니다.

### Q25. 빠른 clock에서 느린 clock으로 pulse를 보낼 때 문제는?

pulse 폭이 느린 clock period보다 짧으면 sampling되지 않고 놓칠 수 있습니다. toggle synchronizer, pulse stretching, handshake를 사용합니다.

### Q26. Multi-bit CDC는 왜 단순 2-flop으로 처리하면 안 되는가?

각 bit가 서로 다른 cycle에 capture되어 잘못된 조합 값이 만들어질 수 있습니다. multi-bit data는 handshake, async FIFO, gray code pointer 등을 사용합니다.

---

## 7. FIFO

### Q27. Synchronous FIFO의 full/empty는 어떻게 판단하는가?

같은 clock domain에서는 read/write pointer 비교 또는 count 방식으로 판단합니다. pointer wrap-around를 구분하기 위해 extra MSB를 두는 방식도 사용합니다.

### Q28. Asynchronous FIFO는 어떻게 설계하는가?

read/write pointer를 gray code로 변환해 상대 clock domain으로 synchronizing하고, 동기화된 pointer를 기준으로 full/empty를 판단합니다. data memory는 각 domain에서 read/write합니다.

### Q29. FIFO test plan은?

- reset 후 empty 확인
- empty read
- full write
- simultaneous read/write
- wrap-around
- random burst
- async FIFO라면 clock ratio 변경
- data ordering 확인

---

## 8. Arbiter

### Q30. Fixed priority arbiter란?

항상 높은 우선순위 request부터 grant하는 arbiter입니다. 단순하지만 낮은 우선순위가 starvation될 수 있습니다.

### Q31. Round-robin arbiter란?

마지막 grant 이후 다음 requester부터 우선순위를 주는 방식입니다. fairness를 보장하기 좋지만 pointer update와 wrap-around 처리가 필요합니다.

### Q32. Arbiter 검증 항목은?

- request가 없을 때 grant 없음
- 단일 request grant
- 다중 request 우선순위
- grant 후 pointer update
- starvation 여부
- request가 계속 유지되는 경우

---

## 9. Protocol / Interface

### Q33. Valid-ready handshake를 설명하라.

`valid && ready`가 1인 cycle에 data transfer가 발생합니다. source는 valid가 올라간 뒤 handshake 전까지 data를 유지해야 하고, sink는 받을 수 있을 때 ready를 올립니다.

### Q34. Backpressure란?

downstream이 데이터를 받을 수 없을 때 ready를 낮추거나 almost_full을 올려 upstream 전송을 늦추는 방식입니다.

### Q35. Valid-ready pipe stage를 추가할 때 주의할 점은?

- data와 valid를 함께 register 처리
- ready 경로가 길어지면 skid buffer 고려
- stall 중 data stability 보장
- bubble 처리

---

## 10. Coding Challenge 연습 목록

### 바로 손코딩 가능해야 하는 문제

1. Up/down counter
2. Edge detector
3. 101 sequence detector
4. 1101 configurable pattern detector
5. Odd/even parity detector
6. Population count
7. 512:1 mux
8. Fixed priority arbiter
9. Round-robin arbiter
10. Synchronous FIFO

### 풀이 전에 확인할 질문

- reset은 sync인가 async인가?
- input/output valid는 있는가?
- latency 요구사항은 있는가?
- throughput은 매 cycle 1개인가?
- overflow/underflow는 어떻게 처리하는가?
- invalid input은 don't care인가 error인가?

---

## 11. 프로젝트 설명 대비 질문

1. 본인이 구현한 RTL 모듈 하나를 architecture부터 설명하라.
2. 왜 FSM으로 구현했는가? 다른 방식은 없었는가?
3. Critical path는 어디라고 생각하는가?
4. 어떤 corner case를 검증했는가?
5. Simulation 결과와 synthesis warning을 어떻게 확인했는가?
6. 면적/속도/전력 중 무엇을 우선했고 trade-off는 무엇인가?
7. 개선한다면 어떤 구조로 바꾸겠는가?
