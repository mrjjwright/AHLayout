//
//  ExampleColorView.h
//  TUILayout
//
//  Created by John Wright on 11/27/11.
//  Copyright (c) 2011 AirHeart. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TUIKit.h"
#import "AHLayout.h"
#import "AHAppDelegate.h"

@interface ExampleView : TUIView

@property (nonatomic) BOOL expanded;
@property (nonatomic, strong) NSMutableDictionary *dictionary;
@property (nonatomic) BOOL selected;

@property (nonatomic,weak) NSMutableArray *objects;

@end
