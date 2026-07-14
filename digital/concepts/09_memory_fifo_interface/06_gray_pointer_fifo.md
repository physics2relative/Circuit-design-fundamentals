# 09-06. Gray Pointer FIFO

Gray pointer FIFO는 asynchronous FIFO에서 pointer를 다른 clock domain으로 넘길 때 Gray code를 사용하는 구조이다. 목적은 pointer가 변하는 순간 여러 bit가 동시에 바뀌는 문제를 줄이는 것이다.

## Binary pointer의 문제

Binary counter는 증가할 때 여러 bit가 동시에 바뀔 수 있다.

```text
0111 -> 1000
```

이 전환에서는 네 bit가 모두 바뀐다. 이 값을 다른 clock domain에서 sampling하면 일부 bit는 이전 값, 일부 bit는 다음 값으로 보일 수 있다. 그러면 실제 pointer와 전혀 다른 값이 만들어질 수 있다.

## Gray code의 특징

Gray code는 인접한 값 사이에서 한 bit만 바뀌도록 만든 code이다.

```text
binary: 000 001 010 011 100 101 110 111
gray  : 000 001 011 010 110 111 101 100
```

한 번에 한 bit만 바뀌면 synchronizer 입력에서 metastability가 생기더라도 pointer가 이전 값 또는 다음 값 근처로 해석될 가능성이 높다. 여러 bit가 섞여 완전히 엉뚱한 pointer가 되는 위험을 줄인다.

## Binary to Gray 변환

Binary pointer를 Gray code로 바꾸는 일반식은 다음과 같다.

```verilog
assign gray = binary ^ (binary >> 1);
```

FIFO 내부 pointer 증가와 memory address 계산은 binary가 편하다. 반면 CDC crossing에는 Gray code가 적합하다. 따라서 보통 binary pointer와 Gray pointer를 함께 유지한다.

## Gray to Binary 변환

상대 domain에서 synchronized Gray pointer를 비교할 때는 Gray 상태로 직접 비교하거나, 필요하면 binary로 변환해서 distance를 계산할 수 있다.

Gray to binary는 상위 bit부터 XOR 누적을 사용한다.

```text
binary[MSB] = gray[MSB]
binary[i]   = binary[i+1] ^ gray[i]
```

## Async FIFO flag와 Gray pointer

Empty 판단은 read domain에서 수행한다. read pointer의 다음 값과 synchronized write pointer가 같으면 empty가 된다.

Full 판단은 write domain에서 수행한다. write pointer의 다음 Gray 값이 synchronized read pointer와 특정 관계가 되면 full이다. Extra MSB를 포함한 Gray pointer에서는 상위 bit 관계를 이용해 한 바퀴 앞섰는지를 판단한다.

## Gray code만으로 충분한가

Gray code는 여러 bit 동시 변화 문제를 줄이는 방법이지, synchronizer를 대체하지 않는다. Gray pointer의 각 bit도 CDC 신호이므로 2FF synchronizer를 통과해야 한다.

또한 Gray pointer가 안전하려면 source domain에서 pointer가 한 번에 하나씩 증가해야 한다. 한 cycle에 여러 entry를 한꺼번에 push/pop하는 구조에서는 그에 맞는 별도 설계가 필요하다.

## 핵심 정리

Async FIFO에서 Gray pointer를 쓰는 이유는 pointer CDC를 안전하게 만들기 위해서이다. Data bus를 넘기는 것이 아니라 pointer만 넘기고, 그 pointer는 한 번에 한 bit만 변하도록 Gray code로 표현한다.
