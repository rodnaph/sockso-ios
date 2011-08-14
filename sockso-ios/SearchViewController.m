
#import "SearchViewController.h"
#import "MusicItem.h"
#import "SocksoServer.h"
#import "PlayViewController.h"
#import "Track.h"
#import "MusicCell.h"
#import "ArtistViewController.h"
#import "AlbumViewController.h"
#import "EGOImageView.h"

@implementation SearchViewController

@synthesize server, listContent, homeViewController;

#pragma mark -
#pragma mark Init

- (void) dealloc {

    [images release];
    [server release];
    [listContent release];
    [homeViewController release];
    
    [super dealloc];
    
}

#pragma mark -
#pragma mark Helpers

+ (SearchViewController *) viewForServer:(SocksoServer *)server {
    
    SearchViewController *aView = [[SearchViewController alloc]
                                   initWithNibName:@"SearchView"
                                   bundle:nil];
    
    aView.server = server;
    
    return [aView autorelease];
    
}

#pragma mark -
#pragma mark View

- (void) viewDidLoad {
    
    images = [[NSMutableDictionary alloc] init];
    
}

- (void)viewDidAppear:(BOOL)animated {
    
    self.homeViewController.title = @"Search";
    
}

#pragma mark -
#pragma mark TableView

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
	return [self.listContent count];

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
	    
    MusicItem *item = [self.listContent objectAtIndex:indexPath.row];

    [cell drawForItem:item];

    if ( [item isAlbum] || [item isArtist] ) {
        cell.artworkImage.imageURL = [server getImageUrlForMusicItem:item];
    }
    
    else if ( [item isTrack] ) {
        Track *track = (Track *) item;
        cell.artworkImage.imageURL = [server getImageUrlForMusicItem:track.album];
        cell.actionImage.image = [UIImage imageNamed:@"play.png"];
    }
    
	return cell;
    
}

- (void) tableView:(UITableView *) tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog( @"Select" );
    
    MusicItem *item = [self.listContent objectAtIndex:[indexPath row]];
    
    if ( [item isTrack] ) {
        
        PlayViewController *playView = [PlayViewController viewForTrack:(Track *)item
                                                                 server:server];
        
        [self.homeViewController.navigationController pushViewController:playView
                                                                animated:YES];

    }
    
    else if ( [item isArtist] ) {
        
        ArtistViewController *ctrl = [ArtistViewController initWithItem:item
                                                              forServer:server];
        
        [self.homeViewController.navigationController pushViewController:ctrl
                                                                animated:YES];
        
    }
    
    else if ( [item isAlbum] ) {
        
        AlbumViewController *ctrl = [AlbumViewController initWithItem:item
                                                            forServer:server];
        
        [self.homeViewController.navigationController pushViewController:ctrl
                                                                animated:YES];
        
    }
    
}

#pragma mark -
#pragma mark Search Bar

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {

    [searchBar resignFirstResponder];
    
    [self performSearch:[searchBar text]];
    
}

- (void)performSearch:(NSString *)query {
    
    __block SearchViewController *this = self;
    
    [server search:query
         onComplete:^(NSMutableArray *items) {
             [this showSearchResults:items];
         }
         onFailure:^{ [this showSearchFailed]; }];
    
}

- (void)showSearchFailed {
    
    // @todo
    
    NSLog( @"Search failed..." );
    
}

- (void)showSearchResults:(NSMutableArray *) items {
        
    self.listContent = items;
    
    [self.tableView reloadData];
    
}

@end

