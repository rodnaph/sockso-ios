
#import "TrackTest.h"
#import "Track.h"

@implementation TrackTest

- (void)setUp {
    data_ = [[[NSMutableDictionary alloc] init] autorelease];
    [data_ setValue:@"123" forKey:@"id"];
    [data_ setValue:@"foo" forKey:@"name"];
    NSMutableDictionary *album = [[[NSMutableDictionary alloc] init] autorelease];
    [album setValue:@"al456" forKey:@"id"];
    [album setValue:@"bar" forKey:@"name"];
    [data_ setValue:album forKey:@"album"];
}

- (void)testInitwithdataWhereIdHasNoPrefixSetsCorrectMid {
    Track *track = [Track fromData:data_];
    STAssertTrue( [track.mid isEqualToString:@"tr123"], @"Track set with prefix" );
}

- (void)testInitwithdataWhereIdContainsPrefixSetsCorrectMid {
    [data_ setValue:@"tr123" forKey:@"id"];
    Track *track = [Track fromData:data_];
    STAssertTrue( [track.mid isEqualToString:@"tr123"], @"Track set with prefix" );
}

- (void)testFromdataWhereAlbumIdContainsPrefix {
    Track *track = [Track fromData:data_];
    STAssertTrue( [track.album.mid isEqualToString:@"al456"], @"Album mid set correctly" );
}

- (void)testFromdataWhereAlbumIdDoesntContainPrefix {
    [[data_ valueForKey:@"album"] setValue:@"456" forKey:@"id"];
    Track *track = [Track fromData:data_];
    STAssertTrue( [track.album.mid isEqualToString:@"al456"], @"Album mid set correctly" );
}

@end
