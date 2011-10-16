
#import "SocksoServer.h"
#import "MusicItem.h"
#import "AudioStreamer.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "JSON.h"
#import "SocksoApi.h"
#import "SocksoPlayer.h"
#import "Artist.h"
#import "Album.h"
#import "Track.h"

@implementation SocksoServer

@synthesize ipAndPort, title, tagline, requiresLogin, version,
            player=player_,
            api=api_;

#pragma mark -
#pragma mark Constructors

+ (SocksoServer *)disconnectedServer:(NSString *)ipAndPort {
    
    SocksoServer *server = [[[SocksoServer alloc] init] autorelease];
    
    server.ipAndPort = ipAndPort;
    
    server.player = [[[SocksoPlayer alloc] initWithServer:server] autorelease];
    server.api = [[[SocksoApi alloc] initWithServer:server] autorelease];
    
    return server;

}

+ (SocksoServer *)connectedServer:(NSString *)ipAndPort title:(NSString *)title tagline:(NSString *)tagline {

    SocksoServer * server = [SocksoServer disconnectedServer:ipAndPort];
    
    server.title = title;
    server.tagline = tagline;
    
    return server;
    
}

#pragma mark -
#pragma mark Init

- (void)dealloc {
    
    [version release];
    [ipAndPort release];
    [title release];
    [tagline release];
    [player_ release];
    [api_ release];
    
    [super dealloc];
    
}

#pragma mark -
#pragma mark Helpers

+ (void)findCommunityServers:(void (^)(NSMutableArray *))onComplete onFailure:(void (^)(void))onFailure {
    
    NSString *jsonUrl = @"http://sockso.pu-gh.com/community.html?format=json";
    NSURL *url = [NSURL URLWithString:jsonUrl];
    
    __block ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    
    [request setCompletionBlock:^{

        SBJsonParser *parser = [[SBJsonParser alloc] init];
        NSMutableArray *servers = [[NSMutableArray alloc] init];
        NSArray *data = [parser objectWithString:[request responseString]];
        
        [parser release];
        
        for ( NSDictionary *datum in data ) {
            NSString *ipAndPort = [NSString stringWithFormat:@"%@:%@", [datum objectForKey:@"ip"], [datum objectForKey:@"port"]];
            SocksoServer *server = [SocksoServer disconnectedServer:ipAndPort];
            server.title = [datum objectForKey:@"title"];
            server.tagline = [datum objectForKey:@"tagline"];
            server.version = [datum objectForKey:@"version"];
            server.requiresLogin = [[datum objectForKey:@"requiresLogin"] isEqualToString:@"1"] ? YES : NO;
            if ( [server isSupportedVersion] ) {
                [servers addObject:server];
            }
        }
        
        onComplete( [servers autorelease] );
        
    }];
    
    [request setFailedBlock:onFailure];
    [request startAsynchronous];
    
}

#pragma mark -
#pragma mark Methods

- (BOOL)isSupportedVersion {
    
    NSArray *versionParts = [version componentsSeparatedByString:@"."];
    
    if ( [versionParts count] < 2 ) {
        return NO;
    }
    
    int major = [[versionParts objectAtIndex:0] intValue];
    int minor = [[versionParts objectAtIndex:1] intValue];
    
    if ( major > 1 ) {
        return YES;
    }
    
    else if ( major > 0 && minor > 4 ) {
        return YES;
    }
    
    return NO;
    
}

- (void)hasSession:(void (^)(void))onSuccess onFailure:(void (^)(void))onFailure {
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@/api/session", ipAndPort]];
    
    __block ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    
    [request setCompletionBlock:^{
        if ( [[request responseString] isEqualToString:@"1"] ) {
            onSuccess();
        }
        else {
            onFailure();
        }
    }];
    
    [request setFailedBlock:onFailure];
    [request startAsynchronous];
    
}

- (void)loginWithName:(NSString *)name andPassword:(NSString *)password onSuccess:(void (^)(void))onSuccess onFailure:(void (^)(void))onFailure {
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@/user/login", ipAndPort]];
    
    __block SocksoServer *this = self;
    __block ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];

    [ASIHTTPRequest clearSession];
    
    request.shouldRedirect = NO;

    [request setPostValue:@"login" forKey:@"todo"];
    [request setPostValue:name forKey:@"name"];
    [request setPostValue:password forKey:@"pass"];
    
    [request setCompletionBlock:^{
        [this hasSession:onSuccess onFailure:onFailure];
    }];
    
    [request startAsynchronous];
    
}

- (void)connect:(void (^)(void))onConnect onFailure:(void (^)(void))onFailure {
    
    NSString *fullUrl = [NSString stringWithFormat:@"http://%@/json/serverinfo", ipAndPort];
    NSURL *url = [NSURL URLWithString:fullUrl];
    
    NSLog( @"Connecting to server at: %@", fullUrl );
    
    __block ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    
    [request setCompletionBlock:^{
        
        SBJsonParser *parser = [[SBJsonParser alloc] init];
        NSDictionary *serverInfo = [parser objectWithString:[request responseString]];
        self.title = [serverInfo objectForKey:@"title"];
        self.tagline = [serverInfo objectForKey:@"tagline"];
        self.version = [serverInfo objectForKey:@"version"];
        self.requiresLogin = [[serverInfo objectForKey:@"requiresLogin"] isEqualToString:@"1"] ? YES : NO;
        
        onConnect();
        
        [parser release];
        
    }];
    
    [request setFailedBlock:onFailure];
    [request startAsynchronous];

}

- (void)search:(NSString *)query onComplete:(void (^)(NSArray *))onComplete onFailure:(void (^)(void))onFailure {
    
    NSURL *url = [self getSearchUrl:query];
    __block ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];

    [request setCompletionBlock:^{

        SBJsonParser *parser = [[SBJsonParser alloc] init];
        NSArray *results = [parser objectWithString:[request responseString]];
        NSMutableArray *items = [[[NSMutableArray alloc] init] autorelease];

        for ( NSDictionary *result in results ) {
            
            NSString *mid = [result objectForKey:@"id"];
            MusicItem *item = nil;
            
            if ( [MusicItem isTrack:mid] ) {
                item = [Track fromData:result];
            }
            
            else if ( [MusicItem isAlbum:mid] ) {
                item = [Album fromData:result];
            }
            
            else if ( [MusicItem isArtist:mid] ) {
                item = [Artist fromData:result];
            }
            
            if ( item != nil ) {
                [items addObject:item];
            }
            
        }

        NSLog( @"Search returned %d results", [items count] );
        
        onComplete( [NSArray arrayWithArray:items] );
        
        [parser release];
        
    }];
    
    [request setFailedBlock:onFailure];
    [request startAsynchronous];
    
}

- (NSURL *)getSearchUrl:(NSString *) query {
    
    NSString *fullUrl = [NSString stringWithFormat:@"http://%@/json/search/%@",
                         ipAndPort,
                         [query stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURL *url = [NSURL URLWithString:fullUrl];
    
    NSLog( @"Search Query URL: %@", fullUrl );
    
    return url;
    
}

- (NSURL *)getImageUrlForMusicItem:(MusicItem *)item {
    
    NSString *urlString = [NSString stringWithFormat:@"http://%@/file/cover/%@", ipAndPort, item.mid];
    NSURL *url = [NSURL URLWithString:urlString];
    
    return url;
    
}

@end
