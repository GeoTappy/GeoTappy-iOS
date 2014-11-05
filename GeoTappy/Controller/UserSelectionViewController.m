//
//  UserSelectionViewController.m
//  GeoTappy
//
//  Created by Dylan Marriott on 12/10/14.
//  Copyright (c) 2014 Dylan Marriott. All rights reserved.
//

#import "UserSelectionViewController.h"
#import "User.h"
#import "UserDefaults.h"
#import "Group.h"
#import "CustomCell.h"

@implementation UserSelectionViewController {
    User* _user;
    Group* _group;
    __weak id<UserSelectionDelegate> _delegate;
    NSMutableArray* _friends;
}

- (instancetype)initWithDelegate:(id<UserSelectionDelegate>)delegate group:(id)group {
    if (self = [super initWithStyle:UITableViewStyleGrouped]) {
        _delegate = delegate;
        _group = group;
        _user = [UserDefaults instance].currentUser;
        _friends = [NSMutableArray array];
        for (User* f in _user.friends) {
            if (![_group.users containsObject:f]) {
                [_friends addObject:f];
            }
        }
    }
    return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _friends.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    User* friend = [_friends objectAtIndex:indexPath.row];
    CustomCell* cell = [[CustomCell alloc] initWithName:friend.name image:friend.profileImage];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    User* u = [_friends objectAtIndex:indexPath.row];
    [_delegate selectedUser:u];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
