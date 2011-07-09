
#import <SenTestingKit/SenTestingKit.h>
#import "SocksoServerTest.h"
#import "SocksoServer.h"

@implementation SocksoServerTest

- (void) setUp {
    server = [SocksoServer disconnectedServer:@"127.0.0.1"];
}

- (void) testSearchUrlEncodesTheSearchString {
    // @todo
    //NSURL *url = [server getSearchUrl:@"a b"];
    //BOOL isEqual = [[url path] isEqualToString:@"/json/search/a%20b"];
    //STAssertTrue( isEqual, @"Special characters should be encoded" );
}

@end
