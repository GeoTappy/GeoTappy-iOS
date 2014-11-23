//
//  GeoTappyTests.m
//  GeoTappyTests
//
//  Created by Dylan Marriott on 22.11.14.
//  Copyright (c) 2014 Dylan Marriott. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "User.h"
#import "Friend.h"
#import "Group.h"

@interface GeoTappyTests : XCTestCase

@end

@implementation GeoTappyTests {
    User* _user;
    User* _bigUser;
}

- (void)setUp {
    [super setUp];
    
    _user = [[User alloc] init];
    _user.identifier = @0;
    _user.name = @"Dylan Marriott";
    _user.profileImageUrl = @"p0";
    NSMutableArray* friends = [NSMutableArray array];
    for (int i = 10; i < 20; i++) {
        Friend* friend = [[Friend alloc] init];
        friend.identifier = [NSNumber numberWithInt:i];
        friend.name = [NSString stringWithFormat:@"Friend #%i", i];
        friend.profileImageUrl = [NSString stringWithFormat:@"p%i", i];
        [friends addObject:friend];
    }
    _user.friends = friends;
    Group* g1 = [[Group alloc] init];
    g1.name = @"Group 1";
    [g1 addFriend:friends[0]];
    [g1 addFriend:friends[2]];
    [g1 addFriend:friends[4]];
    [g1 addFriend:friends[6]];
    Group* g2 = [[Group alloc] init];
    g2.name = @"Group 2";
    [g2 addFriend:friends[6]];
    [g2 addFriend:friends[8]];
    NSMutableArray* selected = [NSMutableArray array];
    [selected addObject:friends[0]];
    [selected addObject:friends[5]];
    [selected addObject:friends[8]];
    [selected addObject:g1];
    _user.selectedFavourites = selected;
    NSMutableArray* unselected = [NSMutableArray array];
    //[unselected addObject:friends[0]];
    [unselected addObject:friends[1]];
    [unselected addObject:friends[2]];
    [unselected addObject:friends[3]];
    [unselected addObject:friends[4]];
    //[unselected addObject:friends[5]];
    [unselected addObject:friends[6]];
    [unselected addObject:friends[7]];
    //[unselected addObject:friends[8]];
    [unselected addObject:friends[9]];
    [unselected addObject:g2];
    _user.unselectedFavourites = unselected;
}

