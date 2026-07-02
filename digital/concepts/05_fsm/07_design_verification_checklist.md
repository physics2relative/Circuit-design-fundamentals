# FSM Design and Verification Checklist

## 설계 절차

1. 입력과 출력 정의
2. reset state 정의
3. 가능한 state 나열
4. state transition 조건 정리
5. Moore/Mealy 선택
6. state encoding 선택
7. next-state logic 작성
8. output logic 작성
9. illegal state 처리
10. transition coverage 확인

## 검증 포인트

- reset 후 initial state
- 모든 state transition
- 모든 output condition
- illegal state recovery
- 동시에 들어오는 input condition
- state가 stuck되지 않는지 여부
- one-cycle pulse output의 길이

## 정리

FSM 검증은 state별 transition을 모두 확인하는 것이 핵심이다. 특정 state에 들어가는 조건뿐 아니라 빠져나오는 조건도 함께 확인해야 한다.
