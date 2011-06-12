
//
//  The initial view that presents the user with the dialog
//  to enter the details of the server to connect to.
//

#import <UIKit/UIKit.h>
#import "JSON.h"

@interface ConnectViewController : UIViewController <UITextFieldDelegate> {
    UITextField *server;
    UIButton *connect;
    UIButton *community;
    NSMutableData *responseData;
    @private SBJsonParser *parser;
}

@property (nonatomic, retain) IBOutlet UITextField *server;
@property (nonatomic, retain) IBOutlet UIButton *connect;
@property (nonatomic, retain) IBOutlet UIButton *community;

- (IBAction) connectClicked;
- (IBAction) communityClicked;

@end
