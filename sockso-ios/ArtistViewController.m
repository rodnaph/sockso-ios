
#import "ArtistViewController.h"
#import "PlayViewController.h"
#import "MusicCell.h"
#import "MusicItem.h"
#import "AlbumViewController.h"
#import "SocksoApi.h"
#import "SocksoPlayer.h"

@implementation ArtistViewController

@synthesize item, nameLabel,
            artworkImage=artworkImage_,
            modeButtons, albums, tracks, musicTable, activityView;

+ (ArtistViewController *) initWithItem:(MusicItem *)item forServer:(SocksoServer *)server {
    
    ArtistViewController *ctrl = [[ArtistViewController alloc]
                                  initWithNibName:@"ArtistView"
                                   bundle:nil];
    
    ctrl.item = item;
    ctrl.server = server;
    
    return [ctrl autorelease];
    
}

#pragma mark -
#pragma mark init

- (void) dealloc {
    
    [item release];
    [nameLabel release];
    [artworkImage_ release];
    [modeButtons release];
    [albums release];
    [tracks release];
    [musicTable release];
    [activityView release];
    
    [super dealloc];
    
}

#pragma mark -
#pragma mark View

- (void) viewDidLoad {
    
    images = [[NSMutableDictionary alloc] init];
    
    self.title = item.name;
    nameLabel.text = item.name;
        
    [self showArtwork];
    [self showAlbums];
    
}

- (void)showArtwork {
    
    artworkImage_.imageURL = [self.server getImageUrlForMusicItem:item];
    
}

//
// return the number of rows in the list
//

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
	return mode == AV_MODE_ALBUMS
        ? [albums count]
        : [tracks count];
    
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
    
    NSArray *items = mode == AV_MODE_ALBUMS ? albums : tracks;
    MusicItem *cellItem = [items objectAtIndex:indexPath.row];
	
    [cell drawForItem:cellItem fromServer:self.server];
    
	return cell;
    
}

- (void) showAlbums {

    __block ArtistViewController *this = self;
    
    mode = AV_MODE_ALBUMS;
    
    if ( albums == nil ) {
        [activityView setHidden:NO];
        
        [self.server.api albumsForArtist:(Artist *)item
                onComplete:^(NSArray *_albums) {
                    [activityView setHidden:YES];
                    this.albums = _albums;
                    [this showAlbums];
                }
                onFailure:^{}];
    }
    
    else {
        [musicTable reloadData];
    }
    
}

- (void) showTracks {
    
    __block ArtistViewController *this = self;
    
    mode = AV_MODE_TRACKS;
    
    if ( tracks == nil ) {
        [activityView setHidden:NO];
        [self.server.api tracksForArtist:(Artist *)item
                onComplete:^(NSArray *_tracks) {
                    [activityView setHidden:YES];
                    this.tracks = _tracks;
                    [this showTracks];
                }
                onFailure:^{}];
    }
    
    else {
        [musicTable reloadData];
    }
    
}

//
// Music item selected
//

- (void) tableView:(UITableView *) tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSArray *items = mode == AV_MODE_ALBUMS ? albums : tracks;
    MusicItem *cellItem = [items objectAtIndex:[indexPath row]];
    
    if ( [cellItem isTrack] ) {
        
        [self.server.player playTrack:(Track *)cellItem];
        
        PlayViewController *playView = [PlayViewController viewForServer:self.server];
        
        [self.navigationController pushViewController:playView
                                             animated:YES];
        
    }
    
    else if ( [cellItem isAlbum] ) {
        AlbumViewController *ctrl = [AlbumViewController initWithItem:cellItem forServer:self.server];
        [self.navigationController pushViewController:ctrl animated:YES];
    }
    
    else {
        NSLog( @"NOT YET IMPLEMENTED" );
    }
    
}

- (IBAction) modeButtonChanged {
    
    if ( [modeButtons selectedSegmentIndex] == 0 ) {
        [self showAlbums];
    }
    
    else {
        [self showTracks];
    }
    
}

@end
