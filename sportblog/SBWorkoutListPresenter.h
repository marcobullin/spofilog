#import <Foundation/Foundation.h>
#import "SBWorkoutInteractorIO.h"
#import "SBWorkoutsView.h"

@interface SBWorkoutListPresenter : NSObject <SBWorkoutInteractorOutput>

@property(nonatomic, strong) id<SBWorkoutInteractorInput> workoutInteractor;
@property(nonatomic, strong) id<SBWorkoutsView> view;

- (void)findWorkouts;
- (void)createWorkout;
- (void)removeWorkout:(NSDictionary *)workout atIndexPath:(NSIndexPath *)indexPath;

@end
