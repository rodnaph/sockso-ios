
#import "MusicItem.h"

@implementation MusicItem

@synthesize mid, name;

+ (id) itemWithName:(NSString *)mid name:(NSString *)name {
    
    MusicItem *item = [[[self alloc] init] autorelease];
    item.mid = mid;
    item.name = name;
    
    return item;
    
}

- (NSString *) getId {
    
    return [mid substringFromIndex:2];
                                    
}

- (BOOL) hasPrefix:(NSString *)prefix {
    
    return [[mid substringToIndex:2] isEqualToString:prefix];
    
}

- (BOOL) isTrack {
    
    return [self hasPrefix:@"tr"];
    
}

- (BOOL) isAlbum {
    
    return [self hasPrefix:@"al"];
    
}

- (BOOL) isArtist {
    
    return [self hasPrefix:@"ar"];
    
}

- (void) dealloc {
    
    [mid release];
    [name release];
    
    [super dealloc];
    
}

@end
