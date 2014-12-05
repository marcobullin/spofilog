#import "SBStatisticExerciseInteractor.h"
#import "SBWorkoutDataSource.h"

@implementation SBStatisticExerciseInteractor

- (void)findExerciseSetsByName:(NSString *)name {
    SBWorkoutDataSource *datasource = [SBWorkoutDataSource new];

    RLMResults *exercises = [datasource allExerciseSetsByName:name];
    
    NSMutableArray *result = [NSMutableArray new];
    for (SBExerciseSet *exercise in exercises) {
        NSDictionary *dict = @{
            @"name": exercise.name,
            @"date": exercise.date,
            @"sets": exercise.sets
        };
        
        [result addObject:dict];
    }
    
    [self.output foundExerciseSets:result];
}

@end
