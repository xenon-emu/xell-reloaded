#ifndef CONFIG_H
#define	CONFIG_H

#define ELF_MAXSIZE (32*1024*1024)

/**
*	Configuration
**/
//#define DEFAULT_THEME
//#define SWIZZY_THEME
//#define XTUDO_THEME
#define VALI_THEME
#define NO_PRINT_CONFIG
#define NO_NETWORKING
//#define NO_DVD
#ifndef NO_NETWORKING
#define NO_DHCP
#endif

/* Filesystem drivers */

#define FS_ISO9660
#define FS_FAT
//#define FS_EXT2FS
//#define FS_XTAF
//#define FS_NTFS

void mount_all_devices();

int findDevices();

#endif	/* CONFIG_H */

