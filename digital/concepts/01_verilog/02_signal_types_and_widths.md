# Signal Types and Widths

## 핵심 관점

Verilog에서 signal 선언은 단순 문법이 아니라 **어떤 방식으로 driven 되는 신호인가**와 **몇 bit hardware인가**를 결정한다.

## `wire`

`wire`는 회로의 연결선에 해당하는 net type이다. 보통 `assign` 문이나 module instance output에 의해 driven 된다.

```verilog
wire a;
wire [7:0] data;

assign a = b & c;
```

## `reg`

`reg`는 `always`나 `initial` block 내부에서 값을 대입받는 variable type이다. 이름과 달리 항상 flip-flop을 의미하지 않는다.

```verilog
reg [7:0] q;

always @(posedge clk) begin
    q <= d;
end
```

clocked always block에서 update되면 register로 합성될 수 있고, 조합 always block에서 모든 path에 값이 assign되면 조합논리로 합성될 수 있다.

## Width

Verilog에서는 width mismatch가 자주 bug를 만든다.

```verilog
wire [3:0] a;
wire [7:0] b;
wire [7:0] y;

assign y = a + b;
```

tool이 자동 extension이나 truncation을 하더라도, 의도한 zero extension인지 sign extension인지 확인해야 한다.

## Bit slicing and concatenation

```verilog
assign upper = data[7:4];
assign lower = data[3:0];
assign byte_value = {upper, lower};
```

bit slicing과 concatenation은 datapath 작성에서 자주 사용한다. width가 맞지 않으면 truncation이나 extension이 발생할 수 있다.

## Signed / unsigned

`reg [7:0] a`는 기본적으로 unsigned로 다뤄진다. signed 연산이 필요하면 선언과 연산 의도를 명확히 해야 한다.

```verilog
reg signed [7:0] a;
reg signed [7:0] b;
wire signed [8:0] sum;

assign sum = a + b;
```

## 주의점

- `reg`는 항상 실제 register를 의미하지 않는다.
- 한 signal을 여러 곳에서 drive하지 않는다.
- width mismatch warning은 무시하지 않는다.
- signed/unsigned 연산은 명시적으로 확인한다.
- slicing과 concatenation의 결과 width를 계산한다.
