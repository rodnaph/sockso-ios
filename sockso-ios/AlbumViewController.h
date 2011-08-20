
#import <UIKit/UIKit.h>
#import "MusicItem.h"
#import "SocksoServer.h"
#import "EGOImageView.h"
#import "ServerViewController.h"

@interface AlbumViewController : ServerViewController <UITableViewDelegate, UITableViewDataSource> {}

@property (nonatomic, retain) IBOutlet UITableView *trackTable;
@property (nonatomic, retain) IBOutlet UILabel *nameLabel, *artistLabel;
@property (nonatomic, retain) IBOutlet EGOImageView *artworkImage;

@property (nonatomic, retain) MusicItem *albumItem;
@property (nonatomic, retain) NSArray *tracks;

+ (AlbumViewController *) initWithItem:(MusicItem *)albumItem forServer:(SocksoServer *)server;

- (void) showArtwork;
- (void) loadTracks;

@end
