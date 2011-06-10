
#import "ConnectViewController.h"

@implementation ConnectViewController

@synthesize server;
@synthesize connect;
@synthesize community;

- (BOOL) textFieldShouldReturn:(UITextField *)textField {
    
    [server resignFirstResponder];
    
    return YES;
    
}

- (IBAction) communityClicked {
    
    server.text = @"Community!";
    
}

- (IBAction) connectClicked {
    
    server.text = @"Connext!";
    
}

- (void) dealloc {
    [server release];
    [connect release];
    [super dealloc];
}

@end
