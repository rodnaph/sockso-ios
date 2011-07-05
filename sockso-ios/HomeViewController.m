
#import "HomeViewController.h"
#import "MusicItem.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "JSON.h"
#import "SocksoServer.h"
#import "PlayViewController.h"
#import "MusicViewController.h"
#import "Track.h"

@implementation HomeViewController

@synthesize server, listContent;

- (void) viewDidLoad {
    
    self.title = server.title;
    
    if ( [self.title isEqualToString:@""] ) {
        self.title = server.tagline;
    }

    if ( [self.title isEqualToString:@""] ) {
        self.title = @"Sockso";
    }
    
}

//
// Create a view controller for the server
//

+ (HomeViewController *) viewForServer:(SocksoServer *)server {
    
    HomeViewController *aView = [[HomeViewController alloc]
                                 initWithNibName:@"HomeView"
                                 bundle:nil];
    
    aView.server = server;
    
    return [aView autorelease];
    
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
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellID];
    
	if ( cell == nil ) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellID] autorelease];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}
	
    MusicItem *item = [self.listContent objectAtIndex:indexPath.row];
	
	cell.textLabel.text = item.name;
        
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
    
    [server search:query
         onComplete:^(NSMutableArray *items) {
             [self showSearchResults:items];
         }
         onFailure:^{}];
    
}

//
// Informs the user their search failed
//

- (void) showSearchFailed {
    
    // @todo
    
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
            [self.navigationController pushViewController:[PlayViewController viewForTrack:track server:server]
                                                 animated:YES];
        }];
        
    }
    
    else {
        [self.navigationController pushViewController:[MusicViewController viewForItem:item] animated:YES];
    }
    
}


//
// dealloc
//

- (void) dealloc {
    
    [server release];
    [listContent release];
    
    [super dealloc];
    
}

@end

