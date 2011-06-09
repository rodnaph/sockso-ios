
#import "ConnectView.h"

@implementation ConnectView

@synthesize server;
@synthesize connect;
@synthesize background;

- (id) init {
    
    UIImage *aImage = [UIImage imageNamed:@"background.gif"];
        
    self.background = aImage;
    [aImage release];
    
    return self;
    
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField {
    
    [server resignFirstResponder];
    
    return YES;
    
}

- (IBAction) connectClicked {
}

- (void) dealloc {
    [server release];
    [connect release];
    [background release];
    [super dealloc];
}

@end
