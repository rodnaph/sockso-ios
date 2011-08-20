
#import "LoginHandlerDelegate.h"

@class SocksoServer;

@interface CommunityViewController : UITableViewController <UITableViewDelegate, LoginHandlerDelegate> {}

@property (nonatomic, retain) NSArray *servers;

@end
