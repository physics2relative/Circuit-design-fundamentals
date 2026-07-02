# Sequential Logic

Clock edge를 기준으로 state를 저장하고 갱신하는 logic을 정리하는 대단원이다.

## Contents

1. [Sequential Logic Model](./01_sequential_logic_model.md)
2. [Latch and Flip-Flop](./02_latch_flipflop.md)
3. [Register, Counter, and Shift Register](./03_register_counter_shift.md)
4. [Enable and Pipeline Register](./04_enable_pipeline.md)
5. [Reset in Sequential Logic](./05_reset_in_sequential_logic.md)
6. [Sequential RTL Checklist](./06_sequential_rtl_checklist.md)

## 핵심 정리

- Sequential logic은 저장된 state를 가진다.
- 대부분 clock edge에서 state가 update된다.
- reset, enable, update condition, pipeline alignment를 명확히 해야 한다.
