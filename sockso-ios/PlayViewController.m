
#import "PlayViewController.h"
#import "SocksoServer.h"
#import "Track.h"

@implementation PlayViewController

@synthesize nameLabel, playButton, track, server, controls;

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

- (void) viewDidAppear:(BOOL) animated {
    
    [nameLabel setText:track.name];
    
    [server play:track];
    
}

- (IBAction) playClicked {
    
    if ( server.mode == SS_MODE_PAUSED ) {
        [playButton setTitle:@"Pause" forState:UIControlStateNormal];    
        [server play];
    }
    
    else if ( server.mode == SS_MODE_PLAYING ) {
        [playButton setTitle:@"Play" forState:UIControlStateNormal];    
        [server pause];
    }

}

- (void) dealloc {
        
    [super dealloc];
    
}

@end
