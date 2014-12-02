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

@end
