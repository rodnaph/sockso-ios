
#import "SocksoServer.h"
#import "MusicItem.h"
#import "AudioStreamer.h"
#import "ASIHTTPRequest.h"
#import "JSON.h"

@implementation SocksoServer

@synthesize ipAndPort, title, tagline, streamer;

+ (SocksoServer *) disconnectedServer:(NSString *)ipAndPort {
    
    SocksoServer *server = [SocksoServer alloc];
    
    server.ipAndPort = ipAndPort;
    
    return server;

}

+ (SocksoServer *) connectedServer:(NSString *)ipAndPort title:(NSString *)title tagline:(NSString *)tagline {
        
    SocksoServer *server = [SocksoServer alloc];
    
    server.ipAndPort = ipAndPort;
    server.title = title;
    server.tagline = tagline;
    
    return [server autorelease];
    
}

- (void) connect:(void (^)(void))onConnect onFailure:(void (^)(void))onFailure {
    
    NSString *fullUrl = [NSString stringWithFormat:@"http://%@/json/serverinfo", [server text]];
    NSURL *url = [NSURL URLWithString:fullUrl];
    
    NSLog( @"Connecting to server at: %@", fullUrl );
    
    __block ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    
    [request setCompletionBlock:^{
        NSDictionary *serverInfo = [parser objectWithString:[request responseString]];
        onConnect();
    }];
    
    [request setFailedBlock:^{
        onFailure();
    }];
    
    [request startAsynchronous];

}

- (void) play:(MusicItem *)item {

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
