
#import "CommunityServerCell.h"

@implementation CommunityServerCell

@synthesize padlockImage=padlockImage_,
            serverNameLabel=serverNameLabel_;

- (void)dealloc {
    
    [padlockImage_ release];
    [serverNameLabel_ release];
    
    [super dealloc];
    
}

@end
