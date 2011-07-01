
#import "Track.h"
#import "Album.h"
#import "Artist.h"

@implementation Track

@synthesize album, artist;

//
// Creates a track from the data returned by API
//

+ (Track *) fromData:(NSDictionary *)data {
    
    Track *track = [[[Track alloc] init] autorelease];
    Album *album = [[[Album alloc] init] autorelease];
    Artist *artist = [[[Artist alloc] init] autorelease];
    
    NSDictionary *artistData = [data objectForKey:@"album"];
    artist.mid = [NSString stringWithFormat:@"al%@", [artistData objectForKey:@"id"]];
    artist.name = [artistData objectForKey:@"name"];
    
    NSDictionary *albumData = [data objectForKey:@"album"];
    album.mid = [NSString stringWithFormat:@"al%@", [albumData objectForKey:@"id"]];
    album.name = [albumData objectForKey:@"name"];
    
    track.mid = [NSString stringWithFormat:@"tr%@", [data objectForKey:@"id"]];
    track.name = [data objectForKey:@"name"];
    
    return track;
    
}

@end
