
#import "SocksoAppDelegate.h"
#import "SocksoView.h"

@implementation SocksoAppDelegate

@synthesize window;
@synthesize view;

- (void) applicationDidFinishLaunching:(UIApplication *)application {
    
    SocksoView *aView = [[SocksoView alloc]
                         initWithNibName:@"SocksoView"
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
