
#import <UIKit/UIKit.h>

@interface HomeViewController : UITableViewController  <UISearchDisplayDelegate, UISearchBarDelegate> {
	NSMutableArray *listContent;
}

@property (nonatomic, retain) NSMutableArray *listContent;

@end
