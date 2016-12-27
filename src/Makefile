help:
	@echo
	@echo -e '  \e[7mBuild\e[0m'
	@echo -e '    \e[1mall\e[0m                    - Build Operating System'
	@echo -e '    \e[1mtoolchain\e[0m              - Build toolchain'
	@echo
	@echo -e '  \e[7mCleaning\e[0m'
	@echo -e '    \e[7m\e[1mclean\e[0m                  - Delete all files created by build'
	@echo

all: toolchain

toolchain:
	@scripts/build_toolchain.sh

clean:
	@rm -rf ./out

.PHONY: toolchain system kernel image clean
