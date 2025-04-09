#import "hook/fishhook.h"
#import "hook/hook.h"
#import "il2cpp/il2cpp.h"
#import "RealOffset/RealOffset.h"
#import "Obf.h"
#import <UIKit/UIKit.h>

float cameraHeight = 1.0f;
float minCam = 1.0f;
float maxCam = 5.0f;

@interface SliderManager : NSObject
+ (SliderManager *)sharedInstance;
- (void)setupGestureRecognizer;
- (void)handleTapGesture:(UITapGestureRecognizer *)gesture;
- (void)showCameraHeightAlert;
@end

@implementation SliderManager

+ (SliderManager *)sharedInstance {
    static SliderManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (void)setupGestureRecognizer {
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    tapGesture.numberOfTapsRequired = 3;
    tapGesture.numberOfTouchesRequired = 2;
    
    UIWindow *mainWindow = [UIApplication sharedApplication].keyWindow;
    [mainWindow addGestureRecognizer:tapGesture];
}

- (void)handleTapGesture:(UITapGestureRecognizer *)gesture {
    if (gesture.state == UIGestureRecognizerStateEnded) {
        [self showCameraHeightAlert];
    }
}

- (void)showCameraHeightAlert {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"PPCam" 
                                                                             message:@"Điều chỉnh cam" 
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"Đóng" 
                                                        style:UIAlertActionStyleCancel 
                                                      handler:nil]];
    // Create custom view for slider
    UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 260, 70)];
    
    // Create and configure slider
    UISlider *slider = [[UISlider alloc] initWithFrame:CGRectMake(10, 10, 240, 30)];
    slider.minimumValue = minCam;
    slider.maximumValue = maxCam;
    slider.value = cameraHeight;
    
    // Add value change handler for the slider
    [slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    // Create and configure value label
    UILabel *valueLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 40, 240, 20)];
    valueLabel.textAlignment = NSTextAlignmentCenter;
    valueLabel.text = [NSString stringWithFormat:@"%.1f", cameraHeight];
    valueLabel.tag = 1000; // Tag for later reference
    
    // Add subviews
    [containerView addSubview:slider];
    [containerView addSubview:valueLabel];
    
    // Set custom view to alert controller
    alertController.view.clipsToBounds = YES;
    
    // This is the key part - adding a clear view of right size before the content view
    UIViewController *contentVC = [[UIViewController alloc] init];
    contentVC.view = containerView;
    
    // Increase the height of alert controller
    [alertController setValue:contentVC forKey:@"contentViewController"];
    
    // Present the alert
    UIWindow *mainWindow = [UIApplication sharedApplication].keyWindow;
    UIViewController *rootViewController = mainWindow.rootViewController;
    [rootViewController presentViewController:alertController animated:YES completion:nil];
}

- (void)sliderValueChanged:(UISlider *)slider {
    cameraHeight = slider.value;
    
    // Update the value label when slider moves
    UIView *containerView = slider.superview;
    UILabel *valueLabel = [containerView viewWithTag:1000];
    if (valueLabel) {
        valueLabel.text = [NSString stringWithFormat:@"%.1f", cameraHeight];
    }
}

@end

float FLOAT1(void * _this){
    return cameraHeight;
}

void (*_OnCameraHeightChanged)(void *instance);
void OnCameraHeightChanged(void *instance)
{
    _OnCameraHeightChanged(instance);
}

void (*_CameraSystem_Update)(void *instance);
void CameraSystem_Update(void *instance)
{
    if (instance != NULL)
    {
        OnCameraHeightChanged(instance);
    }
    _CameraSystem_Update(instance);
}

bool damage(){
    Il2CppAttach();
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        PPIL2CppImpl("Project_d.dll", "", "CameraSystem", (void *)OnCameraHeightChanged, (void *)&_OnCameraHeightChanged, "OnCameraHeightChanged", 0);
        PPIL2CppImpl("Project_d.dll", "", "CameraSystem", (void *)CameraSystem_Update, (void *)&_CameraSystem_Update, "Update", 0);
        [[SliderManager sharedInstance] setupGestureRecognizer];
    });
    return hook(
        (void *[]) {
            (void *)getRealOffsetUnity(ENCRYPTOFFSET("0x655ED78")),
            // RVA: 0x655ED78 Offset: 0x655ED78 VA: 0x655ED78
            // private float GetCameraHeightRateValue(int type) { }
            //AOV VIETNAM VERSION - kgvn -> Rep
        },
        (void *[]) {
            (void *)FLOAT1,
        },
    1);
}

__attribute__((constructor))
static void initialize() {
    damage();
}