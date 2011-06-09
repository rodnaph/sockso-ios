
#import <UIKit/UIKit.h>
#import "SocksoView.h"

@interface SocksoAppDelegate : NSObject <UIApplicationDelegate> {
    SocksoView *view;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) SocksoView *view;

@end
