
#import <UIKit/UIKit.h>
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
    
    [NSThread detachNewThreadSelector:@selector(loadAsync)
                             toTarget:self withObject:nil];
    
}

- (void) loadAsync {
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@/file/cover/%@",
                                       server.ipAndPort,
                                       item.mid]];
        
    NSLog( @"Fetch image: %@ (%@)", url, item.name );
        
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
    
    [[self delegate] imageDidLoad:image atIndex:indexPath];

    [url release];
    
}

- (void) dealloc {
    
    [indexPath release];
    [item release];
    [server release];
    
    [super dealloc];
    
}

@end
