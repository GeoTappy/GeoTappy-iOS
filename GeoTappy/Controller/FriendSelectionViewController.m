//
//  FriendSelectionViewController.m
//  GeoTappy
//
//  Created by Dylan Marriott on 12/10/14.
//  Copyright (c) 2014 Dylan Marriott. All rights reserved.
//

#import "FriendSelectionViewController.h"
#import "Friend.h"
#import "User.h"
#import "UserDefaults.h"
#import "Group.h"
#import "CustomCell.h"

@implementation UserSelectionViewController {
    User* _user;
    __weak id<FriendSelectionDelegate> _delegate;
    NSMutableArray* _friends;
}

- (instancetype)initWithDelegate:(id<FriendSelectionDelegate>)delegate group:(Group *)group {
    if (self = [super initWithStyle:UITableViewStyleGrouped]) {
        _delegate = delegate;
        _user = [UserDefaults instance].currentUser;
        _friends = [NSMutableArray array];
        for (Friend* f in _user.friends) {
            if (![group.friends containsObject:f]) {
                [_friends addObject:f];
            }
        }
        self.tableView.backgroundColor = [UIColor colorWithWhite:0.92 alpha:1.0];
    }
    return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _friends.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    User* friend = [_friends objectAtIndex:indexPath.row];
    CustomCell* cell = [[CustomCell alloc] initWithName:friend.name favourite:friend];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    Friend* f = [_friends objectAtIndex:indexPath.row];
    [_delegate selectedFriend:f];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
