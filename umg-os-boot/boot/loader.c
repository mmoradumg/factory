#include "efi_min.h"
#include "bootinfo.h"
#define PAGE 4096ULL
#define BASE 0x200000ULL
#define MAX_IMAGE (128ULL*1024*1024)
typedef struct {uint8_t ident[16];uint16_t type,machine;uint32_t version;U64 entry,phoff,shoff;uint32_t flags;uint16_t ehsize,phentsize,phnum,shentsize,shnum,shstrndx;} EH;
typedef struct {uint32_t type,flags;U64 offset,vaddr,paddr,filesz,memsz,align;} PH;
_Static_assert(sizeof(EH)==64,"ELF header");_Static_assert(sizeof(PH)==56,"ELF program header");
static void zero(void*p,U64 n){volatile uint8_t*q=p;while(n--)*q++=0;}
static EFI_STATUS read_at(FILE_PROTOCOL*f,U64 off,void*buf,U64 n){EFI_STATUS s=f->set_position(f,off);if(EFI_ERROR(s))return s;uint8_t*p=buf;while(n){UINTN z=n>1048576?1048576:(UINTN)n;s=f->read(f,&z,p);if(EFI_ERROR(s))return s;if(!z)return EFI_LOAD_ERROR;p+=z;n-=z;}return 0;}
static int add(U64 a,U64 b,U64*out){*out=a+b;return *out<a;}
static int pow2(U64 a){return a&&!(a&(a-1));}
static __attribute__((noreturn)) void stop(void){for(;;)__asm__ volatile("cli; hlt");}
static EFI_STATUS exit_bs(BOOT_SERVICES*b,HANDLE image,umg_boot_info_t*bi){void*map=0;UINTN cap=0;for(int tries=0;tries<20;tries++){UINTN n=cap,key=0,ds=0;uint32_t ver=0;EFI_STATUS s=b->get_memory_map(&n,map,&key,&ds,&ver);if(s==EFI_BUFFER_TOO_SMALL){UINTN extra=(ds?ds:64)*16;if(n>UINT64_MAX-extra)return EFI_OUT_OF_RESOURCES;void*next=0;s=b->allocate_pool(EfiLoaderData,n+extra,&next);if(EFI_ERROR(s))return s;map=next;cap=n+extra;continue;}if(EFI_ERROR(s))return s;if(!ds||n%ds)return EFI_LOAD_ERROR;bi->memory_map=(U64)(uintptr_t)map;bi->memory_map_size=n;bi->memory_descriptor_size=ds;bi->memory_descriptor_version=ver;s=b->exit_boot_services(image,key);if(!s)return 0;if(s!=EFI_INVALID_PARAMETER)return s;}return EFI_LOAD_ERROR;}
EFI_STATUS EFIAPI efi_main(HANDLE image,SYSTEM_TABLE*st){if(!st||!st->boot_services)return EFI_INVALID_PARAMETER;BOOT_SERVICES*b=st->boot_services;EFI_STATUS s;LOADED_IMAGE*li=0;SIMPLE_FS*fs=0;FILE_PROTOCOL*root=0,*f=0;GOP*g=0;EH h;PH ph[128];U64 low=UINT64_MAX,high=0;int found=0,exec=0;
 s=b->handle_protocol(image,&LOADED_IMAGE_GUID,(void**)&li);if(EFI_ERROR(s)||!li)return EFI_LOAD_ERROR;
 s=b->handle_protocol(li->device_handle,&SIMPLE_FS_GUID,(void**)&fs);if(EFI_ERROR(s)||!fs)return EFI_LOAD_ERROR;
 s=fs->open_volume(fs,&root);if(EFI_ERROR(s)||!root)return EFI_LOAD_ERROR;
 static CHAR16 path[]={ '\\','k','e','r','n','e','l','\\','K','E','R','N','E','L','.','E','L','F',0};
 s=root->open(root,&f,path,EFI_FILE_MODE_READ,0);if(EFI_ERROR(s)||!f)return EFI_NOT_FOUND;
 s=read_at(f,0,&h,sizeof h);if(EFI_ERROR(s))return s;
 if(h.ident[0]!=127||h.ident[1]!='E'||h.ident[2]!='L'||h.ident[3]!='F'||h.ident[4]!=2||h.ident[5]!=1||h.ident[6]!=1||h.type!=2||h.machine!=62||h.version!=1||h.ehsize!=64||h.phentsize!=56||!h.phnum||h.phnum>128)return EFI_LOAD_ERROR;
 U64 phbytes=(U64)h.phnum*sizeof(PH),phend;if(add(h.phoff,phbytes,&phend)||phend>64*1024*1024)return EFI_LOAD_ERROR;
 s=read_at(f,h.phoff,ph,phbytes);if(EFI_ERROR(s))return s;
 for(unsigned i=0;i<h.phnum;i++){PH*p=&ph[i];if(p->type==2||p->type==3)return EFI_UNSUPPORTED;if(p->type!=1)continue;if(p->filesz>p->memsz||p->paddr!=p->vaddr||p->paddr<BASE)return EFI_LOAD_ERROR;if(p->align>1&&(!pow2(p->align)||((p->vaddr-p->offset)&(p->align-1))))return EFI_LOAD_ERROR;U64 end,fe;if(add(p->paddr,p->memsz,&end)||add(p->offset,p->filesz,&fe)||fe>64*1024*1024)return EFI_LOAD_ERROR;if(!p->memsz)continue;found=1;if(p->paddr<low)low=p->paddr;if(end>high)high=end;if((p->flags&1)&&h.entry>=p->paddr&&h.entry<end)exec=1;for(unsigned j=0;j<i;j++){PH*q=&ph[j];if(q->type==1&&q->memsz){U64 qe;if(add(q->paddr,q->memsz,&qe))return EFI_LOAD_ERROR;if(p->paddr<qe&&q->paddr<end)return EFI_LOAD_ERROR;}}}
 if(!found||!exec)return EFI_LOAD_ERROR;low&=~4095ULL;if(low!=BASE||high>UINT64_MAX-4095)return EFI_LOAD_ERROR;high=(high+4095)&~4095ULL;if(high<=low||high-low>MAX_IMAGE)return EFI_LOAD_ERROR;
 U64 address=low;s=b->allocate_pages(AllocateAddress,EfiLoaderData,(high-low)/PAGE,&address);if(EFI_ERROR(s)||address!=low)return EFI_OUT_OF_RESOURCES;
 zero((void*)(uintptr_t)low,high-low);for(unsigned i=0;i<h.phnum;i++){PH*p=&ph[i];if(p->type==1&&p->filesz){s=read_at(f,p->offset,(void*)(uintptr_t)p->paddr,p->filesz);if(EFI_ERROR(s))return s;}}
 s=f->close(f);if(EFI_ERROR(s))return s;s=root->close(root);if(EFI_ERROR(s))return s;
 s=b->locate_protocol(&GOP_GUID,0,(void**)&g);if(EFI_ERROR(s)||!g||!g->mode||!g->mode->info)return EFI_UNSUPPORTED;GOP_INFO*gi=g->mode->info;if(gi->pixel_format>1||!gi->horizontal_resolution||!gi->vertical_resolution||gi->pixels_per_scanline<gi->horizontal_resolution||gi->pixels_per_scanline>UINT32_MAX/4)return EFI_UNSUPPORTED;
 U64 required=(U64)gi->pixels_per_scanline*4*gi->vertical_resolution;if(required>g->mode->framebuffer_size||!g->mode->framebuffer_base)return EFI_UNSUPPORTED;
 U64 bp=0;s=b->allocate_pages(AllocateAnyPages,EfiLoaderData,1,&bp);if(EFI_ERROR(s))return s;zero((void*)(uintptr_t)bp,PAGE);umg_boot_info_t*bi=(void*)(uintptr_t)bp;bi->magic=UMG_BOOT_MAGIC;bi->framebuffer_base=g->mode->framebuffer_base;bi->framebuffer_size=g->mode->framebuffer_size;bi->width=gi->horizontal_resolution;bi->height=gi->vertical_resolution;bi->pixels_per_scanline=gi->pixels_per_scanline;bi->pixel_format=gi->pixel_format;
 s=exit_bs(b,image,bi);if(EFI_ERROR(s))stop();typedef void(__attribute__((sysv_abi))*entry_fn)(umg_boot_info_t*);((entry_fn)(uintptr_t)h.entry)(bi);stop();}
