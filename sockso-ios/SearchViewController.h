
#import "HomeViewDelegate.h"

@class SocksoServer, HomeViewController;

@interface SearchViewController : UITableViewController  <UISearchDisplayDelegate, UISearchBarDelegate, HomeViewDelegate> {}

@property (nonatomic, retain) SocksoServer *server;
@property (nonatomic, retain) NSArray *listContent;
@property (nonatomic, assign) HomeViewController *homeViewController;

+ (SearchViewController *)viewForServer:(SocksoServer *)server;

@end
