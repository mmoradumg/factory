#ifndef EFI_MIN_H
#define EFI_MIN_H
#include <stdint.h>
#include <stddef.h>
typedef uint64_t U64; typedef uint64_t UINTN; typedef uint64_t EFI_STATUS; typedef void* HANDLE; typedef uint16_t CHAR16;
#define EFIAPI __attribute__((ms_abi))
#define EFI_ERROR(s) ((s)>>63)
#define ERR(n) (0x8000000000000000ULL|(n))
#define EFI_BUFFER_TOO_SMALL ERR(5)
#define EFI_INVALID_PARAMETER ERR(2)
#define EFI_LOAD_ERROR ERR(1)
#define EFI_UNSUPPORTED ERR(3)
#define EFI_OUT_OF_RESOURCES ERR(9)
#define EFI_NOT_FOUND ERR(14)
#define EFI_SUCCESS 0
#define EfiLoaderData 2
#define AllocateAddress 2
#define AllocateAnyPages 0
#define EFI_FILE_MODE_READ 1ULL
#define PixelRedGreenBlueReserved8BitPerColor 0
#define PixelBlueGreenRedReserved8BitPerColor 1
#define PixelBitMask 2
#define PixelBltOnly 3
typedef struct {uint32_t a;uint16_t b,c;uint8_t d[8];} GUID;
typedef struct {U64 signature;uint32_t revision,header_size,crc32,reserved;} TABLE_HDR;
typedef struct BOOT_SERVICES BOOT_SERVICES;
struct BOOT_SERVICES {
 TABLE_HDR hdr;
 void *raise_tpl,*restore_tpl;
 EFI_STATUS(EFIAPI *allocate_pages)(int,int,UINTN,U64*);
 EFI_STATUS(EFIAPI *free_pages)(U64,UINTN);
 EFI_STATUS(EFIAPI *get_memory_map)(UINTN*,void*,UINTN*,UINTN*,uint32_t*);
 EFI_STATUS(EFIAPI *allocate_pool)(int,UINTN,void**);
 EFI_STATUS(EFIAPI *free_pool)(void*);
 void *create_event,*set_timer,*wait_for_event,*signal_event,*close_event,*check_event,*install_protocol_interface,*reinstall_protocol_interface,*uninstall_protocol_interface;
 EFI_STATUS(EFIAPI *handle_protocol)(HANDLE,GUID*,void**);
 void *reserved,*register_protocol_notify,*locate_handle,*locate_device_path,*install_configuration_table;
 void *load_image,*start_image,*exit,*unload_image;
 EFI_STATUS(EFIAPI *exit_boot_services)(HANDLE,UINTN);
 void *get_next_monotonic_count,*stall,*set_watchdog_timer,*connect_controller,*disconnect_controller,*open_protocol,*close_protocol,*open_protocol_information,*protocols_per_handle,*locate_handle_buffer;
 EFI_STATUS(EFIAPI *locate_protocol)(GUID*,void*,void**);
};
typedef struct {TABLE_HDR hdr;CHAR16*firmware_vendor;uint32_t firmware_revision;HANDLE console_in_handle;void*con_in;HANDLE console_out_handle;void*con_out;HANDLE stderr_handle;void*stderr_interface;void*runtime_services;BOOT_SERVICES*boot_services;UINTN number_of_table_entries;void*configuration_table;} SYSTEM_TABLE;
typedef struct {uint32_t version;HANDLE parent_handle;SYSTEM_TABLE*system_table;HANDLE device_handle;void*file_path;void*reserved;uint32_t load_options_size;void*load_options;void*image_base;U64 image_size;int image_code_type,image_data_type;void*unload;} LOADED_IMAGE;
typedef struct FILE_PROTOCOL FILE_PROTOCOL;
struct FILE_PROTOCOL {U64 revision;EFI_STATUS(EFIAPI*open)(FILE_PROTOCOL*,FILE_PROTOCOL**,CHAR16*,U64,U64);EFI_STATUS(EFIAPI*close)(FILE_PROTOCOL*);void*delete_file;EFI_STATUS(EFIAPI*read)(FILE_PROTOCOL*,UINTN*,void*);void*write;EFI_STATUS(EFIAPI*get_position)(FILE_PROTOCOL*,U64*);EFI_STATUS(EFIAPI*set_position)(FILE_PROTOCOL*,U64);EFI_STATUS(EFIAPI*get_info)(FILE_PROTOCOL*,GUID*,UINTN*,void*);};
typedef struct {U64 revision;EFI_STATUS(EFIAPI*open_volume)(void*,FILE_PROTOCOL**);} SIMPLE_FS;
typedef struct {uint32_t version,horizontal_resolution,vertical_resolution,pixel_format;uint32_t pixel_information[4];uint32_t pixels_per_scanline;} GOP_INFO;
typedef struct {uint32_t max_mode,mode;GOP_INFO*info;UINTN size_of_info;U64 framebuffer_base;UINTN framebuffer_size;} GOP_MODE;
typedef struct {void*query_mode,*set_mode,*blt;GOP_MODE*mode;} GOP;
static GUID LOADED_IMAGE_GUID={0x5B1B31A1,0x9562,0x11d2,{0x8e,0x3f,0x00,0xa0,0xc9,0x69,0x72,0x3b}};
static GUID SIMPLE_FS_GUID={0x0964e5b22,0x6459,0x11d2,{0x8e,0x39,0x00,0xa0,0xc9,0x69,0x72,0x3b}};
static GUID GOP_GUID={0x9042a9de,0x23dc,0x4a38,{0x96,0xfb,0x7a,0xde,0xd0,0x80,0x51,0x6a}};
static GUID FILE_INFO_GUID={0x09576e92,0x6d3f,0x11d2,{0x8e,0x39,0x00,0xa0,0xc9,0x69,0x72,0x3b}};
#endif
