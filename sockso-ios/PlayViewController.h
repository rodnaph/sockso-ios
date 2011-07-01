
#import <UIKit/UIKit.h>
#import "MusicItem.h"
#import "SocksoServer.h"

@interface PlayViewController : UIViewController {}

@property (nonatomic, retain) IBOutlet UILabel *nameLabel;
@property (nonatomic, retain) IBOutlet UIButton *playButton;
@property (nonatomic, retain) IBOutlet UISegmentedControl *controls;
@property (nonatomic, retain) MusicItem *item;
@property (nonatomic, retain) SocksoServer *server;

+ (PlayViewController *) viewForTrack:(MusicItem *) item server:(SocksoServer *) server;

- (IBAction) playClicked;

@end
