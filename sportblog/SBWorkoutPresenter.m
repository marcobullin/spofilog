#import "SBWorkoutPresenter.h"

@implementation SBWorkoutPresenter

- (void)findExercisesFromWorkout:(NSDictionary *)workout {
    [self.workoutInteractor findExercisesFromWorkout:workout];
}

- (void)foundExercises:(NSArray *)exercises {
    
    NSMutableArray *result = [NSMutableArray new];
    for (NSDictionary *exercise in exercises) {
        
        NSArray *frontImageNames = [NSArray new];
        NSArray *backImageNames = [NSArray new];
        
        if (exercise[@"frontImages"] != nil && ![exercise[@"frontImages"] isEqualToString:@""]) {
            frontImageNames = [exercise[@"frontImages"] componentsSeparatedByString: @","];
        }
        
        if (exercise[@"backImages"] != nil && ![exercise[@"backImages"] isEqualToString:@""]) {
            backImageNames = [exercise[@"backImages"] componentsSeparatedByString: @","];
        }
        
        NSDictionary *dict = [NSDictionary dictionaryWithObjects:@[
                                                                   exercise[@"exerciseId"],
                                                                   exercise[@"name"],
                                                                   frontImageNames,
                                                                   backImageNames,
                                                                   exercise[@"sets"]
                                                                   ]
                                                         forKeys:@[
                                                                   @"exerciseId",
                                                                   @"name",
                                                                   @"frontImages",
                                                                   @"backImages",
                                                                   @"sets"
                                                                   ]];
        [result addObject:dict];
        
    }
    
    [self.view displayExercises:result];
}

- (void)addExercise:(NSDictionary *)exercise toWorkout:(NSDictionary *)workout {
    [self.workoutInteractor addExercise:exercise toWorkoutWithId:workout[@"workoutId"]];
}

- (void)addedExercise:(NSDictionary *)exercise {

    NSArray *frontImageNames = [NSArray new];
    NSArray *backImageNames = [NSArray new];
        
    if (exercise[@"frontImages"] != nil && ![exercise[@"frontImages"] isEqualToString:@""]) {
        frontImageNames = [exercise[@"frontImages"] componentsSeparatedByString: @","];
    }
    
    if (exercise[@"backImages"] != nil && ![exercise[@"backImages"] isEqualToString:@""]) {
        backImageNames = [exercise[@"backImages"] componentsSeparatedByString: @","];
    }
    
    NSDictionary *dict = [NSDictionary dictionaryWithObjects:@[
                                                               exercise[@"exerciseId"],
                                                               exercise[@"name"],
                                                               frontImageNames,
                                                               backImageNames,
                                                               exercise[@"sets"]
                                                               ]
                                                     forKeys:@[
                                                               @"exerciseId",
                                                               @"name",
                                                               @"frontImages",
                                                               @"backImages",
                                                               @"sets"
                                                               ]];
    
    [self.view displayAddedExercise:dict];
}

- (void)removeExercise:(NSDictionary *)exercise fromWorkout:(NSDictionary *)workout atIndex:(int)index {
    [self.workoutInteractor removeExercise:exercise fromWorkout:workout atIndex:index];
}

- (void)exerciseDeletedAtIndex:(int)index {
    [self.view deletedExerciseAtIndex:index];
}

- (void)updateWorkout:(NSDictionary *)workout withName:(NSString *)name andDate:(NSDate *)date {
    if ([name isEqualToString:@""]) {
        name = NSLocalizedString(@"Workout", nil);
    }
    
    [self.workoutInteractor updateWorkout:workout withName:name andDate:date];
}

- (void)updatedWorkoutWithName:(NSString *)name andDate:(NSDate *)date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    
    NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];
    [dateFormatter2 setDateFormat:@"EEEE"];
    
    NSString *day = [dateFormatter2 stringFromDate:date];
    NSString *displayDate = [NSString stringWithFormat:@"%@ - %@", day, [dateFormatter stringFromDate:date]];
    
    NSDictionary *dict = [NSDictionary dictionaryWithObjects:@[name, displayDate, date] forKeys:@[@"name", @"date", @"dateObject"]];
    [self.view displayWorkout:dict];
}

@end
