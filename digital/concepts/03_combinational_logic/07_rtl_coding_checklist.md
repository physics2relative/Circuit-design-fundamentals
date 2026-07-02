# RTL Coding Checklist

## 조합논리 작성 기준

- `assign` 또는 `always @(*)` 사용
- blocking assignment 사용
- 모든 output에 default assignment
- `case`에는 필요한 모든 branch와 default 처리
- latch inference warning 확인
- combinational loop warning 확인

## 좋은 형태

```verilog
always @(*) begin
    y = 1'b0;

    case (sel)
        2'b00: y = a;
        2'b01: y = b;
        2'b10: y = c;
        2'b11: y = d;
        default: y = 1'b0;
    endcase
end
```

## 확인할 것

- 모든 input 조합에서 output이 결정되는가
- 의도하지 않은 priority가 생기지 않았는가
- width mismatch가 없는가
- signed/unsigned 비교가 명확한가
- combinational path가 너무 길지 않은가
