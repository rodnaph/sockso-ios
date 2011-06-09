
#import <UIKit/UIKit.h>

@interface ConnectView : UIViewController {
    UITextField *server;
    UIButton *connect;
    UIImage *background;
}

@property (nonatomic, retain) IBOutlet UITextField *server;
@property (nonatomic, retain) IBOutlet UIButton *connect;
@property (nonatomic, retain) UIImage *background;

- (IBAction) connectClicked; 

@end
