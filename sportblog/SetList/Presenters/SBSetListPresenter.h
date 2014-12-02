#import <Foundation/Foundation.h>
#import "SBSetListInteractorIO.h"
#import "SBSetListView.h"

@interface SBSetListPresenter : NSObject <SBSetListInteractorOutput>

@property (nonatomic, strong) id<SBSetListInteractorInput> interactor;
@property (nonatomic, strong) id<SBSetListView> view;

- (void)findSetsFromExercise:(NSDictionary *)exercise;
- (void)deleteSet:(NSDictionary *)set fromExercise:(NSDictionary *)exercise atIndex:(int)index;
- (void)createSetDependingOnSet:(NSDictionary *)set andAddToExercise:(NSDictionary *)exercise;
- (void)createSetDependingOnLastExerciseWithNumber:(int)number andAddToExercise:(NSDictionary *)exercise withFallbackWeight:(float)weight andFallbackRepetitions:(int)repetitions;

@end
