
#import <Foundation/Foundation.h>
#import "MusicItem.h"

@interface Album : MusicItem {}

@property (nonatomic, retain) MusicItem *artist;
@property (nonatomic, retain) NSString *year;

@end
