
#import "Track.h"
#import "Album.h"
#import "Artist.h"

@implementation Track

@synthesize album=album_,
            artist=artist_;

#pragma mark -
#pragma mark Init

- (void)dealloc {
    
    [album_ release];
    [artist_ release];
    
    [super dealloc];
    
}

#pragma mark -
#pragma mark Helpers

+ (Track *) fromData:(NSDictionary *)data {
    
    Track *track = [[[Track alloc] init] autorelease];
    
    [track fromData:data];
    
    if ( [data objectForKey:@"artist"] != nil ) {
        track.artist = [Artist fromData:[data objectForKey:@"artist"]];
    }
    
    if ( [data objectForKey:@"album"] != nil ) {
        track.album = [Album fromData:[data objectForKey:@"album"]];
    }
        
    return track;
    
}

#pragma mark -
#pragma mark Methods

- (void)setMid:(NSString *)mid {

    [super setMid:mid];
    
    [self setMidPrefix:@"tr"];
    
}

@end
