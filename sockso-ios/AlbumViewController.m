
#import "AlbumViewController.h"
#import "MusicCell.h"
#import "MusicItem.h"
#import "ImageLoader.h"
#import "Album.h"

@implementation AlbumViewController

@synthesize trackTable, nameLabel, artworkImage, albumItem, server, artistLabel;

+ (AlbumViewController *) initWithItem:(MusicItem *)albumItem forServer:(SocksoServer *)server {
    
    AlbumViewController *ctrl = [[AlbumViewController alloc]
                                 initWithNibName:@"AlbumView"
                                 bundle:nil];
    
    ctrl.albumItem = albumItem;
    ctrl.server = server;
    
    return [ctrl autorelease];
    
}

- (void) viewDidLoad {
    
    self.title = albumItem.name;
    
    nameLabel.text = albumItem.name;
    artistLabel.text = ((Album *) albumItem).artist.name;
    
    [self showArtwork];
    
}

- (void) showArtwork {
    
    ImageLoader *loader = [ImageLoader fromServer:server forItem:albumItem atIndex:nil];
    [loader setDelegate:(id<ImageLoaderDelegate> *)self];
    [loader load];
    
}

- (void) imageDidLoad:(UIImage *)image atIndex:(NSIndexPath *)indexPath {
    
    artworkImage.image = image;
    
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
	return 0;
    
}

//
// return the cell for the row at the specified index
//

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	static NSString *kCellID = @"cellID";
	
	MusicCell *cell = (MusicCell *) [tableView dequeueReusableCellWithIdentifier:kCellID];
    
	if ( cell == nil ) {
        
        NSArray *objects = [[NSBundle mainBundle] loadNibNamed:@"MusicCellView"
                                                         owner:self
                                                       options:nil];
        cell = (MusicCell *) [objects objectAtIndex:0];
        
	}
    
    MusicItem *cellItem = [nil objectAtIndex:indexPath.row];
    
    cell.textLabel.text = cellItem.name;
    cell.trackName.text = @"";
    cell.artistName.text = @"";
    cell.actionImage.image = [UIImage imageNamed:@"play.png"];
    
	return cell;
    
}


- (void) dealloc {
    
    [artistLabel release];
    [trackTable release];
    [nameLabel release];
    [artworkImage release];
    [albumItem release];
    [server release];
    
    [super dealloc];
    
}

@end
