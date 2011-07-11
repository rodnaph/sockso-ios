
#import "CommunityViewController.h"
#import "HomeViewController.h"
#import "SocksoServer.h"
#import "LoginViewController.h"

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
	
    SocksoServer *server = [self.servers objectAtIndex:indexPath.row];
	
	cell.textLabel.text = [NSString stringWithFormat:@"%@ - %@",
                           server.title,
                           server.tagline];
    
	return cell;
    
}

//
// When a row is selected show the server, no need to query for info as we've
// already got it from the community listing
//

- (void) tableView:(UITableView *) tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SocksoServer *server = [self.servers objectAtIndex:[indexPath row]];
    
    [self connectTo:server];
    
}

- (void) showHomeView:(SocksoServer *)server {
    
    [self.navigationController pushViewController:[HomeViewController viewForServer:server]
                                         animated:YES];
    
}

- (void) loginOccurredTo:(SocksoServer *)server {
    
    [self showHomeView:server];
    
}

- (void) showLoginView:(SocksoServer *)server {

    LoginViewController *ctrl = [LoginViewController initWithServer:server];
    [ctrl setDelegate:(id <LoginHandlerDelegate> *)self];

    [self presentModalViewController:ctrl animated:YES];
    
}

- (void) connectTo:(SocksoServer *)server {

    __block CommunityViewController *this = self;
    
    if ( [server requiresLogin] ) {
        [server hasSession:^{
            [this showHomeView:server];
        }
        onFailure:^{
            [this showLoginView:server];
        }];
    }
    
    else {
        [self showHomeView:server];
    }

}

- (void) dealloc {
    
    [servers release];
    
    [super dealloc];
    
}

@end
