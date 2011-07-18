
#import "HomeViewController.h"

@implementation HomeViewController

@synthesize server;

+ (HomeViewController *)initWithServer:(SocksoServer *)server {
    
    HomeViewController *homeView = [[HomeViewController alloc]
                                    initWithNibName:@"HomeView"
                                    bundle:nil];
    
    homeView.server = server;
    
    return [homeView autorelease];

}

- (void)dealloc {
    
    [server release];
    
    [super dealloc];
    
}

@end
