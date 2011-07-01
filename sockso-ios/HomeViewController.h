
#import <UIKit/UIKit.h>
#import "SocksoServer.h"

@interface HomeViewController : UITableViewController  <UISearchDisplayDelegate, UISearchBarDelegate> {
	NSMutableArray *listContent;
}

@property (nonatomic, retain) SocksoServer *server;

+ (HomeViewController *) viewForServer:(SocksoServer *) server;

- (void) showSearchResults:(NSMutableArray *) items;
- (void) showSearchFailed;

- (void) performSearch:(NSString *) query;

@end
