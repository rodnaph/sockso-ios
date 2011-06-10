
#import <UIKit/UIKit.h>
#import "ConnectViewController.h"

@interface SocksoAppDelegate : NSObject <UIApplicationDelegate> {
    ConnectViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) ConnectViewController *viewController;

@end
