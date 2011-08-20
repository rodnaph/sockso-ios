
#import "InfoViewController.h"

@implementation InfoViewController

@synthesize infoLabel=infoLabel_,
            okButton=okButton_,
            message=message_;

#pragma mark -
#pragma mark Init

- (void)dealloc {
    
    [message_ release];
    [infoLabel_ release];
    [okButton_ release];
    
    [super dealloc];
    
}

#pragma mark -
#pragma mark Helpers

+ (InfoViewController *)initWithString:(NSString *)message {
    
    InfoViewController *viewCtrl = [[InfoViewController alloc]
                                    initWithNibName:@"InfoView"
                                    bundle:nil];
    
    viewCtrl.message = message;
    viewCtrl.modalTransitionStyle = UIModalTransitionStylePartialCurl;
    
    return [viewCtrl autorelease];
    
}

#pragma mark -
#pragma mark View

- (void) viewDidLoad {
    
    infoLabel_.text = message_;
    
}

#pragma mark -
#pragma mark Actions

- (IBAction) okClicked {
    
    [self dismissModalViewControllerAnimated:YES];
    
}

@end
