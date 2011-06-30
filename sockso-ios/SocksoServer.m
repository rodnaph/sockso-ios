
#import "SocksoServer.h"
#import "MusicItem.h"
#import "AudioStreamer.h"
#import "ASIHTTPRequest.h"
#import "JSON.h"

@implementation SocksoServer

@synthesize ipAndPort, title, tagline, streamer, parser;

//
// creates a server not yet connected
//

+ (SocksoServer *) disconnectedServer:(NSString *)ipAndPort {
    
    SocksoServer *server = [[SocksoServer alloc] init];
    
    server.ipAndPort = ipAndPort;
    
    return [server autorelease];

}

//
// creates a server connected to the specified address
//

+ (SocksoServer *) connectedServer:(NSString *)ipAndPort title:(NSString *)title tagline:(NSString *)tagline {

    SocksoServer * server = [SocksoServer disconnectedServer:ipAndPort];
    
    server.title = title;
    server.tagline = tagline;
    
    return server;
    
}

- (id) init {
    
    [super init];
    
    parser = [[SBJsonParser alloc] init];
    
    return self;
    
}

//
//  try and connect to the server
//

- (void) connect:(void (^)(void))onConnect onFailure:(void (^)(void))onFailure {
    
    NSString *fullUrl = [NSString stringWithFormat:@"http://%@/json/serverinfo", ipAndPort];
    NSURL *url = [NSURL URLWithString:fullUrl];
    
    NSLog( @"Connecting to server at: %@", fullUrl );
    
    __block ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    
    [request setCompletionBlock:^{
        
        NSDictionary *serverInfo = [parser objectWithString:[request responseString]];
        self.title = [serverInfo objectForKey:@"title"];
        self.tagline = [serverInfo objectForKey:@"tagline"];
        
        onConnect();
        
    }];
    
    [request setFailedBlock:onFailure];
    [request startAsynchronous];

}

//
//  start playing a music item, stop any other playing if it is
//

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

//
//  play the current track if it's paused or stopped
//

- (void) play {
    
}

- (void) dealloc {
        
    [streamer release];
    [parser release];
    
    [super dealloc];
    
}

@end
