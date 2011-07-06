
#import <Foundation/Foundation.h>

@protocol ImageLoaderDelegate <NSObject>

- (void) imageDidLoad:(UIImage *)image atIndex:(NSIndexPath *)indexPath;

@end
