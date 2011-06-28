
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
    
    NSString *baseUrl = @"http://192.168.0.2:4444/json/search/";
    NSString *fullUrl = [baseUrl stringByAppendingString:[searchBar text]];
    NSURL *url = [NSURL URLWithString:fullUrl];
 
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setDelegate:self];
    [request startAsynchronous];
    
}

//
// search request returned
//

- (void) requestFinished: (ASIHTTPRequest *) request {
    
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSArray *results = [parser objectWithString:[request responseString]];

    [self.listContent removeAllObjects];
    
    for ( NSDictionary *result in results ) {
        MusicItem *item = [MusicItem
                           itemWithName:[result objectForKey:@"id"]
                           name:[result objectForKey:@"name"]];
        [self.listContent addObject:item];
    }

    NSLog( @"Call Reload" );
    
    [self.tableView reloadData];
    [self.searchDisplayController setActive:FALSE];
    
    [parser release];
    
}


- (BOOL) searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    
    return YES;
    
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption {
    
    return YES;
    
}

@end
