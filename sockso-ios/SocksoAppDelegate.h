
#import <UIKit/UIKit.h>
#import "NavController.h"

@interface SocksoAppDelegate : NSObject <UIApplicationDelegate> {
    NavController *navigationController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) NavController *navigationController;

@end
