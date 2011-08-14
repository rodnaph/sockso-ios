
#import "MusicItem.h"

@interface MusicItem (Private)

+ (BOOL)mid:(NSString *)mid hasPrefix:(NSString *)prefix;

@end

@implementation MusicItem

@synthesize mid=mid_,
            name=name_;

#pragma mark -
#pragma mark Init

- (void) dealloc {
    
    [mid_ release];
    [name_ release];
    
    [super dealloc];
    
}

+ (id) itemWithName:(NSString *)mid name:(NSString *)name {
    
    MusicItem *item = [[[self alloc] init] autorelease];
    
    item.mid = mid;
    item.name = name;
    
    return item;
    
}

#pragma mark -
#pragma mark Helpers

+ (BOOL)isTrack:(NSString *)mid {
    
    return [MusicItem mid:mid hasPrefix:@"tr"];
    
}

+ (BOOL)isAlbum:(NSString *)mid {
    
    return [MusicItem mid:mid hasPrefix:@"al"];
    
}

+ (BOOL)isArtist:(NSString *)mid {
    
    return [MusicItem mid:mid hasPrefix:@"ar"];
    
}

+ (BOOL)mid:(NSString *)mid hasPrefix:(NSString *)prefix {
    
    return [[mid substringToIndex:2] isEqualToString:prefix];
    
}

#pragma mark -
#pragma mark Methods

- (void)fromData:(NSDictionary *)data {
    
    self.mid = [data objectForKey:@"id"];
    self.name = [data objectForKey:@"name"];
    
}

- (void)fromData:(NSDictionary *)data withType:(NSString *)type {
    
    [self fromData:data];
    
}

- (NSString *) getId {
    
    return [mid_ substringFromIndex:2];
                                    
}

- (BOOL) isTrack {
    
    return [MusicItem isTrack:mid_];
    
}

- (BOOL) isAlbum {
    
    return [MusicItem isAlbum:mid_];
    
}

- (BOOL) isArtist {
    
    return [MusicItem isArtist:mid_];
    
}

@end
