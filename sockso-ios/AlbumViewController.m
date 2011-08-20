
#import "AlbumViewController.h"
#import "SocksoApi.h"
#import "SocksoPlayer.h"
#import "MusicCell.h"
#import "MusicItem.h"
#import "Album.h"
#import "PlayViewController.h"

@implementation AlbumViewController

@synthesize trackTable, nameLabel,
            artworkImage=artworkImage_,
            albumItem, artistLabel, tracks;

+ (AlbumViewController *) initWithItem:(MusicItem *)albumItem forServer:(SocksoServer *)server {
    
    AlbumViewController *ctrl = [[AlbumViewController alloc]
                                 initWithNibName:@"AlbumView"
                                 bundle:nil];
    
    ctrl.albumItem = albumItem;
    ctrl.server = server;
    
    return [ctrl autorelease];
    
}

#pragma mark -
#pragma mark init

- (void) dealloc {
    
    [artistLabel release];
    [trackTable release];
    [nameLabel release];
    [artworkImage_ release];
    [albumItem release];
    [tracks release];
    
    [super dealloc];
    
}

#pragma mark -
#pragma mark View

- (void) viewDidLoad {
    
    self.title = albumItem.name;
    
    nameLabel.text = albumItem.name;
    artistLabel.text = @"";
    
    if ( [albumItem isKindOfClass:[Album class]] ) {
        artistLabel.text = ((Album *) albumItem).artist.name;
    }
    
    [self showArtwork];
    [self loadTracks];
    
}

#pragma mark -
#pragma mark Table View

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
	return [tracks count];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	static NSString *kCellID = @"cellID";
	
	MusicCell *cell = (MusicCell *) [tableView dequeueReusableCellWithIdentifier:kCellID];
    
	if ( cell == nil ) {
        
        NSArray *objects = [[NSBundle mainBundle] loadNibNamed:@"MusicCellView"
                                                         owner:self
                                                       options:nil];
        cell = (MusicCell *) [objects objectAtIndex:0];
        
	}
    
    MusicItem *cellItem = [tracks objectAtIndex:indexPath.row];
    
    [cell drawForItem:cellItem fromServer:self.server];
    
	return cell;
    
}

- (void) tableView:(UITableView *) tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MusicItem *cellItem = [tracks objectAtIndex:[indexPath row]];
    
    [self.server.player playTrack:(Track *)cellItem];

    PlayViewController *playView = [PlayViewController viewForServer:self.server];

    [self.navigationController pushViewController:playView
                                         animated:YES];
        
}

#pragma mark -
#pragma mark Misc

- (void) loadTracks {
    
    __block AlbumViewController *this = self;
    
    [self.server.api tracksForAlbum:(Album *)albumItem
                   onComplete:^(NSArray *_tracks) {
                       this.tracks = _tracks;
                       [this.trackTable reloadData];
                   }
                    onFailure:^{}];
    
}

- (void) showArtwork {
    
    artworkImage_.imageURL = [self.server getImageUrlForMusicItem:albumItem];
    
}

@end
