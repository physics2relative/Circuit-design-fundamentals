# 10-03. Directed and Self-checking Test

Directed test는 설계자가 의도한 특정 scenario를 직접 만들어 검증하는 방식이다. Self-checking testbench는 그 scenario의 결과를 사람이 waveform으로 확인하지 않고 testbench가 자동으로 PASS/FAIL 판정하는 방식이다.

## Directed test

Directed test는 특정 기능이나 corner case를 목표로 한다.

예를 들어 FIFO라면 다음 scenario를 직접 만든다.

- reset 후 empty 확인
- data 3개 push 후 같은 순서로 pop
- depth만큼 채운 뒤 full 확인
- full 상태에서 추가 write 차단 확인
- consumer stall 중 valid-ready 동작 확인

장점은 의도가 명확하고 debug가 쉽다는 점이다. 단점은 설계자가 생각하지 못한 case는 놓치기 쉽다는 점이다.

## Self-checking testbench

Self-checking testbench는 expected result를 testbench 안에서 계산하고 actual result와 비교한다.

```text
stimulus -> DUT -> actual output
             |
             v
        expected output과 비교
```

가장 단순한 형태는 error counter를 두는 방식이다.

```verilog
integer errors;

if (actual !== expected) begin
    $display("ERROR: mismatch at %0t", $time);
    errors = errors + 1;
end

if (errors == 0)
    $display("PASS");
else
    $fatal;
```

이렇게 하면 regression에서 log만 보고도 실패 여부를 알 수 있다.

## FIFO 예시

FIFO ordering test에서는 expected data sequence를 testbench가 알고 있어야 한다.

```text
push: 0x11, 0x22, 0x33
pop expected: 0x11, 0x22, 0x33
```

출력 transaction이 발생할 때마다 expected sequence의 front와 비교한다.

```text
if out_valid && out_ready:
    check(out_data == expected_queue.pop_front())
```

Verilog-only testbench에서는 queue 대신 array와 index를 써도 된다.

## Corner case 구성

Directed test는 정상 동작만 보면 부족하다. 다음과 같은 boundary condition을 반드시 넣어야 한다.

- reset 직후
- empty에서 read 시도
- full에서 write 시도
- full 근처에서 read/write 동시 발생
- pointer wrap-around
- valid는 유지되지만 ready가 늦게 올라오는 경우
- clock ratio가 다른 async FIFO

## Waveform 확인과 self-check의 관계

Self-checking test가 PASS해도 waveform 확인이 완전히 필요 없어지는 것은 아니다. 처음 testbench를 만들 때는 waveform으로 의도한 scenario가 실제로 만들어졌는지 확인해야 한다.

하지만 regression에서는 매번 waveform을 열지 않고 log의 PASS/FAIL을 먼저 보는 것이 효율적이다.

## 핵심 정리

Directed test는 특정 기능과 corner case를 직접 겨냥하는 test이다. Self-checking testbench는 expected와 actual을 자동 비교해서 waveform 수동 확인 의존도를 줄인다. RTL 설계자는 최소한 주요 directed test를 self-checking 형태로 만들 수 있어야 한다.
