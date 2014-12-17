#import <Foundation/Foundation.h>

@protocol SBWorkoutsView <NSObject>

- (void)displayCreatedWorkout:(NSDictionary *)workout;
- (void)displayWorkouts:(NSDictionary *)workouts;
- (void)displayWorkoutDetails:(NSDictionary *)workout;
- (void)removeWorkoutAtIndexPath:(NSIndexPath *)indexPath;

@end