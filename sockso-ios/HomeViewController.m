
#import "HomeViewController.h"
#import "MusicItem.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "JSON.h"

@implementation HomeViewController

@synthesize listContent, serverInfo;

- (void) viewDidLoad {
    
    self.title = [serverInfo objectForKey:@"title"];
    self.listContent = [[NSMutableArray alloc] init];

    [self.tableView reloadData];
    
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

    NSLog( @"Item: %@", item.name );

	return cell;
    
}

//
// search button clicked, make search request
//

- (void) searchBarSearchButtonClicked:(UISearchBar *)searchBar {

    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[self getSearchUrl:searchBar]];
    
    [request setCompletionBlock:^{
        [self showSearchResults:[request responseString]];
        [self.searchDisplayController setActive:FALSE];
    }];
    
    [request setFailedBlock:^{
        [self showSearchFailed];
    }];
    
    [request startAsynchronous];
    
}

//
// returns the URL for a search query using the string in the searchbar
//

- (NSURL *) getSearchUrl:(UISearchBar *) searchBar {
        
    NSString *fullUrl = [NSString stringWithFormat:@"http://%@/json/search/%@",
                         [serverInfo objectForKey:@"ipAndPort"],
                         [searchBar text]];
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

@end
