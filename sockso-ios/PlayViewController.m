
#import "PlayViewController.h"
#import "SocksoServer.h"
#import "Track.h"

@interface PlayViewController ()

- (void)initLabels;
- (void)initArtwork;
- (void)initSlider;

@end

@implementation PlayViewController

@synthesize nameLabel, playButton, track, server,
            artworkImage=artworkImage_,
            albumLabel, artistLabel,
            playSlider=playSlider_,
            timeLabel=timeLabel_;

//
//  Create play controller to play a track on a server
//

+ (PlayViewController *) viewForTrack:(Track *)track server:(SocksoServer *) server {
    
    PlayViewController *aView = [[PlayViewController alloc]
                                 initWithNibName:@"PlayView"
                                 bundle:nil];

    NSLog( @"Track: %@", track.mid );
    
    aView.track = track;
    aView.server = server;
    
    return [aView autorelease];
    
}

#pragma mark -
#pragma mark init

- (void) dealloc {
    
    [timeLabel_ release];
    [playSlider_ release];
    [nameLabel release];
    [playButton release];
    [track release];
    [server release];
    [artworkImage_ release];
    [albumLabel release];
    [artistLabel release];
    
    [super dealloc];
    
}

#pragma mark -
#pragma mark View

- (void) viewDidAppear:(BOOL) animated {
    
    [self initLabels];
    [self initArtwork];
    [self initSlider];
    
    [server play:track];
    
}

- (void)initSlider {
    
    [timeLabel_ setText:@""];
    
    [playSlider_ setMaximumValue:1.0];
    [playSlider_ setValue:0.0];
    
    [NSThread detachNewThreadSelector:@selector(updatePlaySliderTicker) toTarget:self withObject:nil];

}

- (void)initLabels {
    
    [nameLabel setText:track.name];
    [albumLabel setText:track.album.name];
    [artistLabel setText:track.artist.name];
    
}

- (void)initArtwork {

    artworkImage_.imageURL = [server getImageUrlForMusicItem:track.album];

}

#pragma mark -
#pragma mark Play Slider

- (void)updatePlaySliderTicker {
    
    while ( TRUE ) {
        sleep( 1 );
//        if ( self.isVisible ) {
            [self performSelectorOnMainThread:@selector(updatePlaySlider)
                                   withObject:nil
                                waitUntilDone:NO];
//        }
//        else {
//            [self performSelectorOnMainThread:@selector(pause)
//                                   withObject:nil
//                                waitUntilDone:NO];
//            break;
//        }
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
    NSLog( @"Slider moved" );
    if ( [server isPlaying] ) {
        currentTime = [server duration] * [playSlider_ value];
        NSLog( @"Seek to %d", currentTime );
        [server seekTo:currentTime];
    }
    
}

@end
