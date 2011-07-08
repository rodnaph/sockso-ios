
#import <CoreData/CoreData.h>
#import "ConnectViewController.h"
#import "HomeViewController.h"
#import "CommunityViewController.h"
#import "QuartzCore/CAAnimation.h"
#import "CommunityServer.h"
#import "InfoViewController.h"
#import "Properties.h"

@implementation ConnectViewController

@synthesize serverInput, connect, community, activity, connectFailed, context;

//
// Handler for view load time
//

- (void) viewDidLoad {
    
    [super viewDidLoad];

    self.title = @"Connect";
    
    [self initServerInput];
    
}

//
// Initialise the server input with any previously saved value
//

- (void) initServerInput {
    
    Properties *prop = [Properties findByName:@"autosave.connectServer" from:context];
    
    if ( prop != nil ) {
        serverInput.text = prop.value;
    }
    
}

//
// Indicates if the keyboard input should hide
//

- (BOOL) textFieldShouldReturn:(UITextField *)textField {
    
    [serverInput resignFirstResponder];
    
    [self saveServerInput];
    
    return YES;
    
}

- (void) saveServerInput {
    
    [Properties createOrUpdateWithName:@"autosave.connectServer"
                andValue:serverInput.text
                from:context];
    
}

//
// Handler for when community button is clicked
//

- (IBAction) communityClicked {

    [CommunityServer fetchAll:^(NSMutableArray *servers) {
        if ( [servers count] > 0 ) {
            [self showCommunityView:servers];
        }
        else {
            [self showNoCommunityServersFound];
        }
    }];

}

//
// Shows the user a view informing them no community servers were found
//

- (void) showNoCommunityServersFound {
    
    NSString *message = @"Sorry, but no community servers that support Sockso iOS are currently online :(";

    [self presentModalViewController:[InfoViewController initWithString:message]
                            animated:YES];
    
}

//
// Show the community page with the specified selection of servers
//

- (void) showCommunityView:(NSMutableArray *) servers {
    
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

    SocksoServer *server = [SocksoServer disconnectedServer:[serverInput text]];
    
    [server connect:^{ [self showHomeView:server]; }
          onFailure:^{ [self showConnectFailed]; }];
    
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
    
    [serverInput setEnabled:active];
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

- (void) showHomeView:(SocksoServer *) server {
    
    [self setControlsActive:YES];
    [self.navigationController pushViewController:[HomeViewController viewForServer:server]
                                         animated:TRUE];
    
}

- (void) dealloc {
    
    [serverInput release];
    [connect release];
    [community release];
    [activity release];
    [connectFailed release];
    
    [super dealloc];
    
}

@end
