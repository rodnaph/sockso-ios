
#import "PlayViewController.h"
#import "MusicItem.h"

@implementation PlayViewController

@synthesize nameLabel, item, server;

+ (PlayViewController *) viewForTrack:(MusicItem *)item server:(SocksoServer *) server {
    
    PlayViewController *aView = [[PlayViewController alloc]
                                 initWithNibName:@"PlayView"
                                 bundle:nil];

    aView.item = item;
    aView.server = server;
    
    return [aView autorelease];
    
}

@end
