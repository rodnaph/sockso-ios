
#import "MusicViewController.h"

@implementation MusicViewController

@synthesize items;

+ (MusicViewController *) viewForItems:(NSMutableArray *)items {
    
    MusicViewController *aView = [[MusicViewController alloc]
                                  initWithNibName:@"MusicView"
                                  bundle:nil];
    
    aView.items = items;
    
    return [aView autorelease];
    
}

- (void) viewDidLoad {
    
    self.title = @"TITLE"; // items.name;
    
}

@end
