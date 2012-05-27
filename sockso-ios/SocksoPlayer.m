
#import "AudioStreamer.h"
#import "SocksoServer.h"
#import "SocksoPlayer.h"
#import "SocksoApi.h"
#import "Track.h"
#import "Album.h"
#import "Artist.h"

@interface SocksoPlayer (Private)

- (void)initEventThread;
- (void)pollAudioEvents;
- (void)playCurrent;

@end

@implementation SocksoPlayer

@synthesize server=server_,
            tracks=tracks_,
            currentTrackIndex=currentTrackIndex_;

#pragma mark -
#pragma mark Init

- (void)dealloc {
    
    [streamer_ stop];
    [streamer_ release];
    
    [tracks_ release];
    
    progressTimer_ = nil;
    
    [super dealloc];
    
}

#pragma mark -
#pragma mark Helpers

- (id)initWithServer:(SocksoServer *)server {
    
    if ( (self = [super init]) ) {
        self.server = server;
        state = SP_NONE;
        [self initEventThread];
    }
    
    return self;
    
}

- (void)initEventThread {

    progressTimer_ = [NSTimer scheduledTimerWithTimeInterval:0.5
                                             target:self
                                           selector:@selector(pollAudioEvents)
                                           userInfo:nil
                                            repeats:YES];
    
    
}

- (void)pollAudioEvents {
    
    if ( state == SP_PLAYING && !([streamer_ isPlaying] || [streamer_ isWaiting]) ) {
        [self playNext];
    }
        
}

#pragma mark -
#pragma mark Methods

- (void)playArtist:(Artist *)artist {
    
    [server_.api tracksForArtist:artist
                      onComplete:^(NSArray *tracks) {
                          [self setTracks:tracks];
                          [self playCurrent];
                      }
                       onFailure:^{}];
    
}

- (void)playAlbum:(Album *)album {
    
    [server_.api tracksForAlbum:album
                     onComplete:^(NSArray *tracks) {
                         [self setTracks:tracks];
                         [self playCurrent];
                     }
                      onFailure:^{}];
    
}

- (void)setTracks:(NSArray *)tracks {

    if ( tracks_ != nil ) {
        [tracks_ release];
    }
    
    tracks_ = [tracks retain];
    
    currentTrackIndex_ = 0;

}

- (void)playTrack:(Track *)track {

    self.tracks = [NSArray arrayWithObject:track];
    currentTrackIndex_ = 0;
    
    [self playCurrent];
    
}

- (void)play {
    
    state = SP_PLAYING;
    
    [streamer_ start];
    
}

- (void)pause {
    
    state = SP_PAUSED;
    
    [streamer_ pause];
    
}

- (void)stop {
    
    state = SP_STOPPED;
    
    [streamer_ stop];
    [streamer_ release];
    
    streamer_ = nil;

}

- (void)seekTo:(int)seconds {
    
    [streamer_ seekToTime:seconds];
    
}

- (int)duration {
    
    return [streamer_ duration];
    
}

- (int)position {
    
    return [streamer_ progress];
    
}

- (BOOL)isPlaying {
    
    return state == SP_PLAYING;
    
}

- (BOOL)isPaused {
    
    return state == SP_PAUSED;
    
}

- (BOOL)isStopped {
    
    return state == SP_STOPPED;
    
}

- (Track *)getCurrentTrack {
    
    return [tracks_ objectAtIndex:currentTrackIndex_];
    
}

- (BOOL)playPrev {
    
    if ( currentTrackIndex_ > 0 ) {
        currentTrackIndex_--;
        [self playCurrent];
        return YES;
    }
    
    return NO;
    
}

- (BOOL)playNext {
    
    if ( currentTrackIndex_ < ([tracks_ count] - 1) ) {
        currentTrackIndex_++;
        [self playCurrent];
        return YES;
    }
    
    return NO;
    
}

#pragma mark -
#pragma mark Private Methods

- (void)playCurrent {
    
    if ( [self isPlaying] ) {
        [self stop];
    }
    
    MusicItem *item = [tracks_ objectAtIndex:currentTrackIndex_];
    NSString *playUrl = [NSString stringWithFormat:@"http://%@/stream/%@", server_.ipAndPort, [item getId]];
	NSURL *url = [NSURL URLWithString:playUrl];
    
	streamer_ = [[[AudioStreamer alloc] initWithURL:url] retain];
    
    [self play];
    
}

@end
