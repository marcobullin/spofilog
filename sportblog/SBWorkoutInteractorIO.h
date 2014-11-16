#import <Foundation/Foundation.h>

@protocol SBWorkoutInteractorInput <NSObject>
- (void)findAllWorkoutsOrderedByDate;
- (void)createWorkout;
- (void)removeWorkoutWithId:(NSString *)workoutId atIndexPath:(NSIndexPath *)indexPath;
@end


@protocol SBWorkoutInteractorOutput <NSObject>
- (void)foundWorkouts:(NSArray *)workouts;
- (void)workoutCreated:(NSDictionary *)workout;
- (void)workoutDeletedAtIndexPath:(NSIndexPath *)indexPath;
@end