//
//  PhotoCollectionViewCell.m
//  FilterGallery
//
//  Created by Satinder Singh on 4/23/15.
//
//

#import "PhotoCollectionViewCell.h"

@implementation PhotoCollectionViewCell

static const NSInteger IMAGEVIEW_BORDER_LENGTH = 5;


-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if(self){
        [self setup];
    }
    return self;
}

-(void) setup{
    CGRect frame = CGRectInset(self.bounds, IMAGEVIEW_BORDER_LENGTH, IMAGEVIEW_BORDER_LENGTH);
    self.imageView = [[UIImageView alloc] initWithFrame:frame];
    [self.contentView addSubview:self.imageView];
}

@end
