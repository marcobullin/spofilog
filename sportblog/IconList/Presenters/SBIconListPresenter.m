#import "SBIconListPresenter.h"

@implementation SBIconListPresenter

- (void)updateExercise:(NSDictionary *)exercise withFrontImages:(NSArray *)images atIndexPath:(NSIndexPath *)indexPath {
    [self.interactor updateExercise:exercise withFrontImages:images atIndexPath:indexPath];
}

- (void)updateExercise:(NSDictionary *)exercise withBackImages:(NSArray *)images atIndexPath:(NSIndexPath *)indexPath {
    [self.interactor updateExercise:exercise withBackImages:images atIndexPath:indexPath];
}

- (void)updatedIcons:(NSDictionary *)icons atIndexPath:(NSIndexPath *)indexPath {
    [self.view updatedIcons:icons atIndexPath:indexPath];
}

@end
