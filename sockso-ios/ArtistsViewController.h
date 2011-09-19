
#import "HomeViewDelegate.h"

@class SocksoServer, HomeViewController;

@interface ArtistsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, HomeViewDelegate> {
    NSMutableDictionary *sections;
}

@property (nonatomic, retain) SocksoServer *server;
@property (nonatomic, retain) IBOutlet UITableView *artistsTable;
@property (nonatomic, assign) HomeViewController *homeViewController;

+ (ArtistsViewController *)viewForServer:(SocksoServer *)server;

@end
