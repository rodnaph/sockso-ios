
#import <UIKit/UIKit.h>
#import "SocksoServer.h"
#import "HomeViewDelegate.h"
#import "HomeViewController.h"

@interface ArtistsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, HomeViewDelegate> {
    NSArray *artists;
}

@property (nonatomic, retain) SocksoServer *server;
@property (nonatomic, retain) IBOutlet UITableView *artistsTable;
@property (nonatomic, retain) HomeViewController *homeViewController;

+ (ArtistsViewController *) viewForServer:(SocksoServer *)server;

- (void) loadArtists;

@end
