
#import "PlayViewController.h"
#import "SocksoServer.h"
#import "SocksoPlayer.h"
#import "Track.h"
#import "EGOImageView.h"

@interface PlayViewController ()

- (void)initLabels;
- (void)initArtwork;
- (void)initSlider;
- (void)initCurrentTime;

- (void)didTrackChange;

- (void)updatePlaySlider:(NSTimer *)updatedTimer;

@end

@implementation PlayViewController

@synthesize nameLabel=nameLabel_, playButton,
            server=server_,
            artworkImage=artworkImage_,
            albumLabel=albumLabel_,
            artistLabel=artistLabel_,
            playSlider=playSlider_,
            timeLabel=timeLabel_,
            backButton=backButton_,
            nextButton=nextButton_;

#pragma mark -
#pragma mark init

- (void) dealloc {
    
    [timeLabel_ release];
    [playSlider_ release];
    [playButton release];
    [server_ release];
    
    [artworkImage_ release];
    [nameLabel_ release];
    [albumLabel_ release];
    [artistLabel_ release];
    [backButton_ release];
    [nextButton_ release];
    
    if ( playTimer_ ) {
        [playTimer_ invalidate];
        playTimer_ = nil;
    }
    
    [super dealloc];
    
}

#pragma mark -
#pragma mark Helpers

+ (PlayViewController *) viewForServer:(SocksoServer *) server {
    
    PlayViewController *aView = [[PlayViewController alloc]
                                 initWithNibName:@"PlayView"
                                 bundle:nil];
    
    aView.server = server;
    
    return [aView autorelease];
    
}

#pragma mark -
#pragma mark View

- (void)viewDidLoad {
    
    [self initCurrentTime];
    [self initSlider];
    [self initLabels];
    [self initArtwork];

}

- (void)viewDidAppear:(BOOL)animated {

    if ( ![server_.player isPlaying] ) {
        [server_.player play];
    }

    [self didTrackChange];
    
}

- (void)initCurrentTime {

    currentTime = [server_.player isPlaying]
        ? [server_.player position]
        : 0;

}

- (void)initSlider {
    
    [timeLabel_ setText:@"0:00"];
    
    [playSlider_ setMaximumValue:1.0];
    [playSlider_ setValue:0.0];
    
    playTimer_ = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                  target:self
                                                selector:@selector(updatePlaySlider:)
                                                userInfo:nil
                                                 repeats:YES];
    
}

- (void)initLabels {
    
    Track *track = [server_.player getCurrentTrack];
    
    if ( track != nil ) {
        nameLabel_.text = track.name;
        albumLabel_.text = track.album.name;
        artistLabel_.text = track.artist.name;
    }

}

- (void)initArtwork {

    Track *track = [server_.player getCurrentTrack];
    
    if ( track != nil ) {
        artworkImage_.imageURL = [server_ getImageUrlForMusicItem:track.album];
    }

}

#pragma mark -
#pragma mark Play Slider

- (void)updatePlaySlider:(NSTimer *)updatedTimer {
    
    if ( [server_.player isPlaying] ) {
        
        double duration = [server_.player duration];
        int minutes = currentTime / 60;
        int seconds = currentTime - (minutes * 60);
        
        self.timeLabel.text = [NSString stringWithFormat:@"%d:%02d", minutes, seconds];
        
        if ( duration > 0 ) {
            [playSlider_ setValue:(currentTime / duration)];
        }
        
        currentTime++;
        
    }
    
}

#pragma mark -
#pragma mark Actions

- (IBAction)didClickPlayButton {
    
    if ( [server_.player isPlaying] ) {
        [playButton setTitle:@"Play" forState:UIControlStateNormal];    
        [server_.player pause];
    }
    
    else if ( [server_.player isPaused] ) {
        [playButton setTitle:@"Pause" forState:UIControlStateNormal];    
        [server_.player play];
    }

}

- (IBAction)playSliderMoved {

    if ( [server_.player isPlaying] ) {
        currentTime = [server_.player duration] * [playSlider_ value];
        [server_.player seekTo:currentTime];
    }
    
}

- (IBAction)didClickBackButton {
    
    if ( [server_.player playPrev] ) {
        [self didTrackChange];
    }
    
}

- (IBAction)didClickNextButton {

    if ( [server_.player playNext] ) {
        [self didTrackChange];
    }

}

- (void)didTrackChange {
    
    [playButton setTitle:@"Pause" forState:UIControlStateNormal];

    [self initLabels];
    [self initArtwork];
    [self initCurrentTime];
    
}

@end
