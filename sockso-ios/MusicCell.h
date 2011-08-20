
#import "MusicItem.h"
#import "EGOImageView.h"
#import "SocksoServer.h"

@interface MusicCell : UITableViewCell {}

@property (nonatomic, retain) IBOutlet UILabel *trackName, *artistName;
@property (nonatomic, retain) IBOutlet UIImageView *actionImage;
@property (nonatomic, retain) IBOutlet EGOImageView *artworkImage;

- (void) drawForItem:(MusicItem *)item fromServer:(SocksoServer *)server;

@end
