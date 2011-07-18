
#import "SocksoServer.h"

@interface HomeViewController : UIViewController {}

@property (nonatomic, retain) SocksoServer *server;

+ (HomeViewController *)initWithServer:(SocksoServer *)server;

@end
