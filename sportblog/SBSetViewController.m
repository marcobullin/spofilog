//
//  SBSetViewController.m
//  sportblog
//
//  Created by Marco Bullin on 13/09/14.
//  Copyright (c) 2014 Bullin. All rights reserved.
//

#import "SBSetViewController.h"
#import "SBLeftRightTableViewCell.h"

@interface SBSetViewController ()

@property (nonatomic) bool isEditSet;
@property (nonatomic) bool isEditWeight;
@property (nonatomic) bool isEditRepetitions;

@end

@implementation SBSetViewController
UIPickerView *picker;
UIView *changeView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.hidesBackButton = YES;
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(onDone:)];
    
    self.navigationItem.rightBarButtonItem = doneButton;
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(onCancelSet:)];
    self.navigationItem.leftBarButtonItem = cancelButton;
    
    if (self.currentSet) {
        self.number = self.currentSet.number;
        self.weight = self.currentSet.weight;
        self.repetitions = self.currentSet.repetitions;
    } else {
        if (self.previousSet) {
            self.number = self.previousSet.number+1;
            self.weight = self.previousSet.weight;
            self.repetitions = self.previousSet.repetitions;
        } else {
            self.number = 1;
            self.weight = 0.0;
            self.repetitions = 0;
        }
    }
    
    self.tableView.delegate = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    
    //self.view.backgroundColor = [UIColor colorWithRed:140.0f/255.0f green:150.0f/255.0f blue:160.0f/255.0f alpha:1];
    UIImageView *imageView = [[UIImageView alloc] init];
    [imageView setImage:[UIImage imageNamed:@"hantel.png"]];
    [self.tableView setBackgroundView:imageView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"cell";
    
    SBLeftRightTableViewCell *cell = (SBLeftRightTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SBLeftRightTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    cell.backgroundColor = [UIColor clearColor];
    cell.leftLabel.textColor = [UIColor whiteColor];
    cell.rightLabel.textColor = [UIColor whiteColor];
    
    // set cell
    if (indexPath.row == 0) {
        cell.leftLabel.text = NSLocalizedString(@"Set", nil);
        cell.rightLabel.text = [NSString stringWithFormat:@"%d", self.number];
        
        return cell;
    }
    
    // weight cell
    if (indexPath.row == 1) {
        cell.leftLabel.text = NSLocalizedString(@"Weight", nil);
        cell.rightLabel.text = [NSString stringWithFormat:@"%.01fkg", self.weight];
        return cell;
    }

    // repetition cell
    cell.leftLabel.text = NSLocalizedString(@"Repetitions", nil);
    cell.rightLabel.text = [NSString stringWithFormat:@"%d", self.repetitions];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
 
    changeView = [[UIView alloc] initWithFrame:CGRectMake(0, self.tableView.frame.size.height, self.tableView.frame.size.width, 200)];
    changeView.backgroundColor = [UIColor colorWithRed:200.0f/255.0f green:200.0f/255.0f blue:200.0f/255.0f alpha:0.8];
    
    [self.view addSubview:changeView];
    
    picker = [[UIPickerView alloc] init];
    picker.frame = CGRectMake(0, 44, 320, 162);
    picker.showsSelectionIndicator = YES;
    picker.dataSource = self;
    picker.delegate = self;
    
    if (indexPath.row == 0) {
        self.isEditSet = YES;
        self.isEditWeight = NO;
        self.isEditRepetitions = NO;
        [picker selectRow:self.number-1 inComponent:0 animated:NO];
        [changeView addSubview:[self createToolbar:NSLocalizedString(@"Set", nil)]];
    }
    
    if (indexPath.row == 1) {
        self.isEditSet = NO;
        self.isEditWeight = YES;
        self.isEditRepetitions = NO;
        
        NSString *str= [NSString stringWithFormat:@"%.01f", self.weight];
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
        [picker selectRow:self.repetitions inComponent:0 animated:NO];
        [changeView addSubview:[self createToolbar:NSLocalizedString(@"Repetitions", nil)]];
    }
    
    [changeView addSubview:picker];
    
    [UIView animateWithDuration:0.5 animations:^{
        changeView.frame = CGRectMake(0, self.tableView.frame.size.height - changeView.frame.size.height,self.tableView.frame.size.width, 200);
    }];
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
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

- (UIView *)createToolbar:(NSString *)titleString {
    UIToolbar *inputAccessoryView = [[UIToolbar alloc] init];
    inputAccessoryView.barStyle = UIBarStyleDefault;
    inputAccessoryView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [inputAccessoryView sizeToFit];
    
    CGRect frame = inputAccessoryView.frame;
    frame.size.height = 44.0f;
    inputAccessoryView.frame = frame;
        
    UIBarButtonItem *doneBtn =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done:)];
    UIBarButtonItem *flexibleSpaceLeft = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *cancelBtn =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)];
        
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0 , 11.0f, 100, 21.0f)];
    [titleLabel setText:titleString];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
        
    UIBarButtonItem *title = [[UIBarButtonItem alloc] initWithCustomView:titleLabel];
    
    NSMutableArray *array = [NSMutableArray arrayWithObjects:cancelBtn,flexibleSpaceLeft,title,flexibleSpaceLeft, doneBtn, nil];
    [inputAccessoryView setItems:array];
        
    return inputAccessoryView;
}

- (void)done:(id)sender {
    
    if (self.isEditSet) {
        self.number = [picker selectedRowInComponent:0] + 1;
    }
    
    if (self.isEditWeight) {
        self.weight = [[NSString stringWithFormat:@"%d.%d", [picker selectedRowInComponent:0], [picker selectedRowInComponent:2]] floatValue];
    }
    
    if (self.isEditRepetitions) {
        self.repetitions = [picker selectedRowInComponent:0];
    }
    
    [self.tableView reloadData];
    
    [UIView animateWithDuration:.5 animations:^{
        changeView.frame = CGRectMake(0, self.tableView.frame.size.height, self.tableView.frame.size.width, 200);
    } completion:^(BOOL finished) {
        [changeView removeFromSuperview];
    }];
}
    
- (void)cancel:(id)sender {
    [UIView animateWithDuration:.5 animations:^{
        changeView.frame = CGRectMake(0, self.tableView.frame.size.height, self.tableView.frame.size.width, 200);
    } completion:^(BOOL finished) {
        [changeView removeFromSuperview];
    }];
}

- (void)onDone:(id)sender {
    if (!self.currentSet) {
        SBSet *set = [[SBSet alloc] init];
        set.number = self.number;
        set.weight = self.weight;
        set.repetitions = self.repetitions;
        
        [self.delegate addSetViewController:self didCreatedNewSet:set];
    } else {
        [self.currentSet.realm beginWriteTransaction];
        self.currentSet.number = self.number;
        self.currentSet.weight = self.weight;
        self.currentSet.repetitions = self.repetitions;
        [self.currentSet.realm commitWriteTransaction];
    }

    [self.navigationController popViewControllerAnimated:YES];
}

- (void)onCancelSet:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
