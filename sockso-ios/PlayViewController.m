
#import "PlayViewController.h"
#import "SocksoServer.h"
#import "Track.h"
#import "ImageLoader.h"

@implementation PlayViewController

@synthesize nameLabel, playButton, track, server, artworkImage, albumLabel, artistLabel;

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
    [albumLabel setText:track.album.name];
    [artistLabel setText:track.artist.name];
    
    ImageLoader *loader = [ImageLoader fromServer:server forItem:track.album atIndex:nil];
    [loader setDelegate:(id <ImageLoaderDelegate> *)self];
    [loader load];
    
    [server play:track];
    
}

//
// Loads album art
//

- (void) imageDidLoad:(UIImage *)image atIndex:(NSIndexPath *)indexPath {
    
    artworkImage.image = image;

}

//
// Toggle play/paused
//

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
    
    [nameLabel release];
    [playButton release];
    [track release];
    [server release];
    [artworkImage release];
    [albumLabel release];
    [artistLabel release];
    
    [super dealloc];
    
}

@end
