@protocol SBSetInteractorInput <NSObject>

- (void)updateSet:(NSDictionary *)set withNumber:(int)number;
- (void)updateSet:(NSDictionary *)set withWeight:(float)weight;
- (void)updateSet:(NSDictionary *)set withRepetitions:(int)repetitions;

@end

@protocol SBSetInteractorOutput <NSObject>

- (void)updatedSet:(NSDictionary *)set;

@end