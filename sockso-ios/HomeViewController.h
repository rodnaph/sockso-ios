
#import <UIKit/UIKit.h>

@interface HomeViewController : UITableViewController  <UISearchDisplayDelegate, UISearchBarDelegate> {
	NSMutableArray *listContent;
    NSDictionary *serverInfo;
}

@property (nonatomic, retain) NSMutableArray *listContent;
@property (nonatomic, retain) NSDictionary *serverInfo;

- (void) showSearchResults:(NSString *) resultData;
- (void) showSearchFailed;
- (NSURL *) getSearchUrl:(UISearchBar *) searchBar;
- (void) parseSearchResults:(NSArray *) results;

@end
