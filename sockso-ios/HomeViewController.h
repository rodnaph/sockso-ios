
#import "SocksoServer.h"

@interface HomeViewController : UIViewController <UITabBarDelegate> {}

@property (nonatomic, retain) IBOutlet UIView *viewContainer;
@property (nonatomic, retain) IBOutlet UITabBar *tabBar;

@property (nonatomic, retain) SocksoServer *server;
@property (nonatomic, retain) NSArray *viewControllers;
@property (nonatomic, retain) UIViewController *activeViewController;

+ (HomeViewController *)initWithServer:(SocksoServer *)server;

@end
