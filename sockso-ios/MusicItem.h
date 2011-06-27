
#import <Foundation/Foundation.h>

@interface MusicItem : NSObject {
    NSString *mid; // eg. tr123, al456
    NSString *name;
}

@property (nonatomic, retain) NSString *mid, *name;

+ (id) itemWithName:(NSString *)mid name:(NSString *)name;

@end
