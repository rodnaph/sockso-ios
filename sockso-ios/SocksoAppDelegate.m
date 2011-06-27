
#import "SocksoAppDelegate.h"
#import "ConnectViewController.h"

@implementation SocksoAppDelegate

@synthesize window, navigationController;

- (void) applicationDidFinishLaunching:(UIApplication *)application {

    ConnectViewController *aView = [[ConnectViewController alloc]
                                    initWithNibName:@"ConnectView"
                                    bundle:nil];

    UINavigationController *navController = [[UINavigationController alloc]
                                             initWithRootViewController:aView];
    
    NSLog( @"Create navigation controller" );
    
    self.navigationController = navController;
    [navController release];
    [aView release];
    
    NSLog( @"Make window visible" );
    
    [self.window addSubview:navigationController.view];
    [self.window makeKeyAndVisible];

}

- (void) dealloc {
    [navigationController release];
    [window release];
    [super dealloc];
}

@end
