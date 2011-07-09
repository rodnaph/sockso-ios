
#import "Album.h"

@implementation Album

@synthesize artist;

- (void) dealloc {
    
    [artist release];
    
    [super dealloc];
    
}

@end
