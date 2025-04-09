#include <mach/mach.h>
#include <mach-o/dyld.h>
#include <CoreFoundation/CoreFoundation.h>
#include <string>

struct MemoryFileInfo {
    uint32_t index;
    const struct mach_header *header;
    const char *name;
    long long address;
};

bool getType(unsigned int data);
MemoryFileInfo getBaseInfo();
MemoryFileInfo getMemoryFileInfo(const std::string& fileName);
uintptr_t getAbsoluteAddress(const char *fileName, uintptr_t address);
uint64_t getRealOffsetUnity(uint64_t offset);
uint64_t getRealOffsetAnogs(uint64_t offset);