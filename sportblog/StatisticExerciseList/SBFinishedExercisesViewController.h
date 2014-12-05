#import <UIKit/UIKit.h>
#import "SBAbstractViewController.h"
#import "SBStatisticExerciseListPresenter.h"
#import "SBStatisticExerciseListView.h"

@interface SBFinishedExercisesViewController : SBAbstractViewController <UITableViewDataSource, UITableViewDelegate, SBStatisticExerciseListView>

@property (nonatomic, strong) SBStatisticExerciseListPresenter *presenter;

@end
