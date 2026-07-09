# Clock, Reset, and CDC

## 작성 범위

Clock/reset 사용 원칙과 CDC(clock domain crossing), RDC(reset domain crossing)를 정리하는 대단원이다. Timing 자체의 setup/hold 분석은 `../06_timing_sta/`에서 다루고, clock gating은 `../08_low_power_clock_gating/`에서 따로 다룬다. 이 문서는 `../../projects/cdc_behavioral_models/`의 xrun 실습을 기준으로 CDC 문제와 해결 구조를 정리한다.

## 핵심 요약

CDC의 본질은 서로 다른 clock domain 사이에서 **sampling 시점을 보장할 수 없다는 점**이다. 비동기 신호가 destination clock edge 근처에서 변하면 receiver flip-flop은 setup/hold 조건을 만족하지 못할 수 있고, 이때 metastability 또는 불확정 sampling 문제가 발생한다.

정리하면 다음과 같다.

```text
single-bit level:
    2FF synchronizer로 metastability 전파 확률을 낮춘다.
    단, destination에서 몇 cycle에 보일지는 1 cycle 정도 흔들릴 수 있다.

single-bit pulse/event:
    pulse를 그대로 넘기면 miss될 수 있다.
    toggle synchronizer 또는 request/ack handshake로 level화해서 넘긴다.

multi-bit data:
    bit별 synchronizer로 넘기면 coherency가 깨질 수 있다.
    async FIFO, handshake + stable data, Gray code counter 등을 사용한다.

reset:
    reset assert는 비동기로 허용할 수 있지만,
    deassert는 각 clock domain에서 synchronizer를 거쳐 release하는 것이 기본이다.
```

## 실습 프로젝트 연결

CDC 실습 코드는 다음 위치에 있다.

```text
digital/projects/cdc_behavioral_models/
```

실행은 EDA 서버 기준으로 다음과 같다.

```bash
cd /user/choi.jw/PROJECT/Circuit-Design-Fundamentals/digital/projects/cdc_behavioral_models
bash sim/run_xrun.sh
```

각 예제의 waveform은 다음 위치에 생성된다.

```text
sim/xrun_work/<numbered_tb_name>/waves.shm
```

나중에 문서에 waveform을 넣을 때는 `digital/assets/waveforms/` 또는 `digital/assets/images/`에 캡처를 저장하고 이 문서에 링크한다.

```markdown
<!-- TODO: waveform image -->
![CDC waveform](../../assets/waveforms/<file_name>.png)
```

---

## 1. Metastability와 xmodel의 의미

RTL simulation은 실제 flip-flop 내부의 analog metastability를 정확히 표현하지 못한다. 실습에서는 교육용 `x_inject_dff`를 사용한다.

동작은 다음과 같다.

```text
1. destination clock edge 근처에서 input이 변한다.
2. setup/hold window 안에 걸리면 q를 X로 만든다.
3. RESOLVE_DELAY_NS 이후 deterministic value로 resolve시킨다.
```

즉 여기서의 `X`는 실제 중간 전압을 의미한다기보다, destination domain이 그 timing에서 0/1을 확정할 수 없다는 표시이다. 실제 회로에서는 metastability가 0으로 풀릴지 1로 풀릴지 확률적이며, resolve time도 PVT, cell 특성, slack에 따라 달라진다.

중요한 점은 다음이다.

```text
2FF synchronizer는 metastability를 제거하는 회로가 아니다.
첫 번째 FF가 흔들렸을 때, 두 번째 FF가 sampling하기 전까지 resolve될 시간을 벌어주는 구조이다.
```

---

## 2. Synchronizer 없는 direct capture

실습 1번은 source clock domain에서 launch된 `async_in`을 destination FF 하나가 바로 capture하는 구조이다.

```text
clk_src domain                  clk_dst domain
--------------                  --------------
async_in ---------------------> [FF]
```

문제는 `async_in`이 `clk_dst`와 timing 관계가 없다는 점이다. destination clock edge 근처에서 `async_in`이 변하면 receiver FF는 setup/hold window를 위반할 수 있다.

