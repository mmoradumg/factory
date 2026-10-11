CC ?= clang
LD ?= ld.lld
.PHONY: all clean check
all: build/kernel.elf build/BOOTX64.EFI
build:
	mkdir -p build
build/entry.o: kernel/entry.S | build
	clang -target x86_64-unknown-none-elf -ffreestanding -mno-red-zone -c $< -o $@
build/main.o: kernel/main.c include/bootinfo.h | build
	clang -target x86_64-unknown-none-elf -O2 -ffreestanding -fno-stack-protector -fno-pic -fno-pie -mno-red-zone -Iinclude -c $< -o $@
build/kernel.elf: build/entry.o build/main.o kernel/linker.ld
	ld.lld -nostdlib -z max-page-size=4096 -T kernel/linker.ld build/entry.o build/main.o -o $@
build/BOOTX64.EFI: boot/loader.c boot/efi_min.h include/bootinfo.h | build
	clang -target x86_64-pc-win32-coff -O2 -ffreestanding -fshort-wchar -fno-stack-protector -mno-red-zone -mno-stack-arg-probe -Iinclude -c boot/loader.c -o build/loader.obj
	lld-link /subsystem:efi_application /entry:efi_main /nodefaultlib /machine:x64 /out:$@ build/loader.obj
check: all
	file build/kernel.elf build/BOOTX64.EFI
	readelf -h -lW build/kernel.elf
clean:
	rm -rf build
