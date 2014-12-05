#import <Foundation/Foundation.h>
#import "SBStatisticExerciseInteractorIO.h"
#import "SBStatisticExerciseView.h"

@interface SBStatisticExercisePresenter : NSObject <SBStatisticExerciseInteractorOutput>

@property (nonatomic, strong) id<SBStatisticExerciseInteractorInput> interactor;
@property (nonatomic, strong) id<SBStatisticExerciseView> view;


- (void)findStatisticsForExerciseSetsWithName:(NSString *)name;

@end
