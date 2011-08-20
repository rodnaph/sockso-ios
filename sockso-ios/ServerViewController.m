
#import "ServerViewController.h"
#import "PlayViewController.h"

@interface ServerViewController (Private)

- (void)didClickCurrentlyPlayingButton;

@end

@implementation ServerViewController

@synthesize server=server_;

#pragma mark -
#pragma mark Init

- (void)dealloc {
    
    [server_ release];
    
    [super dealloc];
    
}

#pragma mark -
#pragma mark View

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    if ( [server_.player isPlaying] ) {
        
        UIBarButtonItem *playIcon = [[UIBarButtonItem alloc] initWithTitle:@"Playing"
                                                                     style:UIBarButtonItemStylePlain
                                                                    target:self
                                                                    action:@selector(didClickCurrentlyPlayingButton)];
        
        self.navigationItem.rightBarButtonItem = playIcon;
        [playIcon release];
        
    }
    
    else {
        self.navigationItem.rightBarButtonItem = nil;
    }
    
}

#pragma mark -
#pragma mark Methods

- (void)didClickCurrentlyPlayingButton {
    
    PlayViewController *playView = [PlayViewController viewForServer:server_];
    
    [self.navigationController pushViewController:playView animated:YES];
    
}

@end