이 구조의 의미는 다음이다.

```text
비동기 입력을 FF 하나로 직접 받으면 첫 stage 출력이 X 또는 불확정 값이 될 수 있다.
그 값을 바로 control/datapath에 쓰면 downstream logic이 잘못 동작할 수 있다.
```

면접 답변으로는 다음처럼 말할 수 있다.

> 서로 다른 clock domain의 신호를 destination FF 하나로 바로 받으면 setup/hold 관계가 보장되지 않아 metastability가 발생할 수 있다. 따라서 CDC boundary에서는 synchronizer나 handshake 같은 구조가 필요하다.

---

## 3. 2FF synchronizer

single-bit level 신호의 기본 해결책은 2FF synchronizer이다.

```text
async_level ----> [FF1] ----> [FF2] ----> synced_level
                  clk_dst    clk_dst
```

FF1은 metastability가 발생할 수 있는 지점이다. FF2는 FF1의 출력이 다음 destination clock edge 전까지 안정되기를 기대하고 sampling한다.

실습에서는 두 경우를 나눴다.

```text
02_two_flop_sync_resolved_xmodel:
    FF1이 X가 되지만 다음 destination edge 전에 resolve된다.
    FF2는 안정된 값을 sampling한다.

03_two_flop_sync_unresolved_xmodel:
    FF1의 resolve delay가 길어서 다음 destination edge까지 X가 유지된다.
    FF2도 X를 sampling할 수 있다.
```

따라서 2FF synchronizer는 확률을 줄이는 구조이지 절대적인 보장은 아니다. 신뢰성은 MTBF 관점으로 평가한다. 더 높은 신뢰성이 필요하면 3FF synchronizer를 사용하거나, event/data 성격에 맞는 protocol을 사용한다.

single-bit level synchronizer에서 중요한 해석은 다음이다.

```text
old value로 resolve:
    destination에서 변화가 한 cycle 늦게 보인 것처럼 동작할 수 있다.

new value로 resolve:
    destination에서 변화가 한 cycle 빨리 보인 것처럼 동작할 수 있다.
```

즉 single-bit level에서는 대개 논리값 오류라기보다 latency uncertainty로 해석된다. 단, 정확한 cycle timing이 필요한 신호나 pulse/event에는 이 구조만으로 부족하다.

---

## 4. Pulse crossing 문제

source domain에서 1-cycle pulse가 발생했다고 하자.

```text
src_pulse: ___|‾|________
```

이 pulse width는 source clock 기준이다. destination clock이 더 느리거나 phase가 맞지 않으면 destination은 이 pulse를 sampling하지 못할 수 있다.

```text
src_pulse: ___|‾|________
clk_dst:   ______↑_______↑
```

실습 4번은 `clk_src` domain에서 생성된 1-cycle pulse를 `clk_dst` domain으로 그대로 넘기려는 상황을 보여준다. pulse가 destination edge 사이에서 끝나면 miss될 수 있고, edge 근처에 걸리면 first stage가 X가 될 수 있다.

정리하면 다음과 같다.

```text
짧은 pulse를 CDC 경계에 그대로 넘기면 안 된다.
source pulse를 destination이 볼 수 있을 만큼 유지되는 level/event representation으로 바꿔야 한다.
```

대표적인 해결책은 다음이다.

```text
- pulse stretching
- toggle synchronizer
- request/ack handshake
```

---

## 5. Toggle synchronizer

Toggle synchronizer는 source pulse를 직접 넘기지 않고, event가 발생할 때마다 source-domain toggle state를 반전시킨다.

```text
src_pulse 발생:
    src_toggle <= ~src_toggle
```

구조는 다음과 같다.

```text
clk_src domain                         clk_dst domain
--------------                         --------------
src_pulse -> [toggle FF] ----CDC----> [FF1] -> [FF2] -> [FF3]
                                                   |       |
                                                   +--XOR--+--> dst_pulse
```

