# 6-2. Two-stage Op-Amp Structure

Two-stage op-amp는 기본 analog IC 설계에서 자주 다루는 구조이다.

```text
Differential input stage -> second gain stage -> output/load
              |                    |
          bias circuits       Miller compensation
```

## 구성 요소

- differential pair input stage
- current mirror active load
- second common-source gain stage
- bias current source
- Miller compensation capacitor

## 역할

Input stage는 differential input을 current/voltage로 변환하고, second stage는 추가 gain과 output swing을 제공한다. Miller capacitor는 stability를 위해 dominant pole을 만든다.
