
#import "ASIHTTPRequest.h"
#import "JSON.h"
#import "SocksoApi.h"
#import "Artist.h"
#import "Album.h"
#import "Track.h"
#import "MusicItem.h"
#import "SocksoServer.h"

@interface SocksoApi (Private)

- (void)getTracksForMusicItem:(MusicItem *)item onComplete:(void (^)(NSArray *))onComplete onFailure:(void (^)(void))onFailure;

@end

@implementation SocksoApi

@synthesize server=server_;

#pragma mark -
#pragma mark Helpers

- (id)initWithServer:(SocksoServer *)server {
    
    if ( (self = [super init]) ) {
        self.server = (SocksoServer *) server;
    }
    
    return self;
    
}

#pragma mark -
#pragma mark Methods

- (void)session:(void (^)(void))onSuccess onFailure:(void (^)(void))onFailure {
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@/api/session", server_.ipAndPort]];
    
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

- (void)tracksForAlbum:(Album *)album onComplete:(void (^)(NSArray *))onComplete onFailure:(void (^)(void))onFailure {
    
    [self getTracksForMusicItem:album onComplete:onComplete onFailure:onFailure];
    
}

- (void)getTracksForMusicItem:(MusicItem *)item onComplete:(void (^)(NSArray *))onComplete onFailure:(void (^)(void))onFailure {
    
    NSString *itemType = [item isArtist] ? @"artists" : @"albums";
    NSString *urlString = [NSString stringWithFormat:@"http://%@/api/%@/%@/tracks",
                           server_.ipAndPort,
                           itemType,
                           [item getId]];
    NSURL *url = [NSURL URLWithString:urlString];
    
    __block ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    
    NSLog( @"Query tracks: %@", urlString );
    
    [request setCompletionBlock:^{
        
        SBJsonParser *parser = [[SBJsonParser alloc] init];
        NSArray *trackData = [parser objectWithString:[request responseString]];
        NSMutableArray *tracks = [[[NSMutableArray alloc] init] autorelease];
        
        for ( NSDictionary *data in trackData ) {
            Track *track = [Track fromData:data];
            [tracks addObject:track];
        }
        
        onComplete( [NSArray arrayWithArray:tracks] );
        
        [parser release];
        
    }];
    
    [request setFailedBlock:onFailure];
    [request startAsynchronous];
    
}

//
// Returns albums for the specified artist
//

- (void)albumsForArtist:(Artist *)item onComplete:(void (^)(NSArray *))onComplete onFailure:(void (^)(void))onFailure {
    
    NSString *urlString = [NSString stringWithFormat:@"http://%@/api/artists/%@",
                           server_.ipAndPort,
                           [item getId]];
    NSURL *url = [NSURL URLWithString:urlString];
    __block ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    
    NSLog( @"Query: %@ (%@)", urlString, item.mid );
    
    [request setCompletionBlock:^{
        
        SBJsonParser *parser = [[SBJsonParser alloc] init];
        NSDictionary *artist = [parser objectWithString:[request responseString]];
        NSMutableArray *albums = [[[NSMutableArray alloc] init] autorelease];
        
        for ( NSDictionary *data in [artist objectForKey:@"albums"] ) {
            Album *album = [Album fromData:data];
            [albums addObject:album];
        }
        
        onComplete( [NSArray arrayWithArray:albums] );
        
        [parser release];
        
    }];
    
    [request setFailedBlock:onFailure];
    [request startAsynchronous];
    
}

- (void)tracksForArtist:(Artist *)artist onComplete:(void (^)(NSArray *))onComplete onFailure:(void (^)(void))onFailure {
    
    [self getTracksForMusicItem:artist onComplete:onComplete onFailure:onFailure];
    
}

- (void)artists:(void (^)(NSArray *))onComplete onFailure:(void (^)(void))onFailure {
    
    NSString *urlString = [NSString stringWithFormat:@"http://%@/api/artists?limit=-1", server_.ipAndPort];
    
    __block ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlString]];
    
    NSLog( @"Query artists: %@", urlString );
    
    [request setCompletionBlock:^{
        
        SBJsonParser *parser = [[SBJsonParser alloc] init];
        NSMutableArray *artists = [[NSMutableArray alloc] init];
        NSArray *artistsData = [parser objectWithString:[request responseString]];
        
        for ( NSDictionary *artistData in artistsData ) {
            Artist *artist = [Artist fromData:artistData];
            [artists addObject:artist];
        }
        
        onComplete( [NSArray arrayWithArray:artists] );
        
        [artists release];
        [parser release];
        
    }];
    
    [request setTimeOutSeconds:5];
    [request setFailedBlock:onFailure];
    [request startAsynchronous];
    
}

@end
