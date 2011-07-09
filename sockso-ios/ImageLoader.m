
#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"
#import "ImageLoader.h"
#import "ImageLoaderDelegate.h"
#import "SocksoServer.h"

@implementation ImageLoader

@synthesize indexPath, item, server, delegate;

+ (ImageLoader *) fromServer:(SocksoServer *)server forItem:(MusicItem *)item atIndex:(NSIndexPath *)indexPath {
    
    ImageLoader *loader = [ImageLoader alloc];
    
    loader.server = server;
    loader.item = item;
    loader.indexPath = indexPath;
    
    return [loader autorelease];
    
}

- (void) load {

    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@/file/cover/%@",
                                       server.ipAndPort,
                                       item.mid]];
    __block ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    __block id <ImageLoaderDelegate> *del = delegate;
    
    [request setCompletionBlock:^{
        UIImage *image = [UIImage imageWithData:[request responseData]];
        [(id <ImageLoaderDelegate> )del imageDidLoad:image atIndex:indexPath];
    }];
    
    [request startAsynchronous];
    
}

- (void) dealloc {

    [indexPath release];
    [item release];
    [server release];
    
    [super dealloc];
    
}

@end
