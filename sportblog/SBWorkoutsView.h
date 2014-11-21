#import <Foundation/Foundation.h>

@protocol SBWorkoutsView <NSObject>

- (void)displayCreatedWorkout:(NSDictionary *)workout;
- (void)displayWorkouts:(NSArray *)workouts;
- (void)displayWorkoutDetails:(NSDictionary *)workout;
- (void)removeWorkoutAtIndex:(int)index;

@end