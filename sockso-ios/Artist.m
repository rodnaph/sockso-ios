
#import "Artist.h"

@implementation Artist

#pragma mark -
#pragma mark Helpers

+ (Artist *)fromData:(NSDictionary *)data {
    
    Artist *artist = [[[Artist alloc] init] autorelease];
    
    [artist fromData:data];
    
    return artist;
    
}

#pragma mark -
#pragma mark Methods

- (void)setMid:(NSString *)mid {
    
    [super setMid:mid];
    
    [self setMidPrefix:@"ar"];
    
}

@end
