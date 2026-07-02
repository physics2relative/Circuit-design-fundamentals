# Signal Types and Widths

## 핵심 관점

Verilog에서 signal 선언은 단순 문법이 아니라 **어떤 방식으로 driven 되는 신호인가**와 **몇 bit hardware인가**를 결정합니다.

## `wire`

`wire`는 회로의 연결선에 가깝습니다. 보통 `assign` 문이나 module instance output에 의해 driven 됩니다.

```verilog
wire a;
wire [7:0] data;

assign a = b & c;
```

## `reg`

`reg`는 `always`나 `initial` block 내부에서 값을 대입받는 변수 타입입니다. 이름과 달리 항상 flip-flop을 의미하지 않습니다.

```verilog
reg [7:0] q;

always @(posedge clk) begin
    q <= d;
end
```

clocked always block에서 update되면 register로 합성될 수 있고, 조합 always block에서 모든 path에 값이 assign되면 조합논리로 합성될 수 있습니다.

## Width

Verilog에서는 width mismatch가 자주 bug를 만듭니다.

```verilog
wire [3:0] a;
wire [7:0] b;
wire [7:0] y;

assign y = a + b;
```

이런 코드는 simulator/synthesis tool이 자동 확장을 하더라도, 의도한 zero extension인지 sign extension인지 명확히 확인해야 합니다.

## Bit slicing and concatenation

```verilog
assign upper = data[7:4];
assign lower = data[3:0];
assign byte_value = {upper, lower};
```

bit slicing과 concatenation은 datapath 작성에서 자주 쓰입니다. width가 맞지 않으면 truncation이나 extension이 발생할 수 있습니다.

## Signed / unsigned 주의

`reg [7:0] a`는 기본적으로 unsigned로 다뤄집니다. signed 연산이 필요하면 선언과 연산 모두 의도를 명확히 해야 합니다.

```verilog
reg signed [7:0] a;
reg signed [7:0] b;
wire signed [8:0] sum;

assign sum = a + b;
```

## 면접 질문

### Q. `wire`와 `reg`의 차이는?

면접 답변:

> `wire`는 continuous assignment나 module 연결에 의해 driven 되는 net이고, `reg`는 procedural block 내부에서 값을 대입받는 타입입니다. `reg`가 항상 실제 register를 의미하는 것은 아니며, 어떤 always block에서 어떻게 assign되는지에 따라 조합논리나 순차논리로 합성될 수 있습니다.

### Q. width mismatch가 위험한 이유는?

면접 답변:

> Verilog는 width가 다를 때 자동 extension이나 truncation이 일어날 수 있습니다. 이 동작이 의도와 다르면 상위 bit 손실, sign 처리 오류, overflow 판단 오류가 생길 수 있으므로 lint warning과 waveform을 확인해야 합니다.
