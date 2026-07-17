# 5-5. Two-stage Op-Amp Structure

Two-stage op-amp는 기본 analog IC 설계에서 자주 다루는 구조이다.

## 기본 block

```text
Differential input stage -> gain stage -> output/load
             |                |
          bias circuits   compensation
```

일반적인 구성은 다음과 같다.

- differential pair input stage
- current mirror active load
- second gain stage
- bias current source
- Miller compensation capacitor

## 각 block의 역할

Differential input stage는 입력 차이를 전류 차이로 변환한다. Current mirror load는 differential-to-single-ended 변환과 gain 형성에 기여한다. Second stage는 추가 gain과 output drive를 제공한다.

## Miller compensation

Miller compensation capacitor는 dominant pole을 만들어 feedback stability를 확보한다. 하지만 compensation capacitor가 크면 bandwidth와 slew rate trade-off가 생긴다.

## 실습 연결

Virtuoso/Spectre 실습에서는 다음을 확인하면 좋다.

- DC operating point
- open-loop gain
- unity-gain bandwidth
- phase margin
- transient step response
- slew rate
- input/output swing
