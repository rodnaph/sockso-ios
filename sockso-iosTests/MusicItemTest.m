
#import <Foundation/Foundation.h>
#import "MusicItemTest.h"
#import "MusicItem.h"

@implementation MusicItemTest

- (void) testGetidReturnsNumericPortionOfMid {
    MusicItem *item = [MusicItem itemWithName:@"tr123" name:@"SomeName"];
    STAssertTrue( [[item getId] isEqualToString:@"123"], @"Numeric portion if mid not returned" );
}

- (void) testIstrackReturnsTrueWhenMusicItemIsATrack {
    MusicItem *item = [MusicItem itemWithName:@"tr123" name:@"Name"];
    STAssertTrue( [item isTrack], @"Item not detected as track" );
}

- (void) testIstrackReturnsFalseWhenItemIsNotATrack {
    MusicItem *item = [MusicItem itemWithName:@"al123" name:@"Name"];
    STAssertFalse( [item isTrack], @"Item is not a track" );
}

@end
