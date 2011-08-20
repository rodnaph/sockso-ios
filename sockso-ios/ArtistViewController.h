
#import "ServerViewController.h"

@class SocksoServer, MusicItem, EGOImageView;

enum AV_MODES {
    AV_MODE_ALBUMS = 1,
    AV_MODE_TRACKS = 2
};

@interface ArtistViewController : ServerViewController <UITableViewDelegate, UITableViewDataSource> {
    int mode;
}

@property (nonatomic, retain) MusicItem *item;
@property (nonatomic, retain) NSArray *albums, *tracks;

@property (nonatomic, retain) IBOutlet UILabel *nameLabel;
@property (nonatomic, retain) IBOutlet EGOImageView *artworkImage;
@property (nonatomic, retain) IBOutlet UISegmentedControl *modeButtons;
@property (nonatomic, retain) IBOutlet UITableView *musicTable;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *activityView;

+ (ArtistViewController *)initWithItem:(MusicItem *)item forServer:(SocksoServer *)server;

- (IBAction)modeButtonChanged;

@end
