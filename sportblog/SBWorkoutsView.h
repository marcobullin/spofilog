#import <Foundation/Foundation.h>

@protocol SBWorkoutsView <NSObject>

- (void)displayWorkouts:(NSArray *)workouts;
- (void)displayWorkoutDetails:(NSDictionary *)workout;
- (void)removeWorkoutAtIndexPath:(NSIndexPath *)indexPath;

@end