//
//  ProductBookShelfDecorationView.m
//  xyktpad
//
//  Created by lifuyong on 14/12/31.
//  Copyright (c) 2014年 cdmooc. All rights reserved.
//

#import "ProductBookShelfDecorationView.h"

@interface ProductBookShelfDecorationView ()
{
    UIImageView *_imageView;
}

@end

@implementation ProductBookShelfDecorationView

+ (NSString *)kind
{
    return @"ProductBookShelfDecorationView";
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImage *background = [UIImage imageNamed:@"书架"];
        
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,
                                                                   0,
                                                                   CGRectGetWidth(frame),
                                                                   CGRectGetHeight(frame))];
        _imageView.image = background;
//        _imageView.contentMode=UIViewContentModeScaleAspectFit;
//        _imageView.backgroundColor=[UIColor redColor];
        [self addSubview:_imageView];
    }
    return self;
}


@end
