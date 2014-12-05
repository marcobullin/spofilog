@protocol SBIconListInteractorInput <NSObject>

- (void)updateExercise:(NSDictionary *)exercise withFrontImages:(NSArray *)images atIndexPath:(NSIndexPath *)indexPath;
- (void)updateExercise:(NSDictionary *)exercise withBackImages:(NSArray *)images atIndexPath:(NSIndexPath *)indexPath;

@end


@protocol SBIconListInteractorOutput <NSObject>

- (void)updatedIcons:(NSDictionary *)icons atIndexPath:(NSIndexPath *)indexPath;

@end