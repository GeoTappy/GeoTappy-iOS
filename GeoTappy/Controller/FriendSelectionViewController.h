//
//  FriendSelectionViewController.h
//  GeoTappy
//
//  Created by Dylan Marriott on 12/10/14.
//  Copyright (c) 2014 Dylan Marriott. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Friend;
@class Group;

@protocol FriendSelectionDelegate <NSObject>

- (void)selectedFriend:(Friend *)friend;

@end

@interface UserSelectionViewController : UITableViewController

- (instancetype)initWithDelegate:(id<FriendSelectionDelegate>)delegate group:(Group *)group;

@end
