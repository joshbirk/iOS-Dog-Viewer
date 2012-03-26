
#import <UIKit/UIKit.h>
#import "SFRestAPI.h"

@interface DogViewController : UIViewController <SFRestDelegate, UIPickerViewDataSource> {
    NSDictionary *dog;
    NSArray *breeds;
    NSString *selectedBreed;
	
	UILabel *lblDogName;
	UILabel *lblAge;
	UILabel *lblBreed;
    UIPickerView *selectBreed;
    UIButton *btnUpdateBreed;
    
}

//custom init method that allows us to pass in the album id to be loaded
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil dog:(NSDictionary *)_dog breeds:(NSArray *)_breeds;

@property (nonatomic, retain) NSDictionary *dog;
@property (nonatomic, retain) NSArray *breeds;
@property (nonatomic, retain) NSString *selectedBreed;


@property (nonatomic, retain) IBOutlet UILabel *lblDogName;
@property (nonatomic, retain) IBOutlet UILabel *lblAge;
@property (nonatomic, retain) IBOutlet UILabel *lblBreed;
@property (nonatomic, retain) IBOutlet UIPickerView *selectBreed;
@property (nonatomic, retain) IBOutlet UIButton *btnUpdateBreed;


@end
