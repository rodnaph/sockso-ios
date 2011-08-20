
#import <UIKit/UIKit.h>
#import "MusicItem.h"
#import "SocksoServer.h"
#import "EGOImageView.h"
#import "ServerViewController.h"

enum AV_MODES {
    AV_MODE_ALBUMS = 1,
    AV_MODE_TRACKS = 2
};

@interface ArtistViewController : ServerViewController <UITableViewDelegate, UITableViewDataSource> {
    int mode;
    NSMutableDictionary *images;
}

@property (nonatomic, retain) MusicItem *item;
@property (nonatomic, retain) NSArray *albums, *tracks;

@property (nonatomic, retain) IBOutlet UILabel *nameLabel;
@property (nonatomic, retain) IBOutlet EGOImageView *artworkImage;
@property (nonatomic, retain) IBOutlet UISegmentedControl *modeButtons;
@property (nonatomic, retain) IBOutlet UITableView *musicTable;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *activityView;

+ (ArtistViewController *) initWithItem:(MusicItem *)item forServer:(SocksoServer *)server;

- (void) showArtwork;
- (void) showAlbums;
- (void) showTracks;

- (IBAction) modeButtonChanged;

@end
