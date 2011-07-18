
#import <UIKit/UIKit.h>
#import "SocksoServer.h"
#import "ImageLoader.h"
#import "ImageLoaderDelegate.h"

@interface SearchViewController : UITableViewController  <UISearchDisplayDelegate, UISearchBarDelegate, ImageLoaderDelegate> {
    NSMutableDictionary *images;
}

@property (nonatomic, retain) SocksoServer *server;
@property (nonatomic, retain) NSMutableArray *listContent;

+ (SearchViewController *) viewForServer:(SocksoServer *)server;

- (void) showSearchResults:(NSMutableArray *)items;
- (void) showSearchFailed;

- (void) performSearch:(NSString *)query;

- (void) setArtworkOnCell:(UITableViewCell *)cell forMusicItem:(MusicItem *)item atIndex:(NSIndexPath *)indexPath;

@end
