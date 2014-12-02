#import <Foundation/Foundation.h>

@protocol SBWorkoutListInteractorInput <NSObject>
- (void)findAllWorkoutsOrderedByDate;
- (void)createWorkout;
- (void)deleteWorkout:(NSDictionary *)workout atIndex:(int)index;
@end


@protocol SBWorkoutListInteractorOutput <NSObject>
- (void)foundWorkouts:(NSArray *)workouts;
- (void)workoutCreated:(NSDictionary *)workout;
- (void)workoutDeletedAtIndex:(int)index;
@end