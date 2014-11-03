  //
//  YYReminderViewController.m
//  YouYun
//
//  Created by Ranchao Zhang on 3/21/14.
//  Copyright (c) 2014 Ranchao Zhang. All rights reserved.
//

#import "YYReminderViewController.h"

static NSString * const REMINDER_TABLE_VIEW_CELL_ID = @"REMINDER_TABLE_VIEW_CELL_ID";

@interface YYReminderViewController ()

@end

@implementation YYReminderViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initialize];
    [self fetchReminders];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self fetchReminders];
}

- (void)initialize
{
    // Setup new reminder icon
    FAKIonIcons *newReminderIcon = [FAKIonIcons ios7PlusIconWithSize:28];
    [newReminderIcon addAttribute:NSForegroundColorAttributeName value:SCHOOL_VERY_LIGHT_COLOR];
    
    UIButton *newReminderButton = [UIButton new];
    newReminderButton.frame = CGRectMake(276, 0, 44, 44);
    [newReminderButton setBackgroundImage:[newReminderIcon imageWithSize:CGSizeMake(44, 44)] forState:UIControlStateNormal];
    [newReminderButton setShowsTouchWhenHighlighted:YES];
    [newReminderButton addTarget:self action:@selector(newReminderButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spacer.width = -16;
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithCustomView:newReminderButton];
    self.navigationItem.rightBarButtonItems = @[spacer, barItem];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reminderDidChange:) name:REMINDERS_DID_CHANGE_NOTIFICATION object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Reminder
- (void)fetchReminders
{
    NSDictionary *parameter = @{@"signature" : @"tempkey"};
    [[YYHTTPManager I] GET:GET_REMINDERS_API withURLEncodedParameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        OLog(responseObject);
        _reminders = [responseObject[@"result"] mutableCopy];
        [_table reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        OLog(@"failure");
        OLog(error);
    }];
}

- (void)reminderDidChange:(NSNotification *) aNotification
{
    [self fetchReminders];
}


- (void)setReminderIsDone:(BOOL) isDone forReminderAtIndexPath:(NSIndexPath *) indexPath
{
    @try {
        OLog(_reminders[indexPath.item]);
        NSString *updateReminderURL = [NSString stringWithFormat:UPDATE_REMINDER_API, _reminders[indexPath.item][@"_id"]];
        
        [[YYHTTPManager I] PATCH:updateReminderURL withJSONParameters:@{@"isDone": @(isDone), @"signature" : @"tempkey"} success:^(AFHTTPRequestOperation *operation, id responseObject) {
            _reminders[indexPath.item] = responseObject[@"result"];
            [_table reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [_table reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        }];
    }
    @catch (NSException *exception) {
    }
    @finally {
    }
}

#pragma mark - UIBarButtonItem
- (void)newReminderButtonClicked:(id)sender
{
    YYNewReminderViewController *viewCtrl = [self.storyboard instantiateViewControllerWithIdentifier:[YYNewReminderViewController identifier]];
    [self.navigationController pushViewController:viewCtrl animated:YES];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _reminders.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YYReminderTableViewCell *cell = [_table dequeueReusableCellWithIdentifier:REMINDER_TABLE_VIEW_CELL_ID];
    NSDictionary *info = _reminders[indexPath.row];
    cell.title.text = info[@"message"];
    BOOL isChecked = [info[@"isDone"] boolValue];
    if (cell.checkbox.checked != isChecked) [cell.checkbox setChecked:isChecked];
    cell.checkbox.onTap = ^void (BOOL isChecked) {
        [self setReminderIsDone:isChecked forReminderAtIndexPath:indexPath];
    };
    return cell;
}

#pragma mark - UITableViewCell

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSDictionary *info = _reminders[indexPath.item];
        NSString *deleteReminderURL = [NSString stringWithFormat:UPDATE_REMINDER_API, info[@"_id"]];
        [[YYHTTPManager I] DELETE:deleteReminderURL withJSONParameters:@{@"signature" : @"tempkey"} success:^(AFHTTPRequestOperation *operation, id responseObject) {
            OLog(responseObject);
            [_reminders removeObjectAtIndex:indexPath.item];
            [_table deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            OLog(error);
        }];
    }   
}

@end
