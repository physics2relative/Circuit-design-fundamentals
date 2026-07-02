# Parameterization

## 핵심 관점

Parameterization은 같은 RTL을 여러 width, depth, configuration으로 재사용하기 위한 방법이다. 단순히 숫자를 바꾸는 기능이 아니라 boundary condition과 width 계산까지 함께 관리해야 한다.

## `parameter`

```verilog
module counter #(
    parameter WIDTH = 8
)(
    input  wire             clk,
    input  wire             rst_n,
    output reg  [WIDTH-1:0] count
);

always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        count <= {WIDTH{1'b0}};
    else
        count <= count + 1'b1;
end

endmodule
```

## `localparam`

`localparam`은 module 내부에서 고정된 derived constant를 만들 때 사용한다. 외부에서 override되지 않는 값이라는 의도를 표현할 수 있다.

```verilog
localparam IDLE = 2'b00;
localparam RUN  = 2'b01;
localparam DONE = 2'b10;
```

## Parameter override

module instance에서 parameter를 바꿔 재사용할 수 있다.

```verilog
counter #(
    .WIDTH(16)
) u_counter (
    .clk   (clk),
    .rst_n (rst_n),
    .count (count)
);
```

## Generate

`generate`는 compile/elaboration time에 hardware 구조를 반복 생성할 때 사용한다. runtime loop가 아니다.

```verilog
genvar i;
generate
    for (i = 0; i < WIDTH; i = i + 1) begin : gen_bit
        assign y[i] = a[i] & b[i];
    end
endgenerate
```

## 주의점

- parameter 변경 시 vector width가 함께 맞는지 확인한다.
- depth가 parameter이면 pointer width, full/empty 조건도 같이 확인한다.
- `$clog2` 같은 system function 사용 가능 여부는 tool과 Verilog version을 확인한다.
- parameter가 많아질수록 interface와 verification case도 복잡해진다.

## 정리

Parameterization은 RTL 재사용성을 높이지만, configuration이 늘어날수록 검증해야 할 조합도 늘어난다. width, depth, boundary condition을 함께 고려해야 한다.
