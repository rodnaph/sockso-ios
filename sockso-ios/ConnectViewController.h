
#import "LoginHandlerDelegate.h"

@class SocksoServer;

@interface ConnectViewController : UIViewController <UITextFieldDelegate, LoginHandlerDelegate> {
    SocksoServer *currentServer;
}

@property (nonatomic, retain) IBOutlet UITextField *serverInput;
@property (nonatomic, retain) IBOutlet UIButton *connect;
@property (nonatomic, retain) IBOutlet UIButton *community;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *activity, *communityActivity;

@property (nonatomic, retain) NSManagedObjectContext *context;

- (IBAction)connectClicked;
- (IBAction) communityClicked;

- (void)showHomeView:(SocksoServer *) server;
- (void)showCommunityView:(NSMutableArray *) servers;
- (void)showNoCommunityServersFound;

- (IBAction)tryToConnect;
- (void)hasConnectedTo:(SocksoServer *)server;
- (void)showConnectFailed;
- (void)showConnecting;
- (void)setControlsActive:(BOOL) active;

- (void)initServerInput;
- (void)saveServerInput;

@end
