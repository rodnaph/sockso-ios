
#import "PlayViewController.h"
#import "MusicItem.h"
#import "AudioStreamer.h"

@implementation PlayViewController

@synthesize nameLabel, item, server, streamer;

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
    
    NSString *playUrl = [NSString stringWithFormat:@"http://%@/stream/%@",
                         server.ipAndPort,
                         [item getId]];
    
    NSLog( @"Play url: %@", playUrl );
    
	NSURL *url = [NSURL URLWithString:playUrl];
	streamer = [[AudioStreamer alloc] initWithURL:url];
    
    [streamer start];
    
}

- (void) dealloc {
    
    [streamer release];
    
    [super dealloc];
    
}

@end
