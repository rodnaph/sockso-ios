
//
//  The initial view that presents the user with the dialog
//  to enter the details of the server to connect to.
//

#import <UIKit/UIKit.h>

@interface ConnectView : UIViewController <UITextFieldDelegate> {
    UITextField *server;
    UIButton *connect;
}

@property (nonatomic, retain) IBOutlet UITextField *server;
@property (nonatomic, retain) IBOutlet UIButton *connect;

- (IBAction) connectClicked; 

@end
