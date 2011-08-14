
#import "PlayViewController.h"
#import "SocksoServer.h"
#import "Track.h"

@interface PlayViewController ()

- (void)initLabels;
- (void)initArtwork;
- (void)initSlider;

@end

@implementation PlayViewController

@synthesize nameLabel=nameLabel_, playButton, track, server,
            artworkImage=artworkImage_,
            albumLabel=albumLabel_,
            artistLabel=artistLabel_,
            playSlider=playSlider_,
            timeLabel=timeLabel_;

#pragma mark -
#pragma mark init

- (void) dealloc {
    
    [timeLabel_ release];
    [playSlider_ release];
    [playButton release];
    [track release];
    [server release];
    [artworkImage_ release];
    [nameLabel_ release];
    [albumLabel_ release];
    [artistLabel_ release];
    
    [super dealloc];
    
}

#pragma mark -
#pragma mark Helpers

+ (PlayViewController *) viewForTrack:(Track *)track server:(SocksoServer *) server {
    
    PlayViewController *aView = [[PlayViewController alloc]
                                 initWithNibName:@"PlayView"
                                 bundle:nil];
    
    aView.track = track;
    aView.server = server;
    
    return [aView autorelease];
    
}

#pragma mark -
#pragma mark View

- (void)viewDidLoad {
    
    [self initLabels];
    [self initArtwork];
    [self initSlider];

    [server play:track];
    
}

- (void)initSlider {
    
    [timeLabel_ setText:@""];
    
    [playSlider_ setMaximumValue:1.0];
    [playSlider_ setValue:0.0];
    
    [NSThread detachNewThreadSelector:@selector(updatePlaySliderTicker)
                             toTarget:self
                           withObject:nil];

}

- (void)initLabels {
    
    nameLabel_.text = track.name;
    albumLabel_.text = track.album.name;
    artistLabel_.text = track.artist.name;

}

- (void)initArtwork {

    artworkImage_.imageURL = [server getImageUrlForMusicItem:track.album];

}

#pragma mark -
#pragma mark Play Slider

- (void)updatePlaySliderTicker {
    
    while ( TRUE ) {
        sleep( 1 );
        [self performSelectorOnMainThread:@selector(updatePlaySlider)
                               withObject:nil
                            waitUntilDone:NO];
    }
    
}

- (void)updatePlaySlider {
    
    if ( [server isPlaying] ) {
        
        double duration = [server duration];
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

- (IBAction)playClicked {
    
    if ( server.mode == SS_MODE_PAUSED ) {
        [playButton setTitle:@"Pause" forState:UIControlStateNormal];    
        [server play];
    }
    
    else if ( server.mode == SS_MODE_PLAYING ) {
        [playButton setTitle:@"Play" forState:UIControlStateNormal];    
        [server pause];
    }

}

- (IBAction)playSliderMoved {

    if ( [server isPlaying] ) {
        currentTime = [server duration] * [playSlider_ value];
        [server seekTo:currentTime];
    }
    
}

@end
