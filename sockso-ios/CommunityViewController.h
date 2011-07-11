
#import <UIKit/UIKit.h>
#import "SocksoServer.h"
#import "LoginHandlerDelegate.h"

@interface CommunityViewController : UITableViewController <UITableViewDelegate, LoginHandlerDelegate> {}

@property (nonatomic, retain) NSArray *servers;

- (void) connectTo:(SocksoServer *)server;

- (void) showHomeView:(SocksoServer *)server;
- (void) showLoginView:(SocksoServer *)server;

@end
