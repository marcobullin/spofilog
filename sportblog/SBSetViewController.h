#import <UIKit/UIKit.h>
#import "SBSet.h"
#import "SBAbstractViewController.h"
#import "SBSetPresenter.h"

@class SBSetViewController;

@interface SBSetViewController : SBAbstractViewController <UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate, UIPickerViewDataSource, UIPickerViewDelegate, SBSetView>

@property (nonatomic) int number;
@property (nonatomic) float weight;
@property (nonatomic) int repetitions;
@property (strong, nonatomic) NSDictionary *currentSet;
@property (nonatomic, strong) SBSetPresenter *presenter;

@end
