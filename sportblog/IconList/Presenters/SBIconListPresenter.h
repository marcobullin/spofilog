#import <Foundation/Foundation.h>
#import "SBIconListInteractorIO.h"
#import "SBIconListView.h"

@interface SBIconListPresenter : NSObject <SBIconListInteractorOutput>

@property (nonatomic, strong) id<SBIconListInteractorInput>interactor;
@property (nonatomic, strong) id<SBIconListView> view;

- (void)updateExercise:(NSDictionary *)exercise withFrontImages:(NSArray *)images atIndexPath:(NSIndexPath *)indexPath;
- (void)updateExercise:(NSDictionary *)exercise withBackImages:(NSArray *)images atIndexPath:(NSIndexPath *)indexPath;

@end
