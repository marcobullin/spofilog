#import <Foundation/Foundation.h>

typedef void (^SBCellBlock)(id cell, id item);
typedef void (^SBOnDeleteBlock)(id item);

@interface SBArrayDataSource : NSObject <UITableViewDataSource>

- (id)initWithItems:(RLMArray *)items
     cellIdentifier:(NSString *)identifier
 configureCellBlock:(SBCellBlock)cellBlock
      onDeleteBlock:(SBOnDeleteBlock)deleteBlock;

- (id)itemAtIndexPath:(NSIndexPath *)indexPath;

@end