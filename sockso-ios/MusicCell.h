
#import <UIKit/UIKit.h>
#import "MusicItem.h"

@interface MusicCell : UITableViewCell {}

@property (nonatomic, retain) IBOutlet UILabel *trackName, *artistName;

- (void) drawForItem:(MusicItem *)item;

@end
