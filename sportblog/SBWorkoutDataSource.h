#import <Foundation/Foundation.h>
#import "SBWorkout.h"
#import "SBExercise.h"

@interface SBWorkoutDataSource : NSObject

- (RLMResults *)allWorkoutsOrderedByDate;
- (RLMArray *)allExercisesForWorkoutId:(NSString *)workoutId;
- (SBWorkout *)createWorkoutWithName:(NSString *)name andDate:(NSDate *)date;
- (void)deleteWorkoutWithId:(NSString *)workoutId;
- (void)removeExerciseSetWithId:(NSString *)exerciseId fromWorkoutWithId:(NSString *)workoutId;
- (void)addExercise:(NSDictionary *)exercise toWorkoutWithId:(NSString *)workoutId;
- (void)updateWorkoutWithId:(NSString *)workoutId withName:(NSString *)workoutName andDate:(NSDate *)workoutDate;
- (RLMResults *)allExercisesOrderedByName;
- (void)deleteExerciseWithId:(NSString *)exerciseId;
- (SBExercise *)createExerciseWithName:(NSString *)name;
- (void)createBulkOfExercises;

@end
