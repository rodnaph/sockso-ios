
@class SocksoServer, Artist, Album, Track, AudioStreamer;

typedef enum {
    SP_NONE = 0,
    SP_STOPPED,
    SP_PLAYING,
    SP_PAUSED
} SocksoPlayerState;

@interface SocksoPlayer : NSObject {
    AudioStreamer *streamer_;
    SocksoPlayerState state;
    NSTimer *progressTimer_;
}

@property (nonatomic, assign) SocksoServer *server;
@property (nonatomic, retain) NSArray *tracks;
@property (nonatomic, assign) int currentTrackIndex;

- (id)initWithServer:(SocksoServer *)server;

- (void)playTrack:(Track *)track;
- (void)playAlbum:(Album *)album;
- (void)playArtist:(Artist *)artist;

- (BOOL)isPlaying;
- (BOOL)isPaused;
- (BOOL)isStopped;

- (void)play;
- (void)pause;
- (void)seekTo:(int)seconds;
- (void)stop;
- (int)duration;
- (int)position;

- (BOOL)playPrev;
- (BOOL)playNext;

- (Track *)getCurrentTrack;

@end
