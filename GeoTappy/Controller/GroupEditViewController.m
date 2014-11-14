//
//  GroupEditViewController.m
//  GeoTappy
//
//  Created by Dylan Marriott on 11/10/14.
//  Copyright (c) 2014 Dylan Marriott. All rights reserved.
//

#import "GroupEditViewController.h"
#import "Group.h"
#import "User.h"
#import "FriendSelectionViewController.h"
#import "UserDefaults.h"
#import "CustomCell.h"
#import "UIBAlertView.h"
#import "Friend.h"

@interface GroupEditViewController () <FriendSelectionDelegate>

@end

@implementation GroupEditViewController {
    Group* _group;
    User* _user;
}

- (id)initWithGroup:(Group *)group user:(User *)user {
    if (self = [super initWithStyle:UITableViewStyleGrouped]) {
        _group = group;
        _user = user;
        self.title = _group.name;
        UIBarButtonItem* addItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(add:)];
        self.navigationItem.rightBarButtonItem = addItem;
        self.tableView.backgroundColor = [UIColor colorWithWhite:0.92 alpha:1.0];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    [self updateButtons];
}

- (void)updateButtons {
    NSMutableArray* notSelected = [NSMutableArray array];
    for (Friend* f in _user.friends) {
        if (![_group.friends containsObject:f]) {
            [notSelected addObject:f];
        }
    }
    self.navigationItem.rightBarButtonItem.enabled = notSelected.count > 0;
}

- (void)add:(id)sender {
    UserSelectionViewController* vc = [[UserSelectionViewController alloc] initWithDelegate:self group:_group];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - FriendSelectionDelegate
- (void)selectedFriend:(Friend *)friend {
    [_group addFriend:friend];
    [_user save];
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _group.friends.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Friend* friend = [_group.friends objectAtIndex:indexPath.row];
    CustomCell* cell = [[CustomCell alloc] initWithName:friend.name favourite:friend];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_group removeFriendAtIndex:indexPath.row];
        [_user save];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self updateButtons];
        
        if (_group.friends.count == 0) {
            UIBAlertView* av = [[UIBAlertView alloc] initWithTitle:@"Delete Group" message:@"Do you want to delete this group?" cancelButtonTitle:@"Cancel" otherButtonTitles:@"Delete", nil];
            [av showWithDismissHandler:^(NSInteger selectedIndex, NSString *selectedTitle, BOOL didCancel) {
                if (!didCancel) {
                    [_user.selectedFavourites removeObject:_group];
                    [_user.unselectedFavourites removeObject:_group];
                    [_user save];
                    [self.navigationController popViewControllerAnimated:YES];
                }
            }];
        }
    }
}


@end
