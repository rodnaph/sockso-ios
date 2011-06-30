
#import <UIKit/UIKit.h>
#import "MusicItem.h"

@interface MusicViewController : UITableViewController {
    MusicItem *item;
}

@property (nonatomic, retain) MusicItem *item;

+ (MusicViewController *) viewForItem:(MusicItem *) item;

@end
