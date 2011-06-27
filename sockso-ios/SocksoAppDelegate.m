
#import "SocksoAppDelegate.h"
#import "ConnectViewController.h"

@implementation SocksoAppDelegate

@synthesize window;
@synthesize navigationController;

- (void) applicationDidFinishLaunching:(UIApplication *)application {

    ConnectViewController *aView = [[ConnectViewController alloc]
                                    initWithNibName:@"ConnectView"
                                    bundle:nil];

    UINavigationController *navController = [[UINavigationController alloc]
                                             initWithRootViewController:aView];
    
    self.navigationController = navController;
    [navController release];
    [aView release];
    
    [self.window addSubview:navigationController.view];
    [self.window makeKeyAndVisible];

}

- (void) dealloc {
    [navigationController release];
    [window release];
    [super dealloc];
}

@end
