
#import "SocksoAppDelegate.h"
#import "ConnectViewController.h"
#import "SocksoModule.h"

@implementation SocksoAppDelegate

@synthesize window, navigationController;

- (void) applicationDidFinishLaunching:(UIApplication *)application {

    SocksoModule *socksoModule = [[[SocksoModule alloc] init] autorelease];
    JSObjectionInjector *injector = [JSObjection createInjector:socksoModule];

    [JSObjection setGlobalInjector:injector];
    
    ConnectViewController *aView = [[injector getObject:[ConnectViewController class]]
                                    initWithNibName:@"ConnectView" bundle:nil];
    
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
