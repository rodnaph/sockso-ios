
#import "SocksoAppDelegate.h"
#import "ConnectViewController.h"
#import "SocksoModule.h"

@interface SocksoAppDelegate (Private)

- (void)initInjection;
- (void)initInterface;

@end

@implementation SocksoAppDelegate

@synthesize window, navigationController;

- (void) applicationDidFinishLaunching:(UIApplication *)application {

    [self initInjection];
    [self initInterface];
    
}

- (void)initInjection {
    
    SocksoModule *socksoModule = [[[SocksoModule alloc] init] autorelease];
    JSObjectionInjector *injector = [JSObjection createInjector:socksoModule];

    [JSObjection setGlobalInjector:injector];
    
    [socksoModule release];
    
}

- (void)initInterface {
    
    JSObjectionInjector *injector = [JSObjection globalInjector];
    ConnectViewController *controller = [[injector getObject:[ConnectViewController class]]
                                         initWithNibName:@"ConnectView" bundle:nil];
    
    UINavigationController *navController = [[UINavigationController alloc]
                                             initWithRootViewController:controller];
    
    self.navigationController = navController;
    [navController release];
    [controller release];
    
    [self.window addSubview:navigationController.view];
    [self.window makeKeyAndVisible];

}

- (void) dealloc {
    
    [navigationController release];
    [window release];
    
    [super dealloc];
    
}

@end
