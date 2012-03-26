#import <UIKit/UIKit.h>
#import "SFRestAPI.h"

@interface RootViewController : UITableViewController <SFRestDelegate> {
    
    NSArray *dataRows;
    NSArray *breedNames;
    IBOutlet UITableView *tableView;    
    
}

@property (nonatomic, retain) NSArray *dataRows;
@property (nonatomic, retain) NSArray *breedNames;


@end