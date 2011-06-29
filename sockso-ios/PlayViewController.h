
#import <UIKit/UIKit.h>
#import "MusicItem.h"
#import "SocksoServer.h"

@interface PlayViewController : UIViewController {
    UILabel *nameLabel;
    UISegmentedControl *controls;
    
    MusicItem *item;
    SocksoServer *server;
}

@property (nonatomic, retain) IBOutlet UILabel *nameLabel;
@property (nonatomic, retain) IBOutlet UISegmentedControl *controls;
@property (nonatomic, retain) MusicItem *item;
@property (nonatomic, retain) SocksoServer *server;

+ (PlayViewController *) viewForTrack:(MusicItem *) item server:(SocksoServer *) server;

@end
