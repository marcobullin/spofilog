#import <UIKit/UIKit.h>
#import "SBWorkout.h"
#import "SBExercisesViewController.h"
#import "SBWorkoutsInteractor.h"
#import "GAITrackedViewController.h"

@interface SBWorkoutViewController : GAITrackedViewController <UITableViewDataSource, UITableViewDelegate, SBExerciseViewControllerDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) SBWorkout *workout;
@property (nonatomic, strong) SBWorkoutsInteractor *interactor;

@end
