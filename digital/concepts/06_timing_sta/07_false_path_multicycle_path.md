# False Path and Multicycle Path

## Timing exception

Timing exception은 STA tool의 기본 timing check를 일부 path에 대해 수정하는 constraint이다. 대표적으로 false path와 multicycle path가 있다.

Exception은 timing closure에서 필요하지만, 잘못 사용하면 실제 timing bug를 숨길 수 있다. 따라서 path의 구조적 의미를 이해하고 제한적으로 사용해야 한다.

## False path

False path는 실제 동작에서 timing을 만족할 필요가 없는 path이다. 논리적으로 sensitization되지 않거나, 서로 관계없는 clock domain 사이의 path처럼 일반적인 setup/hold check가 의미 없는 경우가 있다.

예시는 다음과 같다.

- 서로 exclusive한 mode 사이의 path
- static configuration signal path
- CDC synchronizer의 async crossing path 중 일반 STA로 분석하지 않는 구간

False path로 지정하면 STA는 해당 path의 setup/hold violation을 보고하지 않는다. 그래서 잘못 지정하면 실제로 필요한 path의 violation이 숨겨진다.

## Multicycle path

Multicycle path는 data가 1 cycle 안에 도착할 필요가 없고 여러 cycle 동안 전달될 수 있는 path이다.

```text
기본: launch 후 다음 capture edge에서 data capture
multicycle: launch 후 N번째 capture edge에서 data capture
```

예를 들어 enable이 특정 cycle마다만 열리는 datapath라면, 해당 path는 1 cycle이 아니라 여러 cycle의 시간을 사용할 수 있다.

## Setup multicycle과 hold multicycle

Multicycle setup을 늘리면 setup check의 capture edge가 뒤로 이동한다. 하지만 hold check도 함께 올바르게 조정하지 않으면 의도치 않은 hold constraint가 생기거나 너무 완화될 수 있다.

따라서 multicycle path는 setup과 hold constraint를 함께 이해해야 한다. 단순히 setup만 늘리는 것은 위험하다.

## CDC와 false path 주의점

CDC path는 서로 다른 clock domain 사이의 path이므로 일반적인 single-clock setup/hold 분석으로 안전성을 보장할 수 없다. 하지만 모든 CDC path를 무작정 false path로 처리하면 안 된다.

CDC는 다음이 함께 필요하다.

- CDC 구조가 올바른지 확인한다.
- Synchronizer, handshake, async FIFO 등 적절한 구조를 사용한다.
- STA exception은 해당 구조에 맞게 제한적으로 적용한다.
- CDC lint/checker로 crossing 구조를 별도로 확인한다.

## 핵심 정리

- False path는 실제 timing check가 의미 없는 path를 제외하는 constraint이다.
- Multicycle path는 data 전달에 여러 cycle을 허용하는 constraint이다.
- Exception은 violation을 숨길 수 있으므로 매우 신중하게 사용해야 한다.
- CDC path는 false path만으로 해결되는 문제가 아니라 CDC 구조 검증이 필요하다.
