# Reset Synchronizer and RDC

## RDC의 의미

Reset도 clock domain 관점에서는 crossing 문제가 생길 수 있다. 특히 reset deassertion이 clock edge 근처에서 발생하면 flip-flop의 recovery/removal timing을 위반할 수 있다.

Active-low reset 기준 원칙은 다음이다.

```text
assert:
    async로 즉시 걸어도 된다.

deassert:
    각 clock domain에서 synchronizer를 거쳐 clock에 맞춰 release한다.
```

이를 보통 async assert, sync deassert라고 한다.

## Reset synchronizer 구조

Active-low reset synchronizer는 다음과 같이 쓸 수 있다.

```verilog
always @(posedge clk or negedge async_rst_n) begin
    if (!async_rst_n) begin
        rst_sync_1 <= 1'b0;
        rst_sync_2 <= 1'b0;
    end else begin
        rst_sync_1 <= 1'b1;
        rst_sync_2 <= rst_sync_1;
    end
end

assign sync_rst_n = rst_sync_2;
```

구조적으로는 다음과 같다.

```text
1'b1 -> [FF1] -> [FF2] -> sync_rst_n
          ^       ^
          |       |
        reset   reset
```

두 FF는 모두 `async_rst_n`으로 비동기 reset된다.

## 동작

Reset assert 상태에서는 두 FF가 즉시 0이 된다.

```text
async_rst_n = 0:
    rst_sync_1 = 0
    rst_sync_2 = 0
    sync_rst_n = 0
```

Reset이 풀리면 clock edge마다 1이 shift-in된다.

```text
async_rst_n = 1 이후:
    1st clk: rst_sync_1 = 1, rst_sync_2 = 0
    2nd clk: rst_sync_1 = 1, rst_sync_2 = 1
```

따라서 `sync_rst_n`은 해당 clock domain 기준으로 2 cycle 뒤에 release된다.

## Domain별 reset

여러 clock domain이 있으면 reset synchronizer도 domain별로 둔다.

```text
global_rst_n
   +--> reset_synchronizer @ clk_src --> rst_src_n --> src domain FFs
   +--> reset_synchronizer @ clk_dst --> rst_dst_n --> dst domain FFs
```

각 domain 내부 FF는 자기 domain에서 만들어진 reset만 사용한다.

```text
clk_src domain -> rst_src_n 사용
clk_dst domain -> rst_dst_n 사용
```

## 피해야 하는 방식

```text
- global reset을 모든 domain FF에 직접 연결
- rst_src_n을 dst domain FF에 사용
- rst_dst_n을 src domain FF에 사용
- domain reset들을 OR/AND로 섞어서 사용
```

Reset을 섞으면 한 domain의 reset 변화가 다른 domain FF를 비동기적으로 release하거나 assert할 수 있다. 이는 새로운 RDC 문제를 만든다.
