# Reset in Sequential Logic

## 핵심 관점

Sequential logic은 reset 이후 state가 명확해야 한다. 특히 FSM state, valid bit, control register는 reset이 필요한 경우가 많다.

## Reset 대상

Reset이 필요한 경우가 많은 signal은 다음과 같다.

- FSM state
- valid bit
- control register
- pointer
- status flag

큰 datapath register는 reset tree 부담을 줄이기 위해 reset하지 않고 valid bit로 관리할 수 있다.

## Synchronous reset / asynchronous reset

Reset coding 방식은 `../07_clock_reset_cdc/`에서 더 자세히 다룬다. 여기서는 sequential state의 initial condition을 명확히 하는 것이 핵심이다.

## 주의점

- reset 이후 legal state로 시작해야 한다.
- reset이 없는 register의 초기값을 simulation 값으로 가정하지 않는다.
- datapath reset 생략 시 valid bit와 함께 해석해야 한다.
