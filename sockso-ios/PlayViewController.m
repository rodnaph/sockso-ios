
#import "PlayViewController.h"
#import "SocksoServer.h"
#import "MusicItem.h"

@implementation PlayViewController

@synthesize nameLabel, playButton, item, server, controls;

//
//  Create play controller to play a track on a server
//

+ (PlayViewController *) viewForTrack:(MusicItem *)item server:(SocksoServer *) server {
    
    PlayViewController *aView = [[PlayViewController alloc]
                                 initWithNibName:@"PlayView"
                                 bundle:nil];

    aView.item = item;
    aView.server = server;
    
    return [aView autorelease];
    
}

- (void) viewDidAppear:(BOOL) animated {
    
    [nameLabel setText:item.name];
    
    [server play:item];
    
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
