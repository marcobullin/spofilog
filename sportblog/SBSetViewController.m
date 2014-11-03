#import "SBSetViewController.h"
#import "SBLeftRightCell.h"
#import "UIColor+SBColor.h"

@interface SBSetViewController ()

@property (nonatomic) bool isEditSet;
@property (nonatomic) bool isEditWeight;
@property (nonatomic) bool isEditRepetitions;

@end

@implementation SBSetViewController
UIPickerView *picker;
UIView *changeView;
UIView *overlayView;

#pragma mark - lifecycle methods

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.screenName = @"Set Screen";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.setInteractor = [SBSetInteractor new];
    
    self.title = NSLocalizedString(@"Edit Set", nil);
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.allowsMultipleSelectionDuringEditing = NO;
    self.tableView.tableFooterView = [UIView new];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"cell";
    
    SBLeftRightCell *cell = (SBLeftRightCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SBLeftRightCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    cell.backgroundColor = [UIColor actionCellColor];
    cell.leftLabel.textColor = [UIColor whiteColor];
    cell.rightLabel.textColor = [UIColor whiteColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    // set cell
    if (indexPath.row == 0) {
        cell.leftLabel.text = NSLocalizedString(@"Set", nil);
        cell.rightLabel.text = [NSString stringWithFormat:@"%d", self.currentSet.number];
        
        return cell;
    }
    
    // weight cell
    if (indexPath.row == 1) {
        cell.leftLabel.text = NSLocalizedString(@"Weight", nil);
        cell.rightLabel.text = [NSString stringWithFormat:@"%.01f kg", self.currentSet.weight];
        return cell;
    }

    // repetition cell
    cell.leftLabel.text = NSLocalizedString(@"Repetitions", nil);
    cell.rightLabel.text = [NSString stringWithFormat:@"%d", self.currentSet.repetitions];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    changeView = [[UIView alloc] initWithFrame:CGRectMake(0, self.tableView.frame.size.height, self.tableView.frame.size.width, 280)];
    changeView.backgroundColor = [UIColor whiteColor];
    
    if (overlayView == nil) {
        overlayView = [UIView new];
        overlayView.frame = self.tableView.frame;
        overlayView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    }

    [self.view addSubview:overlayView];
    [self.view addSubview:changeView];
    
    picker = [[UIPickerView alloc] init];
    picker.frame = CGRectMake(0, 44, self.view.frame.size.width, 162);
    picker.showsSelectionIndicator = YES;
    picker.dataSource = self;
    picker.delegate = self;
    
    if (indexPath.row == 0) {
        self.isEditSet = YES;
        self.isEditWeight = NO;
        self.isEditRepetitions = NO;
        [picker selectRow:self.currentSet.number-1 inComponent:0 animated:NO];
        [changeView addSubview:[self createToolbar:NSLocalizedString(@"Set", nil)]];
    }
    
    if (indexPath.row == 1) {
        self.isEditSet = NO;
        self.isEditWeight = YES;
        self.isEditRepetitions = NO;
        
        NSString *str= [NSString stringWithFormat:@"%.01f", self.currentSet.weight];
        NSArray *arr = [str componentsSeparatedByString:@"."];
        int first=[[arr firstObject] intValue];
        int last=[[arr lastObject] intValue];
        
        [picker selectRow:first inComponent:0 animated:NO];
        [picker selectRow:last inComponent:2 animated:NO];
        
       [changeView addSubview:[self createToolbar:NSLocalizedString(@"Weight", nil)]];
    }
    
    if (indexPath.row == 2) {
        self.isEditSet = NO;
        self.isEditWeight = NO;
        self.isEditRepetitions = YES;
        [picker selectRow:self.currentSet.repetitions inComponent:0 animated:NO];
        [changeView addSubview:[self createToolbar:NSLocalizedString(@"Repetitions", nil)]];
    }
    
    [changeView addSubview:picker];
    
    [UIView animateWithDuration:0.5 animations:^{
        changeView.frame = CGRectMake(0, self.tableView.frame.size.height - changeView.frame.size.height,self.tableView.frame.size.width, 280);
    }];
}

#pragma mark - UIPickerViewDataSource

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (self.isEditSet || self.isEditRepetitions) {
        return 99;
    }
    
    if (component == 0) {
        return 300;
    }
    
    if (component == 1 || component == 3) {
        return 1;
    }
    
    return 10;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    if (self.isEditSet) {
        return 1;
    }
    
    if (self.isEditRepetitions) {
        return 1;
    }
    
    return 4;
}

