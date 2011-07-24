
#import "AlbumViewController.h"
#import "MusicCell.h"
#import "MusicItem.h"
#import "Album.h"
#import "PlayViewController.h"

@implementation AlbumViewController

@synthesize trackTable, nameLabel, artworkImage, albumItem, server, artistLabel, tracks;

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
    artistLabel.text = @"";
    
    if ( [albumItem isKindOfClass:[Album class]] ) {
        artistLabel.text = ((Album *) albumItem).artist.name;
    }
    
    [self showArtwork];
    [self loadTracks];
    
}

- (void) loadTracks {

    __block AlbumViewController *this = self;
    
    [server getTracksForAlbum:albumItem
                   onComplete:^(NSMutableArray *_tracks) {
                       this.tracks = _tracks;
                       [this.trackTable reloadData];
                   }
                    onFailure:^{}];
    
}

- (void) showArtwork {
}

- (void) imageDidLoad:(UIImage *)image atIndex:(NSIndexPath *)indexPath {
    
    artworkImage.image = image;
    
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
	return [tracks count];
    
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
    
    MusicItem *cellItem = [tracks objectAtIndex:indexPath.row];
    
    cell.textLabel.text = cellItem.name;
    cell.trackName.text = @"";
    cell.artistName.text = @"";
    cell.actionImage.image = [UIImage imageNamed:@"play.png"];
    
	return cell;
    
}

- (void) tableView:(UITableView *) tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MusicItem *cellItem = [tracks objectAtIndex:[indexPath row]];
    
    int trackId = [[cellItem getId] intValue];
        
    [server getTrack:trackId onComplete:^(Track *track){
        [self.navigationController pushViewController:[PlayViewController viewForTrack:track server:server]
                                             animated:YES];
    }];
        
}


- (void) dealloc {
    
    [artistLabel release];
    [trackTable release];
    [nameLabel release];
    [artworkImage release];
    [albumItem release];
    [server release];
    [tracks release];
    
    [super dealloc];
    
}

@end
