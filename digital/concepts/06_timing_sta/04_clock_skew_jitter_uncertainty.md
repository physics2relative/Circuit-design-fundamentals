# Clock Skew, Jitter, and Uncertainty

## Clock skew

Clock skew는 같은 clock source에서 나온 clock이 launch FF와 capture FF에 서로 다른 시간에 도착하는 현상이다.

```text
skew = capture clock arrival time - launch clock arrival time
```

Capture clock이 launch clock보다 늦게 도착하면 positive skew로 볼 수 있고, capture clock이 더 빨리 도착하면 negative skew로 볼 수 있다.

## Setup에서 skew의 영향

Setup timing에서는 capture edge가 늦게 도착하면 data가 도착할 시간이 늘어난다. 따라서 positive skew는 setup에 유리하게 작용할 수 있다.

반대로 capture edge가 빨리 도착하면 data가 도착할 시간이 줄어든다. Negative skew는 setup에 불리하다.

## Hold에서 skew의 영향

Hold timing에서는 capture edge 직후 data가 유지되어야 한다. Capture clock이 늦게 도착하는 positive skew는 hold 관점에서는 불리할 수 있다. Launch 쪽에서는 새 data가 이미 나오기 시작했는데, capture 쪽 clock은 늦게 도착해서 hold window가 겹칠 수 있기 때문이다.

즉, setup에 유리한 skew가 hold에는 불리할 수 있고, hold에 유리한 skew가 setup에는 불리할 수 있다.

## Clock jitter

Clock jitter는 clock edge 위치가 cycle마다 흔들리는 현상이다. 이상적인 clock은 정확한 주기로 edge가 발생하지만, 실제 clock은 PLL, clock network, noise 등의 영향으로 edge 위치가 변동한다.

Jitter는 timing margin을 줄이는 방향으로 고려된다. STA에서는 worst-case를 가정해야 하므로, jitter는 setup/hold 양쪽에서 uncertainty로 반영될 수 있다.

## Clock uncertainty

Clock uncertainty는 clock edge 위치에 대한 불확실성을 constraint로 모델링한 것이다. Jitter, clock source variation, modeling margin 등이 포함될 수 있다.

Uncertainty가 커지면 timing margin은 줄어든다. Setup에서는 required time이 더 빡빡해지고, hold에서는 data 안정성 요구가 더 엄격해진다.

## CTS와 skew

CTS(clock tree synthesis) 전에는 clock network가 이상적으로 가정되는 경우가 많다. CTS 이후에는 실제 clock tree가 삽입되면서 각 register까지의 insertion delay가 생기고, skew가 구체적으로 나타난다.

따라서 synthesis 초기의 timing 결과와 place & route 이후의 timing 결과는 달라질 수 있다.

## 핵심 정리

- Clock skew는 launch/capture FF에 clock이 도착하는 시간 차이이다.
- Positive skew는 setup에 유리할 수 있지만 hold에는 불리할 수 있다.
- Jitter는 clock edge가 cycle마다 흔들리는 현상이다.
- Uncertainty는 clock timing의 불확실성을 STA constraint에 반영한 margin이다.
- Clock 관련 margin은 setup과 hold를 동시에 고려해야 한다.
