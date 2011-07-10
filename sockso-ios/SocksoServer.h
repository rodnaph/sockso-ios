
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

@property (nonatomic, retain) NSString *ipAndPort, *title, *tagline;
@property (nonatomic) int mode;
@property (nonatomic) BOOL requiresLogin;

+ (SocksoServer *) disconnectedServer:(NSString *) ipAndPort;
+ (SocksoServer *) connectedServer:(NSString *) ipAndPort title:(NSString *) title tagline:(NSString *) tagline;

// playing musc stream

- (void) play:(MusicItem*) item;
- (void) play;
- (void) pause;

// connection

- (void) connect:(void (^)(void)) onConnect onFailure:(void (^)(void)) onFailure;
- (void) loginWithName:(NSString *)name andPassword:(NSString *)password onSuccess:(void (^)(void))onSuccess onFailure:(void (^)(void))onFailure;
- (BOOL) hasSession;

// querying

- (void) search:(NSString *)query onComplete:(void (^)(NSMutableArray *))onComplete onFailure:(void (^)(void))onFailure;
- (void) getTrack:(int)trackId onComplete:(void (^)(Track *))onComplete;
- (void) getAlbumsForArtist:(MusicItem *)item onComplete:(void (^)(NSMutableArray *))onComplete onFailure:(void (^)(void))onFailure;
- (void) getTracksForArtist:(MusicItem *)item onComplete:(void (^)(NSMutableArray *))onComplete onFailure:(void (^)(void))onFailure;
- (void) getTracksForAlbum:(MusicItem *)item onComplete:(void (^)(NSMutableArray *))onComplete onFailure:(void (^)(void))onFailure;

// private

- (NSURL *) getSearchUrl:(NSString *)query;

- (void) getTracksForMusicItem:(MusicItem *)item onComplete:(void (^)(NSMutableArray *))onComplete onFailure:(void (^)(void))onFailure;

@end
