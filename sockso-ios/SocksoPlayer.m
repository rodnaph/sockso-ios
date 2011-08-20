
#import "SocksoServer.h"
#import "SocksoPlayer.h"
#import "Track.h"
#import "Album.h"
#import "Artist.h"

@interface SocksoPlayer (Private)

- (void)playPrev;
- (void)playCurrent;
- (void)playNext;

@end

@implementation SocksoPlayer

@synthesize server=server_,
            tracks=tracks_,
            currentTrackIndex=currentTrackIndex_;

#pragma mark -
#pragma mark Init

- (void)dealloc {
    
    [server_ release];
    [tracks_ release];
    
    [super dealloc];
    
}

#pragma mark -
#pragma mark Helpers

- (id)initWithServer:(SocksoServer *)server {
    
    if ( (self = [super init]) ) {
        self.server = server;
    }
    
    return self;
    
}

#pragma mark -
#pragma mark Methods

- (void)playArtist:(Album *)artist {
}

- (void)playAlbum:(Album *)album {
}

- (void)playTrack:(Track *)track {

    self.tracks = [NSArray arrayWithObject:track];
    currentTrackIndex_ = 0;
    
    [self playCurrent];
    
}

- (void)play {
    
    [streamer_ start];
    
}

- (void)pause {
    
    [streamer_ pause];
    
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
    
    return [streamer_ isPlaying];
    
}

- (BOOL)isPaused {
    
    return [streamer_ isPaused];
    
}

- (Track *)getCurrentTrack {
    
    return [tracks_ objectAtIndex:currentTrackIndex_];
    
}

#pragma mark -
#pragma mark Private Methods

- (void)playPrev {
    
    currentTrackIndex_--;
    
    [self playCurrent];
    
}

- (void)playCurrent {
    
    MusicItem *item = [tracks_ objectAtIndex:currentTrackIndex_];
    
    if ( [self isPlaying] ) {
        [streamer_ stop];
        [streamer_ release];
        streamer_ = nil;
    }
    
    NSString *playUrl = [NSString stringWithFormat:@"http://%@/stream/%@",
                         server_.ipAndPort,
                         [item getId]];
    
    NSLog( @"Play URL: %@", playUrl );
    
	NSURL *url = [NSURL URLWithString:playUrl];
	streamer_ = [[[AudioStreamer alloc] initWithURL:url] retain];
    
    [streamer_ start];
    
}

- (void)playNext {
    
    currentTrackIndex_++;
    
    [self playCurrent];
    
}

@end
