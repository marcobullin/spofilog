#import <UIKit/UIKit.h>
#import "SBWorkout.h"
#import "SBExercisesViewController.h"
#import "SBWorkoutsInteractor.h"
#import "SBExerciseInteractor.h"
#import "SBAbstractViewController.h"

@interface SBWorkoutViewController : SBAbstractViewController <UITableViewDataSource, UITableViewDelegate, SBExerciseViewControllerDelegate>

@property (nonatomic, strong) SBWorkout *workout;
@property (nonatomic, strong) SBWorkoutsInteractor *workoutInteractor;
@property (nonatomic, strong) SBExerciseInteractor *exerciseInteractor;

@end
