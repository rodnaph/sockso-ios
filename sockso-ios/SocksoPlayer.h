
@class SocksoServer, Artist, Album, Track, AudioStreamer;

@interface SocksoPlayer : NSObject {
    AudioStreamer *streamer_;
}

@property (nonatomic, retain) SocksoServer *server;
@property (nonatomic, retain) NSArray *tracks;
@property (nonatomic, assign) int currentTrackIndex;

- (id)initWithServer:(SocksoServer *)server;

- (void)playTrack:(Track *)track;
- (void)playAlbum:(Album *)album;
- (void)playArtist:(Album *)artist;

- (BOOL)isPlaying;
- (BOOL)isPaused;

- (void)play;
- (void)pause;
- (void)seekTo:(int)seconds;
- (int)duration;
- (int)position;

- (Track *)getCurrentTrack;

@end
