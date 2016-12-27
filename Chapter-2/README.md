## 2장: 크로스 컴파일러 빌드

크로스 컴파일러(cross compiler)는 컴파일러가 실행되는 플랫폼이 아닌 다른 플랫폼에서 실행 가능한 코드를 생성할 수 있는 컴파일러입니다.

크로스 컴파일러 툴은 임베디드 시스템 혹은 여러 플랫폼에서 실행파일을 생성하는데 사용됩니다.

> [크로스 컴파일러 - 위키백과](https://ko.wikipedia.org/wiki/크로스_컴파일러)

### **환경 변수 설정**

TARGET과 TOOLS 환경 변수를 정해줍니다.

TARGET은 컴파일해서 만들어진 바이너리가 만들어내는 바이너리가 실행되는 OS/기계를 지정합니다.

TOOLS는 우리가 빌드 한 크로스 컴파일러가 위치할 곳을 지정해줍니다.

```
$ export TARGET="x86_64-pc-linux"
$ export TOOLS=/home/leekyuhyuk/How-to-Make-a-Operating-System/src/out/tools
$ export PATH="${TOOLS}/bin:${PATH}"
```

### **Binutils 빌드**

GNU 바이너리 유틸리티 또는 GNU Binutils는 여러 종류의 오브젝트 파일 형식들을 조작하기 위한 프로그래밍 도구 모음입니다.

> [GNU 바이너리 유틸리티 - 위키백과](https://ko.wikipedia.org/wiki/GNU_바이너리_유틸리티)

```
$ wget https://ftp.gnu.org/gnu/binutils/binutils-2.27.tar.bz2
$ tar -xjvf binutils-2.27.tar.bz2
$ cd binutils-2.27
$ ./configure --target=${TARGET} --prefix=${TOOLS} --disable-nls --disable-shared --enable-64-bit-bfd
$ make configure-host
$ make LDFLAGS="-all-static"
$ make install
```

configure 옵션들이 의미하는 것:

  - --target=${TARGET} : 컴파일해서 만들어진 바이너리가 만들어내는 바이너리가 "x86_64-pc-linux"에서 실행되게 합니다.
  - --prefix=${TOOLS} : 빌드한 binutils가 ${TOOLS}에 저장됩니다.
  - --disable-nls : 국제화를 사용하지 않습니다. (크로스 컴파일러에는 i18n이 필요하지 않으므로 국제화를 사용하지 않습니다)
  - --disable-shared : 공유 라이브러리 사용하지 않습니다. (정적 라이브러리를 사용합니다)
  - --enable-64-bit-bfd : 64비트 관련 기능을 활성화합니다.

`make LDFLAGS="-all-static"`의 LDFLAGS의 값으로 링크 옵션을 변경할 수 있습니다. `-all-static`는 모두 정적 라이브러리를 사용하게 하는 옵션입니다.

### **GCC 빌드**

GNU 컴파일러 모음(GNU Compiler Collection, 줄여서 GCC)는 GNU 프로젝트의 일환으로 개발되어 널리 쓰이고 있는 컴파일러입니다.

C, C++, 자바, 포트란, 에이다 등 여러 언어를 컴파일할 수 있습니다.

> [GNU 컴파일러 모음 - 위키백과](https://ko.wikipedia.org/wiki/GNU_컴파일러_모음)

```
$ wget https://ftp.gnu.org/gnu/gcc/gcc-6.3.0/gcc-6.3.0.tar.bz2
$ wget https://ftp.gnu.org/gnu/gmp/gmp-6.1.2.tar.xz
$ wget https://ftp.gnu.org/gnu/mpc/mpc-1.0.3.tar.gz
$ wget https://ftp.gnu.org/gnu/mpfr/mpfr-3.1.5.tar.xz
$ tar -xjvf gcc-6.3.0.tar.bz2
$ tar -xJvf gmp-6.1.2.tar.xz
$ tar -xvzf mpc-1.0.3.tar.gz
$ tar -xJvf mpfr-3.1.5.tar.xz
$ mv gmp-6.1.2 gcc-6.3.0/gmp
$ mv mpc-1.0.3 gcc-6.3.0/mpc
$ mv mpfr-3.1.5 gcc-6.3.0/mpfr
$ cd gcc-6.3.0
$ ./configure --target=${TARGET} --prefix=${TOOLS} --disable-nls --disable-shared --enable-languages=c --enable-multilib --without-headers
$ make configure-host
$ make all-gcc
$ make install-gcc
```

configure 옵션들이 의미하는 것:

  - --target=${TARGET} : 컴파일해서 만들어진 바이너리가 만들어내는 바이너리가 "x86_64-pc-linux"에서 실행되게 합니다.
  - --prefix=${TOOLS} : 빌드한 binutils가 ${TOOLS}에 저장됩니다.
  - --disable-nls : 국제화를 사용하지 않습니다. (크로스 컴파일러에는 i18n이 필요하지 않으므로 국제화를 사용하지 않습니다)
  - --disable-shared : 공유 라이브러리 사용하지 않습니다. (정적 라이브러리를 사용합니다)
  - --enable-languages=c : GCC에서 C언어를 컴파일 할 수 있게 설정합니다.
  - --enable-multilib : 32비트와 64비트의 라이브러리를 모두 생성합니다.
  - --without-headers : 크로스 컴파일 할 때 GCC가 대상의 libc를 사용하지 못하게 합니다.
