
#import <Foundation/Foundation.h>
#import "SocksoServer.h"

@protocol LoginHandlerDelegate <NSObject>

- (void) loginOccurredTo:(SocksoServer *)server;

@end
