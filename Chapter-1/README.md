## 1장: 개발 환경 설정

첫 번째 단계로 Debian 8.6에서 개발 환경을 설정할 것입니다.

### **패키지 설치하기**

```
$ sudo apt install binutils build-essential gcc make nasm qemu zip -y
```

### **운영체제 빌드와 테스트**

[Makefile](https://github.com/LeeKyuHyuk/How-to-Make-a-Operating-System/blob/master/src/Makefile) 파일에 운영체제의 빌드 규칙이 정의되어있습니다.

```
$ git clone https://github.com/LeeKyuHyuk/How-to-Make-a-Operating-System.git
$ cd How-to-Make-a-Operating-System/src
```

빌드:

```
make all
```

QEMU를 사용하여 운영체제 테스트:

```
make run
```

QEMU에 대한 문서는 [QEMU Emulator Documentation](http://wiki.qemu.org/download/qemu-doc.html)에서 볼 수 있습니다.
