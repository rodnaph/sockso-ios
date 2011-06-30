
#import <Foundation/Foundation.h>
#import "MusicItem.h"
#import "AudioStreamer.h"

@interface SocksoServer : NSObject {
    NSString *ipAndPort, *title, *tagline;
    AudioStreamer *streamer;
}

@property (nonatomic, retain) NSString *ipAndPort, *title, *tagline;
@property (nonatomic, retain) AudioStreamer *streamer;

// not yet connected to sockso server
+ (SocksoServer *) disconnectedServer:(NSString *) ipAndPort;

// connected to a sockso server
+ (SocksoServer *) connectedServer:(NSString *) ipAndPort title:(NSString *) title tagline:(NSString *) tagline;

- (void) play:(MusicItem*) item;
- (void) play;

- (void) connect:(void (^)(void)) onConnect onFailure:(void (^)(void)) onFailure;

@end
