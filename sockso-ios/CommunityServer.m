
#import "CommunityServer.h"
#import "ASIHTTPRequest.h"
#import "JSON.h"

@implementation CommunityServer

@synthesize title, tagline, version, ipAndPort;

//
// Create a server from the doctionary data
//

+ (CommunityServer *) fromData:(NSDictionary *)data {
    
    CommunityServer *server = [[CommunityServer alloc] init];
    
    server.title = [data objectForKey:@"title"];
    server.tagline = [data objectForKey:@"tagline"];
    server.version = [data objectForKey:@"version"];
    server.ipAndPort = [NSString stringWithFormat:@"%@:%@",
                        [data objectForKey:@"ip"],
                        [data objectForKey:@"port"]];
    
    return [server autorelease];
    
}

//
// Fetch all valid community servers and pass to onComplete handler
//

+ (void) fetchAll:(void (^)(NSMutableArray *))onComplete {
    
    NSString *jsonUrl = [NSString stringWithFormat:@"http://%@/community.html?format=json",
                         CS_SOCKSO_DOMAIN];
    NSURL *url = [NSURL URLWithString:jsonUrl];
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setCompletionBlock:^{
        onComplete( [self parseServerData:[request responseString]] );
    }];
    [request startAsynchronous];
    
}

//
// Parse server data into CommunityServer objects
//

+ (NSMutableArray *) parseServerData:(NSString *)responseString {

    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSArray *allServerData = [parser objectWithString:responseString];
    NSMutableArray *servers = [[[NSMutableArray alloc] init] autorelease];
    
    [parser release];
    
    for ( NSDictionary *serverData in allServerData ) {
        CommunityServer *server = [CommunityServer fromData:serverData];
        if ( [server isSupportedVersion] ) {
            [servers addObject:server];
        }
    }
    
    return servers;
    
}

//
// Indicates if this server is supported
//

- (BOOL) isSupportedVersion {
    
    NSArray *versionParts = [version componentsSeparatedByString:@"."];
    
    int major = [[versionParts objectAtIndex:0] intValue];
    int minor = [[versionParts objectAtIndex:1] intValue];
    int revision = [[versionParts objectAtIndex:2] intValue];
    
    
    if ( major > 1 ) {
        return YES;
    }
    
    else if ( major > 0 && minor > 3 ) {
        return YES;
    }
    
    else if ( major > 0 && minor > 2 && revision > 4 ) {
        return YES;
    }
    
    return NO;
    
}

- (void) dealloc {
    
    [title release];
    [tagline release];
    [version release];
    [ipAndPort release];
    
    [super dealloc];
    
}

@end
