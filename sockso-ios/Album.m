
#import "Album.h"

@implementation Album

@synthesize artist,
            year=year_;

- (void) dealloc {
    
    [artist release];
    [year_ release];
    
    [super dealloc];
    
}

@end
