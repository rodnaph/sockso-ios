
#import <UIKit/UIKit.h>

@interface HomeViewController : UITableViewController  <UISearchDisplayDelegate, UISearchBarDelegate> {
	NSMutableArray *listContent;
    NSDictionary *serverInfo;
}

@property (nonatomic, retain) NSMutableArray *listContent;
@property (nonatomic, retain) NSDictionary *serverInfo;

@end
