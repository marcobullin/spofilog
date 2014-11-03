#import <UIKit/UIKit.h>
#import "SBExerciseSet.h"
#import "SBSetViewController.h"
#import "SBAbstractViewController.h"
#import "SBSetInteractor.h"
#import "SBExerciseInteractor.h"

@interface SBSetsViewController : SBAbstractViewController <UITableViewDataSource, UITableViewDelegate, SBSetViewControllerDelegate>

@property (nonatomic, strong) SBExerciseSet *exercise;
@property (nonatomic, strong) RLMArray *sets;
@property (nonatomic, strong) SBSetInteractor *setInteractor;
@property (nonatomic, strong) SBExerciseInteractor *exerciseInteractor;

@end
