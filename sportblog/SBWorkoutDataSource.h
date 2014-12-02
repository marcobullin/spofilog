#import <Foundation/Foundation.h>
#import "SBWorkout.h"
#import "SBExercise.h"

@interface SBWorkoutDataSource : NSObject

- (RLMResults *)allWorkoutsOrderedByDate;
- (RLMArray *)allExercisesForWorkoutId:(NSString *)workoutId;
- (SBWorkout *)createWorkoutWithName:(NSString *)name andDate:(NSDate *)date;
- (void)deleteWorkoutWithId:(NSString *)workoutId;
- (void)removeExerciseSetWithId:(NSString *)exerciseId fromWorkoutWithId:(NSString *)workoutId;
- (SBExerciseSet *)addExercise:(NSDictionary *)exercise toWorkoutWithId:(NSString *)workoutId;
- (void)updateWorkoutWithId:(NSString *)workoutId withName:(NSString *)workoutName andDate:(NSDate *)workoutDate;
- (RLMResults *)allExercisesOrderedByName;
- (void)deleteExerciseWithId:(NSString *)exerciseId;
- (SBExercise *)createExerciseWithName:(NSString *)name;
- (void)deleteSetWithId:(NSString *)setId fromExerciseWithId:(NSString *)exerciseId;
- (SBSet *)createSetWithNumber:(int)number weight:(float)weight andRepetitions:(int)repetitions;
- (void)addSet:(SBSet *)set toExerciseWithId:(NSString *)exerciseId;
- (SBSet *)lastSetOfExerciseWithName:(NSString *)name;


- (void)createBulkOfExercises;


@end
