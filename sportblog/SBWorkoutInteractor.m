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
        [dict setObject:exercise.sets forKey:@"sets"];
        [dict setObject:exercise.frontImages forKey:@"frontImages"];
        [dict setObject:exercise.backImages forKey:@"backImages"];
        
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
    [dataSource addExercise:exercise toWorkoutWithId:workoutId];
    
    [self.output addedExercise:exercise];
}



@end
