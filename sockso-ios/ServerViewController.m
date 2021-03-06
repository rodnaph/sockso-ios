
#import "ServerViewController.h"
#import "PlayViewController.h"
#import "SocksoPlayer.h"
#import "SocksoServer.h"

@interface ServerViewController (Private)

- (void)didClickCurrentlyPlayingButton;

@end

@implementation ServerViewController

@synthesize server=server_;

#pragma mark - View Methods

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    if ( [server_.player isPlaying] || [server_.player isPaused] ) {
        
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

#pragma mark - Methods

- (void)didClickCurrentlyPlayingButton {
    
    PlayViewController *playView = [PlayViewController viewForServer:server_];
    
    [self.navigationController pushViewController:playView animated:YES];
    
}

@end
