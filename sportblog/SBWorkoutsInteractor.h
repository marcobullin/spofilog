#import <Foundation/Foundation.h>
#import "SBWorkout.h"
#import "SBExerciseSet.h"

@interface SBWorkoutsInteractor : NSObject

- (RLMArray *)findWorkouts;
- (void)deleteWorkout:(SBWorkout *)workout;
- (void)updateWorkout:(SBWorkout *)workout withName:(NSString *)name andDate:(NSDate *)date;
- (SBWorkout *)createWorkoutWithName:(NSString *)name andDate:(NSDate *)date;
- (void)removeExerciseAtRow:(int)row fromWorkout:(SBWorkout *)workout;

@end
