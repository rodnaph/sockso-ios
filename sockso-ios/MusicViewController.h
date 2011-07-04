
#import <UIKit/UIKit.h>

@interface MusicViewController : UITableViewController {}

@property (nonatomic, retain) NSMutableArray *items;

+ (MusicViewController *) viewForItems:(NSMutableArray *)items;

@end
