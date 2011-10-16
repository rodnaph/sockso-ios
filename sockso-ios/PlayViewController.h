
@class SocksoServer, Track, EGOImageView;

@interface PlayViewController : UIViewController {
    int currentTime;
    NSTimer *playTimer_;
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
