
#import "MusicItem.h"

@implementation MusicItem

@synthesize mid, name;

+ (id) itemWithName:(NSString *)mid name:(NSString *)name {
    
    MusicItem *item = [[[self alloc] init] autorelease];
    item.mid = mid;
    item.name = name;
    
    return item;
    
}

- (void) dealloc {
    [mid release];
    [name release];
    [super dealloc];
}

@end
