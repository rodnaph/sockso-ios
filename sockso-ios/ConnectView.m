
#import "ConnectView.h"

@implementation ConnectView

@synthesize server;
@synthesize connect;

- (BOOL) textFieldShouldReturn:(UITextField *)textField {
    
    [server resignFirstResponder];
    
    return YES;
    
}

- (IBAction) connectClicked {
}

- (void) dealloc {
    [server release];
    [connect release];
    [super dealloc];
}

@end