핵심은 `src_toggle`이 짧은 pulse가 아니라 다음 event 전까지 유지되는 level이라는 점이다.

```text
src_pulse:  ___|‾|_____________________|‾|____
src_toggle: ____‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾_______
```

Destination에서는 동기화된 toggle 값과 1-cycle delayed 값의 차이를 XOR로 검출한다.

```text
dst_sync_2 = 현재 동기화된 toggle 값
dst_sync_3 = 이전 cycle의 toggle 값

dst_pulse = dst_sync_2 ^ dst_sync_3
```

동작 예는 다음과 같다.

```text
cycle:       0   1   2   3   4
FF2:         0   0   1   1   1
FF3:         0   0   0   1   1
FF2 ^ FF3:   0   0   1   0   0
```

한계도 있다. Source event가 너무 빠르게 두 번 발생하면 toggle이 다시 원래 값으로 돌아올 수 있고, destination이 중간 변화를 못 보면 event를 놓칠 수 있다.

```text
event1: toggle 0 -> 1
event2: toggle 1 -> 0

destination이 중간 1을 못 보면 변화가 없던 것처럼 보일 수 있다.
```

따라서 toggle synchronizer는 low-rate event 전달에 적합하며, event loss를 반드시 막아야 하거나 back-pressure가 필요하면 handshake를 사용한다.

---

## 6. Multi-bit bus CDC 문제

Multi-bit bus를 bit별 2FF synchronizer로 넘기는 것은 안전하지 않다.

```text
src_bus[0] -> sync -> dst_bus[0]
src_bus[1] -> sync -> dst_bus[1]
src_bus[2] -> sync -> dst_bus[2]
src_bus[3] -> sync -> dst_bus[3]
```

각 bit는 독립적으로 sampling된다. 따라서 source에서 하나의 bus transition이 발생해도 destination에서는 bit마다 old/new 값이 섞일 수 있다.

예를 들어 다음 전이를 생각한다.

```text
old = 0011
new = 1100
```

각 bit가 독립적으로 old 또는 new로 잡히면 destination에서는 source가 만든 적 없는 값이 나타날 수 있다.

```text
0011  old
1100  new
1111  incoherent
0000  incoherent
1010  incoherent
```

실습 6번은 `clk_src` domain의 FF에서 `src_bus`를 launch하고, `clk_dst` domain에서 bit별 synchronizer로 받는다. xmodel에서는 violation bit가 deterministic value로 resolve되도록 해 bus coherency가 깨지는 상황을 waveform에서 보기 쉽게 했다.

핵심은 다음이다.

```text
single-bit level은 latency uncertainty로 받아들일 수 있는 경우가 많다.
multi-bit data는 bit별 latency/resolve 차이가 data corruption으로 이어질 수 있다.
```

Multi-bit data는 다음 구조를 사용한다.

```text
- async FIFO
- request/ack handshake + stable data bus
- Gray code counter/pointer
- source-synchronous interface
```

---

## 7. Request/Ack handshake CDC

Handshake CDC는 source가 event를 그냥 던지는 것이 아니라, destination이 받았다는 ack가 돌아올 때까지 request를 유지하는 closed-loop CDC 구조이다.

```text
src domain                              dst domain
----------                              ----------
src_event
   |
   v
[src_req FF] ---- req ----> [2FF sync] ---- dst_req
     ^                                      |
     |                                      v
     |                                  dst_pulse
     |                                      |
[src ack sync] <---- ack ---- [dst_ack FF]--+
```

Source 내부 event는 1-cycle pulse일 수 있지만, CDC 경계에서는 `src_req` level로 바꾼다.

```text
src_event: ___|‾|________________
src_req:   ____‾‾‾‾‾‾‾‾‾‾‾‾____
```

Destination은 sync된 request의 rising edge를 검출해 내부 pulse를 만든다.

```text
dst_pulse = dst_req_sync_2 & ~dst_req_sync_3
```

그 뒤 ack를 source로 돌려보낸다. Source는 ack를 동기화해서 확인한 뒤 request를 내린다.

실습 7번 결과는 다음이다.

