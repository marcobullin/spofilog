#import <Foundation/Foundation.h>
#import "SBWorkout.h"
#import "SBExercise.h"
#import "SBExerciseSet.h"
#import "SBSet.h"

@interface SBExerciseInteractor : NSObject

- (void)createExerciseSetFromWorkout:(SBWorkout *)workout andExercise:(SBExercise *)exercise;
- (void)createExerciseWithName:(NSString *)name frontImages:(NSString *)frontImages andBackImages:(NSString *)backImages;
- (void)deleteExercise:(SBExercise *)exercise;
- (void)createBulkOfExercises;
- (void)addSet:(SBSet *)set toExerciseSet:(SBExerciseSet *)exercise;
- (BOOL)isExerciseNameAlreadyAvailable:(NSString *)name;

@end
