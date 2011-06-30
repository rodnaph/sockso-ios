
#import <Foundation/Foundation.h>
#import "MusicItem.h"
#import "AudioStreamer.h"
#import "JSON.h"

@interface SocksoServer : NSObject {
    NSString *ipAndPort, *title, *tagline;
    AudioStreamer *streamer;
    SBJsonParser *parser;
}

@property (nonatomic, retain) NSString *ipAndPort, *title, *tagline;
@property (nonatomic, retain) AudioStreamer *streamer;
@property (nonatomic, retain) SBJsonParser *parser;

+ (SocksoServer *) disconnectedServer:(NSString *) ipAndPort;
+ (SocksoServer *) connectedServer:(NSString *) ipAndPort title:(NSString *) title tagline:(NSString *) tagline;

// playing musc stream

- (void) play:(MusicItem*) item;
- (void) play;

// connection and querying

- (void) connect:(void (^)(void)) onConnect onFailure:(void (^)(void)) onFailure;
- (void) search:(NSString *)query onConnect:(void (^)(NSMutableArray *))onConnect onFailure:(void (^)(void))onFailure;

// private

- (NSURL *) getSearchUrl:(NSString *)query;

@end
