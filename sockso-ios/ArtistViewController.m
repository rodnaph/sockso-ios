
#import "ArtistViewController.h"
#import "PlayViewController.h"
#import "ImageLoader.h"
#import "MusicCell.h"
#import "MusicItem.h"

@implementation ArtistViewController

@synthesize item, server, nameLabel, artworkImage, modeButtons,
            albums, tracks, musicTable, activityView;

+ (ArtistViewController *) initWithItem:(MusicItem *)item forServer:(SocksoServer *)server {
    
    ArtistViewController *ctrl = [[ArtistViewController alloc]
                                  initWithNibName:@"ArtistView"
                                   bundle:nil];
    
    ctrl.item = item;
    ctrl.server = server;
    
    return [ctrl autorelease];
    
}

- (void) viewDidLoad {
    
    images = [[NSMutableDictionary alloc] init];
    
    self.title = item.name;
    nameLabel.text = item.name;
        
    [self showArtwork];
    [self showAlbums];
    
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
    
    NSMutableArray *items = mode == AV_MODE_ALBUMS ? albums : tracks;
    MusicItem *cellItem = [items objectAtIndex:indexPath.row];
	
    cell.textLabel.text = cellItem.name;
    cell.trackName.text = @"";
    cell.artistName.text = @"";
    
    if ( [cellItem isAlbum] ) {
        [self setArtworkOnCell:cell forMusicItem:cellItem atIndex:indexPath];
    }
    
    else {
        cell.actionImage.image = [UIImage imageNamed:@"play.png"];
    }
    
	return cell;
    
}

//
// Sets cell artwork for an artist or album
//

- (void) setArtworkOnCell:(UITableViewCell *)cell forMusicItem:(MusicItem *)cellItem atIndex:(NSIndexPath *)indexPath {
    
    NSString *key = [NSString stringWithFormat:@"image-%@", cellItem.mid];
    UIImage *image = [images objectForKey:key];
    
    if ( image ) {
        cell.imageView.image = image;
    }
    
    else {
        
        cell.imageView.image = [UIImage imageNamed:@"transparent.png"];
        
        ImageLoader *loader = [ImageLoader fromServer:server forItem:cellItem atIndex:indexPath];
        [loader setDelegate:(id<ImageLoaderDelegate> *)self];
        [loader load];
        
    }
    
}

- (void) showAlbums {

    __block ArtistViewController *this = self;
    
    mode = AV_MODE_ALBUMS;
    
    if ( albums == nil ) {
        [activityView setHidden:NO];
        [server getAlbumsForArtist:item
                onComplete:^(NSMutableArray *_albums) {
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
        [server getTracksForArtist:item
                onComplete:^(NSMutableArray *_tracks) {
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

- (void) showArtwork {

    ImageLoader *loader = [ImageLoader fromServer:server forItem:item atIndex:nil];
    [loader setDelegate:(id<ImageLoaderDelegate> *)self];
    [loader load];

}

- (void) imageDidLoad:(UIImage *)image atIndex:(NSIndexPath *)indexPath {
    
    if ( indexPath == nil ) {
        artworkImage.image = image;
    }
    
    else {
    
        MusicItem *cellItem = [albums objectAtIndex:indexPath.row];
        NSString *key = [NSString stringWithFormat:@"image-%@", cellItem.mid];
        
        [images setValue:image forKey:key];
        
        [self.musicTable reloadData];

    }
    
}

//
// Music item selected
//

- (void) tableView:(UITableView *) tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSMutableArray *items = mode == AV_MODE_ALBUMS ? albums : tracks;
    MusicItem *cellItem = [items objectAtIndex:[indexPath row]];
    
    if ( [cellItem isTrack] ) {
        
        int trackId = [[cellItem getId] intValue];
        
        [server getTrack:trackId onComplete:^(Track *track){
            [self.navigationController pushViewController:[PlayViewController viewForTrack:track server:server]
                                                 animated:YES];
        }];
        
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

- (void) dealloc {
    
    [item release];
    [server release];
    [nameLabel release];
    [artworkImage release];
    [modeButtons release];
    [albums release];
    [tracks release];
    [musicTable release];
    [activityView release];

    [super dealloc];
    
}

@end
