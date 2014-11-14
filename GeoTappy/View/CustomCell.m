//
//  CustomCell.m
//  GeoTappy
//
//  Created by Dylan Marriott on 12/10/14.
//  Copyright (c) 2014 Dylan Marriott. All rights reserved.
//

#import "CustomCell.h"
#import "Favourite.h"
#import "ProfileImageView.h"
#import "Group.h"
#import "Friend.h"
#import "FavouriteListener.h"

@interface CustomCell () <FavouriteListener>
@end

@implementation CustomCell {
    UILabel* _name;
    ProfileImageView* _imageView;
}

- (instancetype)initWithName:(NSString *)name favourite:(id<Favourite>)favourite {
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    
    [favourite addFavouriteListener:self];
    [self favouriteChanged:favourite];
    
    _name = [[UILabel alloc] init];
    _name.text = name;
    [self.contentView addSubview:_name];
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _name.frame = CGRectMake(60, 0, self.contentView.frame.size.width - 50, self.contentView.frame.size.height);
    _imageView.frame = CGRectMake(10, self.contentView.frame.size.height / 2 - 15, 30, 30);
}

- (void)favouriteChanged:(id<Favourite>)favourite {
    [_imageView removeFromSuperview]; // bit hacky, refactor this maybe one day :D
    NSMutableArray* images = [NSMutableArray array];
    if ([favourite isKindOfClass:[Friend class]]) {
        if (((Friend *)favourite).profileImage != nil) {
            [images addObject:((Friend *)favourite).profileImage];
        }
    } else if ([favourite isKindOfClass:[Group class]]) {
        for (Friend* f in ((Group *)favourite).friends) {
            if (f.profileImage != nil) {
                [images addObject:f.profileImage];
            }
        }
    }
    
    _imageView = [[ProfileImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30) images:images];
    _imageView.contentMode = UIViewContentModeScaleAspectFill;
    _imageView.layer.masksToBounds = YES;
    [self.contentView addSubview:_imageView];
}

@end
