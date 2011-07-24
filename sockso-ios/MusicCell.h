
#import <UIKit/UIKit.h>
#import "MusicItem.h"
#import "EGOImageView.h"

@interface MusicCell : UITableViewCell {}

@property (nonatomic, retain) IBOutlet UILabel *trackName, *artistName;
@property (nonatomic, retain) IBOutlet UIImageView *actionImage;
@property (nonatomic, retain) IBOutlet EGOImageView *artworkImage;

- (void) drawForItem:(MusicItem *)item;

@end
