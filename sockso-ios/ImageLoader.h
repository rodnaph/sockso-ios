
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MusicItem.h"
#import "SocksoServer.h"
#import "ImageLoaderDelegate.h"
#import "ImageCache.h"

@interface ImageLoader : NSObject {
    id <ImageLoaderDelegate> *delegate;
    ImageCache *cache;
}

@property (nonatomic, retain) SocksoServer *server;
@property (nonatomic, retain) MusicItem *item;
@property (nonatomic, retain) NSIndexPath *indexPath;
@property (nonatomic, assign) id <ImageLoaderDelegate> *delegate;

+ (ImageLoader *) fromServer:(SocksoServer *)server forItem:(MusicItem *)item atIndex:(NSIndexPath *)indexPath;

- (void) load;

@end

