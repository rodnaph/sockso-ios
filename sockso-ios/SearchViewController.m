
#import "SearchViewController.h"
#import "MusicItem.h"
#import "SocksoServer.h"
#import "SocksoPlayer.h"
#import "PlayViewController.h"
#import "Track.h"
#import "MusicCell.h"
#import "ArtistViewController.h"
#import "AlbumViewController.h"
#import "EGOImageView.h"
#import "HomeViewController.h"

@interface SearchViewController (Private)

- (void)showSearchResults:(NSArray *)items;
- (void)showSearchFailed;

- (void)performSearch:(NSString *)query;

@end

@implementation SearchViewController

@synthesize server=server_,
            listContent=listContent_,
            homeViewController=homeViewController_;

#pragma mark -
#pragma mark Init

- (void)dealloc {

    [server_ release];
    [listContent_ release];
    [homeViewController_ release];
    
    [super dealloc];
    
}

#pragma mark -
#pragma mark Helpers

+ (SearchViewController *)viewForServer:(SocksoServer *)server {
    
    SearchViewController *aView = [[SearchViewController alloc]
                                   initWithNibName:@"SearchView"
                                   bundle:nil];
    
    aView.server = server;
    
    return [aView autorelease];
    
}

#pragma mark -
#pragma mark View

- (void)viewDidAppear:(BOOL)animated {
    
    self.homeViewController.title = @"Search";
    
}

#pragma mark -
#pragma mark TableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
	return [listContent_ count];

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
	    
    MusicItem *item = [listContent_ objectAtIndex:indexPath.row];

    [cell drawForItem:item fromServer:server_];
    
	return cell;
    
}

- (void)tableView:(UITableView *) tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MusicItem *item = [listContent_ objectAtIndex:[indexPath row]];
    
    if ( [item isTrack] ) {
        
        [server_.player playTrack:(Track *)item];
        
        PlayViewController *playView = [PlayViewController viewForServer:server_];
        
        [self.homeViewController.navigationController pushViewController:playView
                                                                animated:YES];

    }
    
    else if ( [item isArtist] ) {
        
        ArtistViewController *ctrl = [ArtistViewController initWithItem:item
                                                              forServer:server_];
        
        [self.homeViewController.navigationController pushViewController:ctrl
                                                                animated:YES];
        
    }
    
    else if ( [item isAlbum] ) {
        
        AlbumViewController *ctrl = [AlbumViewController initWithItem:item
                                                            forServer:server_];
        
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
    
    [server_ search:query
         onComplete:^(NSArray *items) {
             [this showSearchResults:items];
         }
         onFailure:^{ [this showSearchFailed]; }];
    
}

- (void)showSearchFailed {
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Search Failed"
                                                        message:@"Sorry, but the search failed"
                                                       delegate:self
                                              cancelButtonTitle:@"Try again"
                                              otherButtonTitles:nil, nil];
    
    [alertView show];
    [alertView release];
    
}

- (void)showSearchResults:(NSArray *) items {
        
    self.listContent = items;
    
    [self.tableView reloadData];
    
}

@end

