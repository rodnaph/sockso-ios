
#import "SocksoAppDelegate.h"
#import "ConnectViewController.h"

@implementation SocksoAppDelegate

@synthesize window;
@synthesize viewController;

- (void) applicationDidFinishLaunching:(UIApplication *)application {
    
    ConnectViewController *aViewController = [[ConnectViewController alloc]
                                              initWithNibName:@"ConnectView"
                                              bundle:[NSBundle mainBundle]];
    
    self.viewController = aViewController;
    [aViewController release];
    
    [self.window addSubview:self.viewController.view];
    [self.window makeKeyAndVisible];

}

- (void) dealloc {
    [window release];
    [super dealloc];
}

@end
