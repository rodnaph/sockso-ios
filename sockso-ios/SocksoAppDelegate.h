
#import <UIKit/UIKit.h>

@interface SocksoAppDelegate : NSObject <UIApplicationDelegate> {
    UINavigationController *navigationController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;

@end
