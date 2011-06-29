
#import "CommunityViewController.h"
#import "HomeViewController.h"

@implementation CommunityViewController

@synthesize servers;

- (void) viewDidLoad {

    self.title = @"Community";
    
    [self.tableView reloadData];

}

//
// return the number of rows in the list
//

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
	return [self.servers count];
    
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
	
    NSDictionary *server = [self.servers objectAtIndex:indexPath.row];
	
	cell.textLabel.text = [NSString stringWithFormat:@"%@ - %@",
                           [server objectForKey:@"title"],
                           [server objectForKey:@"tagline"]];
    
	return cell;
    
}

//
// When a row is selected show the server, no need to query for info as we've
// already got it from the community listing
//

- (void) tableView:(UITableView *) tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *server = [self.servers objectAtIndex:[indexPath row]];
    
    HomeViewController *aView = [[HomeViewController alloc]
                                 initWithNibName:@"HomeView"
                                 bundle:nil];

    aView.serverInfo = server;
    
    [self.navigationController pushViewController:aView animated:YES];
    
    [aView release];
    
}

@end
