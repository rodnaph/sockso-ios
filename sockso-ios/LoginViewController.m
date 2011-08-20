
#import "LoginViewController.h"
#import "SocksoServer.h"
#import "LoginHandlerDelegate.h"

@interface LoginViewController (Private)

- (void)loginSuccess;
- (void)loginFailure;

@end

@implementation LoginViewController

@synthesize nameInput=nameInput_,
            passwordInput=passwordInput_,
            loginButton=loginButton_,
            server=server_,
            cancelButton=cancelButton_,
            delegate;

#pragma mark -
#pragma mark Init

- (void)dealloc {
    
    [nameInput_ release];
    [passwordInput_ release];
    [loginButton_ release];
    [server_ release];
    [cancelButton_ release];
    
    [super dealloc];
    
}

#pragma mark -
#pragma mark Helpers

+ (LoginViewController *)initWithServer:(SocksoServer *)server {
    
    LoginViewController *ctrl = [[LoginViewController alloc]
                                 initWithNibName:@"LoginView"
                                 bundle:nil];
    
    ctrl.server = server;
    ctrl.modalTransitionStyle = UIModalTransitionStylePartialCurl;

    return [ctrl autorelease];
    
}

#pragma mark -
#pragma mark Actions

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    
    return YES;
    
}

- (IBAction) loginClicked {
    
    __block LoginViewController *this = self;
    
    [server_ loginWithName:nameInput_.text
              andPassword:passwordInput_.text
                onSuccess:^{ [this loginSuccess]; }
                onFailure:^{ [this loginFailure]; }];
    
}

- (void)loginSuccess {
    
    [self dismissModalViewControllerAnimated:YES];
    [(id <LoginHandlerDelegate>)delegate loginOccurredTo:server_];
    
}

- (void)loginFailure {
    
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"Login Failed"
                          message:@"Sorry, your username and/or password were invalid"
                          delegate:nil
                          cancelButtonTitle:@"Try again"
                          otherButtonTitles:nil, nil];
    
    [alert show];
    [alert release];
    
}

- (void)cancelClicked {
    
    [self dismissModalViewControllerAnimated:YES];
    
}

@end
