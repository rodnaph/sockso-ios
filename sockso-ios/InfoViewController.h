
@interface InfoViewController : UIViewController {}

@property (nonatomic, retain) NSString *message;
@property (nonatomic, retain) IBOutlet UILabel *infoLabel;
@property (nonatomic, retain) IBOutlet UIButton *okButton;

+ (InfoViewController *)initWithString:(NSString *)message;

- (IBAction)okClicked;

@end