- (void)testNoUpdates {
    NSString* jsonString = @"{ \"profile\":{ \"id\":0, \"email\":\"\", \"name\":\"Dylan Marriott\", \"profile_photo_url\":\"p0\", \"friends\":[ { \"id\":10, \"email\":\"\", \"name\":\"Friend #10\", \"profile_photo_url\":\"p10\" }, { \"id\":11, \"email\":\"\", \"name\":\"Friend #11\", \"profile_photo_url\":\"p11\" }, { \"id\":12, \"email\":\"\", \"name\":\"Friend #12\", \"profile_photo_url\":\"p12\" }, { \"id\":13, \"email\":\"\", \"name\":\"Friend #13\", \"profile_photo_url\":\"p13\" }, { \"id\":14, \"email\":\"\", \"name\":\"Friend #14\", \"profile_photo_url\":\"p14\" }, { \"id\":15, \"email\":\"\", \"name\":\"Friend #15\", \"profile_photo_url\":\"p15\" }, { \"id\":16, \"email\":\"\", \"name\":\"Friend #16\", \"profile_photo_url\":\"p16\" }, { \"id\":17, \"email\":\"\", \"name\":\"Friend #17\", \"profile_photo_url\":\"p17\" }, { \"id\":18, \"email\":\"\", \"name\":\"Friend #18\", \"profile_photo_url\":\"p18\" }, { \"id\":19, \"email\":\"\", \"name\":\"Friend #19\", \"profile_photo_url\":\"p19\" }, ], \"cover_photo_url\":\"\" } }";
    
    NSDictionary* json = [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
    [_user updateWithJson:json];
    
    XCTAssert(_user.selectedFavourites.count == 4);
    XCTAssert(_user.unselectedFavourites.count == 8);
    XCTAssert(_user.friends.count == 10);
    
    XCTAssert(_user.identifier.intValue == 0);
    XCTAssert([_user.profileImageUrl isEqualToString:@"p0"]);
    
    User* fav0 = _user.selectedFavourites[0];
    User* fav1 = _user.selectedFavourites[1];
    User* fav2 = _user.selectedFavourites[2];
    Group* fav3 = _user.selectedFavourites[3];
    
    XCTAssert(fav0.identifier.intValue == 10);
    XCTAssert(fav1.identifier.intValue == 15);
    XCTAssert(fav2.identifier.intValue == 18);
    XCTAssert([fav3.name isEqualToString:@"Group 1"]);
    XCTAssert(fav3.friends.count == 4);
}

- (void)testNewOrder {
    NSString* jsonString = @"{ \"profile\":{ \"id\":0, \"email\":\"\", \"name\":\"Dylan Marriott\", \"profile_photo_url\":\"p0\", \"friends\":[ { \"id\":10, \"email\":\"\", \"name\":\"Friend #10\", \"profile_photo_url\":\"p10\" }, { \"id\":16, \"email\":\"\", \"name\":\"Friend #16\", \"profile_photo_url\":\"p16\" }, { \"id\":11, \"email\":\"\", \"name\":\"Friend #11\", \"profile_photo_url\":\"p11\" }, { \"id\":13, \"email\":\"\", \"name\":\"Friend #13\", \"profile_photo_url\":\"p13\" }, { \"id\":19, \"email\":\"\", \"name\":\"Friend #19\", \"profile_photo_url\":\"p19\" }, { \"id\":15, \"email\":\"\", \"name\":\"Friend #15\", \"profile_photo_url\":\"p15\" }, { \"id\":12, \"email\":\"\", \"name\":\"Friend #12\", \"profile_photo_url\":\"p12\" }, { \"id\":17, \"email\":\"\", \"name\":\"Friend #17\", \"profile_photo_url\":\"p17\" }, { \"id\":18, \"email\":\"\", \"name\":\"Friend #18\", \"profile_photo_url\":\"p18\" }, { \"id\":14, \"email\":\"\", \"name\":\"Friend #14\", \"profile_photo_url\":\"p14\" }, ], \"cover_photo_url\":\"\" } }";
    
    NSDictionary* json = [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
    [_user updateWithJson:json];
    
    XCTAssert(_user.selectedFavourites.count == 4);
    XCTAssert(_user.unselectedFavourites.count == 8);
    XCTAssert(_user.friends.count == 10);
    
    XCTAssert(_user.identifier.intValue == 0);
    XCTAssert([_user.profileImageUrl isEqualToString:@"p0"]);
    
    User* fav0 = _user.selectedFavourites[0];
    User* fav1 = _user.selectedFavourites[1];
    User* fav2 = _user.selectedFavourites[2];
    Group* fav3 = _user.selectedFavourites[3];
    
    XCTAssert(fav0.identifier.intValue == 10);
    XCTAssert(fav1.identifier.intValue == 15);
    XCTAssert(fav2.identifier.intValue == 18);
    XCTAssert([fav3.name isEqualToString:@"Group 1"]);
    XCTAssert(fav3.friends.count == 4);
}

- (void)testAdd {
    NSString* jsonString = @"{ \"profile\":{ \"id\":0, \"email\":\"\", \"name\":\"Dylan Marriott\", \"profile_photo_url\":\"p0\", \"friends\":[ { \"id\":10, \"email\":\"\", \"name\":\"Friend #10\", \"profile_photo_url\":\"p10\" }, { \"id\":11, \"email\":\"\", \"name\":\"Friend #11\", \"profile_photo_url\":\"p11\" }, { \"id\":12, \"email\":\"\", \"name\":\"Friend #12\", \"profile_photo_url\":\"p12\" }, { \"id\":13, \"email\":\"\", \"name\":\"Friend #13\", \"profile_photo_url\":\"p13\" }, { \"id\":14, \"email\":\"\", \"name\":\"Friend #14\", \"profile_photo_url\":\"p14\" }, { \"id\":15, \"email\":\"\", \"name\":\"Friend #15\", \"profile_photo_url\":\"p15\" }, { \"id\":16, \"email\":\"\", \"name\":\"Friend #16\", \"profile_photo_url\":\"p16\" }, { \"id\":17, \"email\":\"\", \"name\":\"Friend #17\", \"profile_photo_url\":\"p17\" }, { \"id\":18, \"email\":\"\", \"name\":\"Friend #18\", \"profile_photo_url\":\"p18\" }, { \"id\":19, \"email\":\"\", \"name\":\"Friend #19\", \"profile_photo_url\":\"p19\" }, { \"id\":20, \"email\":\"\", \"name\":\"Friend #20\", \"profile_photo_url\":\"p20\" }, { \"id\":21, \"email\":\"\", \"name\":\"Friend #21\", \"profile_photo_url\":\"p21\" }, ], \"cover_photo_url\":\"\" } }";
    
    NSDictionary* json = [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
    [_user updateWithJson:json];
    
    XCTAssert(_user.selectedFavourites.count == 4);
    XCTAssert(_user.unselectedFavourites.count == 10);
    XCTAssert(_user.friends.count == 12);
    
    XCTAssert(_user.identifier.intValue == 0);
    XCTAssert([_user.profileImageUrl isEqualToString:@"p0"]);
    
    User* fav0 = _user.selectedFavourites[0];
    User* fav1 = _user.selectedFavourites[1];
    User* fav2 = _user.selectedFavourites[2];
    Group* fav3 = _user.selectedFavourites[3];
    
    XCTAssert(fav0.identifier.intValue == 10);
    XCTAssert(fav1.identifier.intValue == 15);
    XCTAssert(fav2.identifier.intValue == 18);
    XCTAssert([fav3.name isEqualToString:@"Group 1"]);
    XCTAssert(fav3.friends.count == 4);
}

- (void)testAddAndRemove {
    NSString* jsonString = @"{ \"profile\":{ \"id\":0, \"email\":\"\", \"name\":\"Dylan Marriott\", \"profile_photo_url\":\"p0\", \"friends\":[ { \"id\":10, \"email\":\"\", \"name\":\"Friend #10\", \"profile_photo_url\":\"p10\" }, { \"id\":16, \"email\":\"\", \"name\":\"Friend #16\", \"profile_photo_url\":\"p16\" }, { \"id\":11, \"email\":\"\", \"name\":\"Friend #11\", \"profile_photo_url\":\"p11\" }, { \"id\":13, \"email\":\"\", \"name\":\"Friend #13\", \"profile_photo_url\":\"p13\" }, { \"id\":19, \"email\":\"\", \"name\":\"Friend #19\", \"profile_photo_url\":\"p19\" }, { \"id\":15, \"email\":\"\", \"name\":\"Friend #15\", \"profile_photo_url\":\"p15\" }, { \"id\":17, \"email\":\"\", \"name\":\"Friend #17\", \"profile_photo_url\":\"p17\" }, { \"id\":24, \"email\":\"\", \"name\":\"Friend #24\", \"profile_photo_url\":\"p24\" }, ], \"cover_photo_url\":\"\" } }";
    
    NSDictionary* json = [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
    [_user updateWithJson:json];
    
    XCTAssert(_user.selectedFavourites.count == 3);
    XCTAssert(_user.unselectedFavourites.count == 7);
    XCTAssert(_user.friends.count == 8);
    
    XCTAssert(_user.identifier.intValue == 0);
    XCTAssert([_user.profileImageUrl isEqualToString:@"p0"]);
    
    User* fav0 = _user.selectedFavourites[0];
    User* fav1 = _user.selectedFavourites[1];
    Group* fav3 = _user.selectedFavourites[2];
    
    XCTAssert(fav0.identifier.intValue == 10);
    XCTAssert(fav1.identifier.intValue == 15);
    XCTAssert([fav3.name isEqualToString:@"Group 1"]);
    XCTAssert(fav3.friends.count == 3);
}

- (void)testUpdateProfilePhotos {
    NSString* jsonString = @"{ \"profile\":{ \"id\":0, \"email\":\"\", \"name\":\"Dylan Marriott\", \"profile_photo_url\":\"new1\", \"friends\":[ { \"id\":10, \"email\":\"\", \"name\":\"Friend #10\", \"profile_photo_url\":\"p10\" }, { \"id\":11, \"email\":\"\", \"name\":\"Friend #11\", \"profile_photo_url\":\"p11\" }, { \"id\":12, \"email\":\"\", \"name\":\"Friend #12\", \"profile_photo_url\":\"p12\" }, { \"id\":13, \"email\":\"\", \"name\":\"Friend #13\", \"profile_photo_url\":\"p13\" }, { \"id\":14, \"email\":\"\", \"name\":\"Friend #14\", \"profile_photo_url\":\"p14\" }, { \"id\":15, \"email\":\"\", \"name\":\"Friend #15\", \"profile_photo_url\":\"new2\" }, { \"id\":16, \"email\":\"\", \"name\":\"Friend #16\", \"profile_photo_url\":\"p16\" }, { \"id\":17, \"email\":\"\", \"name\":\"Friend #17\", \"profile_photo_url\":\"p17\" }, { \"id\":18, \"email\":\"\", \"name\":\"Friend #18\", \"profile_photo_url\":\"p18\" }, { \"id\":19, \"email\":\"\", \"name\":\"Friend #19\", \"profile_photo_url\":\"p19\" }, ], \"cover_photo_url\":\"\" } }";
    
    NSDictionary* json = [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
    [_user updateWithJson:json];
    
    XCTAssert([_user.profileImageUrl isEqualToString:@"new1"]);
    XCTAssert([[_user.selectedFavourites[1] profileImageUrl] isEqualToString:@"new2"]);
}

@end
