#import "SBWorkoutInteractor.h"
#import "SBWorkoutDataSource.h"

@implementation SBWorkoutInteractor

- (void)findExercisesFromWorkout:(NSDictionary *)workout {
    SBWorkoutDataSource *dataSource = [SBWorkoutDataSource new];
    RLMArray *exercises = [dataSource allExercisesForWorkoutId:workout[@"workoutId"]];
    
    NSMutableArray *exercisesArray = [NSMutableArray new];
    for (SBExerciseSet *exercise in exercises) {
        NSMutableDictionary *dict = [NSMutableDictionary new];
        [dict setObject:exercise.exerciseId forKey:@"exerciseId"];
        [dict setObject:exercise.name forKey:@"name"];
        [dict setObject:exercise.frontImages forKey:@"frontImages"];
        [dict setObject:exercise.backImages forKey:@"backImages"];
        
        
        NSMutableArray *sets = [NSMutableArray new];
        for (SBSet *set in exercise.sets) {
            NSDictionary *dictSet = [NSDictionary dictionaryWithObjects:@[
                                                                       set.setId,
                                                                       [NSString stringWithFormat:@"%d", set.number],
                                                                       [NSString stringWithFormat:@"%f", set.weight],
                                                                       [NSString stringWithFormat:@"%d", set.repetitions]
                                                                       ]
                                                             forKeys:@[
                                                                       @"setId",
                                                                       @"number",
                                                                       @"weight",
                                                                       @"repetitions"]];
            [sets addObject:dictSet];
        }
        [dict setObject:sets forKey:@"sets"];
        
        [exercisesArray addObject:dict];
    }
    
    [self.output foundExercises:exercisesArray];
}

- (void)removeExercise:(NSDictionary *)exercise fromWorkout:(NSDictionary *)workout atIndex:(int)index {
    SBWorkoutDataSource *dataSource = [SBWorkoutDataSource new];
    [dataSource removeExerciseSetWithId:exercise[@"exerciseId"] fromWorkoutWithId:workout[@"workoutId"]];
    
    [self.output exerciseDeletedAtIndex:index];
}

- (void)updateWorkout:(NSDictionary *)workout withName:(NSString *)workoutName andDate:(NSDate *)workoutDate {
    SBWorkoutDataSource *dataSource = [SBWorkoutDataSource new];
    [dataSource updateWorkoutWithId:workout[@"workoutId"] withName:workoutName andDate:workoutDate];
    
    [self.output updatedWorkoutWithName:workoutName andDate:workoutDate];
}

- (void)addExercise:(NSDictionary *)exercise toWorkoutWithId:(NSString *)workoutId {
    SBWorkoutDataSource *dataSource = [SBWorkoutDataSource new];
    SBExerciseSet *exerciseSet = [dataSource addExercise:exercise toWorkoutWithId:workoutId];
    
    NSMutableDictionary *dict = [NSMutableDictionary new];
    [dict setObject:exerciseSet[@"exerciseId"] forKey:@"exerciseId"];
    [dict setObject:exerciseSet[@"name"] forKey:@"name"];
    [dict setObject:exerciseSet[@"frontImages"] forKey:@"frontImages"];
    [dict setObject:exerciseSet[@"backImages"] forKey:@"backImages"];
    [dict setObject:[NSMutableArray new] forKey:@"sets"];
    
    [self.output addedExercise:dict];
}



@end
