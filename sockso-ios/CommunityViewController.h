
#import "LoginHandlerDelegate.h"

@class SocksoServer;

@interface CommunityViewController : UITableViewController <UITableViewDelegate, LoginHandlerDelegate> {
    SocksoServer *currentServer;
}

@property (nonatomic, retain) NSArray *servers;

@end
