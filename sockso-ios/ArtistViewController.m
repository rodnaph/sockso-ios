
#import "ArtistViewController.h"
#import "ImageLoader.h"

@implementation ArtistViewController

@synthesize item, server, nameLabel, artworkImage;

+ (ArtistViewController *) initWithItem:(MusicItem *)item forServer:(SocksoServer *)server {
    
    ArtistViewController *ctrl = [[ArtistViewController alloc]
                                  initWithNibName:@"ArtistView"
                                   bundle:nil];
    
    ctrl.item = item;
    ctrl.server = server;
    
    return [ctrl autorelease];
    
}

- (void) viewDidLoad {
    
    self.title = item.name;
    
    nameLabel.text = item.name;
    
    [self loadArtwork];
    
}

- (void) loadArtwork {

    ImageLoader *loader = [ImageLoader fromServer:server forItem:item atIndex:nil];
    [loader setDelegate:(id<ImageLoaderDelegate> *)self];
    [loader load];

}

- (void) imageDidLoad:(UIImage *)image atIndex:(NSIndexPath *)indexPath {
    
    artworkImage.image = image;
    
}

- (void) dealloc {
    
    [item release];
    [server release];
    [nameLabel release];
    [artworkImage release];
    
    [super dealloc];
    
}

@end
