
#import "MusicItem.h"

@implementation MusicItem

@synthesize mid, name;

+ (id) itemWithName:(NSString *)mid name:(NSString *)name {
    
    MusicItem *item = [[[self alloc] init] autorelease];
    item.mid = mid;
    item.name = name;
    
    return item;
    
}

- (BOOL) isTrack {
    
    return [[mid substringToIndex:2] isEqualToString:@"tr"];
    
}

- (void) dealloc {
    
    [mid release];
    [name release];
    
    [super dealloc];
    
}

@end
