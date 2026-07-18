# 4-3. Miller Effect

Miller effect는 입력과 출력 사이의 capacitance가 amplifier gain에 의해 입력 capacitance처럼 크게 보이는 현상이다.

## 기본 직관

입력과 출력 사이에 capacitance `Cgd`가 있고 voltage gain이 음수이면, 입력에서 보는 effective capacitance가 커진다.

```text
Cin_eff ≈ Cgd * (1 - Av)
```

Common-source amplifier에서는 `Av`가 음수이므로 `1 - Av`가 커지고, Miller capacitance가 커진다.

## 영향

- input pole이 낮아짐
- bandwidth 감소
- high-frequency gain 감소
- stage 간 coupling 증가

## Op-amp compensation

Two-stage op-amp에서는 Miller capacitor를 의도적으로 넣어 dominant pole을 만들고 stability를 확보한다. 이 경우 Miller effect를 문제로만 보는 것이 아니라 보상 기법으로 사용한다.
