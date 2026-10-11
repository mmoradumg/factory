#include <stdint.h>
#include "bootinfo.h"
static void debug_puts(const char *s){while(*s){unsigned char c=(unsigned char)*s++;__asm__ volatile("outb %0, %1"::"a"(c),"Nd"((unsigned short)0xe9));}}
static void halt(void){for(;;)__asm__ volatile("cli; hlt");}
void kernel_main(const umg_boot_info_t *b){
 if(!b || b->magic!=UMG_BOOT_MAGIC || !b->framebuffer_base || !b->width || !b->height || b->pixel_format>1){debug_puts("UMG_BOOTINFO_INVALID\n");halt();}
 volatile uint32_t *fb=(volatile uint32_t *)(uintptr_t)b->framebuffer_base;
 uint64_t max=b->framebuffer_size/4;
 for(uint32_t y=0;y<b->height;y++)for(uint32_t x=0;x<b->width;x++){
  uint64_t i=(uint64_t)y*b->pixels_per_scanline+x;
  if(i<max)fb[i]=((x/24+y/24)&1)?0x00131B2A:0x002A4D70;
 }
 debug_puts("UMG_KERNEL_REACHED\n");
 halt();
}
