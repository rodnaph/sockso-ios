
#import <Foundation/Foundation.h>

@interface CommunityServer : NSObject {
    NSString *title, *tagline, *version, *ipAndPort;
}

@property (nonatomic, retain) NSString *title, *tagline, *version, *ipAndPort;

+ (CommunityServer *) fromData:(NSDictionary *) data;

+ (NSMutableArray *) fetchAll:(void (^)(NSMutableArray *))onComplete;

- (BOOL) isSupportedVersion;

@end
