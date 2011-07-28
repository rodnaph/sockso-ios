
#import "PlayViewController.h"
#import "SocksoServer.h"
#import "Track.h"

@interface PlayViewController ()

- (void)initLabels;
- (void)initArtwork;

@end

@implementation PlayViewController

@synthesize nameLabel, playButton, track, server,
            artworkImage=artworkImage_,
            albumLabel, artistLabel;

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
    
    [server play:track];
    
}

- (void)initLabels {
    
    [nameLabel setText:track.name];
    [albumLabel setText:track.album.name];
    [artistLabel setText:track.artist.name];
    
}

- (void)initArtwork {    
    
    artworkImage_.imageURL = [server getImageUrlForMusicItem:track];

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

@end
