
#import "MusicViewController.h"

@implementation MusicViewController

@synthesize item;

+ (MusicViewController *) viewForItem:(MusicItem *)item {
    
    MusicViewController *aView = [[MusicViewController alloc]
                                  initWithNibName:@"MusicView"
                                  bundle:nil];
    
    aView.item = item;
    
    return [aView autorelease];
    
}

- (void) viewDidLoad {
    
    self.title = item.name;
    
}

@end
