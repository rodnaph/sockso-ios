
#import "AlbumTest.h"
#import "Album.h"

@implementation AlbumTest

- (void)setUp {
    data_ = [[[NSMutableDictionary alloc] init] autorelease];
    [data_ setValue:@"123" forKey:@"id"];
    [data_ setValue:@"foo" forKey:@"name"];
}

- (void)testMidSetCorrectWithDataDoesntContainPrefix {
    Album *album = [Album fromData:data_];
    STAssertTrue( [album.mid isEqualToString:@"al123"], @"Mid set correctly" );
}

- (void)testMidSetCorrectlyWhenDataContainsPrefix {
    [data_ setValue:@"al123" forKey:@"id"];
    Album *album = [Album fromData:data_];
    STAssertTrue( [album.mid isEqualToString:@"al123"], @"Mid set correctly" );
}

@end
