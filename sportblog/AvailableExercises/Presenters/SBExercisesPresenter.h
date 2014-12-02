#import <Foundation/Foundation.h>
#import "SBExercisesInteractorIO.h"
#import "SBExercisesView.h"

@interface SBExercisesPresenter : NSObject <SBExercisesInteractorOutput>

@property (nonatomic, strong) id<SBExercisesInteractorInput> interactor;
@property (nonatomic, strong) id<SBExercisesView> view;

- (void)findExercises;
- (void)deleteExercise:(NSDictionary *)exercise atIndex:(int)index;
- (void)createExerciseWithName:(NSString *)name;
- (void)createBulkOfExercises;

@end
