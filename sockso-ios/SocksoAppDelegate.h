
#import <UIKit/UIKit.h>
#import "ConnectView.h"

@interface SocksoAppDelegate : NSObject <UIApplicationDelegate> {
    ConnectView *view;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) ConnectView *view;

@end
