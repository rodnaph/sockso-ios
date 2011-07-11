
#import "ImageCache.h"

@implementation ImageCache

- (id) init {
    
    self = [super init];

    [self initCacheDir];
    
    return self;

}

- (void) initCacheDir {
    
	NSArray *path = NSSearchPathForDirectoriesInDomains( NSCachesDirectory, NSUserDomainMask, YES );
	NSString *cachesDir = [path objectAtIndex:0];
    NSFileManager *fm = [NSFileManager defaultManager];
    
    cacheDir = [[cachesDir stringByAppendingPathComponent:@"images"] retain];
    BOOL isDir = YES;
    
    if ( ![fm fileExistsAtPath:cacheDir isDirectory:&isDir] ) {
        [fm createDirectoryAtPath:cacheDir withIntermediateDirectories:NO attributes:nil error:nil];
    }

}

- (BOOL) isCached:(MusicItem *)item {
    
    NSString *cacheFile = [self getCacheFile:item];
    
    return [[NSFileManager defaultManager] fileExistsAtPath:cacheFile];
    
}

- (BOOL) write:(UIImage *)image forItem:(MusicItem *)item {
    
    NSString *cacheFile = [self getCacheFile:item];
    
    return [UIImagePNGRepresentation(image) writeToFile:cacheFile atomically:YES];
    
}

- (UIImage *) read:(MusicItem *)item {
    
    NSString *cacheFile = [self getCacheFile:item];
    
    return [UIImage imageWithContentsOfFile:cacheFile];
    
}

- (NSString *) getCacheFile:(MusicItem *)item {
    
    return [NSString stringWithFormat:@"%@/%@.png", cacheDir, item.mid];

}

- (void) dealloc {
    
    [cacheDir release];
    
    [super dealloc];
    
}

@end
