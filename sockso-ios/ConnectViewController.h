
//
//  The initial view that presents the user with the dialog
//  to enter the details of the server to connect to.
//

#import <UIKit/UIKit.h>
#import "SocksoServer.h"

@interface ConnectViewController : UIViewController <UITextFieldDelegate> {
    UILabel *connectFailed;
    UITextField *serverInput;
    UIButton *connect;
    UIButton *community;
    UIActivityIndicatorView *activity;    
}

@property (nonatomic, retain) IBOutlet UILabel *connectFailed;
@property (nonatomic, retain) IBOutlet UITextField *serverInput;
@property (nonatomic, retain) IBOutlet UIButton *connect;
@property (nonatomic, retain) IBOutlet UIButton *community;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *activity;

- (IBAction) connectClicked;
- (void) showHomeView:(SocksoServer *) server;

- (IBAction) communityClicked;
- (void) showCommunityView:(NSMutableArray *) servers;

- (void) tryToConnect;
- (void) showConnectFailed;
- (void) showConnecting;
- (void) setControlsActive:(BOOL) active;

@end
