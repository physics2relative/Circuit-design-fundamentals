# OP AMP Practice with Virtuoso/Spectre

## Objective

OP AMP의 DC operating point, AC gain/phase, transient response를 확인하고 주요 성능 지표를 해석합니다.

## Simulation Checklist

- DC operating point에서 모든 MOSFET의 동작 영역 확인
- AC analysis에서 DC gain, unity-gain bandwidth, phase margin 확인
- Transient analysis에서 step response, settling, slew rate 확인
- Bias current 변화에 따른 gain/bandwidth/slew-rate trade-off 관찰

## Interview Takeaways

- OP AMP 성능은 gain, bandwidth, stability, slew rate, swing, power 사이의 trade-off로 설명할 수 있습니다.
- AC 결과가 이상하면 먼저 bias point와 소자의 operating region을 확인합니다.
