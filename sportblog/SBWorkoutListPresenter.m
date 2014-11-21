#import "SBWorkoutListPresenter.h"

@implementation SBWorkoutListPresenter

- (void)findWorkouts {
    [self.workoutListInteractor findAllWorkoutsOrderedByDate];
}

- (void)foundWorkouts:(NSArray *)workouts {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    
    NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];
    [dateFormatter2 setDateFormat:@"EEEE"];
    
    NSMutableArray *allWorkouts = [NSMutableArray new];
    for (NSDictionary *workout in workouts) {
        NSDate *date = [workout objectForKey:@"date"];
        NSString *day = [dateFormatter2 stringFromDate:date];
        
        NSString *displayDate = [NSString stringWithFormat:@"%@ - %@", day, [dateFormatter stringFromDate:date]];
        NSString *displayName = [workout objectForKey:@"name"];
        
        NSMutableDictionary *dict = [NSMutableDictionary new];
        [dict setObject:workout[@"workoutId"] forKey:@"workoutId"];
        [dict setObject:displayName forKey:@"name"];
        [dict setObject:displayDate forKey:@"date"];
        
        [allWorkouts addObject:dict];
    }
    
    [self.view displayWorkouts:allWorkouts];
}

- (void)createWorkout {
    [self.workoutListInteractor createWorkout];
}

- (void)workoutCreated:(NSDictionary *)workout {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    
    NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];
    [dateFormatter2 setDateFormat:@"EEEE"];
    
    NSDate *date = [workout objectForKey:@"date"];
    NSString *day = [dateFormatter2 stringFromDate:date];
    
    NSString *displayDate = [NSString stringWithFormat:@"%@ - %@", day, [dateFormatter stringFromDate:date]];

    NSMutableDictionary *dict = [NSMutableDictionary new];
    [dict setObject:workout[@"workoutId"] forKey:@"workoutId"];
    [dict setObject:workout[@"name"] forKey:@"name"];
    [dict setObject:displayDate forKey:@"date"];
    
    [self.view displayCreatedWorkout:dict];
}

- (void)deleteWorkout:(NSDictionary *)workout atIndex:(int)index {
    [self.workoutListInteractor deleteWorkout:workout atIndex:index];
}

- (void)workoutDeletedAtIndex:(int)index {
    [self.view removeWorkoutAtIndex:index];
}

@end
