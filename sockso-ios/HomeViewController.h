
#import "SocksoServer.h"
#import "ServerViewController.h"

@interface HomeViewController : ServerViewController <UITabBarDelegate> {}

@property (nonatomic, retain) IBOutlet UIView *viewContainer;
@property (nonatomic, retain) IBOutlet UITabBar *tabBar;

@property (nonatomic, retain) NSArray *viewControllers;
@property (nonatomic, retain) UIViewController *activeViewController;

+ (HomeViewController *)initWithServer:(SocksoServer *)server;

@end
