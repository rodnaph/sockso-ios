
#import <UIKit/UIKit.h>
#import "SocksoServer.h"

@interface ArtistsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    NSArray *artists;
}

@property (nonatomic, retain) SocksoServer *server;
@property (nonatomic, retain) IBOutlet UITableView *artistsTable;

+ (ArtistsViewController *) viewForServer:(SocksoServer *)server;

- (void) loadArtists;

@end
