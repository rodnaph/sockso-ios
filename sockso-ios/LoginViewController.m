
#import "LoginViewController.h"
#import "SocksoServer.h"

@implementation LoginViewController

@synthesize nameInput, passwordInput, loginButton, server;

+ (LoginViewController *) initWithServer:(SocksoServer *)server {
    
    LoginViewController *ctrl = [[LoginViewController alloc]
                                 initWithNibName:@"LoginView"
                                 bundle:nil];
    
    ctrl.server = server;
    
    return [ctrl autorelease];
    
}

- (IBAction) loginClicked {
    
    NSLog( @"Login clicked!" );
    
}

- (void) dealloc {
    
    [nameInput release];
    [passwordInput release];
    [loginButton release];
    [server release];
    
    [super dealloc];
    
}

@end
