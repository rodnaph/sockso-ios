
#import <UIKit/UIKit.h>
#import "MusicItem.h"

@interface MusicCell : UITableViewCell {}

@property (nonatomic, retain) IBOutlet UILabel *trackName, *artistName;
@property (nonatomic, retain) IBOutlet UIImageView *actionImage;

- (void) drawForItem:(MusicItem *)item;

@end
