
#import "CommunityViewController.h"
#import "HomeViewController.h"
#import "SocksoServer.h"
#import "LoginViewController.h"
#import "CommunityServerCell.h"
#import "SocksoPlayer.h"

@interface CommunityViewController (Private)

- (void)connectTo:(SocksoServer *)server;

- (void)showHomeView:(SocksoServer *)server;
- (void)showLoginView:(SocksoServer *)server;

@end

@implementation CommunityViewController

@synthesize servers=servers_;

#pragma mark -
#pragma mark Init

- (void)dealloc {
    
    [servers_ release];
    
    [super dealloc];
    
}

#pragma mark -
#pragma mark View

- (void) viewDidLoad {

    self.title = @"Community";

    currentServer = nil;
    
    [self.tableView reloadData];

}

- (void) viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    if ( currentServer != nil ) {
        [[currentServer player] stop];
    }
    
}

#pragma mark -
#pragma mark Table View

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
	return [servers_ count];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	static NSString *kCellID = @"cellID";
	
	CommunityServerCell *cell = (CommunityServerCell *) [tableView dequeueReusableCellWithIdentifier:kCellID];
    
	if ( cell == nil ) {
        NSArray *objects = [[NSBundle mainBundle] loadNibNamed:@"CommunityServerCellView"
                                                         owner:self
                                                       options:nil];
		cell = (CommunityServerCell *) [objects objectAtIndex:0];
	}
	
    SocksoServer *server = [servers_ objectAtIndex:indexPath.row];
	
    cell.padlockImage.hidden = !server.requiresLogin;
	cell.serverNameLabel.text = [NSString stringWithFormat:@"%@ - %@",
                                 server.title,
                                 server.tagline];
    
	return cell;
    
}

- (void)tableView:(UITableView *) tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SocksoServer *server = [servers_ objectAtIndex:[indexPath row]];
    
    [self connectTo:server];
    
}

- (void)showHomeView:(SocksoServer *)server {
    
    HomeViewController *homeView = [HomeViewController initWithServer:server];
    
    [self.navigationController pushViewController:homeView
                                         animated:YES];
    
}

- (void)loginOccurredTo:(SocksoServer *)server {
    
    [self showHomeView:server];
    
}

- (void)showLoginView:(SocksoServer *)server {

    LoginViewController *ctrl = [LoginViewController initWithServer:server];
    [ctrl setDelegate:(id <LoginHandlerDelegate> *)self];

    [self presentModalViewController:ctrl animated:YES];
    
}

- (void) connectTo:(SocksoServer *)server {

    currentServer = server;
    
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

@end
