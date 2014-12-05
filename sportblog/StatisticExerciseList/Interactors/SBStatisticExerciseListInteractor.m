#import "SBStatisticExerciseListInteractor.h"
#import "SBWorkoutDataSource.h"

@implementation SBStatisticExerciseListInteractor

- (void)findDistinctExerciseNames {
    SBWorkoutDataSource *datasource = [SBWorkoutDataSource new];
    RLMResults *exercises = [datasource allExerciseSets];
    
    NSMutableArray *result = [NSMutableArray new];
    for (SBExerciseSet *exercise in exercises) {
        if (![result containsObject:exercise.name]) {
            [result addObject:exercise.name];
        }
    }
    
    [self.output foundDistinctExerciseNames:result];
}

@end
