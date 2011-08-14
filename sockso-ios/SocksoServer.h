
#import <Foundation/Foundation.h>
#import "MusicItem.h"
#import "AudioStreamer.h"
#import "JSON.h"
#import "Track.h"

typedef enum {
    SS_MODE_STOPPED = 0,
    SS_MODE_PLAYING = 1,
    SS_MODE_PAUSED = 2
} SocksoServerMode;

@interface SocksoServer : NSObject {
    AudioStreamer *streamer;
}

@property (nonatomic, retain) NSString *ipAndPort, *title, *tagline, *version;
@property (nonatomic) int mode;
@property (nonatomic) BOOL requiresLogin;

+ (SocksoServer *) disconnectedServer:(NSString *) ipAndPort;
+ (SocksoServer *) connectedServer:(NSString *) ipAndPort title:(NSString *) title tagline:(NSString *) tagline;

+ (void) findCommunityServers:(void (^)(NSMutableArray *))onComplete onFailure:(void (^)(void))onFailure;

- (BOOL) isSupportedVersion;

// playing musc stream

- (void)play:(MusicItem*) item;
- (void)play;
- (void)pause;
- (void)seekTo:(int)time;
- (int)duration;
- (BOOL)isPlaying;

// connection

- (void) connect:(void (^)(void)) onConnect onFailure:(void (^)(void)) onFailure;
- (void) loginWithName:(NSString *)name andPassword:(NSString *)password onSuccess:(void (^)(void))onSuccess onFailure:(void (^)(void))onFailure;
- (void) hasSession:(void (^)(void))onSuccess onFailure:(void (^)(void))onFailure;

// querying

- (void) search:(NSString *)query onComplete:(void (^)(NSMutableArray *))onComplete onFailure:(void (^)(void))onFailure;
- (void) getTrack:(int)trackId onComplete:(void (^)(Track *))onComplete;
- (void) getAlbumsForArtist:(MusicItem *)item onComplete:(void (^)(NSMutableArray *))onComplete onFailure:(void (^)(void))onFailure;
- (void) getTracksForArtist:(MusicItem *)item onComplete:(void (^)(NSMutableArray *))onComplete onFailure:(void (^)(void))onFailure;
- (void) getTracksForAlbum:(MusicItem *)item onComplete:(void (^)(NSMutableArray *))onComplete onFailure:(void (^)(void))onFailure;
- (void) getArtists:(void (^)(NSArray *))onComplete onFailure:(void (^)(void))onFailure;

- (NSURL *)getImageUrlForMusicItem:(MusicItem *)item;

// private

- (NSURL *) getSearchUrl:(NSString *)query;

- (void) getTracksForMusicItem:(MusicItem *)item onComplete:(void (^)(NSMutableArray *))onComplete onFailure:(void (^)(void))onFailure;

@end
