
#import <CoreData/CoreData.h>
#import "ConnectViewController.h"
#import "SearchViewController.h"
#import "CommunityViewController.h"
#import "QuartzCore/CAAnimation.h"
#import "InfoViewController.h"
#import "Properties.h"
#import "LoginViewController.h"
#import "HomeViewController.h"

@interface ConnectViewController (Private)

- (void)showVersionNotSupported;
- (void)showBrowseCommunityFailed;
- (void)showAlertWithTitle:(NSString *)title andMessage:(NSString *)message;

@end

@implementation ConnectViewController

@synthesize serverInput=serverInput_,
            connect=connect_,
            community=community_,
            activity=activity_,
            context=context_,
            communityActivity=communityActivity_;

#pragma mark -
#pragma mark Init

- (void)dealloc {
    
    [serverInput_ release];
    [connect_ release];
    [community_ release];
    [activity_ release];
    [context_ release];
    [communityActivity_ release];
    
    [super dealloc];
    
}

#pragma mark -
#pragma mark View

- (void) viewDidLoad {
    
    [super viewDidLoad];

    self.title = @"Connect";
    
    [self initServerInput];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] init];
    item.title = @"Back";
    
    self.navigationItem.backBarButtonItem = item;
    
    activity_.hidden = YES;
    communityActivity_.hidden = YES;

}

//
// Initialise the server input with any previously saved value
//

- (void) initServerInput {
    
    Properties *prop = [Properties findByName:@"autosave.connectServer" from:context_];
    
    if ( prop != nil ) {
        serverInput_.text = prop.value;
    }
    
}


//
// Indicates if the keyboard input should hide
//

- (BOOL) textFieldShouldReturn:(UITextField *)textField {
    
    [serverInput_ resignFirstResponder];
    
    [self saveServerInput];
    
    return YES;
    
}

- (void) saveServerInput {
    
    [Properties createOrUpdateWithName:@"autosave.connectServer"
                andValue:serverInput_.text
                from:context_];
    
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
// Try and connect to the server specified in the server input field, if all
// goes well then show the home view for that server
//

- (IBAction) tryToConnect {

    __block ConnectViewController *this = self;
    
    SocksoServer *server = [SocksoServer disconnectedServer:[serverInput_ text]];
    
    [server connect:^{ [this hasConnectedTo:server]; }
          onFailure:^{ [this showConnectFailed]; }];
    
}

//
//  Need to check if server requires we login first
//

- (void) hasConnectedTo:(SocksoServer *)server {
    
    [self setControlsActive:YES];

    if ( ![server isSupportedVersion] ) {
        [self showVersionNotSupported];
        return;
    }
        
    if ( !server.requiresLogin ) {
        [self showHomeView:server];
        return;
    }

    // login required

    __block ConnectViewController *this = self;
        
    [server hasSession:^{
        [this showHomeView:server];
    } onFailure:^{
        LoginViewController *ctrl = [LoginViewController initWithServer:server];
        ctrl.delegate = (id <LoginHandlerDelegate> *) self;
        [this presentModalViewController:ctrl animated:YES];
    }];
    
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

    [activity_ setHidden:active];
    [activity_ startAnimating];
    
    [serverInput_ setEnabled:active];
    [community_ setEnabled:active];
    [connect_ setEnabled:active];

}

//
// A connection to a server failed
//

- (void) showConnectFailed {

    [self setControlsActive:YES];
    [self showAlertWithTitle:@"Connect Failed" 
                  andMessage:@"Connection failed, please check the address you entered"];

}

- (void)showVersionNotSupported {

    [self showAlertWithTitle:@"Unsupported Version"
                  andMessage:@"Sorry, but you need at least Sockso 1.5 for Sockso iOS"];
    
}

- (void)showBrowseCommunityFailed {

    [self showAlertWithTitle:@"Request Failed"
                  andMessage:@"Sorry, but the request for community servers failed.  Check your internet connection."];

}

- (void)showAlertWithTitle:(NSString *)title andMessage:(NSString *)message {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:@"Try again"
                                          otherButtonTitles:nil, nil];
    
    [alert show];
    [alert release];
    
}

//
// Show the home view for the server specified in the server input
//

- (void) showHomeView:(SocksoServer *) server {

    HomeViewController *homeController = [HomeViewController initWithServer:server];
    
    [self.navigationController pushViewController:homeController
                                         animated:YES];
    
}

- (void) loginOccurredTo:(SocksoServer *)server {
    
    [self showHomeView:server];
    
}

#pragma mark - Actions

- (IBAction)communityClicked {
    
    __block ConnectViewController *this = self;
    
    communityActivity_.hidden = NO;
    [communityActivity_ startAnimating];
    
    [SocksoServer findCommunityServers:^(NSMutableArray *servers) {
        
        communityActivity_.hidden = YES;
        [communityActivity_ stopAnimating];
        
        if ( [servers count] > 0 ) {
            [this showCommunityView:servers];
        }
        else {
            [this showNoCommunityServersFound];
        }
        
    } onFailure:^{
        [this showBrowseCommunityFailed];
    }];
    
}

- (IBAction)connectClicked {
    
    [self showConnecting];
    [self tryToConnect];
    
}

@end
