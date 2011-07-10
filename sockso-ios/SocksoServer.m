
#import "SocksoServer.h"
#import "MusicItem.h"
#import "AudioStreamer.h"
#import "ASIHTTPRequest.h"
#import "JSON.h"

@implementation SocksoServer

@synthesize ipAndPort, title, tagline, mode, requiresLogin;

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

//
// init server objects
//

- (id) init {
    
    [super init];
    
    mode = SS_MODE_STOPPED;
    
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
        
        SBJsonParser *parser = [[SBJsonParser alloc] init];
        NSDictionary *serverInfo = [parser objectWithString:[request responseString]];
        self.title = [serverInfo objectForKey:@"title"];
        self.tagline = [serverInfo objectForKey:@"tagline"];
        self.requiresLogin = [[serverInfo objectForKey:@"requiresLogin"] isEqualToString:@"1"] ? YES : NO;
        
        onConnect();
        
        [parser release];
        
    }];
    
    [request setFailedBlock:onFailure];
    [request startAsynchronous];

}

//
// Perform the search and return the results to the onConnect handler
//

- (void) search:(NSString *)query onComplete:(void (^)(NSMutableArray *))onComplete onFailure:(void (^)(void))onFailure {
    
    NSURL *url = [self getSearchUrl:query];
    __block ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];

    [request setCompletionBlock:^{

        SBJsonParser *parser = [[SBJsonParser alloc] init];
        NSArray *results = [parser objectWithString:[request responseString]];
        NSMutableArray *items = [[[NSMutableArray alloc] init] autorelease];

        for ( NSDictionary *result in results ) {
            MusicItem *item = [MusicItem
                               itemWithName:[result objectForKey:@"id"]
                               name:[result objectForKey:@"name"]];
            [items addObject:item];
        }

        NSLog( @"Search returned %d results", [items count] );
        
        onComplete( items );
        
        [parser release];
        
    }];
    
    [request setFailedBlock:onFailure];
    [request startAsynchronous];
    
}

//
//  Find a track by id
//

- (void) getTrack:(int)trackId onComplete:(void (^)(Track *))onComplete {
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@/api/tracks/%d",
                                       ipAndPort,
                                       trackId]];
    
    __block ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    
    [request setCompletionBlock:^{
        SBJsonParser *parser = [[SBJsonParser alloc] init];
        NSDictionary *data = [parser objectWithString:[request responseString]];
        onComplete( [Track fromData:data] );
        [parser release];
    }];
    
    [request startAsynchronous];
    
}

//
// returns the URL for a search query using the string in the searchbar
//

- (NSURL *) getSearchUrl:(NSString *) query {
    
    NSString *fullUrl = [NSString stringWithFormat:@"http://%@/json/search/%@",
                         ipAndPort,
                         [query stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURL *url = [NSURL URLWithString:fullUrl];
    
    NSLog( @"Search Query URL: %@", fullUrl );
    
    return url;
    
}

- (void) getTracksForAlbum:(MusicItem *)item onComplete:(void (^)(NSMutableArray *))onComplete onFailure:(void (^)(void))onFailure {
    
    [self getTracksForMusicItem:item onComplete:onComplete onFailure:onFailure];
    
}

- (void) getTracksForMusicItem:(MusicItem *)item onComplete:(void (^)(NSMutableArray *))onComplete onFailure:(void (^)(void))onFailure {
    
    NSString *itemType = [item isArtist] ? @"artists" : @"albums";
    NSString *urlString = [NSString stringWithFormat:@"http://%@/api/%@/%@/tracks",
                           ipAndPort,
                           itemType,
                           [item getId]];
    NSURL *url = [NSURL URLWithString:urlString];
    
    __block ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    
    NSLog( @"Query artist tracks: %@", urlString );
    
    [request setCompletionBlock:^{
        
        SBJsonParser *parser = [[SBJsonParser alloc] init];
        NSArray *trackData = [parser objectWithString:[request responseString]];
        NSMutableArray *tracks = [[[NSMutableArray alloc] init] autorelease];
        
        for ( NSDictionary *data in trackData ) {
            Track *track = [Track itemWithName:[NSString stringWithFormat:@"tr%@", [data objectForKey:@"id"]]
                                          name:[data objectForKey:@"name"]];
            [tracks addObject:track];
        }
        
        onComplete( tracks );
        
        [parser release];
        
    }];
    
    [request setFailedBlock:onFailure];
    [request startAsynchronous];

}

//
// Returns albums for the specified artist
//

- (void) getAlbumsForArtist:(MusicItem *)item onComplete:(void (^)(NSMutableArray *))onComplete onFailure:(void (^)(void))onFailure {
    
    NSString *urlString = [NSString stringWithFormat:@"http://%@/api/artists/%@",
                           ipAndPort,
                           [item getId]];
    NSURL *url = [NSURL URLWithString:urlString];
    __block ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    
    NSLog( @"Query: %@ (%@)", urlString, item.mid );
    
    [request setCompletionBlock:^{
        
        SBJsonParser *parser = [[SBJsonParser alloc] init];
        NSDictionary *artist = [parser objectWithString:[request responseString]];
        NSMutableArray *albums = [[[NSMutableArray alloc] init] autorelease];
        
        for ( NSDictionary *data in [artist objectForKey:@"albums"] ) {
            Album *album = [Album itemWithName:[NSString stringWithFormat:@"al%@", [data objectForKey:@"id"]]
                                          name:[data objectForKey:@"name"]];
            album.artist = item;
            [albums addObject:album];
        }
        
        onComplete( albums );
        
        [parser release];
        
    }];
    
    [request setFailedBlock:onFailure];
    
    [request startAsynchronous];
    
}

- (void) getTracksForArtist:(MusicItem *)item onComplete:(void (^)(NSMutableArray *))onComplete onFailure:(void (^)(void))onFailure {
    
    [self getTracksForMusicItem:item onComplete:onComplete onFailure:onFailure];
    
}

//
//  start playing a music item, stop any other playing if it is
//

- (void) play:(MusicItem *)item {

    if ( mode != SS_MODE_STOPPED ) {
        [streamer stop];
        [streamer release];
    }
    
    NSString *playUrl = [NSString stringWithFormat:@"http://%@/stream/%@",
                         ipAndPort,
                         [item getId]];
    
    NSLog( @"Play url: %@", playUrl );
    
	NSURL *url = [NSURL URLWithString:playUrl];
	streamer = [[AudioStreamer alloc] initWithURL:url];
    
    [streamer start];

    mode = SS_MODE_PLAYING;
    
}

//
// play the current track if it's paused or stopped
//

- (void) play {
    
    [streamer start];
    mode = SS_MODE_PLAYING;
    
}

//
// pause current track
//

- (void) pause {
    
    [streamer pause];
    mode = SS_MODE_PAUSED;
    
}

- (void) dealloc {

    [streamer stop];
    
    [streamer release];
    [ipAndPort release];
    [title release];
    [tagline release];
    
    [super dealloc];
    
}

@end
