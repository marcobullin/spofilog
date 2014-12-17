#import "SBWorkoutListPresenter.h"

@implementation SBWorkoutListPresenter

- (void)findWorkouts {
    [self.workoutListInteractor findAllWorkoutsOrderedByDate];
}

- (void)foundWorkouts:(NSArray *)workouts {
    
    /*
     
     {
        name: Januar - 2014
        workouts: [WorkoutA, WorkoutB]
     }
     
     
     */
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    
    NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];
    [dateFormatter2 setDateFormat:@"EEEE"];
    
    NSDateFormatter *dateFormatter3 = [[NSDateFormatter alloc] init];
    [dateFormatter3 setDateFormat:@"MMMM - YYYY"];
    
    NSMutableDictionary *result = [NSMutableDictionary new];
    for (NSDictionary *workout in workouts) {
        NSDate *date = [workout objectForKey:@"date"];
        NSString *day = [dateFormatter2 stringFromDate:date];
        
        NSString *displayDate = [NSString stringWithFormat:@"%@ - %@", day, [dateFormatter stringFromDate:date]];
        NSString *displayName = [workout objectForKey:@"name"];
     
        NSMutableDictionary *dict = [NSMutableDictionary new];
        [dict setObject:workout[@"workoutId"] forKey:@"workoutId"];
        [dict setObject:displayName forKey:@"name"];
        [dict setObject:displayDate forKey:@"date"];
        [dict setObject:date forKey:@"dateObject"];
        
        NSString *headline = [dateFormatter3 stringFromDate:date];
        
        NSMutableArray *values = [result objectForKey:headline];
        if (values == nil) {
            values = [NSMutableArray new];
        }
        [values addObject:dict];
        [result setObject:values forKey:headline];
    }
    
    [self.view displayWorkouts:result];
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
    [dict setObject:date forKey:@"dateObject"];
    
    [self.view displayCreatedWorkout:dict];
}

- (void)deleteWorkout:(NSDictionary *)workout atIndexPath:(NSIndexPath *)indexPath {
    [self.workoutListInteractor deleteWorkout:workout atIndexPath:indexPath];
}

- (void)workoutDeletedAtIndexPath:(NSIndexPath *)indexPath {
    [self.view removeWorkoutAtIndexPath:indexPath];
}

@end
