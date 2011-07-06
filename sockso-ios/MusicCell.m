
#import "MusicCell.h"

@implementation MusicCell

@synthesize trackName, artistName;

- (void) drawForItem:(MusicItem *)item {

    self.imageView.image = nil;
    self.textLabel.text = @"";
    
    trackName.text = @"";
    artistName.text = @"";
    
    if ( [item isArtist] ) {
        self.textLabel.text = item.name;
    }
    
    else {
        trackName.text = item.name;
        artistName.text = @"Artist Name";
    }

}

- (void) dealloc {
    
    [trackName release];
    [artistName release];
    
    [super dealloc];
    
}

@end
