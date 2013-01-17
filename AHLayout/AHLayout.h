//
//  AHLayout.h
//  Swift
//
//  Created by John Wright on 11/13/11.
//  Copyright (c) 2011 AirHeart. All rights reserved.
//

#define kAHLayoutViewHeight @"kAHLayoutViewHeight"
#define kAHLayoutViewWidth @"kAHLayoutViewWidth"

#import "TUIKit.h"

@interface NSString(TUICompare)

-(NSComparisonResult)compareNumberStrings:(NSString *)str;

@end

#define kAHLayoutAnimation @"AHLayoutAnimation"

@class AHLayout;
@class AHLayoutObject;
typedef void(^AHLayoutHandler)(AHLayout *layout);
typedef void(^AHLayoutViewAnimationBlock)(AHLayout *layout, TUIView *view);

typedef enum {
	AHLayoutScrollPositionNone,
	AHLayoutScrollPositionTop,
	AHLayoutScrollPositionMiddle,
	AHLayoutScrollPositionBottom,
	AHLayoutScrollPositionToVisible, // currently the only supported arg
} AHLayoutScrollPosition;


// a callback handler to be used in various layout operations
typedef enum {
	AHLayoutVertical,
    AHLayoutHorizontal,
} AHLayoutType;


@protocol AHLayoutDataSource;

@interface AHLayout : TUIScrollView <TUIScrollViewDelegate>

@property (nonatomic, weak) NSObject<AHLayoutDataSource> *dataSource;

@property (nonatomic, weak) Class viewClass;
@property (nonatomic) AHLayoutType typeOfLayout;
@property (nonatomic) CGFloat spaceBetweenViews;
@property (nonatomic, readonly) NSInteger numberOfViews;
@property (nonatomic, strong) NSDate *reloadedDate;
@property (nonatomic, copy) AHLayoutHandler reloadHandler;
@property (nonatomic, readonly) NSArray *visibleViews;
@property (nonatomic) BOOL didFirstLayout;

#pragma mark - General

- (TUIView *)dequeueReusableView;
- (void)reloadData;
- (TUIView*) viewForIndex:(NSUInteger) index;
-(NSInteger) indexForView:(TUIView*)v;
- (NSUInteger)indexOfViewAtPoint:(CGPoint) point;
- (TUIView*) viewAtPoint:(CGPoint) point;
- (void)scrollToViewAtIndex:(NSUInteger)index atScrollPosition:(AHLayoutScrollPosition)scrollPosition animated:(BOOL)animated;
- (CGRect) rectForViewAtIndex:(NSUInteger) index;
-(TUIView*) replaceViewForObjectAtIndex:(NSUInteger) index withSize:(CGSize) size;
-(NSUInteger) objectIndexAtTopOfScreen;

#pragma mark - Layout transactions
-(void) beginUpdates;
-(void) endUpdates;

#pragma mark - Resizing
- (void) resizeViewsAtIndexes:(NSArray*) objectIndexes sizes:(NSArray*) sizes animationBlock:(void (^)())animationBlock completion:(void (^)())completionBlock;
-(void) resizeViewsToSize:(CGSize) size scrollToObjectIndex:(NSUInteger) scrollToObjectIndex animationBlock:(void (^)())animationBlock completionBlock:(void (^)())completion;
- (void) resizeViewAtIndex:(NSUInteger) index toSize:(CGSize) size animationBlock:(void (^)())animationBlock  completionBlock:(void (^)())completionBlock;

#pragma mark - Adding and removing views
-(void) insertViewAtIndex:(NSUInteger) index;
-(void) insertViewAtIndex:(NSUInteger) index  animationBlock:(AHLayoutViewAnimationBlock)animationBlock  completionBlock:(void (^)())completionBlock;
-(void)removeViewsAtIndexes:(NSIndexSet *)indexes animationBlock:(AHLayoutViewAnimationBlock)animationBlock  completionBlock:(void (^)())completionBlock;
-(void) prependNumOfViews:(NSInteger) numOfObjects animationBlock:(void (^)())animationBlock  completionBlock:(void (^)())completionBlock;

# pragma mark - Scrolling

@end

//////////////////////////////////////////////////////////////
#pragma mark Protocol AHLayoutDataSource
//////////////////////////////////////////////////////////////

@protocol AHLayoutDataSource <NSObject>

@required
// Populating subview items
- (NSUInteger)numberOfViewsInLayout:(AHLayout *)layout;
- (CGSize)layout:(AHLayout *)layout sizeOfViewAtIndex:(NSUInteger)index;
- (TUIView *)layout:(AHLayout *)layout viewForIndex:(NSInteger)index;

@end



