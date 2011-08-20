
#import "ServerViewController.h"

@class MusicItem, SocksoServer, EGOImageView;

@interface AlbumViewController : ServerViewController <UITableViewDelegate, UITableViewDataSource> {}

@property (nonatomic, retain) IBOutlet UITableView *trackTable;
@property (nonatomic, retain) IBOutlet UILabel *nameLabel, *artistLabel;
@property (nonatomic, retain) IBOutlet EGOImageView *artworkImage;
@property (nonatomic, retain) IBOutlet UIButton *playAlbumButton;
@property (nonatomic, retain) MusicItem *albumItem;
@property (nonatomic, retain) NSArray *tracks;

+ (AlbumViewController *)initWithItem:(MusicItem *)albumItem forServer:(SocksoServer *)server;

- (IBAction)didClickPlayAlbum;

@end
