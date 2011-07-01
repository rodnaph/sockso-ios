
#import <Foundation/Foundation.h>

#define CS_MIN_VERSION @"1.3.5"
#define CS_SOCKSO_DOMAIN @"sockso.pu-gh.com"

@interface CommunityServer : NSObject {}

@property (nonatomic, retain) NSString *title, *tagline, *version, *ipAndPort;

+ (CommunityServer *) fromData:(NSDictionary *) data;

+ (void) fetchAll:(void (^)(NSMutableArray *))onComplete;
+ (NSMutableArray *) parseServerData:(NSString *) responseString;

- (BOOL) isSupportedVersion;

@end
