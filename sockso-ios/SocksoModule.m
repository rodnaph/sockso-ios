
#import "SocksoModule.h"
#import "CoreDataProvider.h"

@implementation SocksoModule

- (void)configure {
    
    [self bind:[UIApplication sharedApplication] toClass:[UIApplication class]];
    [self bindProvider:[[[CoreDataProvider alloc] init] autorelease] toClass:[NSManagedObjectContext class]];
    
}

@end
