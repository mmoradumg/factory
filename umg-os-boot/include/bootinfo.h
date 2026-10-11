#ifndef UMG_BOOTINFO_H
#define UMG_BOOTINFO_H
#include <stdint.h>
#define UMG_BOOT_MAGIC 0x554D47424F4F5431ULL
typedef struct {
 uint64_t magic;
 uint64_t framebuffer_base;
 uint64_t framebuffer_size;
 uint32_t width,height,pixels_per_scanline,pixel_format;
 uint64_t memory_map;
 uint64_t memory_map_size;
 uint64_t memory_descriptor_size;
 uint32_t memory_descriptor_version;
 uint32_t reserved;
} umg_boot_info_t;
#endif
