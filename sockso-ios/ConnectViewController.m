
#import "ConnectViewController.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"

@implementation ConnectViewController

@synthesize server;
@synthesize connect;
@synthesize community;

- (BOOL) textFieldShouldReturn:(UITextField *)textField {
    [server resignFirstResponder];
    return YES;
}

- (IBAction) communityClicked {

    [self showCommunityList];
    
    server.text = @"Community!";
    
}

- (void) showCommunityList {

    NSURL *url = [NSURL URLWithString:@"http://sockso.pu-gh.com/community.html?format=json"];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setDelegate:self];
    [request startAsynchronous];

}

- (void) requestFinished: (ASIHTTPRequest *) request {
    
    NSLog( @"JSON: %@", [request responseString] );
    
}

- (IBAction) connectClicked {
    
    server.text = @"Connext!";
    
}

- (void) dealloc {
    [server release];
    [connect release];
    [super dealloc];
}

@end
