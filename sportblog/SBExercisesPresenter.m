#import "SBExercisesPresenter.h"

@implementation SBExercisesPresenter

- (void)findExercises {
    [self.interactor findExercisesOrderedByName];
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
                                                                  backImageNames
                                                                  ]
                                                         forKeys:@[
                                                                   @"exerciseId",
                                                                   @"name",
                                                                   @"frontImages",
                                                                   @"backImages"
                                                                   ]];
        [result addObject:dict];
        
    }
    
    [self.view displayExercises:result];
}

- (void)deleteExercise:(NSDictionary *)exercise atIndex:(int)index {
    [self.interactor deleteExercise:exercise atIndex:index];
}

- (void)deletedExerciseAtIndex:(int)index {
    [self.view deletedExerciseAtIndex:index];
}

- (void)createExerciseWithName:(NSString *)name {
    [self.interactor createExerciseWithName:name];
}

- (void)exerciseAllreadyExists:(NSString *)name {
    [self.view scrollToExerciseWithName:name];
}

- (void)exerciseCreated:(NSDictionary *)exercise {
    [self.view createdExercise:exercise];
}

- (void)createBulkOfExercises {
    [self.interactor createBulkOfExercises];
}

@end
