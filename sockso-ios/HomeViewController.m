
#import "HomeViewController.h"
#import "SearchViewController.h"
#import "ArtistsViewController.h"
#import "HomeViewDelegate.h"

@interface HomeViewController ()

@property (nonatomic, retain) NSArray *viewControllers;
@property (nonatomic, retain) UIViewController *activeViewController;

- (NSArray *)createViewControllers;
- (void)showViewControllerAtIndex:(int)index;

@end

@implementation HomeViewController

@synthesize server, viewControllers, activeViewController, viewContainer;

+ (HomeViewController *)initWithServer:(SocksoServer *)server {
    
    HomeViewController *homeView = [[HomeViewController alloc]
                                    initWithNibName:@"HomeView"
                                    bundle:nil];
    
    homeView.server = server;
    
    return [homeView autorelease];

}

- (void)viewDidLoad {
    
    self.viewControllers = [self createViewControllers];
    
    [self showViewControllerAtIndex:0];
    
}

- (NSArray *)createViewControllers {
    
    SearchViewController *searchView = [SearchViewController viewForServer:server];
    ArtistsViewController *artistsView = [ArtistsViewController viewForServer:server];
    
    return [NSArray arrayWithObjects:searchView, artistsView, nil];

}

- (void)showViewControllerAtIndex:(int)index {
    
    if (self.activeViewController) {
        [self.activeViewController viewWillDisappear:NO];
        [self.activeViewController.view removeFromSuperview];
        [self.activeViewController viewDidDisappear:NO];
    }
    
    self.activeViewController = [self.viewControllers objectAtIndex:index];
    self.activeViewController.view.frame = self.viewContainer.frame;
    [(id <HomeViewDelegate>)self.activeViewController setHomeViewController:self];
    
    [self.activeViewController viewWillAppear:NO];
    [self.viewContainer addSubview:self.activeViewController.view];
    [self.activeViewController viewDidAppear:NO];    
    
}

- (void)dealloc {
    
    [server release];
    [viewControllers release];
    [activeViewController release];
    
    [super dealloc];
    
}

@end
