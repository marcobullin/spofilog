#import "SBExercisesInteractor.h"
#import "SBWorkoutDataSource.h"
#import "SBExercise.h"

@implementation SBExercisesInteractor

- (void)findExercisesOrderedByName {
    SBWorkoutDataSource *datasource = [SBWorkoutDataSource new];
    RLMResults *exercises = [datasource allExercisesOrderedByName];
    
    NSMutableArray *result = [NSMutableArray new];
    
    for (SBExercise *exercise in exercises) {
        NSMutableDictionary *dict = [NSMutableDictionary new];
        [dict setObject:exercise.exerciseId forKey:@"exerciseId"];
        [dict setObject:exercise.name forKey:@"name"];
        [dict setObject:exercise.frontImages forKey:@"frontImages"];
        [dict setObject:exercise.backImages forKey:@"backImages"];
        
        [result addObject:dict];
    }
    
    [self.output foundExercises:result];
}

- (void)deleteExercise:(NSDictionary *)exercise atIndex:(int)index {
    SBWorkoutDataSource *datasource = [SBWorkoutDataSource new];
    [datasource deleteExerciseWithId:exercise[@"exerciseId"]];
    
    [self.output deletedExerciseAtIndex:index];
}

- (void)createExerciseWithName:(NSString *)name {
    SBWorkoutDataSource *datasource = [SBWorkoutDataSource new];
    SBExercise *exercise = [datasource createExerciseWithName:name];
    
    if (exercise == nil) {
        [self.output exerciseAllreadyExists:name];
        return;
    }
    
    NSDictionary *dict = [NSDictionary dictionaryWithObjects:@[
                                                               exercise.exerciseId,
                                                               exercise.name,
                                                               @[exercise.frontImages],
                                                               @[exercise.backImages]]
                                                     forKeys:@[
                                                               @"exerciseId",
                                                               @"name",
                                                               @"frontImages",
                                                               @"backImages"]];
    
    [self.output exerciseCreated:dict];
}

- (void)createBulkOfExercises {
    SBWorkoutDataSource *datasource = [SBWorkoutDataSource new];
    [datasource createBulkOfExercises];
    
    [self findExercisesOrderedByName];
}

@end