```text
requested=4
accepted=2
seen=2
```

의미는 다음과 같다.

```text
requested:
    source event 시도 수

accepted:
    source가 busy가 아닐 때 실제 request로 받아들인 수

seen:
    destination에서 pulse로 본 수
```

Handshake의 장점은 accepted event가 destination에 안정적으로 전달된다는 점이다. 단점은 왕복 latency가 크고 throughput이 낮다는 점이다.

적합한 신호는 다음과 같다.

```text
- start command
- config update request
- mode switch request
- clear/done 같은 low-rate control event
```

High-throughput data stream에는 async FIFO나 더 큰 buffering protocol이 적합하다.

---

## 8. Async FIFO의 CDC 관점

Async FIFO는 multi-bit data CDC의 대표적인 해결책이다. 이 문서에서는 FIFO 자체의 full/empty 구현 세부보다 CDC 관점만 잡는다.

핵심은 두 가지이다.

```text
1. data bus를 bit별 synchronizer로 직접 넘기지 않는다.
2. write/read pointer를 Gray code로 바꿔 반대 clock domain에 동기화한다.
```

구조는 다음과 같다.

```text
write clock domain                     read clock domain
------------------                     -----------------
wdata -> FIFO memory[write pointer]    FIFO memory[read pointer] -> rdata
          wptr_bin / wptr_gray         rptr_bin / rptr_gray
              |                              |
              v                              v
        sync to read domain            sync to write domain
```

Read side는 synchronized write pointer를 보고 empty 여부를 판단한다. Write side는 synchronized read pointer를 보고 full 여부를 판단한다.

Pointer를 binary 그대로 넘기지 않는 이유는 binary counter가 증가할 때 여러 bit가 동시에 바뀔 수 있기 때문이다.

```text
binary 3 -> 4:
    011 -> 100  // 3 bits change
```

이런 multi-bit transition을 bit별 synchronizer로 넘기면 6번과 같은 coherency 문제가 생긴다. Gray code는 인접한 값 사이에서 한 bit만 변한다.

```text
binary: 000 001 010 011 100
gray:   000 001 011 010 110
```

따라서 CDC 중에 잡히는 값은 old pointer 또는 new pointer에 가깝게 제한되고, pointer가 크게 튀는 위험을 줄일 수 있다.

실습 8번은 async FIFO 전체 구조를 아주 단순화해서 보여준다.

```text
writes_seen=4
reads_seen=4
```

FIFO의 full/empty 식, circular buffer, simultaneous read/write, almost full/empty 등은 `../09_memory_fifo_interface/`에서 자세히 정리하는 것이 좋다. CDC 문맥에서는 다음 문장만 확실히 기억하면 된다.

> Multi-bit data는 직접 CDC하지 않고 FIFO memory를 통해 전달하며, CDC되는 control 정보인 pointer는 Gray code로 변환해 synchronizer를 거친다.

---

## 9. Reset synchronizer와 RDC

Reset도 clock domain 관점에서는 crossing 문제가 생길 수 있다. 특히 reset deassertion이 clock edge 근처에서 발생하면 FF의 recovery/removal timing을 위반할 수 있다.

Active-low reset 기준 원칙은 다음이다.

```text
assert:
    async로 즉시 걸어도 된다.

deassert:
    각 clock domain에서 synchronizer를 거쳐 clock에 맞춰 release한다.
```

Reset synchronizer의 기본 구조는 다음이다.

```verilog
always @(posedge clk or negedge async_rst_n) begin
    if (!async_rst_n) begin
        rst_sync_1 <= 1'b0;
        rst_sync_2 <= 1'b0;
    end else begin
        rst_sync_1 <= 1'b1;
        rst_sync_2 <= rst_sync_1;
    end
end

assign sync_rst_n = rst_sync_2;
```

동작은 다음과 같다.

