
#import "SocksoServer.h"
#import "MusicItem.h"
#import "AudioStreamer.h"

@implementation SocksoServer

@synthesize ipAndPort, title, tagline, streamer;

//
// Create a server with minimal data
//

+ (SocksoServer *) fromData:(NSString *)ipAndPort title:(NSString *)title tagline:(NSString *)tagline {
        
    SocksoServer *server = [SocksoServer alloc];
    
    server.ipAndPort = ipAndPort;
    server.title = title;
    server.tagline = tagline;
    
    return [server autorelease];
    
}

- (void) play:(MusicItem *) item {

    if ( streamer ) {
        [streamer release];
    }
    
    NSString *playUrl = [NSString stringWithFormat:@"http://%@/stream/%@",
                         ipAndPort,
                         [item getId]];
    
    NSLog( @"Play url: %@", playUrl );
    
	NSURL *url = [NSURL URLWithString:playUrl];
	streamer = [[AudioStreamer alloc] initWithURL:url];
    
    [streamer start];

}

- (void) play {
    
}

- (void) dealloc {
        
    [streamer release];
    
    [super dealloc];
    
}

@end
