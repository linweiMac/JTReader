//
//  ProductBookShelfFlowLayout.m
//  xyktpad
//
//  Created by lifuyong on 14/12/31.
//  Copyright (c) 2014年 cdmooc. All rights reserved.
//

#import "ProductBookShelfFlowLayout.h"
#import "ProductBookShelfDecorationView.h"

@interface ProductBookShelfFlowLayout ()
{
    NSDictionary *_shelfFrames;
}

@end

@implementation ProductBookShelfFlowLayout

- (id)init
{
    if (!(self = [super init])) return nil;
    
    // Specify Flow Layout properties
    self.sectionInset = UIEdgeInsetsMake(10, 20, 10, 20);
    self.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.minimumInteritemSpacing = 0;
    self.minimumLineSpacing = 20;
    
    //        let margin : CGFloat = 8.0
    //        let itemW = (kScreenW - 4.0 * margin)/3.0
    //        let itemH = (19.0*itemW)/15.0
    
    CGFloat a = ([UIScreen mainScreen].bounds.size.width - 4.0*12) / 3.0;
    CGFloat b = (19.0 * a) / 15.0;
    
    self.itemSize = (CGSize){100, 126};
    
    self.headerReferenceSize = (CGSize){0,0};
    
    //Register Decoration View Class
    [self registerClass:[ProductBookShelfDecorationView class] forDecorationViewOfKind:[ProductBookShelfDecorationView kind]];
    
    return self;
}

- (void)prepareLayout
{
    [super prepareLayout];
    [self prepareShelfFrameLayouts];
}

- (void)prepareShelfFrameLayouts
{
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    NSInteger sectionCount = [self.collectionView numberOfSections];
    
    CGFloat y = 0;
    CGFloat availableWidth = self.collectionViewContentSize.width - (self.sectionInset.left + self.sectionInset.right);
    int itemsAcross = floorf((availableWidth + self.minimumInteritemSpacing) / (self.itemSize.width + self.minimumInteritemSpacing));
    
    // Iterate through the sections to see how many shelves are needed for each
    for (int section = 0; section < sectionCount; section++)
    {
        y += self.headerReferenceSize.height;
        y += self.sectionInset.top;
        
        NSInteger itemCount = [self.collectionView numberOfItemsInSection:section];
        int rows = ceilf(itemCount/(float)itemsAcross);
        for (int row = 0; row < rows; row++)
        {
            y += self.itemSize.height;
            dictionary[[NSIndexPath indexPathForItem:row inSection:section]] = [NSValue valueWithCGRect:CGRectMake(0, y-8, self.collectionViewContentSize.width, 27)];
            
            if (row < rows - 1)
                y += self.minimumLineSpacing;
        }
        y += self.sectionInset.bottom;
        y += self.footerReferenceSize.height;
    }
    
    _shelfFrames = [NSDictionary dictionaryWithDictionary:dictionary];
    
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    // call super so flow layout can return default attributes for all cells, headers, and footers
    // NOTE: Flow layout has already taken care of the Cell view layout attributes! :)
    NSArray *array = [super layoutAttributesForElementsInRect:rect];
    
    // create a mutable copy so we can add layout attributes for any shelfs that
    // have frames that intersect the rect the CollectionView is interested in
    NSMutableArray *newArray = [array mutableCopy];
    // Add any decoration views (shelves) who's rect intersects with the
    // CGRect passed to the layout by the CollectionView
    [_shelfFrames enumerateKeysAndObjectsUsingBlock:^(id key, id shelfRect, BOOL *stop) {
        if (CGRectIntersectsRect([shelfRect CGRectValue], rect))
        {
            UICollectionViewLayoutAttributes *shelfAttributes =
            [self layoutAttributesForDecorationViewOfKind:[ProductBookShelfDecorationView kind]
                                              atIndexPath:key];
            [newArray addObject:shelfAttributes];
        }
    }];
    
    [_shelfFrames enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        
        
    }];
    return [newArray copy];
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForDecorationViewOfKind:(NSString *)decorationViewKind atIndexPath:(NSIndexPath *)indexPath
{
    id shelfRect = _shelfFrames[indexPath];
    
    // this should never happen, but just in case...
    if (!shelfRect)
        return nil;
    
    UICollectionViewLayoutAttributes *attributes =
    [UICollectionViewLayoutAttributes layoutAttributesForDecorationViewOfKind:decorationViewKind
                                                                withIndexPath:indexPath];
    attributes.frame = [shelfRect CGRectValue];
    attributes.zIndex = -1; // shelves go behind other views
    
    return attributes;
}

@end
