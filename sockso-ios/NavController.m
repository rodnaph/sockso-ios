
#import "NavController.h"
#import "ConnectViewController.h"

@implementation NavController

- (void) viewDidLoad {
    
    ConnectViewController *connectView = [[ConnectViewController alloc]
                                          initWithNibName:@"ConnectView"
                                          bundle:[NSBundle mainBundle]];

    [self pushViewController:connectView animated:TRUE];
    [connectView release];
    
}

@end
