#import <UIKit/UIKit.h>
#import "SBSet.h"
#import "SBAbstractViewController.h"
#import "SBSetInteractor.h"

@class SBSetViewController;

@protocol SBSetViewControllerDelegate <NSObject>
- (void)addSetViewController:(SBSetViewController *)controller didCreatedNewSet:(SBSet *)set;
@end

@interface SBSetViewController : SBAbstractViewController <UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate, UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic) int number;
@property (nonatomic) float weight;
@property (nonatomic) int repetitions;
@property (strong, nonatomic) SBSet *currentSet;
@property (strong, nonatomic) SBSet *previousSet;
@property (nonatomic, weak) id <SBSetViewControllerDelegate> delegate;
@property (nonatomic, strong) SBSetInteractor *setInteractor;

@end
