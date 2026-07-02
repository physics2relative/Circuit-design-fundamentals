# Datapath Building Blocks

## 핵심 관점

Datapath는 data가 연산되고 이동하는 hardware 경로이다. 기본 구성 요소는 연산기, 선택기, 저장소로 나눌 수 있다.

## 기본 구성 요소

- adder
- subtractor
- comparator
- mux
- shifter
- register
- multiplier

## Adder / Subtractor

Adder와 subtractor는 산술 datapath의 기본이다. 큰 bit width의 adder는 carry propagation 때문에 critical path가 될 수 있다.

## Comparator

Comparator는 branch condition, max/min selection, address range check 등에 사용된다. signed 비교와 unsigned 비교를 구분해야 한다.

## MUX

MUX는 여러 data path 중 하나를 선택한다. datapath control의 대부분은 mux select를 만드는 문제로 볼 수 있다.

## Shifter

Shifter는 bit 이동, scaling, alignment 등에 사용된다. variable shift는 fixed shift보다 hardware cost가 클 수 있다.

## Multiplier

Multiplier는 area와 timing 부담이 큰 연산기이다. FPGA에서는 DSP block 사용 여부, ASIC에서는 pipeline 여부가 중요하다.

## 정리

Datapath 설계에서는 연산 자체보다 bit width, signedness, timing, area를 함께 고려해야 한다.
