
#import <Foundation/Foundation.h>
#import "MusicItem.h"
#import "Album.h"
#import "Artist.h"

@interface Track : MusicItem {}

@property (nonatomic, retain) Album *album;
@property (nonatomic, retain) Artist *artist;

+ (Track *) fromData:(NSDictionary *)data;

@end
