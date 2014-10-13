//
//  CustomCell.m
//  GeoTappy
//
//  Created by Dylan Marriott on 12/10/14.
//  Copyright (c) 2014 Dylan Marriott. All rights reserved.
//

#import "CustomCell.h"

@implementation CustomCell {
    UILabel* _name;
    UIImageView* _imageView;
    UIImage* _orgImg;
}

- (instancetype)initWithName:(NSString *)name image:(UIImage *)image {
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    
    _name = [[UILabel alloc] init];
    _name.text = name;
    [self.contentView addSubview:_name];
    
    _orgImg = image;
    _imageView = [[UIImageView alloc] initWithImage:image];
    _imageView.contentMode = UIViewContentModeScaleAspectFill;
    _imageView.layer.masksToBounds = YES;
    [self.contentView addSubview:_imageView];
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _name.frame = CGRectMake(60, 0, self.contentView.frame.size.width - 50, self.contentView.frame.size.height);
    _imageView.frame = CGRectMake(10, self.contentView.frame.size.height / 2 - 15, 30, 30);
}

@end
