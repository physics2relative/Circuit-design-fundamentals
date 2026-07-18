# 5-1. Negative Feedback Basics

Negative feedback은 output의 일부를 input으로 되돌려 error를 줄이는 구조이다.

```text
error = input - feedback
output = A * error
```

## 장점

- closed-loop gain 정확도 개선
- distortion 감소
- bandwidth 증가 가능
- input/output resistance 개선
- process variation에 대한 민감도 감소

## 비용

- loop stability 문제
- phase margin 확보 필요
- compensation으로 bandwidth나 slew rate trade-off 발생
