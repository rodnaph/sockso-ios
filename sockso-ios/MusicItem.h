
#import <Foundation/Foundation.h>

@interface MusicItem : NSObject {}

@property (nonatomic, retain) NSString *mid, *name;

+ (id) itemWithName:(NSString *)mid name:(NSString *)name;

- (void)fromData:(NSDictionary *)data;

- (NSString *)getId;
- (void)setMidPrefix:(NSString *)prefix;

- (BOOL)isTrack;
- (BOOL)isAlbum;
- (BOOL)isArtist;

+ (BOOL)isTrack:(NSString *)mid;
+ (BOOL)isAlbum:(NSString *)mid;
+ (BOOL)isArtist:(NSString *)mid;

@end
