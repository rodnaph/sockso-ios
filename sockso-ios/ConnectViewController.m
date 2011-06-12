
#import "ConnectViewController.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "JSON.h"

@implementation ConnectViewController

@synthesize server;
@synthesize connect;
@synthesize community;

- (void) viewDidLoad {
    
    [super viewDidLoad];
    
    parser = [[SBJsonParser alloc] init];
    
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField {
    [server resignFirstResponder];
    return YES;
}

- (IBAction) communityClicked {
    [self showCommunityList];
}

- (void) showCommunityList {

    NSURL *url = [NSURL URLWithString:@"http://sockso.pu-gh.com/community.html?format=json"];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setDelegate:self];
    [request startAsynchronous];

}

- (void) requestFinished: (ASIHTTPRequest *) request {
    
    id json = [parser objectWithString:[request responseString]];
    
    NSLog( @"JSON: %@", json );
    
}

- (IBAction) connectClicked {
    
    server.text = @"Connext!";
    
}

- (void) dealloc {
    [server release];
    [connect release];
    [parser release];
    [super dealloc];
}

@end
