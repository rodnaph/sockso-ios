
#import "AlbumViewController.h"
#import "SocksoApi.h"
#import "SocksoPlayer.h"
#import "MusicCell.h"
#import "MusicItem.h"
#import "Album.h"
#import "PlayViewController.h"

@interface AlbumViewController (Private)

- (void)showArtwork;
- (void)loadTracks;

@end

@implementation AlbumViewController

@synthesize trackTable=trackTable_,
            nameLabel=nameLabel_,
            artworkImage=artworkImage_,
            albumItem=albumItem_,
            artistLabel=artistLabel_,
            tracks=tracks_,
            playAlbumButton=playAlbumButton_;

#pragma mark -
#pragma mark Init

- (void)dealloc {
    
    [artistLabel_ release];
    [trackTable_ release];
    [nameLabel_ release];
    [artworkImage_ release];
    [albumItem_ release];
    [tracks_ release];
    [playAlbumButton_ release];
    
    [super dealloc];
    
}

#pragma mark -
#pragma mark Helpers

+ (AlbumViewController *) initWithItem:(MusicItem *)albumItem forServer:(SocksoServer *)server {
    
    AlbumViewController *ctrl = [[AlbumViewController alloc]
                                 initWithNibName:@"AlbumView"
                                 bundle:nil];
    
    ctrl.albumItem = albumItem;
    ctrl.server = server;
    
    return [ctrl autorelease];
    
}

#pragma mark -
#pragma mark View

- (void) viewDidLoad {
    
    self.title = albumItem_.name;
    
    nameLabel_.text = albumItem_.name;
    artistLabel_.text = @"";
    
    if ( [albumItem_ isKindOfClass:[Album class]] ) {
        artistLabel_.text = ((Album *) albumItem_).artist.name;
    }
    
    [self showArtwork];
    [self loadTracks];
    
}

#pragma mark -
#pragma mark Table View

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
	return [tracks_ count];
    
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
    
    MusicItem *cellItem = [tracks_ objectAtIndex:indexPath.row];
    
    [cell drawForItem:cellItem fromServer:self.server];
    
	return cell;
    
}

- (void) tableView:(UITableView *) tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MusicItem *cellItem = [tracks_ objectAtIndex:[indexPath row]];
    
    [self.server.player playTrack:(Track *)cellItem];

    PlayViewController *playView = [PlayViewController viewForServer:self.server];

    [self.navigationController pushViewController:playView
                                         animated:YES];
        
}

#pragma mark -
#pragma mark Actions

- (IBAction)didClickPlayAlbum {
    
    [self.server.player playAlbum:(Album *)albumItem_];
    
    PlayViewController *playView = [PlayViewController viewForServer:self.server];
    
    [self.navigationController pushViewController:playView
                                         animated:YES];
    
}

#pragma mark -
#pragma mark Misc

- (void) loadTracks {
    
    __block AlbumViewController *this = self;
    
    [self.server.api tracksForAlbum:(Album *)albumItem_
                   onComplete:^(NSArray *_tracks) {
                       this.tracks = _tracks;
                       [this.trackTable reloadData];
                   }
                    onFailure:^{}];
    
}

- (void) showArtwork {
    
    artworkImage_.imageURL = [self.server getImageUrlForMusicItem:albumItem_];
    
}

@end
