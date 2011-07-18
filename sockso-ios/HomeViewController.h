
#import "SocksoServer.h"

@interface HomeViewController : UIViewController <UITabBarDelegate> {}

@property (nonatomic, retain) SocksoServer *server;
@property (nonatomic, retain) IBOutlet UIView *viewContainer;
@property (nonatomic, retain) IBOutlet UITabBar *tabBar;

+ (HomeViewController *)initWithServer:(SocksoServer *)server;

@end
