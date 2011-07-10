
#import <UIKit/UIKit.h>
#import "SocksoServer.h"
#import "LoginHandlerDelegate.h"

@interface LoginViewController : UIViewController {}

@property (nonatomic, retain) IBOutlet UITextField *nameInput, *passwordInput;
@property (nonatomic, retain) IBOutlet UIButton *loginButton, *cancelButton;

@property (nonatomic, retain) SocksoServer *server;
@property (nonatomic, assign) id <LoginHandlerDelegate> *delegate;

+ (LoginViewController *) initWithServer:(SocksoServer *)server;

- (IBAction) loginClicked;
- (IBAction) cancelClicked;

- (void) loginSuccess;
- (void) loginFailure;

@end
