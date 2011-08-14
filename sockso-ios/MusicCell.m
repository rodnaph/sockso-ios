
#import "MusicCell.h"
#import "Track.h"
#import "Album.h"

@implementation MusicCell

@synthesize trackName, artistName, actionImage, artworkImage;

- (void) drawForItem:(MusicItem *)item {

    self.imageView.image = nil;
    self.textLabel.text = @"";
    
    trackName.text = item.name;
    artistName.text = @"";

    if ( [item isAlbum] ) {
        Album *album = (Album *) item;
        artistName.text = album.artist.name;
    }
    
    else if ( [item isTrack] ) {
        Track *track = (Track *) item;
        artistName.text = track.artist.name;
    }
    
}

- (void) dealloc {
    
    [trackName release];
    [artistName release];
    [actionImage release];
    [artworkImage release];
    
    [super dealloc];
    
}

@end
