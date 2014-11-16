#import <UIKit/UIKit.h>
#import "SBAbstractViewController.h"
#import "SBWorkoutPresenter.h"
#import "SBWorkoutsView.h"

@interface SBWorkoutsViewController : SBAbstractViewController <UITableViewDataSource, UITableViewDelegate, SBWorkoutsView>

@property (nonatomic, strong) SBWorkoutPresenter *workoutPresenter;
@property (nonatomic, strong) NSArray *workouts;

@end
