
#import <Foundation/Foundation.h>
#import "MusicItem.h"
#import "AudioStreamer.h"

@interface SocksoServer : NSObject {
    NSString *ipAndPort, *title, *tagline;
    AudioStreamer *streamer;
}

@property (nonatomic, retain) NSString *ipAndPort, *title, *tagline;
@property (nonatomic, retain) AudioStreamer *streamer;

+ (SocksoServer *) fromData:(NSString *) ipAndPort title:(NSString *) title tagline:(NSString *) tagline;

- (void) play:(MusicItem*) item;
- (void) play;

@end
