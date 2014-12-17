#import <Foundation/Foundation.h>

@protocol SBWorkoutListInteractorInput <NSObject>
- (void)findAllWorkoutsOrderedByDate;
- (void)createWorkout;
- (void)deleteWorkout:(NSDictionary *)workout atIndexPath:(NSIndexPath *)indexPath;
@end


@protocol SBWorkoutListInteractorOutput <NSObject>
- (void)foundWorkouts:(NSArray *)workouts;
- (void)workoutCreated:(NSDictionary *)workout;
- (void)workoutDeletedAtIndexPath:(NSIndexPath *)indexPath;
@end