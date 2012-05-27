
#import "HomeViewController.h"
#import "SearchViewController.h"
#import "ArtistsViewController.h"
#import "HomeViewDelegate.h"

@interface HomeViewController ()

- (NSArray *)createViewControllers;
- (void)showViewControllerAtIndex:(int)index;

@end

@implementation HomeViewController

@synthesize viewControllers=viewControllers_,
            activeViewController=activeViewController_,
            viewContainer=viewContainer_,
            tabBar=tabBar_;

#pragma mark -
#pragma mark Init

- (void)dealloc {
    
    [viewControllers_ release];
    [tabBar_ release];
    [viewContainer_ release];
    
    [super dealloc];
    
}

#pragma mark -
#pragma mark Helpers

+ (HomeViewController *)initWithServer:(SocksoServer *)server {
    
    HomeViewController *homeView = [[HomeViewController alloc]
                                    initWithNibName:@"HomeView"
                                    bundle:nil];
    
    homeView.server = server;
    
    return [homeView autorelease];
    
}

#pragma mark -
#pragma mark View

- (void)viewDidLoad {
    
    self.viewControllers = [self createViewControllers];
    
    [self showViewControllerAtIndex:1];
    
}

- (NSArray *)createViewControllers {
    
    SearchViewController *searchView = [SearchViewController viewForServer:self.server];
    ArtistsViewController *artistsView = [ArtistsViewController viewForServer:self.server];
    
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

#pragma mark -
#pragma mark Tab Bar

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    
    [self showViewControllerAtIndex:item.tag];
    
}

@end
