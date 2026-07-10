# Handshake CDC

## 목적

Handshake CDC는 source가 event를 일방적으로 던지는 open-loop 구조가 아니라, destination이 받았다는 acknowledge를 source로 돌려주는 closed-loop 구조이다.

단발성 control event를 안전하게 넘길 때 사용한다.

```text
- start command
- config update request
- mode switch request
- clear/done 같은 low-rate control event
```

## 구조

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

Source 내부 event는 1-cycle pulse일 수 있지만, CDC 경계에서는 `req` level로 바꾼다.

```text
src_event: ___|‾|________________
src_req:   ____‾‾‾‾‾‾‾‾‾‾‾‾____
```

`req`는 ack가 돌아올 때까지 유지된다.

## Source 동작

```text
if src_event and not busy:
    req를 1로 set
    event를 accepted 처리

if ack_sync가 돌아오면:
    req를 0으로 clear
```

`busy`는 보통 `req`가 아직 내려가지 않은 상태를 의미한다. Busy 동안 들어온 event는 무시하거나 별도 pending buffer에 저장해야 한다.

## Destination 동작

Destination은 synchronized request의 rising edge를 검출해서 내부 1-cycle pulse를 만든다.

```text
dst_pulse = dst_req_sync_2 & ~dst_req_sync_3
```

그 뒤 request를 받았다는 의미로 ack를 source로 돌려보낸다.

## 장점과 단점

장점은 accepted event가 destination에 안정적으로 전달된다는 점이다.

```text
source가 req를 유지한다.
destination은 req를 놓치기 어렵다.
ack가 돌아오기 전까지 다음 request를 막을 수 있다.
```

단점은 왕복 latency가 크고 throughput이 낮다는 점이다.

```text
src -> dst request sync latency
dst -> src ack sync latency
request deassert latency
ack deassert latency
```

따라서 handshake CDC는 low-rate control event에 적합하다. High-throughput data stream에는 async FIFO나 buffering protocol이 적합하다.
