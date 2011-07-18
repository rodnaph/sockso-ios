
#import "ArtistsViewController.h"
#import "SocksoServer.h"

@implementation ArtistsViewController

@synthesize artistsTable, server, homeViewController;

+ (ArtistsViewController *) viewForServer:(SocksoServer *)server {
    
    ArtistsViewController *ctrl = [[ArtistsViewController alloc]
                                   initWithNibName:@"ArtistsView"
                                   bundle:nil];
    
    ctrl.server = server;
    
    return [ctrl autorelease];
    
}

- (void) viewDidLoad {
    
    [self loadArtists];
    
}

- (void) loadArtists {
    
    // check database for artists, if there are none then load them via ajax
    
}

- (int) numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 0;
    
}

- (int) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 0;
    
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return nil;
    
}

- (void) dealloc {
    
    [artistsTable release];
    [server release];
    [artists release];
    [homeViewController release];
    
    [super dealloc];
    
}

@end
