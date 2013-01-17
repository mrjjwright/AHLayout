//
//  AHAppDelegate.m
//  AHLayout
//
//  Created by John Wright on 1/16/13.
//  Copyright (c) 2013 Airheart. All rights reserved.
//

#import "AHAppDelegate.h"
#import "AHLayout.h"
#import "ExampleView.h"

@implementation AHAppDelegate {
    AHLayout *_horizontalLayout;
    AHLayout *_verticalLayout;
    TUIButton *button;
    TUIButton *removeButton;
    BOOL collapsed;
    NSMutableArray *_vertObjects;
    NSMutableArray *_horizObjects;

}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    TUINSView *containerView = [[TUINSView alloc] initWithFrame:[_window.contentView frame]];
    self.window.contentView = containerView;
    CGRect b = [self.window.contentView frame];
    
    TUIView *v = [[TUIView alloc] initWithFrame:b];
    v.backgroundColor = [NSColor grayColor];
    
    CGRect horizFrame = b;
    horizFrame.origin.y = b.size.height - 100;
    horizFrame.size.height = 100;
    _horizontalLayout = [[AHLayout alloc] initWithFrame:horizFrame];
    _horizontalLayout.typeOfLayout = AHLayoutHorizontal;
    _horizontalLayout.backgroundColor = [NSColor whiteColor];
    _horizontalLayout.autoresizingMask = TUIViewAutoresizingFlexibleBottomMargin | TUIViewAutoresizingFlexibleWidth;
    _horizontalLayout.dataSource = self;
    _horizontalLayout.clipsToBounds = YES;
    _horizontalLayout.spaceBetweenViews = 10;
    _horizontalLayout.viewClass = [ExampleView class];
    [v addSubview:_horizontalLayout];
    
    CGRect vertFrame = b;
    vertFrame.size.height -= 100;
    _verticalLayout = [[AHLayout alloc] initWithFrame:vertFrame];
    _verticalLayout.backgroundColor = [NSColor whiteColor];
    _verticalLayout.autoresizingMask = TUIViewAutoresizingFlexibleSize;
    _verticalLayout.dataSource = self;
    _verticalLayout.clipsToBounds = YES;
    _verticalLayout.viewClass = [ExampleView class];
    [v addSubview:_verticalLayout];
    
    containerView.rootView = v;
    
    _vertObjects = [NSMutableArray array];
    
    for (int i=0; i <50; i++) {
        [_vertObjects addObject:[NSMutableDictionary dictionary]];
    }
    
    _horizObjects = [NSMutableArray array];
    
    for (int i=0; i <50; i++) {
        [_horizObjects addObject:[NSMutableDictionary dictionary]];
    }
    
    TUILabel *label = [[TUILabel alloc] initWithFrame:CGRectMake(containerView.rootView.frame.size.width/2, 0, 250, 50)];
    label.text = @"Right click on any cell for options";
    label.font = [NSFont boldSystemFontOfSize:12];
    label.backgroundColor = [NSColor clearColor];
    [containerView.rootView addSubview:label];
    
    [_verticalLayout reloadData];
    [_horizontalLayout reloadData];
}

#pragma mark - AHLayoutDataSource methods

-(TUIView*) layout:(AHLayout *)l viewForIndex:(NSInteger)index {
    ExampleView *v = (ExampleView*) [_verticalLayout dequeueReusableView];
    if ([l isEqual:_verticalLayout]) {
        v.objects = _vertObjects;
    } else {
        v.objects = _horizObjects;
    }
    return v;
}

- (NSUInteger)numberOfViewsInLayout:(AHLayout *)l {
    return [l isEqual:_verticalLayout] ? [_vertObjects count] : [_horizObjects count];
}

-(CGSize) layout:(AHLayout *)l sizeOfViewAtIndex:(NSUInteger)index {
    if ([l isEqual:_verticalLayout]) {
        CGRect b = [self.window.contentView frame];
        return CGSizeMake(b.size.width, 100);
    }
    return CGSizeMake(100, 100);
}

@end
