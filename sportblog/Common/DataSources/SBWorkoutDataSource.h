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
- (SBSet *)updateSetWithId:(NSString *)setId withNumber:(int)number;
- (SBSet *)updateSetWithId:(NSString *)setId withWeight:(float)weight;
- (SBSet *)updateSetWithId:(NSString *)setId withRepetitions:(int)repetitions;
- (RLMArray *)allSetsFromExerciseWithId:(NSString *)exerciseId;
- (void)updateExerciseWithName:(NSString *)name withFrontImages:(NSArray *)images;
- (void)updateExerciseWithName:(NSString *)name withBackImages:(NSArray *)images;
- (RLMResults *)allExerciseSets;
- (RLMResults *)allExerciseSetsByName:(NSString *)name;

- (void)createBulkOfExercises;


@end
