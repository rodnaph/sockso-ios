
#import <UIKit/UIKit.h>
#import "SocksoServer.h"
#import "Track.h"
#import "EGOImageView.h"

@interface PlayViewController : UIViewController {
    int currentTime;
}

@property (nonatomic, retain) IBOutlet UILabel *nameLabel, *albumLabel, *artistLabel, *timeLabel;
@property (nonatomic, retain) IBOutlet UIButton *playButton, *backButton, *nextButton;
@property (nonatomic, retain) IBOutlet EGOImageView *artworkImage;
@property (nonatomic, retain) IBOutlet UISlider *playSlider;

@property (nonatomic, retain) SocksoServer *server;

+ (PlayViewController *)viewForServer:(SocksoServer *)server;

- (IBAction)playSliderMoved;

- (IBAction)didClickPlayButton;
- (IBAction)didClickBackButton;
- (IBAction)didClickNextButton;

@end
