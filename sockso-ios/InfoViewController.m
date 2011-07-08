
#import "InfoViewController.h"

@implementation InfoViewController

@synthesize infoLabel, okButton, message;

+ (InfoViewController *) initWithString:(NSString *)message {
    
    InfoViewController *viewCtrl = [[InfoViewController alloc]
                                    initWithNibName:@"InfoView"
                                    bundle:nil];
    
    viewCtrl.message = message;
    viewCtrl.modalTransitionStyle = UIModalTransitionStylePartialCurl;
    
    return [viewCtrl autorelease];
    
}

- (void) viewDidLoad {
    
    infoLabel.text = message;
    
}

//
// ok clicked, dispose of the dialog
//

- (IBAction) okClicked {
    
    [self dismissModalViewControllerAnimated:YES];
    
}

- (void) dealloc {
    
    [message release];
    [infoLabel release];
    [okButton release];
    
    [super dealloc];
    
}

@end