#pragma mark - UIPickerViewDelegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    if (self.isEditWeight) {
        if (component == 0 || component == 2) {
            return [NSString stringWithFormat:@"%d", (int)row];
        }
        
        if (component == 1) {
            return [NSString stringWithFormat:@","];
        }
        
        if (component == 3) {
            return [NSString stringWithFormat:@"kg"];
        }
    }
    
    if (self.isEditSet) {
        return [NSString stringWithFormat:@"%d", (int)row + 1];
    }
    
    return [NSString stringWithFormat:@"%d", (int)row];
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    if (self.isEditSet || self.isEditRepetitions) {
        return 150.0;
    }
    
    if (component == 0) {
        return 50.0;
    }
    
    if (component == 1) {
        return 20.0;
    }
    
    if (component == 2) {
        return 30.0;
    }
    
    return 40.0;
}

#pragma mark - actions

- (UIView *)createToolbar:(NSString *)titleString {
    UIToolbar *inputAccessoryView = [[UIToolbar alloc] init];
    inputAccessoryView.translucent = NO;
    inputAccessoryView.barTintColor = [UIColor actionCellColor];
    inputAccessoryView.tintColor = [UIColor whiteColor];
    inputAccessoryView.barStyle = UIBarStyleDefault;
    inputAccessoryView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [inputAccessoryView sizeToFit];
    
    CGRect frame = inputAccessoryView.frame;
    frame.size.height = 44.0f;
    inputAccessoryView.frame = frame;
        
    UIBarButtonItem *doneBtn =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(saveChangesAndHideOverlay:)];
    UIBarButtonItem *flexibleSpaceLeft = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *cancelBtn =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(hideOverlay)];
        
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0 , 11.0f, 100, 21.0f)];
    [titleLabel setText:titleString];
    titleLabel.textColor = [UIColor whiteColor];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
        
    UIBarButtonItem *title = [[UIBarButtonItem alloc] initWithCustomView:titleLabel];
    
    NSMutableArray *array = [NSMutableArray arrayWithObjects:cancelBtn,flexibleSpaceLeft,title,flexibleSpaceLeft, doneBtn, nil];
    [inputAccessoryView setItems:array];
        
    return inputAccessoryView;
}

- (void)saveChangesAndHideOverlay:(id)sender {
    
    if (self.isEditSet) {
        int number = (int)[picker selectedRowInComponent:0] + 1;
        [self.setInteractor updateSet:self.currentSet withNumber:number];
    }
    
    if (self.isEditWeight) {
        float weight = [[NSString stringWithFormat:@"%d.%d", (int)[picker selectedRowInComponent:0], (int)[picker selectedRowInComponent:2]] floatValue];
        [self.setInteractor updateSet:self.currentSet withWeight:weight];
    }
    
    if (self.isEditRepetitions) {
        int repetitions = (int)[picker selectedRowInComponent:0];
        [self.setInteractor updateSet:self.currentSet withRepetitions:repetitions];
    }
    
    [self.tableView reloadData];
    
    [self hideOverlay];
}
    
- (void)hideOverlay {
    [UIView animateWithDuration:.5 animations:^{
        changeView.frame = CGRectMake(0, self.tableView.frame.size.height, self.tableView.frame.size.width, 280);
    } completion:^(BOOL finished) {
        [overlayView removeFromSuperview];
        [changeView removeFromSuperview];
    }];
}

@end
