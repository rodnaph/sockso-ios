
#import "HomeViewController.h"
#import "MusicItem.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "JSON.h"
#import "SocksoServer.h"
#import "PlayViewController.h"

@implementation HomeViewController

@synthesize listContent, server;

- (void) viewDidLoad {
    
    self.title = server.title;
    self.listContent = [[NSMutableArray alloc] init];

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

- (void) performSearch:(NSString *)searchText {
    
    NSURL *url = [self getSearchUrl:searchText];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    
    [request setCompletionBlock:^{
        [self showSearchResults:[request responseString]];
    }];
    
    [request setFailedBlock:^{
        [self showSearchFailed];
    }];
    
    [request startAsynchronous];
    
}

//
// returns the URL for a search query using the string in the searchbar
//

- (NSURL *) getSearchUrl:(NSString *) searchText {
        
    NSString *fullUrl = [NSString stringWithFormat:@"http://%@/json/search/%@",
                         server.ipAndPort,
                         searchText];
    NSURL *url = [NSURL URLWithString:fullUrl];

    NSLog( @"Search Query URL: %@", fullUrl );

    return url;

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

- (void) showSearchResults:(NSString *) resultData {
    
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSArray *results = [parser objectWithString:resultData];

    [self parseSearchResults:results];
    [self.tableView reloadData];

    [parser release];
    
}

//
// parses search results to repopulate list contents with MusicItem objects
//

- (void) parseSearchResults:(NSArray *) results {
    
    [self.listContent removeAllObjects];
    
    for ( NSDictionary *result in results ) {
        
        MusicItem *item = [MusicItem
                           itemWithName:[result objectForKey:@"id"]
                           name:[result objectForKey:@"name"]];
        
        [self.listContent addObject:item];
        
    }

}

//
// Music item selected
//

- (void) tableView:(UITableView *) tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    MusicItem *item = [listContent objectAtIndex:[indexPath row]];
    PlayViewController *aView = [PlayViewController viewForTrack:item server:server];
    
    [self.navigationController pushViewController:aView animated:YES];
    
}


//
// dealloc
//

- (void) dealloc {
    
    [listContent release];
    
    [super dealloc];
    
}

@end

