#import <UIKit/UIKit.h>
#import "SBSet.h"
#import "SBAbstractViewController.h"
#import "SBSetInteractor.h"

@class SBSetViewController;

@interface SBSetViewController : SBAbstractViewController <UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate, UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic) int number;
@property (nonatomic) float weight;
@property (nonatomic) int repetitions;
@property (strong, nonatomic) SBSet *currentSet;
@property (strong, nonatomic) SBSet *previousSet;
@property (nonatomic, strong) SBSetInteractor *setInteractor;

@end
