# Priority Logic

## 핵심 관점

Priority logic은 여러 조건이 동시에 참일 때 어떤 조건을 우선할지 정하는 조합논리이다.

## If-else priority

`if-else` chain은 priority 구조를 만들 수 있다.

```verilog
always @(*) begin
    y = 2'b00;
    if (req[0])
        y = 2'b00;
    else if (req[1])
        y = 2'b01;
    else if (req[2])
        y = 2'b10;
    else if (req[3])
        y = 2'b11;
end
```

## Priority encoder

Priority encoder는 여러 request 중 우선순위가 가장 높은 request를 encoded output으로 변환한다.

## 주의점

- 의도하지 않은 priority는 delay와 area를 증가시킬 수 있다.
- 모든 input 조합에 대해 output이 정의되어야 한다.
- priority가 필요한 구조인지 parallel selection이 가능한 구조인지 구분해야 한다.
