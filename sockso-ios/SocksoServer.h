
#import <Foundation/Foundation.h>
#import "MusicItem.h"
#import "AudioStreamer.h"
#import "JSON.h"

typedef enum {
    SS_MODE_STOPPED = 0,
    SS_MODE_PLAYING = 1,
    SS_MODE_PAUSED = 2
} SocksoServerMode;

@interface SocksoServer : NSObject {
    NSString *ipAndPort, *title, *tagline;
    AudioStreamer *streamer;
    SBJsonParser *parser;
    int mode;
}

@property (nonatomic, retain) NSString *ipAndPort, *title, *tagline;
@property (nonatomic, retain) AudioStreamer *streamer;
@property (nonatomic, retain) SBJsonParser *parser;
@property (nonatomic) int mode;

+ (SocksoServer *) disconnectedServer:(NSString *) ipAndPort;
+ (SocksoServer *) connectedServer:(NSString *) ipAndPort title:(NSString *) title tagline:(NSString *) tagline;

// playing musc stream

- (void) play:(MusicItem*) item;
- (void) play;
- (void) pause;

// connection and querying

- (void) connect:(void (^)(void)) onConnect onFailure:(void (^)(void)) onFailure;
- (void) search:(NSString *)query onConnect:(void (^)(NSMutableArray *))onConnect onFailure:(void (^)(void))onFailure;

// private

- (NSURL *) getSearchUrl:(NSString *)query;

@end
