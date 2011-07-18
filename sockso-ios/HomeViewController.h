
#import "SocksoServer.h"

@interface HomeViewController : UIViewController {}

@property (nonatomic, retain) SocksoServer *server;
@property (nonatomic, retain) IBOutlet UIView *viewContainer;

+ (HomeViewController *)initWithServer:(SocksoServer *)server;

@end
