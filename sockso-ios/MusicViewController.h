
#import <UIKit/UIKit.h>
#import "MusicItem.h"

@interface MusicViewController : UITableViewController {}

@property (nonatomic, retain) MusicItem *item;

+ (MusicViewController *) viewForItem:(MusicItem *) item;

@end
