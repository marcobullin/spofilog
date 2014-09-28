#import "SBArrayDataSource.h"

@interface SBArrayDataSource()

@property (nonatomic, strong) RLMArray *items;
@property (nonatomic, copy) NSString *cellIdentifier;
@property (nonatomic, copy) SBCellBlock configureCellBlock;
@property (nonatomic, copy) SBOnDeleteBlock onDeleteBlock;

@end

@implementation SBArrayDataSource

- (id)initWithItems:(RLMArray *)items cellIdentifier:(NSString *)identifier configureCellBlock:(SBCellBlock)cellBlock onDeleteBlock:(SBOnDeleteBlock)deleteBlock {
    self = [super init];
    
    if (self) {
        self.items = items;
        self.cellIdentifier = identifier;
        self.configureCellBlock = cellBlock;
        self.onDeleteBlock = deleteBlock;
    }
    
    return self;
}

- (id)itemAtIndexPath:(NSIndexPath *)indexPath {
    return [self.items objectAtIndex:indexPath.row];
}

#pragma mark UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:self.cellIdentifier forIndexPath:indexPath];
    
    id item = [self itemAtIndexPath:indexPath];
    self.configureCellBlock(cell, item);
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.items count];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        id item = [self.items objectAtIndex:indexPath.row];
        self.onDeleteBlock(item);
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationRight];
    }
}

@end
