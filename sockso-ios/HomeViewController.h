
#import <UIKit/UIKit.h>
#import "SocksoServer.h"

@interface HomeViewController : UITableViewController  <UISearchDisplayDelegate, UISearchBarDelegate> {
	NSMutableArray *listContent;
    SocksoServer *server;
}

@property (nonatomic, retain) NSMutableArray *listContent;
@property (nonatomic, retain) SocksoServer *server;

+ (HomeViewController *) viewForServer:(SocksoServer *) server;

- (void) showSearchResults:(NSString *) resultData;
- (void) showSearchFailed;
- (NSURL *) getSearchUrl:(NSString *) searchText;
- (void) parseSearchResults:(NSArray *) results;
- (void) performSearch:(NSString *) searchText;

@end
