#import "SBWorkoutDataSource.h"
#import "SBWorkout.h"
#import "SBExercise.h"

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

- (SBExercise *)distinctExerciseWithId:(NSString *)exerciseId {
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"exerciseId = %@", exerciseId];
    RLMResults *exercises = [SBExercise objectsWithPredicate:pred];
    
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
    
    exerciseSet.frontImages = [exercise[@"frontImages"] componentsJoinedByString:@","];
    exerciseSet.backImages = [exercise[@"backImages"] componentsJoinedByString:@","];
    
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

- (RLMResults *)allExercisesOrderedByName {
    return [[SBExercise allObjects] sortedResultsUsingProperty:@"name" ascending:YES];
}

- (void)deleteExerciseWithId:(NSString *)exerciseId {
    SBExercise *exercise = [self distinctExerciseWithId:exerciseId];
    
    if (exercise == nil) {
        return;
    }
    
    RLMRealm *realm = [RLMRealm defaultRealm];
    
    [realm beginWriteTransaction];
    [realm deleteObject:exercise];
    [realm commitWriteTransaction];
}

- (SBExercise *)createExerciseWithName:(NSString *)name {
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"name = %@", name];
    RLMResults *exercises = [SBExercise objectsWithPredicate:pred];
    
    if ([exercises count] > 0) {
        return nil;
    }
    
    SBExercise *exercise = [[SBExercise alloc] init];
    exercise.exerciseId = [NSString stringWithFormat:@"exercise_%f", [[NSDate date] timeIntervalSince1970] * 1000];
    exercise.name = name;
    exercise.frontImages = @"front";
    exercise.backImages = @"back";
    
    [RLMRealm.defaultRealm beginWriteTransaction];
    [RLMRealm.defaultRealm addObject:exercise];
    [RLMRealm.defaultRealm commitWriteTransaction];
    
    return exercise;
}

- (void)createBulkOfExercises {
    SBExercise *exercise = [[SBExercise alloc] init];
    exercise.exerciseId = [NSString stringWithFormat:@"exercise_%f", [[NSDate date] timeIntervalSince1970] * 1000];
    exercise.name = NSLocalizedString(@"bench press", nil);
    exercise.frontImages = @"front_shoulder,front_breast";
    exercise.backImages = @"back_triceps";
    
    SBExercise *exercise2 = [[SBExercise alloc] init];
    exercise2.exerciseId = [NSString stringWithFormat:@"exercise_%f", [[NSDate date] timeIntervalSince1970] * 1000];
    exercise2.name = NSLocalizedString(@"deadlift", nil);
    exercise2.frontImages = @"front_neck,front_sides,front_sixpack,front_legs";
    exercise2.backImages = @"back_neck,back_back,back_ass,back_legs";
    
    SBExercise *exercise3 = [[SBExercise alloc] init];
    exercise3.exerciseId = [NSString stringWithFormat:@"exercise_%f", [[NSDate date] timeIntervalSince1970] * 1000];
    exercise3.name = NSLocalizedString(@"biceps curls", nil);
    exercise3.frontImages = @"front_biceps";
    exercise3.backImages = @"back";
    
    SBExercise *exercise4 = [[SBExercise alloc] init];
    exercise4.exerciseId = [NSString stringWithFormat:@"exercise_%f", [[NSDate date] timeIntervalSince1970] * 1000];
    exercise4.name = NSLocalizedString(@"shoulder press", nil);
    exercise4.frontImages = @"front_neck,front_shoulder";
    exercise4.backImages = @"back_neck,back_shoulder";
    
    SBExercise *exercise5 = [[SBExercise alloc] init];
    exercise5.exerciseId = [NSString stringWithFormat:@"exercise_%f", [[NSDate date] timeIntervalSince1970] * 1000];
    exercise5.name = NSLocalizedString(@"hammer curl", nil);
    exercise5.frontImages = @"front_biceps,front_underarm";
    exercise5.backImages = @"back_underarm";
    
    SBExercise *exercise6 = [[SBExercise alloc] init];
    exercise6.exerciseId = [NSString stringWithFormat:@"exercise_%f", [[NSDate date] timeIntervalSince1970] * 1000];
    exercise6.name = NSLocalizedString(@"tricep press", nil);
    exercise6.frontImages = @"front";
    exercise6.backImages = @"back_triceps";
    
    SBExercise *exercise7 = [[SBExercise alloc] init];
    exercise7.exerciseId = [NSString stringWithFormat:@"exercise_%f", [[NSDate date] timeIntervalSince1970] * 1000];
    exercise7.name = NSLocalizedString(@"barbell shrug", nil);
    exercise7.frontImages = @"front_neck,front_underarm";
    exercise7.backImages = @"back_neck,back_underarm";
    
    SBExercise *exercise8 = [[SBExercise alloc] init];
    exercise8.exerciseId = [NSString stringWithFormat:@"exercise_%f", [[NSDate date] timeIntervalSince1970] * 1000];
    exercise8.name = NSLocalizedString(@"full squat", nil);
    exercise8.frontImages = @"front_legs";
    exercise8.backImages = @"back_ass,back_legs";
    
    SBExercise *exercise9 = [[SBExercise alloc] init];
    exercise9.exerciseId = [NSString stringWithFormat:@"exercise_%f", [[NSDate date] timeIntervalSince1970] * 1000];
    exercise9.name = NSLocalizedString(@"bench pull", nil);
    exercise9.frontImages = @"front";
    exercise9.backImages = @"back_triceps,back_shoulder,back_back";
    
    SBExercise *exercise10 = [[SBExercise alloc] init];
    exercise10.exerciseId = [NSString stringWithFormat:@"exercise_%f", [[NSDate date] timeIntervalSince1970] * 1000];
    exercise10.name = NSLocalizedString(@"butterfly", nil);
    exercise10.frontImages = @"front_shoulder,front_breast";
    exercise10.backImages = @"back";
    
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    [realm addObjects:@[
                        exercise,
                        exercise2,
                        exercise3,
                        exercise4,
                        exercise5,
                        exercise6,
                        exercise7,
                        exercise8,
                        exercise9,
                        exercise10
                        ]];
    [realm commitWriteTransaction];
}

@end
