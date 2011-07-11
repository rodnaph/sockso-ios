
#import <Foundation/Foundation.h>
#import "MusicItem.h"

@interface ImageCache : NSObject {
    NSString *cacheDir;
}

- (BOOL) isCached:(MusicItem *)item;
- (UIImage *) read:(MusicItem *)item;
- (BOOL) write:(UIImage *)image forItem:(MusicItem *)item;

- (void) initCacheDir;
- (NSString *) getCacheFile:(MusicItem *)item;

@end
