
#import "LoginViewController.h"
#import "SocksoServer.h"

@implementation LoginViewController

@synthesize nameInput, passwordInput, loginButton, server, cancelButton;

+ (LoginViewController *) initWithServer:(SocksoServer *)server {
    
    LoginViewController *ctrl = [[LoginViewController alloc]
                                 initWithNibName:@"LoginView"
                                 bundle:nil];
    
    ctrl.server = server;
    ctrl.modalTransitionStyle = UIModalTransitionStylePartialCurl;

    return [ctrl autorelease];
    
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    
    return YES;
    
}

- (IBAction) loginClicked {
    
    __block LoginViewController *this = self;
    
    [server loginWithName:nameInput.text
              andPassword:passwordInput.text
                onSuccess:^{ [this loginSuccess]; }
                onFailure:^{ [this loginFailure]; }];
    
}

- (void) loginSuccess {
    
    
    
}

- (void) loginFailure {
    
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"Login Failed"
                          message:@"Sorry, your username and/or password were invalid"
                          delegate:nil
                          cancelButtonTitle:@"Try again"
                          otherButtonTitles:nil, nil];
    
    [alert show];
    [alert release];
    
}

- (void) cancelClicked {
    
    [self dismissModalViewControllerAnimated:YES];
    
}

- (void) dealloc {
    
    [nameInput release];
    [passwordInput release];
    [loginButton release];
    [server release];
    [cancelButton release];
    
    [super dealloc];
    
}

@end
