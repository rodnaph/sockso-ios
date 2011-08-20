
#import "MusicItem.h"
#import "AudioStreamer.h"
#import "JSON.h"
#import "Track.h"

@class SocksoApi, SocksoPlayer;

@interface SocksoServer : NSObject {
    AudioStreamer *streamer;
}

@property (nonatomic, retain) SocksoPlayer *player;
@property (nonatomic, retain) SocksoApi *api;

@property (nonatomic, retain) NSString *ipAndPort, *title, *tagline, *version;
@property (nonatomic) BOOL requiresLogin;

+ (SocksoServer *)disconnectedServer:(NSString *) ipAndPort;
+ (SocksoServer *)connectedServer:(NSString *) ipAndPort title:(NSString *) title tagline:(NSString *) tagline;

+ (void)findCommunityServers:(void (^)(NSMutableArray *))onComplete onFailure:(void (^)(void))onFailure;

- (BOOL) isSupportedVersion;

// connection

- (void) connect:(void (^)(void)) onConnect onFailure:(void (^)(void)) onFailure;
- (void) loginWithName:(NSString *)name andPassword:(NSString *)password onSuccess:(void (^)(void))onSuccess onFailure:(void (^)(void))onFailure;
- (void) hasSession:(void (^)(void))onSuccess onFailure:(void (^)(void))onFailure;

// querying

- (void) search:(NSString *)query onComplete:(void (^)(NSMutableArray *))onComplete onFailure:(void (^)(void))onFailure;

- (NSURL *)getImageUrlForMusicItem:(MusicItem *)item;
- (NSURL *)getSearchUrl:(NSString *)query;

@end
