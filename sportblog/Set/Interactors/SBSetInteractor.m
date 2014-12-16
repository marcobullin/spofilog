#import "SBSetInteractor.h"
#import "SBWorkoutDataSource.h"

@implementation SBSetInteractor

- (void)updateSet:(NSDictionary *)set withNumber:(int)number {
    SBWorkoutDataSource *datasource =[SBWorkoutDataSource new];
    SBSet *updatedSet = [datasource updateSetWithId:set[@"setId"] withNumber:number];
    
    if (updatedSet == nil) {
        return;
    }
    
    NSDictionary *dict = [NSDictionary dictionaryWithObjects:@[
                                                               updatedSet.setId,
                                                               [NSString stringWithFormat:@"%d", updatedSet.number],
                                                               [NSString stringWithFormat:@"%f", updatedSet.weight],
                                                               [NSString stringWithFormat:@"%d", updatedSet.repetitions]
                                                               ]
                                                     forKeys:@[
                                                               @"setId",
                                                               @"number",
                                                               @"weight",
                                                               @"repetitions"]];
    
    [self.output updatedSet:dict];
}

- (void)updateSet:(NSDictionary *)set withWeight:(float)weight {
    SBWorkoutDataSource *datasource =[SBWorkoutDataSource new];
    SBSet *updatedSet = [datasource updateSetWithId:set[@"setId"] withWeight:weight];

    if (updatedSet == nil) {
        return;
    }
    
    NSDictionary *dict = [NSDictionary dictionaryWithObjects:@[
                                                               updatedSet.setId,
                                                               [NSString stringWithFormat:@"%d", updatedSet.number],
                                                               [NSString stringWithFormat:@"%f", updatedSet.weight],
                                                               [NSString stringWithFormat:@"%d", updatedSet.repetitions]
                                                               ]
                                                     forKeys:@[
                                                               @"setId",
                                                               @"number",
                                                               @"weight",
                                                               @"repetitions"]];
    
    [self updateStatisticsForWidget];
    [self.output updatedSet:dict];
}

- (void)updateSet:(NSDictionary *)set withRepetitions:(int)repetitions {
    SBWorkoutDataSource *datasource =[SBWorkoutDataSource new];
    SBSet *updatedSet = [datasource updateSetWithId:set[@"setId"] withRepetitions:repetitions];
    
    if (updatedSet == nil) {
        return;
    }
    
    NSDictionary *dict = [NSDictionary dictionaryWithObjects:@[
                                                               updatedSet.setId,
                                                               [NSString stringWithFormat:@"%d", updatedSet.number],
                                                               [NSString stringWithFormat:@"%f", updatedSet.weight],
                                                               [NSString stringWithFormat:@"%d", updatedSet.repetitions]
                                                               ]
                                                     forKeys:@[
                                                               @"setId",
                                                               @"number",
                                                               @"weight",
                                                               @"repetitions"]];
    
    [self.output updatedSet:dict];
}

- (void)updateStatisticsForWidget {
    SBWorkoutDataSource *dataSource = [SBWorkoutDataSource new];
    
    RLMResults *exercises = [dataSource allExerciseSets];
    
    NSMutableArray *response = [NSMutableArray new];
    
    NSMutableArray *result = [NSMutableArray new];
    for (SBExerciseSet *exercise in exercises) {
        if (![result containsObject:exercise.name]) {
            [result addObject:exercise.name];
        }
    }
    
    int count = 0;
    float prevWeight = 0;
    float statisticProgress = 0;
    for (NSString *name in result) {
        RLMResults *exerciseSets = [dataSource allExerciseSetsByName:name];
        
        count = 0;
        prevWeight = 0;
        statisticProgress = 0;
        for (int i = 0; i < [exerciseSets count]; i++) {
            SBExerciseSet *exercise = exerciseSets[i];
            int countOfSets = [exercise.sets count];
            
            for (int j = 0; j < countOfSets; j++) {
                SBSet *set = [exercise.sets objectAtIndex:j];
                
                if (prevWeight != 0) {
                    statisticProgress += (((set.weight / prevWeight) * 100) - 100);
                }
                prevWeight = set.weight;
                count++;
            }
        }
        
        if (count != 0) {
            statisticProgress = statisticProgress / count;
        }
        
        NSDictionary *dict = @{
                               @"name" : name,
                               @"value" : [NSString stringWithFormat:@"%f", statisticProgress]
                               };
        
        [response addObject:dict];
    }
    
    NSUserDefaults *ud = [[NSUserDefaults alloc] initWithSuiteName:@"group.widget.statistics"];
    
    [ud setObject:response forKey:@"statistics"];
    [ud synchronize];
}

@end
