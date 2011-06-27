
#import "SocksoAppDelegate.h"
#import "ConnectViewController.h"

@implementation SocksoAppDelegate

@synthesize window;
@synthesize navigationController;

- (void) applicationDidFinishLaunching:(UIApplication *)application {

    navigationController = [[NavController alloc] init];
    
    [self.window addSubview:[navigationController view]];
    [self.window makeKeyAndVisible];

}

- (void) dealloc {
    [navigationController release];
    [window release];
    [super dealloc];
}

@end
