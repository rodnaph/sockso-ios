
#import <UIKit/UIKit.h>
#import "MusicItem.h"
#import "SocksoServer.h"
#import "ImageLoaderDelegate.h"

enum AV_MODES {
    AV_MODE_ALBUMS = 1,
    AV_MODE_TRACKS = 2
};

@interface ArtistViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, ImageLoaderDelegate> {
    int mode;
    NSMutableDictionary *images;
}

@property (nonatomic, retain) MusicItem *item;
@property (nonatomic, retain) SocksoServer *server;
@property (nonatomic, retain) NSMutableArray *albums, *tracks;

@property (nonatomic, retain) IBOutlet UILabel *nameLabel;
@property (nonatomic, retain) IBOutlet UIImageView *artworkImage;
@property (nonatomic, retain) IBOutlet UISegmentedControl *modeButtons;
@property (nonatomic, retain) IBOutlet UITableView *musicTable;

+ (ArtistViewController *) initWithItem:(MusicItem *)item forServer:(SocksoServer *)server;

- (void) showArtwork;
- (void) showAlbums;
- (void) showTracks;

- (IBAction) modeButtonChanged;

- (void) setArtworkOnCell:(UITableViewCell *)cell forMusicItem:(MusicItem *)cellItem atIndex:(NSIndexPath *)indexPath;

@end