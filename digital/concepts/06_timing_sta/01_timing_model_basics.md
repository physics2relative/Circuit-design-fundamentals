# Timing Model Basics

## 작성 예정

- Sequential timing path의 기본 구조
- Launch flip-flop과 capture flip-flop
- Clock-to-Q delay
- Combinational delay
- Setup time
- Hold time
- Clock period
- Data arrival time과 required time의 개념

## 기본 구조

```text
launch FF ---- combinational logic ---- capture FF
    ^                                      ^
    |                                      |
  clock                                  clock
```
