#pragma once

#include <string>
#include <map>
#include <cstdint>

#ifdef __OBJC__
@class NSString;
#else
typedef struct NSString NSString;
#endif

void writeLog(const std::string &message);
void Il2CppAttach();

class MemoryInfo {
public:
    uint32_t index;
    const struct mach_header *header;
    const char *name;
    intptr_t address;
};

struct MethodInfo1 {
    void* methodPointer;
    void* virtualMethodPointer;
    void* invoker_method;
    const char* name;
};

MemoryInfo getBaseAddress(const std::string &fileName);
void *Il2CppGetImageByName(const char *image);
void *Il2CppGetClassType(const char *image, const char *namespaze, const char *clazz);
bool PPIL2CppImpl(const char *image, const char *namespaze, const char *clazz, void* hook, void* orig, const char *name, int cnttt);

namespace IL2CPP {
    extern const void *(*il2cpp_assembly_get_image)(const void *assembly);
    extern void *(*il2cpp_domain_get)();
    extern void **(*il2cpp_domain_get_assemblies)(const void *domain, size_t *size);
    extern const char *(*il2cpp_image_get_name)(void *image);
    extern void *(*il2cpp_class_from_name)(const void *image, const char *namespaze, const char *name);
    extern void *(*il2cpp_class_get_field_from_name)(void *klass, const char *name);
    extern void *(*il2cpp_class_get_method_from_name)(void *klass, const char *name, int argsCount);
    extern size_t (*il2cpp_field_get_offset)(void *field);
    extern void (*il2cpp_field_static_get_value)(void *field, void *value);
    extern void (*il2cpp_field_static_set_value)(void *field, void *value);
    extern void *(*il2cpp_string_new)(const char *str);
    extern void *(*il2cpp_string_new_utf16)(const wchar_t *str, int32_t length);
    extern uint16_t *(*il2cpp_string_chars)(void *str);
}

class Il2CppString {
private:
    void *str;

public:
    Il2CppString(const char *utf8Str);
    Il2CppString(const wchar_t *utf16Str, int32_t length);
    Il2CppString(NSString *nsString);
    ~Il2CppString();
    uint16_t *getChars();
    std::string toUtf8String();
    std::wstring toUtf16String();
    void *getInternalString();
};

class Il2CppField {
private:
    void *image;
    void *klass;
    void *field;

public:
    Il2CppField(const char *assemblyName);
    Il2CppField &getClass(const char *namespaze, const char *className);
    Il2CppField &getField(const char *fieldName);
    size_t getOffset() const;
    
    template <typename T>
    T getValue() {
        T value;
        IL2CPP::il2cpp_field_static_get_value(field, &value);
        return value;
    }
    
    template <typename T>
    void setValue(T value) {
        IL2CPP::il2cpp_field_static_set_value(field, &value);
    }
    
    template <typename T>
    void showValue(const char *fieldName) {
        T value = getValue<T>();
        writeLog(std::string(fieldName) + " Value = " + std::to_string(value));
    }
};

class Il2CppMethod {
private:
    void *image;
    void *klass;
    void *method;

public:
    Il2CppMethod(const char *assemblyName);
    Il2CppMethod &getClass(const char *namespaze, const char *className);
    uint64_t getMethod(const char *methodName, int argsCount);
    
    template <typename Ret, typename... Args>
    Ret invoke(Args... args) {
        using MethodType = Ret (*)(Args...);
        MethodType methodFunc = reinterpret_cast<MethodType>(method);
        return methodFunc(args...);
    }
};

uint64_t PPGetMethodOld(const char *dllfilenamec, const char *namespazec, const char *classNamec, const char *methodNamec, int argsCount);
uint64_t PPGetFieldOld(const char *dllFilenamec, const char *namespaceNamec, const char *classNamec, const char *fieldNamec);