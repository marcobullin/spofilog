#import "SBExerciseInteractor.h"

@implementation SBExerciseInteractor

- (void)createExerciseSetFromWorkout:(SBWorkout *)workout andExercise:(SBExercise *)exercise {
    SBExerciseSet *exerciseSet =  [[SBExerciseSet alloc] init];
    exerciseSet.name = exercise.name;
    exerciseSet.date = workout.date;
    exerciseSet.created = [[NSDate date] timeIntervalSince1970];
    exerciseSet.frontImages = exercise.frontImages;
    exerciseSet.backImages = exercise.backImages;
    
    [workout.realm beginWriteTransaction];
    [workout.exercises addObject:exerciseSet];
    [workout.realm commitWriteTransaction];
}

- (void)deleteExercise:(SBExercise *)exercise {
    RLMRealm *realm = [RLMRealm defaultRealm];
    
    [realm beginWriteTransaction];
    [realm deleteObject:exercise];
    [realm commitWriteTransaction];
}

- (void)createExerciseWithName:(NSString *)name frontImages:(NSString *)frontImages andBackImages:(NSString *)backImages {
    SBExercise *exercise = [[SBExercise alloc] init];
    exercise.name = name;
    exercise.frontImages = frontImages;
    exercise.backImages = backImages;
    
    [RLMRealm.defaultRealm beginWriteTransaction];
    [RLMRealm.defaultRealm addObject:exercise];
    [RLMRealm.defaultRealm commitWriteTransaction];
}

- (void)addSet:(SBSet *)set toExerciseSet:(SBExerciseSet *)exercise {
    [exercise.realm beginWriteTransaction];
    [exercise.sets addObject:set];
    [exercise.realm commitWriteTransaction];
}

- (void)createBulkOfExercises {
    SBExercise *exercise = [[SBExercise alloc] init];
    exercise.name = NSLocalizedString(@"bench press", nil);
    exercise.frontImages = @"front_shoulder,front_breast";
    exercise.backImages = @"back_triceps";
    
    SBExercise *exercise2 = [[SBExercise alloc] init];
    exercise2.name = NSLocalizedString(@"deadlift", nil);
    exercise2.frontImages = @"front_neck,front_sides,front_sixpack,front_legs";
    exercise2.backImages = @"back_neck,back_back,back_ass,back_legs";
    
    SBExercise *exercise3 = [[SBExercise alloc] init];
    exercise3.name = NSLocalizedString(@"biceps curls", nil);
    exercise3.frontImages = @"front_biceps";
    exercise3.backImages = @"back";
    
    SBExercise *exercise4 = [[SBExercise alloc] init];
    exercise4.name = NSLocalizedString(@"shoulder press", nil);
    exercise4.frontImages = @"front_neck,front_shoulder";
    exercise4.backImages = @"back_neck,back_shoulder";
    
    SBExercise *exercise5 = [[SBExercise alloc] init];
    exercise5.name = NSLocalizedString(@"hammer curl", nil);
    exercise5.frontImages = @"front_biceps,front_underarm";
    exercise5.backImages = @"back_underarm";
    
    SBExercise *exercise6 = [[SBExercise alloc] init];
    exercise6.name = NSLocalizedString(@"tricep press", nil);
    exercise6.frontImages = @"front";
    exercise6.backImages = @"back_triceps";
    
    SBExercise *exercise7 = [[SBExercise alloc] init];
    exercise7.name = NSLocalizedString(@"barbell shrug", nil);
    exercise7.frontImages = @"front_neck,front_underarm";
    exercise7.backImages = @"back_neck,back_underarm";
    
    SBExercise *exercise8 = [[SBExercise alloc] init];
    exercise8.name = NSLocalizedString(@"full squat", nil);
    exercise8.frontImages = @"front_legs";
    exercise8.backImages = @"back_ass,back_legs";
    
    SBExercise *exercise9 = [[SBExercise alloc] init];
    exercise9.name = NSLocalizedString(@"bench pull", nil);
    exercise9.frontImages = @"front";
    exercise9.backImages = @"back_triceps,back_shoulder,back_back";
    
    SBExercise *exercise10 = [[SBExercise alloc] init];
    exercise10.name = NSLocalizedString(@"butterfly", nil);
    exercise10.frontImages = @"front_shoulder,front_breast";
    exercise10.backImages = @"back";
    
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    [realm addObject:exercise];
    [realm addObject:exercise2];
    [realm addObject:exercise3];
    [realm addObject:exercise4];
    [realm addObject:exercise5];
    [realm addObject:exercise6];
    [realm addObject:exercise7];
    [realm addObject:exercise8];
    [realm addObject:exercise9];
    [realm addObject:exercise10];
    [realm commitWriteTransaction];
}

@end
