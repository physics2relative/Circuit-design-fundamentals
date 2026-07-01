# Assets Policy

`assets`는 문서에 삽입할 이미지와 파형 캡처를 저장하는 폴더입니다. 역할이 명확하도록 root가 아니라 각 분야 내부에 둡니다.

## 위치

```text
analog/assets/
  images/       # 회로도, 블록 다이어그램
  waveforms/    # 공개 가능한 파형 캡처 이미지

digital/assets/
  images/       # RTL 블록도, FSM diagram
  waveforms/    # simulation waveform, timing diagram 캡처
```

## 올려도 되는 것

- 직접 그린 블록 다이어그램
- 공개 가능한 waveform 캡처 이미지
- 직접 작성한 timing diagram
- 문서 설명용 작은 이미지

## 올리지 않는 것

- PDK/model/library 파일
- Cadence/Virtuoso 원본 DB
- Spectre raw data 전체
- `.vcd`, `.fsdb`, `.wlf` 같은 대용량 dump
- 라이선스 파일
- 강의자료/회사자료 원문 캡처
