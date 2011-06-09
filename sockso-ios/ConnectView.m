
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

- (IBAction) connectClicked {
    
    server.text = @"CLICKED!";
    
}

- (void) drawRect:(CGRect) rect {
    
    
    
}

@end
