
#import <UIKit/UIKit.h>

@interface ConnectView : UIViewController <UITextFieldDelegate> {
    UITextField *server;
    UIButton *connect;
}

@property (nonatomic, retain) IBOutlet UITextField *server;
@property (nonatomic, retain) IBOutlet UIButton *connect;

- (IBAction) connectClicked; 

@end
