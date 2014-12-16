#import <UIKit/UIKit.h>

@interface TodayViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *exercises;

@end
