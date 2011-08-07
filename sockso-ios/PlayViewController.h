
#import <UIKit/UIKit.h>
#import "SocksoServer.h"
#import "Track.h"
#import "EGOImageView.h"

@interface PlayViewController : UIViewController {
    int currentTime;
}

@property (nonatomic, retain) IBOutlet UILabel *nameLabel, *albumLabel, *artistLabel, *timeLabel;
@property (nonatomic, retain) IBOutlet UIButton *playButton;
@property (nonatomic, retain) IBOutlet EGOImageView *artworkImage;
@property (nonatomic, retain) IBOutlet UISlider *playSlider;
@property (nonatomic, retain) Track *track;
@property (nonatomic, retain) SocksoServer *server;

+ (PlayViewController *) viewForTrack:(Track *) track server:(SocksoServer *) server;

- (IBAction)playClicked;
- (IBAction)playSliderMoved;

@end
