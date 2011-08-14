
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

- (void) testIssupportedversionReturnsFalseWhenVersionBelowRequired {
    server.version = @"1.3.4";
    STAssertFalse( [server isSupportedVersion], @"Version should not be supported" );
    server.version = @"1.3.5";
    STAssertFalse( [server isSupportedVersion], @"Version should not be supported" );
}

- (void) testIssupportedversionReturnsFalseWhenVersionIsInvalid {
    server.version = @"";
    STAssertFalse( [server isSupportedVersion], @"Version should not be supported" );
    server.version = @"1";
    STAssertFalse( [server isSupportedVersion], @"Version should not be supported" );
    server.version = @"asdhjas.asdasd";
    STAssertFalse( [server isSupportedVersion], @"Version should not be supported" );
}

- (void) testIssupportedversionReturnsTrueWhenVersionEqualsRequired {
    server.version = @"1.5.0";
    STAssertTrue( [server isSupportedVersion], @"Version should be supported" );
    server.version = @"1.5";
    STAssertTrue( [server isSupportedVersion], @"Version should be supported" );
}

- (void) testIssupportedversionReturnsTrueWhenVersionAboveRequired {
    server.version = @"1.5.5";
    STAssertTrue( [server isSupportedVersion], @"Version should be supported" );
    server.version = @"2.0.1";
    STAssertTrue( [server isSupportedVersion], @"Version should be supported" );
}

@end
