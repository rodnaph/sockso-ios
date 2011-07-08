
#import "CommunityServerTest.h"
#import "CommunityServer.h"

@implementation CommunityServerTest

- (void) testIssupportedversionReturnsFalseWhenVersionBelowRequired {
    CommunityServer *server = [[CommunityServer alloc] init];
    server.version = @"1.3.4";
    STAssertFalse( [server isSupportedVersion], @"Version should not be supported" );
    server.version = @"1.3.5";
    STAssertFalse( [server isSupportedVersion], @"Version should not be supported" );
}

- (void) testIssupportedversionReturnsFalseWhenVersionIsInvalid {
    CommunityServer *server = [[CommunityServer alloc] init];
    server.version = @"";
    STAssertFalse( [server isSupportedVersion], @"Version should not be supported" );
    server.version = @"1";
    STAssertFalse( [server isSupportedVersion], @"Version should not be supported" );
    server.version = @"asdhjas.asdasd";
    STAssertFalse( [server isSupportedVersion], @"Version should not be supported" );
}

- (void) testIssupportedversionReturnsTrueWhenVersionEqualsRequired {
    CommunityServer *server = [[CommunityServer alloc] init];
    server.version = @"1.4.0";
    STAssertTrue( [server isSupportedVersion], @"Version should be supported" );
}

- (void) testIssupportedversionReturnsTrueWhenVersionAboveRequired {
    CommunityServer *server = [[CommunityServer alloc] init];
    server.version = @"1.4.5";
    STAssertTrue( [server isSupportedVersion], @"Version should be supported" );
    server.version = @"2.0.1";
    STAssertTrue( [server isSupportedVersion], @"Version should be supported" );
}

@end
