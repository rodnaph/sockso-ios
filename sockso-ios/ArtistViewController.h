
#import <UIKit/UIKit.h>
#import "MusicItem.h"
#import "SocksoServer.h"
#import "ImageLoaderDelegate.h"

enum AV_MODES {
    AV_MODE_ALBUMS = 1,
    AV_MODE_TRACKS = 2
};

@interface ArtistViewController : UIViewController <ImageLoaderDelegate> {
    int mode;
    NSMutableArray *albums, *tracks;
}

@property (nonatomic, retain) MusicItem *item;
@property (nonatomic, retain) SocksoServer *server;

@property (nonatomic, retain) IBOutlet UILabel *nameLabel;
@property (nonatomic, retain) IBOutlet UIImageView *artworkImage;

+ (ArtistViewController *) initWithItem:(MusicItem *)item forServer:(SocksoServer *)server;

- (void) loadArtwork;

@end