```text
async_rst_n = 0:
    rst_sync_1 = 0
    rst_sync_2 = 0
    sync_rst_n = 0
    reset assert는 즉시 반영된다.

async_rst_n = 1 이후:
    1st clk: rst_sync_1 = 1, rst_sync_2 = 0
    2nd clk: rst_sync_1 = 1, rst_sync_2 = 1
    sync_rst_n이 1이 되어 reset이 풀린다.
```

즉 reset synchronizer는 `1'b1 -> FF1 -> FF2 -> sync_rst_n` 형태로 1을 shift-in하는 구조이다. 두 FF는 모두 `async_rst_n`으로 비동기 reset된다.

여러 clock domain이 있다면 reset은 domain별로 만들어야 한다.

```text
global_rst_n
   +--> reset_synchronizer @ clk_src --> rst_src_n --> src domain FFs
   +--> reset_synchronizer @ clk_dst --> rst_dst_n --> dst domain FFs
```

하면 안 되는 방식은 다음이다.

```text
- global reset을 모든 domain FF에 직접 연결
- rst_src_n을 dst domain FF에 사용
- rst_dst_n을 src domain FF에 사용
- domain reset들을 OR/AND로 섞어서 사용
```

실습 9번은 global reset을 직접 받은 bad FF와 reset synchronizer를 거친 good FF를 비교한다. Bad path는 reset release timing이 clock edge 근처에 걸리면 X가 발생할 수 있고, good path는 reset이 각 domain clock에 맞춰 release된다.

---

## 설계 선택 기준

CDC 구조는 신호의 성격에 따라 고른다.

| 전달 대상 | 추천 구조 | 핵심 조건 |
| --- | --- | --- |
| single-bit slow level | 2FF synchronizer | 1~2 cycle latency uncertainty 허용 |
| single-bit short pulse | toggle synchronizer 또는 handshake | pulse를 level/event state로 변환 |
| low-rate control event | request/ack handshake | ack 전까지 다음 요청을 막아도 됨 |
| multi-bit status with encoded sequence | Gray code | 한 번에 한 bit만 바뀌도록 제한 |
| multi-bit data stream | async FIFO | data는 memory, pointer만 CDC |
| reset | reset synchronizer | async assert, sync deassert |

## 면접 답변용 정리

CDC를 설명할 때는 다음 순서로 말하면 좋다.

1. 서로 다른 clock domain 사이에는 setup/hold timing 관계가 보장되지 않는다.
2. 비동기 신호가 destination clock edge 근처에서 변하면 receiver FF가 metastability에 빠질 수 있다.
3. Single-bit level은 2FF synchronizer로 metastability 전파 확률을 낮춘다.
4. Pulse는 destination이 놓칠 수 있으므로 toggle이나 handshake로 level화해서 넘긴다.
5. Multi-bit data는 bit별 sync 시 coherency가 깨지므로 async FIFO 또는 handshake protocol을 사용한다.
6. Reset deassertion도 recovery/removal 문제가 있으므로 domain별 reset synchronizer를 사용한다.

짧은 답변은 다음과 같다.

> CDC는 서로 다른 clock domain 사이에서 sampling timing을 보장할 수 없어 metastability와 data coherency 문제가 생기는 상황이다. Single-bit level 신호는 2FF synchronizer로 resolve time을 확보하고, pulse/event는 toggle 또는 request/ack handshake로 level화한다. Multi-bit data는 bit별 synchronizer로 넘기면 incoherent value가 생길 수 있으므로 async FIFO처럼 data는 memory에 저장하고 Gray pointer만 CDC한다. Reset은 assert는 비동기로 허용하되 deassert는 각 clock domain에서 synchronizer를 거쳐 release한다.

## 남겨둘 waveform TODO

나중에 SimVision 캡처를 넣으면 좋은 위치는 다음이다.

```text
1. direct capture에서 X 발생
2. 2FF resolved / unresolved 비교
3. pulse miss 또는 edge 근처 X
4. toggle synchronizer의 FF2/FF3 XOR pulse 생성
5. multi-bit bus incoherent value
6. handshake req/ack 왕복
7. async FIFO Gray pointer crossing
8. reset synchronizer의 00 -> 01 -> 11 release
```
