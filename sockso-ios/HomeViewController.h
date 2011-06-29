
#import <UIKit/UIKit.h>

@interface HomeViewController : UITableViewController  <UISearchDisplayDelegate, UISearchBarDelegate> {
	NSMutableArray *listContent;
    NSDictionary *serverInfo;
}

@property (nonatomic, retain) NSMutableArray *listContent;
@property (nonatomic, retain) NSDictionary *serverInfo;

+ (HomeViewController *) viewForServer:(NSDictionary *) server;

- (void) showSearchResults:(NSString *) resultData;
- (void) showSearchFailed;
- (NSURL *) getSearchUrl:(NSString *) searchText;
- (void) parseSearchResults:(NSArray *) results;
- (void) performSearch:(NSString *) searchText;

@end
