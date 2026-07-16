# 10-05. Coverage Basics

Coverage는 test가 설계의 어느 부분을 얼마나 실행했는지, 또는 어떤 기능 scenario를 확인했는지 측정하는 지표이다. 중요한 점은 coverage가 PASS/FAIL을 대체하지 않는다는 것이다.

## Code coverage

Code coverage는 RTL code의 구조적 실행 정도를 본다.

대표적인 항목은 다음이다.

- line coverage
- branch coverage
- expression coverage
- toggle coverage
- FSM state/transition coverage

예를 들어 어떤 `if`문의 else branch가 한 번도 실행되지 않았다면 branch coverage가 낮게 나온다.

```verilog
if (full)
    block_write();
else
    accept_write();
```

여기서 full case를 테스트하지 않으면 full 관련 bug를 놓칠 가능성이 있다.

## Functional coverage

Functional coverage는 설계자가 정의한 기능 scenario가 발생했는지를 본다.

FIFO라면 다음을 cover할 수 있다.

- empty 상태를 봤는가
- full 상태를 봤는가
- pointer wrap-around를 봤는가
- read/write 동시 발생을 봤는가
- full 직전에서 pop/push를 봤는가

Functional coverage는 design intent를 반영해야 한다. 단순히 code가 실행됐는지보다 “중요한 상황을 실제로 테스트했는가”에 가깝다.

## Coverage closure

Coverage closure는 목표 coverage를 만족할 때까지 test를 추가하거나 수정하는 과정이다.

```text
coverage report 확인
    |
    v
빠진 scenario 분석
    |
    v
test 추가 또는 constraint 수정
    |
    v
regression 재실행
```

작은 프로젝트에서는 formal한 coverage report가 없더라도 checklist 형태로 closure를 할 수 있다.

## Coverage를 맹신하면 안 되는 이유

Coverage가 높다고 반드시 검증이 충분한 것은 아니다.

예를 들어 code coverage가 100%여도 checker가 틀리면 bug를 못 잡는다. Functional coverage가 높아도 expected result 비교가 부실하면 의미가 약하다.

반대로 coverage가 낮으면 아직 안 본 logic이나 scenario가 있다는 경고로 받아들여야 한다.

## 설계자 관점의 coverage 질문

RTL 설계자가 스스로 물어볼 질문은 다음이다.

- reset 후 초기 상태를 봤는가?
- 정상 transaction만 본 것은 아닌가?
- full/empty, overflow/underflow 같은 boundary를 봤는가?
- FSM의 모든 주요 state와 transition을 봤는가?
- CDC/FIFO에서는 clock ratio와 stall case를 봤는가?
- low power/clock gating에서는 enable 전환 timing을 봤는가?

## 핵심 정리

Coverage는 test가 어디까지 설계를 건드렸는지 보여주는 지표이다. PASS/FAIL checker가 correctness를 판단하고, coverage는 빠진 scenario를 찾는 데 사용한다. 둘을 함께 봐야 검증의 신뢰도가 올라간다.
