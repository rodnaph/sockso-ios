
#import "ArtistViewController.h"
#import "PlayViewController.h"
#import "MusicCell.h"
#import "MusicItem.h"
#import "AlbumViewController.h"
#import "SocksoApi.h"
#import "SocksoPlayer.h"

@interface ArtistViewController (Private)

- (void)showArtwork;
- (void)showAlbums;
- (void)showTracks;

@end

@implementation ArtistViewController

@synthesize item=item_,
            nameLabel=nameLabel_,
            artworkImage=artworkImage_,
            modeButtons=modeButtons_,
            albums=albums_,
            tracks=tracks_,
            musicTable=musicTable_,
            activityView=activityView_;

#pragma mark -
#pragma mark Init

- (void) dealloc {
    
    [item_ release];
    [nameLabel_ release];
    [artworkImage_ release];
    [modeButtons_ release];
    [albums_ release];
    [tracks_ release];
    [musicTable_ release];
    [activityView_ release];
    
    [super dealloc];
    
}

#pragma mark -
#pragma mark Helpers

+ (ArtistViewController *)initWithItem:(MusicItem *)item forServer:(SocksoServer *)server {
    
    ArtistViewController *ctrl = [[ArtistViewController alloc]
                                  initWithNibName:@"ArtistView"
                                  bundle:nil];
    
    ctrl.item = item;
    ctrl.server = server;
    
    return [ctrl autorelease];
    
}

#pragma mark -
#pragma mark View

- (void) viewDidLoad {
    
    self.title = item_.name;
    
    nameLabel_.text = item_.name;
        
    [self showArtwork];
    [self showAlbums];
    
}

- (void)showArtwork {
    
    artworkImage_.imageURL = [self.server getImageUrlForMusicItem:item_];
    
}

#pragma mark -
#pragma mark Table View

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
	return mode == AV_MODE_ALBUMS
        ? [albums_ count]
        : [tracks_ count];
    
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
    
    NSArray *items = mode == AV_MODE_ALBUMS ? albums_ : tracks_;
    MusicItem *cellItem = [items objectAtIndex:indexPath.row];
	
    [cell drawForItem:cellItem fromServer:self.server];
    
	return cell;
    
}


//
// Music item selected
//

- (void) tableView:(UITableView *) tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSArray *items = mode == AV_MODE_ALBUMS ? albums_ : tracks_;
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
    
}

#pragma mark -
#pragma mark Private Methods

- (void)showAlbums {

    __block ArtistViewController *this = self;
    
    mode = AV_MODE_ALBUMS;
    
    if ( albums_ == nil ) {
        [activityView_ setHidden:NO];
        
        [self.server.api albumsForArtist:(Artist *)item_
                onComplete:^(NSArray *_albums) {
                    [activityView_ setHidden:YES];
                    this.albums = _albums;
                    [this showAlbums];
                }
                onFailure:^{}];
    }
    
    else {
        [musicTable_ reloadData];
    }
    
}

- (void)showTracks {
    
    __block ArtistViewController *this = self;
    
    mode = AV_MODE_TRACKS;
    
    if ( tracks_ == nil ) {
        [activityView_ setHidden:NO];
        [self.server.api tracksForArtist:(Artist *)item_
                onComplete:^(NSArray *_tracks) {
                    [activityView_ setHidden:YES];
                    this.tracks = _tracks;
                    [this showTracks];
                }
                onFailure:^{}];
    }
    
    else {
        [musicTable_ reloadData];
    }
    
}

#pragma mark -
#pragma mark Actions

- (IBAction)modeButtonChanged {
    
    if ( [modeButtons_ selectedSegmentIndex] == 0 ) {
        [self showAlbums];
    }
    
    else {
        [self showTracks];
    }
    
}

@end
