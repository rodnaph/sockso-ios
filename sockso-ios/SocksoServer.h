
#import <Foundation/Foundation.h>

@interface SocksoServer : NSObject {
    NSString *ipAndPort, *title, *tagline;
}

@property (nonatomic, retain) NSString *ipAndPort, *title, *tagline;

+ (SocksoServer *) fromData:(NSString *) ipAndPort title:(NSString *) title tagline:(NSString *) tagline;

@end
