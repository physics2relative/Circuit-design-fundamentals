# MUX, Decoder, and Encoder

## MUX

MUX는 select signal에 따라 여러 input 중 하나를 output으로 전달하는 조합논리이다.

```text
2:1 MUX
sel = 0 → y = d0
sel = 1 → y = d1
```

Verilog 표현 예시는 다음과 같다.

```verilog
assign y = sel ? d1 : d0;
```

MUX는 datapath selection, bus selection, control path selection에 자주 사용된다.

## Decoder

Decoder는 encoded input을 one-hot output으로 변환한다.

```text
2-bit input → 4-bit one-hot output
00 → 0001
01 → 0010
10 → 0100
11 → 1000
```

Address decoding, register selection, one-hot control generation에 사용된다.

## Encoder

Encoder는 one-hot 또는 priority input을 encoded output으로 변환한다. 여러 input이 동시에 1일 수 있으면 priority encoder가 필요하다.

## One-hot

One-hot 표현은 여러 bit 중 하나만 1인 encoding이다. decoding이 단순하고 timing에 유리할 수 있으나 bit 수가 증가한다.
