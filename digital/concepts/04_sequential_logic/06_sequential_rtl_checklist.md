# Sequential RTL Checklist

## 작성 기준

- state update는 clock edge 기준으로 작성한다.
- clocked always block에서는 non-blocking assignment를 사용한다.
- reset condition과 enable condition의 priority를 명확히 한다.
- counter overflow와 wrap-around를 확인한다.
- pipeline stage 사이 data/control alignment를 확인한다.

## 확인할 것

- reset 이후 state가 정의되는가
- enable이 0일 때 hold 동작이 맞는가
- 모든 register가 의도한 clock에서 update되는가
- unintended latch가 없는가
- sequential loop나 combinational feedback이 없는가
