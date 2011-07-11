
#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"
#import "ImageLoader.h"
#import "ImageLoaderDelegate.h"
#import "SocksoServer.h"

@implementation ImageLoader

@synthesize indexPath, item, server, delegate;

+ (ImageLoader *) fromServer:(SocksoServer *)server forItem:(MusicItem *)item atIndex:(NSIndexPath *)indexPath {
    
    NSLog( @"Creating image loader" );
    
    ImageLoader *loader = [[ImageLoader alloc] init];
    
    loader.server = server;
    loader.item = item;
    loader.indexPath = indexPath;
    
    return [loader autorelease];
    
}

- (id) init {
    
    self = [super init];
    
    cache = [[[ImageCache alloc] init] retain];
    
    return self;
    
}

- (void) load {

    if ( [cache isCached:item] ) {
        [(id <ImageLoaderDelegate> )delegate imageDidLoad:[cache read:item] atIndex:indexPath];
    }
    
    else {
    
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@/file/cover/%@",
                                           server.ipAndPort,
                                           item.mid]];
        __block ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
        __block id <ImageLoaderDelegate> *del = delegate;
        __block ImageCache *theCache = cache;
    
        [request setCompletionBlock:^{
            UIImage *image = [UIImage imageWithData:[request responseData]];
            [theCache write:image forItem:item];
            [(id <ImageLoaderDelegate> )del imageDidLoad:image atIndex:indexPath];
        }];
    
        [request startAsynchronous];
        
    }
    
}

- (void) dealloc {
    
    [cache release];

    [indexPath release];
    [item release];
    [server release];
    
    [super dealloc];
    
}

@end
