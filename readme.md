# PP_Hook_Cam

## Giới thiệu | Introduction

**Tiếng Việt**

Một Dự án Theos Obj-C cho phép tuỳ chỉnh tầm nhìn xa gần AOV mà không cần phải vá UnityFramework.

**English**

A Theos Obj-C project that allows customizing AOV view distance without patching UnityFramework.

## Hướng Dẫn | Instructions

**Tiếng Việt**

Tại Hook_Cam_No_Va.mm, điều chỉnh Offset phiên bản của bạn tại:

```objectivec
(void *[]) {
    (void *)getRealOffsetUnity(ENCRYPTOFFSET("0x655ED78")),
    // RVA: 0x655ED78 Offset: 0x655ED78 VA: 0x655ED78
    // private float GetCameraHeightRateValue(int type) { }
    //AOV VIETNAM VERSION - kgvn -> Rep
},
```

Đồng thời điều chỉnh các thông số sau theo ý muốn:

```objectivec
float cameraHeight = 1.0f;
float minCam = 1.0f;
float maxCam = 5.0f;
```

**English**

In Hook_Cam_No_Va.mm, adjust the offset for your version at:

```objectivec
(void *[]) {
    (void *)getRealOffsetUnity(ENCRYPTOFFSET("0x655ED78")),
    // RVA: 0x655ED78 Offset: 0x655ED78 VA: 0x655ED78
    // private float GetCameraHeightRateValue(int type) { }
    //AOV VIETNAM VERSION - kgvn -> Rep
},
```

Also adjust the following parameters as desired:

```objectivec
float cameraHeight = 1.0f;
float minCam = 1.0f;
float maxCam = 5.0f;
```

## Cài đặt | Installation

**Tiếng Việt**

Cài đặt qua Theos:

1. Gõ lệnh `make`
2. Sau đó lấy file `PCamNoVa.dylib` ở thư mục `.theos/obj`

**English**

Installation via Theos:

1. Run the `make` command
2. Then get the `PCamNoVa.dylib` file from the `.theos/obj` directory

## Tác giả | Author

**Tiếng Việt**

Tác giả: Phát Phạm  
Telegram: [PhatPham](https://t.me/pdp7803)  
Facebook: [PhatPham](https://fb.com/ppnohope)

**English**

Author: Phát Phạm  
Telegram: [PhatPham](https://t.me/pdp7803)  
Facebook: [PhatPham](https://fb.com/ppnohope)
