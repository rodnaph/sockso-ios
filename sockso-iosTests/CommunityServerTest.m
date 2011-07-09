
#import "CommunityServerTest.h"
#import "CommunityServer.h"

@implementation CommunityServerTest

- (void) setUp {
    server = [[CommunityServer alloc] init];
}

- (void) tearDown {
    [server release];
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
    server.version = @"1.4.0";
    STAssertTrue( [server isSupportedVersion], @"Version should be supported" );
}

- (void) testIssupportedversionReturnsTrueWhenVersionAboveRequired {
    server.version = @"1.4.5";
    STAssertTrue( [server isSupportedVersion], @"Version should be supported" );
    server.version = @"2.0.1";
    STAssertTrue( [server isSupportedVersion], @"Version should be supported" );
}

@end
