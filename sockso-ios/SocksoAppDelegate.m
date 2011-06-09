
#import "SocksoAppDelegate.h"
#import "ConnectView.h"

@implementation SocksoAppDelegate

@synthesize window;
@synthesize view;

- (void) applicationDidFinishLaunching:(UIApplication *)application {
    
    ConnectView *aView = [[ConnectView alloc]
                          initWithNibName:@"ConnectView"
                          bundle:[NSBundle mainBundle]];
    
    self.view = aView;
    [aView release];
    
    [self.window addSubview:self.view.view];
    [self.window makeKeyAndVisible];
        
}

- (void) dealloc {
    [window release];
    [super dealloc];
}

@end
