
#import "SocksoServer.h"

@implementation SocksoServer

@synthesize ipAndPort, title, tagline;

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

@end
