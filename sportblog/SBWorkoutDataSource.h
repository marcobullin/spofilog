#import <Foundation/Foundation.h>
#import "SBWorkout.h"

@interface SBWorkoutDataSource : NSObject

- (RLMResults *)allWorkoutsOrderedByDate;
- (SBWorkout *)createWorkoutWithName:(NSString *)name andDate:(NSDate *)date;
- (void)deleteWorkoutWithId:(int)workoutId;

@end
