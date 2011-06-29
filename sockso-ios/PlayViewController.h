
#import <UIKit/UIKit.h>
#import "MusicItem.h"
#import "SocksoServer.h"
#import "AudioStreamer.h"

@interface PlayViewController : UIViewController {
    UILabel *nameLabel;
    MusicItem *item;
    SocksoServer *server;
    AudioStreamer *streamer;
}

@property (nonatomic, retain) IBOutlet UILabel *nameLabel;
@property (nonatomic, retain) MusicItem *item;
@property (nonatomic, retain) SocksoServer *server;
@property (nonatomic, retain) AudioStreamer *streamer;

+ (PlayViewController *) viewForTrack:(MusicItem *) item server:(SocksoServer *) server;

@end
