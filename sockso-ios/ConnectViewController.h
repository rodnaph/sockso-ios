
//
//  The initial view that presents the user with the dialog
//  to enter the details of the server to connect to.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "SocksoServer.h"
#import "LoginHandlerDelegate.h"

@interface ConnectViewController : UIViewController <UITextFieldDelegate, LoginHandlerDelegate> {}

@property (nonatomic, retain) IBOutlet UITextField *serverInput;
@property (nonatomic, retain) IBOutlet UIButton *connect;
@property (nonatomic, retain) IBOutlet UIButton *community;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *activity;

@property (nonatomic, retain) NSManagedObjectContext *context;

- (IBAction) connectClicked;
- (void) showHomeView:(SocksoServer *) server;

- (IBAction) communityClicked;
- (void) showCommunityView:(NSMutableArray *) servers;
- (void) showNoCommunityServersFound;

- (void) tryToConnect;
- (void) hasConnectedTo:(SocksoServer *)server;
- (void) showConnectFailed;
- (void) showConnecting;
- (void) setControlsActive:(BOOL) active;

- (void) initServerInput;
- (void) saveServerInput;

@end
