# Differential Pair Simulation

## Objective

differential pair의 current steering, differential gain, common-mode gain, CMRR, offset을 확인한다.

## Circuit under test

이 프로젝트에는 공개 가능한 수준의 회로 구조 설명, 직접 그린 회로도 이미지, simulation 조건, 결과 plot을 정리한다. PDK model과 proprietary netlist는 포함하지 않는다.

## Simulation checklist

- DC Vid sweep
- AC differential gain
- AC common-mode gain
- CMRR calculation
- input common-mode sweep
- Monte Carlo offset if available

## Result summary format

```text
simulation type:
observed metric:
expected result:
simulation result:
difference / debug note:
```

## Interview takeaway

Simulation 결과가 어떤 회로 직관을 검증하는지 한 문단으로 정리한다.
