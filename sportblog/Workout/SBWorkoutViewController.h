#import <UIKit/UIKit.h>
#import "SBExercisesViewController.h"
#import "SBAbstractViewController.h"
#import "SBWorkoutPresenter.h"
#import "SBWorkoutView.h"

@interface SBWorkoutViewController : SBAbstractViewController <UITableViewDataSource, UITableViewDelegate, SBExerciseViewControllerDelegate, SBWorkoutView>

@property (nonatomic, strong) NSMutableDictionary *workout;
@property (nonatomic, strong) NSMutableArray *exercises;
@property (nonatomic, strong) SBWorkoutPresenter *workoutPresenter;

@end
