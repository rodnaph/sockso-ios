
#import <UIKit/UIKit.h>
#import "SocksoServer.h"
#import "ImageLoader.h"
#import "ImageLoaderDelegate.h"

@interface HomeViewController : UITableViewController  <UISearchDisplayDelegate, UISearchBarDelegate, ImageLoaderDelegate> {
    NSMutableDictionary *images;
}

@property (nonatomic, retain) SocksoServer *server;
@property (nonatomic, retain) NSMutableArray *listContent;

+ (HomeViewController *) viewForServer:(SocksoServer *)server;

- (void) showSearchResults:(NSMutableArray *)items;
- (void) showSearchFailed;

- (void) performSearch:(NSString *)query;

@end
