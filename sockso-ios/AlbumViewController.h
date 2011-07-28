
#import <UIKit/UIKit.h>
#import "MusicItem.h"
#import "SocksoServer.h"
#import "EGOImageView.h"

@interface AlbumViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {}

@property (nonatomic, retain) IBOutlet UITableView *trackTable;
@property (nonatomic, retain) IBOutlet UILabel *nameLabel, *artistLabel;
@property (nonatomic, retain) IBOutlet EGOImageView *artworkImage;

@property (nonatomic, retain) MusicItem *albumItem;
@property (nonatomic, retain) SocksoServer *server;
@property (nonatomic, retain) NSMutableArray *tracks;

+ (AlbumViewController *) initWithItem:(MusicItem *)albumItem forServer:(SocksoServer *)server;

- (void) showArtwork;
- (void) loadTracks;

@end
