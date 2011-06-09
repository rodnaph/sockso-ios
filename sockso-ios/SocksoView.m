
#import "SocksoView.h"

@implementation SocksoView

@synthesize server;
@synthesize connect;

- (IBAction) connectClicked {
    
    server.text = @"CLICKED!";
    
}

- (void) loadView {
    
    [super loadView];
    
}

@end
