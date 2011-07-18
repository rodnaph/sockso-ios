
#import <UIKit/UIKit.h>
#import "SocksoServer.h"
#import "ImageLoader.h"
#import "ImageLoaderDelegate.h"
#import "HomeViewDelegate.h"
#import "HomeViewController.h"

@interface SearchViewController : UITableViewController  <UISearchDisplayDelegate, UISearchBarDelegate, ImageLoaderDelegate, HomeViewDelegate> {
    NSMutableDictionary *images;
}

@property (nonatomic, retain) SocksoServer *server;
@property (nonatomic, retain) NSMutableArray *listContent;
@property (nonatomic, retain) HomeViewController *homeViewController;

+ (SearchViewController *) viewForServer:(SocksoServer *)server;

- (void) showSearchResults:(NSMutableArray *)items;
- (void) showSearchFailed;

- (void) performSearch:(NSString *)query;

- (void) setArtworkOnCell:(UITableViewCell *)cell forMusicItem:(MusicItem *)item atIndex:(NSIndexPath *)indexPath;

@end
