@protocol SBSetListView <NSObject>

- (void)displaySets:(NSArray *)sets;
- (void)deleteSetAtIndex:(int)index;
- (void)displayCreatedSet:(NSDictionary *)set;

@end