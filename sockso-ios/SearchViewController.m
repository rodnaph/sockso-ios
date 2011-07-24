
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

//
// Create a view controller for the server
//

+ (SearchViewController *) viewForServer:(SocksoServer *)server {
    
    SearchViewController *aView = [[SearchViewController alloc]
                                   initWithNibName:@"SearchView"
                                   bundle:nil];
    
    aView.server = server;
    
    return [aView autorelease];
    
}

//
// dealloc
//

- (void) dealloc {
    
    [images release];
    [server release];
    [listContent release];
    [homeViewController release];
    
    [super dealloc];
    
}

#pragma mark -
#pragma mark View

- (void) viewDidLoad {
    
    images = [[NSMutableDictionary alloc] init];
    
    self.title = server.title;
    
    if ( [self.title isEqualToString:@""] ) {
        self.title = server.tagline;
    }

    if ( [self.title isEqualToString:@""] ) {
        self.title = @"Sockso";
    }
    
}

//
// return the number of rows in the list
//

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
	return [self.listContent count];

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
	    
    MusicItem *item = [self.listContent objectAtIndex:indexPath.row];
	
    [cell drawForItem:item];
    
    if ( [item isAlbum] || [item isArtist] ) {
        cell.artworkImage.imageURL = [server getImageUrlForMusicItem:item];
    }
    
    else {
        cell.actionImage.image = [UIImage imageNamed:@"play.png"];
    }
    
	return cell;
    
}

//
// search button clicked, make search request
//

- (void) searchBarSearchButtonClicked:(UISearchBar *)searchBar {

    [searchBar resignFirstResponder];
    
    [self performSearch:[searchBar text]];
    
}

//
//  perform a search with the specified text
//

- (void) performSearch:(NSString *)query {
    
    __block SearchViewController *this = self;
    
    [server search:query
         onComplete:^(NSMutableArray *items) {
             [this showSearchResults:items];
         }
         onFailure:^{ [this showSearchFailed]; }];
    
}

//
// Informs the user their search failed
//

- (void) showSearchFailed {
    
    // @todo
    
    NSLog( @"Search failed..." );
    
}

//
// puts search result data into listContent then reloads the table
//

- (void) showSearchResults:(NSMutableArray *) items {
        
    self.listContent = items;
    
    [self.tableView reloadData];
    
}

//
// Music item selected
//

- (void) tableView:(UITableView *) tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    MusicItem *item = [self.listContent objectAtIndex:[indexPath row]];
    
    if ( [item isTrack] ) {
        
        int trackId = [[item.mid substringFromIndex:2] intValue];
        
        [server getTrack:trackId onComplete:^(Track *track){
            [self.homeViewController.navigationController pushViewController:[PlayViewController viewForTrack:track server:server]
                                                 animated:YES];
        }];
        
    }
    
    else if ( [item isArtist] ) {
        ArtistViewController *ctrl = [ArtistViewController initWithItem:item forServer:server];
        [self.homeViewController.navigationController pushViewController:ctrl animated:YES];
    }
    
    else if ( [item isAlbum] ) {
        AlbumViewController *ctrl = [AlbumViewController initWithItem:item forServer:server];
        [self.homeViewController.navigationController pushViewController:ctrl animated:YES];
    }
    
    else {
        NSLog( @"NOT YET IMPLEMENTED" );
    }
    
}

@end

