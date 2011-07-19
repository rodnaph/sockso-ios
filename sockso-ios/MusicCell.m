
#import "MusicCell.h"

@implementation MusicCell

@synthesize trackName, artistName, actionImage, artworkImage;

- (void) drawForItem:(MusicItem *)item {

    self.imageView.image = nil;
    self.textLabel.text = @"";
    
    trackName.text = item.name;
    artistName.text = @"";
    
    if ( ![item isArtist] ) {
        artistName.text = @"Artist Name";
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
