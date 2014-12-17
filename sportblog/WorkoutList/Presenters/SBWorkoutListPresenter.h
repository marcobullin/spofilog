#import <Foundation/Foundation.h>
#import "SBWorkoutListInteractorIO.h"
#import "SBWorkoutsView.h"

@interface SBWorkoutListPresenter : NSObject <SBWorkoutListInteractorOutput>

@property(nonatomic, strong) id<SBWorkoutListInteractorInput> workoutListInteractor;
@property(nonatomic, strong) id<SBWorkoutsView> view;

- (void)findWorkouts;
- (void)createWorkout;
- (void)deleteWorkout:(NSDictionary *)workout atIndexPath:(NSIndexPath *)indexPath;

@end
