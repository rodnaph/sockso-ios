
//
//  The initial view that presents the user with the dialog
//  to enter the details of the server to connect to.
//

#import <UIKit/UIKit.h>
#import "JSON.h"
#import "SocksoServer.h"

@interface ConnectViewController : UIViewController <UITextFieldDelegate> {
    
    UILabel *connectFailed;
    UITextField *serverInput;
    UIButton *connect;
    UIButton *community;
    UIActivityIndicatorView *activity;
    
    NSMutableData *responseData;
    
    @private SBJsonParser *parser;
    
}

@property (nonatomic, retain) IBOutlet UILabel *connectFailed;
@property (nonatomic, retain) IBOutlet UITextField *serverInput;
@property (nonatomic, retain) IBOutlet UIButton *connect;
@property (nonatomic, retain) IBOutlet UIButton *community;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *activity;

- (IBAction) connectClicked;
- (IBAction) communityClicked;

- (void) showHomeView:(SocksoServer *) server;
- (void) tryToConnect;
- (void) showConnectFailed;

- (void) showConnecting;
- (void) setControlsActive:(BOOL) active;

- (void) fetchCommunityList;
- (void) showCommunityPage:(NSArray *) servers;
- (NSArray *) getCommunityServers:(NSString *) serverJson;

@end
