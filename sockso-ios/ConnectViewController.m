
#import "ConnectViewController.h"
#import "ASIHTTPRequest.h"
#import "JSON.h"
#import "HomeViewController.h"
#import "CommunityViewController.h"
#import "QuartzCore/CAAnimation.h"

@implementation ConnectViewController

@synthesize server, connect, community, activity, connectFailed;

//
// Handler for view load time
//

- (void) viewDidLoad {
    
    [super viewDidLoad];
    
    parser = [[SBJsonParser alloc] init];
    
}

//
// Indicates if the keyboard inout should hide
//

- (BOOL) textFieldShouldReturn:(UITextField *)textField {
    
    [server resignFirstResponder];
    
    return YES;
    
}

//
// Handler for when community button is clicked
//

- (IBAction) communityClicked {

    [self fetchCommunityList];

}

//
// Fetch community servers
//

- (void) fetchCommunityList {

    NSURL *url = [NSURL URLWithString:@"http://sockso.pu-gh.com/community.html?format=json"];
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setCompletionBlock:^{
        NSArray *servers = [self getCommunityServers:[request responseString]];
        [self showCommunityPage:servers];
    }];
    [request startAsynchronous];
    
}

//
// Parse the JSON to retrieve a list of community servers
//

- (NSArray *) getCommunityServers:(NSString *) serverJson {
    
    return [parser objectWithString:serverJson];
    
}

//
// Show the community page with the specified selection of servers
//

- (void) showCommunityPage:(NSArray *) servers {
    
    CommunityViewController *aView = [[CommunityViewController alloc]
                                      initWithNibName:@"CommunityView"
                                      bundle:nil];
    
    aView.servers = servers;
    
    [self.navigationController pushViewController:aView animated:YES];
    [aView release];

}

//
// Connect clicked, try and connect to specified server
//

- (IBAction) connectClicked {
    
    [self showConnecting];
    [self tryToConnect];
    
}

//
// Try and connect to the server specified in the server input field, if all
// goes well then show the home view for that server
//

- (IBAction) tryToConnect {

    NSString *fullUrl = [NSString stringWithFormat:@"http://%@/json/serverinfo", [server text]];
    NSURL *url = [NSURL URLWithString:fullUrl];

    NSLog( @"Connecting to server at: %@", fullUrl );
    
    __block ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    
    [request setCompletionBlock:^{
        NSDictionary *serverInfo = [parser objectWithString:[request responseString]];
        [self showHomeView:serverInfo];
    }];
    
    [request setFailedBlock:^{
        [self showConnectFailed];
    }];
    
    [request startAsynchronous];
    
}

//
// Change the display to disable controls as we're trying to connect to a server
//

- (void) showConnecting {
    
    [self setControlsActive:NO];
    
}

//
// Sets the controls to be active/inactive for when we're either trying to connect
// to a server, or allowing the user to input the server address
//

- (void) setControlsActive:(BOOL) active {

    [activity setHidden:active];
    [activity startAnimating];
    
    [server setEnabled:active];
    [community setEnabled:active];
    [connect setEnabled:active];

}

//
// A connection to a server failed
//

- (void) showConnectFailed {
    
    connectFailed.alpha = 0;
    [connectFailed setHidden:NO];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    [UIView setAnimationDuration:0.5f];
    connectFailed.alpha = 1;
    [UIView setAnimationDidStopSelector:@selector(showLabelAnimationDidStop:finished:)];
    [UIView commitAnimations];
    
    [self setControlsActive:YES];
    
}

- (void)showLabelAnimationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag {

    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    [UIView setAnimationDuration:1.0f];
    connectFailed.alpha = 0;
    [UIView commitAnimations];

}

//
// Show the home view for the server specified in the server input
//

- (void) showHomeView:(NSDictionary *) serverInfo {
    
    [self setControlsActive:YES];
    
    [serverInfo setValue:[server text] forKey:@"ipAndPort"];
    
    SocksoServer *socksoServer = [SocksoServer fromData:[server text]
                                                  title:[serverInfo objectForKey:@"title"]
                                                tagline:[serverInfo objectForKey:@"tagline"]];
    
    [self.navigationController pushViewController:[HomeViewController viewForServer:socksoServer]
                                         animated:TRUE];
    
}

//
// dealloc
//

- (void) dealloc {
    
    [server release];
    
    [super dealloc];
    
}

@end
