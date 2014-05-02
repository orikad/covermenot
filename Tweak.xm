#import <SpringBoard/SpringBoard.h>

#define UIStatusBarStyleRed (6)

@interface UIStatusBarServer : NSObject
+ (void)removeStyleOverrides:(int)arg1;
+ (void)addStyleOverrides:(int)arg1;
@end

static BOOL didTriggerStatusBarStyle = NO;

static void showDoubleStatusBar(void)
{
    if (didTriggerStatusBarStyle == NO) {
        [UIStatusBarServer addStyleOverrides:UIStatusBarStyleRed];
        didTriggerStatusBarStyle = YES;
    }
}

static void removeDoubleStatusBar(void)
{
    if (didTriggerStatusBarStyle) {
        [UIStatusBarServer removeStyleOverrides:UIStatusBarStyleRed];
        didTriggerStatusBarStyle = NO;
    }
}

%group BannerControllerHooks
%hook BannerControllerClass

- (void)_tearDownView
{
    removeDoubleStatusBar();
    %orig();
}

- (void)animationDidStop:(id)animation finished:(BOOL)finished
{
    %orig();
    if (finished && [self isShowingBanner]) {
        showDoubleStatusBar();
    }
}

%end
%end

%hook SBBulletinWindowController
- (void)removeWindowClient:(id)client
{
    removeDoubleStatusBar();
    %orig();
}
%end


%ctor
{
    Class bannerControllerClassToHook = (objc_getClass("SBBannerController")) ? : (objc_getClass("SBBulletinBannerController"));
    %init(BannerControllerHooks, BannerControllerClass = bannerControllerClassToHook);
    %init;
}

