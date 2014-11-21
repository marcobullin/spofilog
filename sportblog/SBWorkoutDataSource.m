#import "SBWorkoutDataSource.h"
#import "SBWorkout.h"

@implementation SBWorkoutDataSource

- (RLMResults *)allWorkoutsOrderedByDate {
    return [[SBWorkout allObjects] sortedResultsUsingProperty:@"date" ascending:NO];
}

- (SBWorkout *)createWorkoutWithName:(NSString *)name andDate:(NSDate *)date {
    SBWorkout *workout = [SBWorkout new];
    workout.workoutId = [NSString stringWithFormat:@"workoutId_%f", [[NSDate date] timeIntervalSince1970] * 1000];
    workout.name = name;
    workout.date = date;
    
    RLMRealm *realm = [RLMRealm defaultRealm];
    
    [realm beginWriteTransaction];
    [realm addObject:workout];
    [realm commitWriteTransaction];
    
    return workout;
}

- (void)deleteWorkoutWithId:(NSString *)workoutId {
    SBWorkout *workout = [self distinctWorkoutWithId:workoutId];
    
    if (workout == nil) {
        return;
    }
    
    [RLMRealm.defaultRealm beginWriteTransaction];
    
    // delete exercises
    for (SBExerciseSet *exercise in workout.exercises) {
        
        // delete sets
        for (SBSet *set in exercise.sets) {
            [workout.exercises.realm deleteObject:set];
        }
        
        [workout.realm deleteObject:exercise];
    }
    
    // delete workout
    [RLMRealm.defaultRealm deleteObject:workout];
    [RLMRealm.defaultRealm commitWriteTransaction];
}

- (SBWorkout *)distinctWorkoutWithId:(NSString *)workoutId {
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"workoutId = %@", workoutId];
    RLMResults *workouts = [SBWorkout objectsWithPredicate:pred];
    
    if ([workouts count] != 1) {
        return nil;
    }
    
    return [workouts firstObject];
}

- (SBExerciseSet *)distinctExerciseSetWithId:(NSString *)exerciseSetId {
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"exerciseId = %@", exerciseSetId];
    RLMResults *exercises = [SBExerciseSet objectsWithPredicate:pred];
    
    if ([exercises count] != 1) {
        return nil;
    }
    
    return [exercises firstObject];
}

- (void)removeExerciseSetWithId:(NSString *)exerciseId fromWorkoutWithId:(NSString *)workoutId {
    SBWorkout *workout = [self distinctWorkoutWithId:workoutId];
    
    if (workout == nil) {
        return;
    }
    
    SBExerciseSet *exercise = [self distinctExerciseSetWithId:exerciseId];
    
    if (exercise == nil) {
        return;
    }
    
    [workout.realm beginWriteTransaction];
    
    // delete sets
    for (SBSet *set in exercise.sets) {
        [RLMRealm.defaultRealm deleteObject:set];
    }
    
    // remove exercise from workout
    for (int i = 0; i < [workout.exercises count]; i++) {
        SBExerciseSet *exerciseSet = [workout.exercises objectAtIndex:i];
        if ([exerciseSet isEqualToObject:exercise]) {
            [workout.exercises removeObjectAtIndex:i];
            break;
        }
    }
    
    [RLMRealm.defaultRealm deleteObject:exercise];
    
    [workout.realm commitWriteTransaction];
}

- (void)updateWorkoutWithId:(NSString *)workoutId withName:(NSString *)workoutName andDate:(NSDate *)workoutDate {
    SBWorkout *workout = [self distinctWorkoutWithId:workoutId];
    
    if (workout == nil) {
        return;
    }
    
    [workout.realm beginWriteTransaction];
    workout.name = workoutName;
    workout.date = workoutDate;
    [workout.realm commitWriteTransaction];
}

-(void)addExercise:(NSDictionary *)exercise toWorkoutWithId:(NSString *)workoutId {
    SBWorkout *workout = [self distinctWorkoutWithId:workoutId];
    
    if (workout == nil) {
        return;
    }
    
    SBExerciseSet *exerciseSet =  [[SBExerciseSet alloc] init];
    exerciseSet.exerciseId = exercise[@"exerciseId"];
    exerciseSet.name = exercise[@"name"];
    exerciseSet.date = workout.date;
    exerciseSet.created = [[NSDate date] timeIntervalSince1970];
    
    exerciseSet.frontImages = exercise[@"frontImages"];
    exerciseSet.backImages = exercise[@"backImages"];
    
    [workout.realm beginWriteTransaction];
    [workout.exercises addObject:exerciseSet];
    [workout.realm commitWriteTransaction];
}

- (RLMArray *)allExercisesForWorkoutId:(NSString *)workoutId {
    SBWorkout *workout = [self distinctWorkoutWithId:workoutId];
    
    if (workout == nil) {
        return nil;
    }
    
    return workout.exercises;
}

@end
