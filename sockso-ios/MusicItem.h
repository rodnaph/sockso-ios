
#import <Foundation/Foundation.h>

@interface MusicItem : NSObject {}

@property (nonatomic, retain) NSString *mid, *name;

+ (id) itemWithName:(NSString *)mid name:(NSString *)name;

- (NSString *) getId;
- (BOOL) isTrack;

@end
