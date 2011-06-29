
#import "PlayViewController.h"
#import "MusicItem.h"

@implementation PlayViewController

@synthesize nameLabel, item, server, controls;

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

- (void) dealloc {
        
    [super dealloc];
    
}

@end
