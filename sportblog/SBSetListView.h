@protocol SBSetListView <NSObject>

- (void)deleteSetAtIndex:(int)index;
- (void)displayCreatedSet:(NSDictionary *)set;

@end