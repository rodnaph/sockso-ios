
#import "Album.h"
#import "Artist.h"

@implementation Album

@synthesize artist=artist_,
            year=year_;

#pragma mark -
#pragma mark Init

- (void) dealloc {
    
    [artist_ release];
    [year_ release];
    
    [super dealloc];
    
}

#pragma mark -
#pragma mark Helpers

+ (Album *)fromData:(NSDictionary *)data {
    
    Album *album = [[[Album alloc] init] autorelease];

    [album fromData:data];
    
    album.year = [data objectForKey:@"year"];
    
    if ( [data objectForKey:@"artist"] != nil ) {
        album.artist = [Artist fromData:[data objectForKey:@"artist"]];
    }

    return album;
    
}

@end
