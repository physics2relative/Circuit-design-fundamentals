# Width Extension and Truncation

## 핵심 관점

Datapath에서 width 변화는 값의 의미를 바꿀 수 있다. width extension과 truncation은 의도적으로 관리해야 한다.

## Zero extension

Unsigned 값의 width를 늘릴 때는 상위 bit를 0으로 채운다.

```text
4'b1010 → 8'b0000_1010
```

## Sign extension

Signed 값의 width를 늘릴 때는 sign bit를 상위 bit로 복제한다.

```text
4'b1010 (-6) → 8'b1111_1010 (-6)
4'b0010 (+2) → 8'b0000_0010 (+2)
```

## Truncation

Width를 줄이면 상위 bit가 잘릴 수 있다.

```text
8'b0001_0010 → 4'b0010
```

하위 bit만 필요한 counter, address offset 등에서는 의도된 truncation일 수 있으나 산술 연산에서는 주의가 필요하다.

## RTL 주의점

- assignment width mismatch warning을 확인한다.
- signed 값을 확장할 때 zero extension이 되지 않도록 주의한다.
- 곱셈 결과는 operand보다 더 큰 width가 필요할 수 있다.
- truncation이 의도된 경우 코드나 주석으로 명확히 남긴다.
