#import <UIKit/UIKit.h>
#import "SBAbstractViewController.h"
#import "SBWorkoutListPresenter.h"
#import "SBWorkoutsView.h"

@interface SBWorkoutsViewController : SBAbstractViewController <UITableViewDataSource, UITableViewDelegate, SBWorkoutsView>

@property (nonatomic, strong) SBWorkoutListPresenter *workoutPresenter;
@property (nonatomic, strong) NSArray *workouts;

@end
