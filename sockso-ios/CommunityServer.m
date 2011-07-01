
#import "CommunityServer.h"
#import "ASIHTTPRequest.h"
#import "JSON.h"

@implementation CommunityServer

@synthesize title, tagline, version, ipAndPort;

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

+ (NSMutableArray *) fetchAll:(void (^)(NSMutableArray *))onComplete {
    
    NSURL *url = [NSURL URLWithString:@"http://sockso.pu-gh.com/community.html?format=json"];
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setCompletionBlock:^{
        
        SBJsonParser *parser = [[SBJsonParser alloc] init];
        NSArray *allServerData = [parser objectWithString:[request responseString]];
        NSMutableArray *servers = [[[NSMutableArray alloc] init] autorelease];
        
        [parser release];
        
        for ( NSDictionary *serverData in allServerData ) {
            CommunityServer *server = [CommunityServer fromData:serverData];
            if ( [server isSupportedVersion] ) {
                [servers addObject:server];
            }
            else {
                [server release];
            }
        }
        
        onComplete( servers );
        
    }];
    [request startAsynchronous];

    return nil;
    
}

- (BOOL) isSupportedVersion {
    
    return YES;
    
}

@end
