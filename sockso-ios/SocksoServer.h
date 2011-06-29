
#import <Foundation/Foundation.h>
#import "MusicItem.h"

@interface SocksoServer : NSObject {
    NSString *ipAndPort, *title, *tagline;
}

@property (nonatomic, retain) NSString *ipAndPort, *title, *tagline;

+ (SocksoServer *) fromData:(NSString *) ipAndPort title:(NSString *) title tagline:(NSString *) tagline;

- (void) play:(MusicItem*) item;
- (void) play;

@end
