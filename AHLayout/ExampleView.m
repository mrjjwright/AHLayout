//
//  ExampleColorView.m
//  AHLayout
//
//  Created by John Wright on 11/27/11.
//  Copyright (c) 2011 AirHeart. All rights reserved.
//

#import "ExampleView.h"


@implementation ExampleView {
    NSInteger objectIndex;
    TUITextRenderer *textRenderer;
    NSAttributedString *attributedString;
    CGSize originalSize;
}

@synthesize expanded;
@synthesize dictionary;
@synthesize selected;

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        //self.opaque = YES;
        textRenderer = [[TUITextRenderer alloc] init];
		self.textRenderers = [NSArray arrayWithObjects:textRenderer, nil];
        //self.clipsToBounds = YES;
        self.backgroundColor = [NSColor lightGrayColor];
    }
    return self;
}

-(AHLayout*) parentLayout {
    return (AHLayout*) self.superview;
}

-(void) setTag:(NSInteger) tag {
    [super setTag:tag];
    textRenderer.attributedString = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ld", self.tag]];
}

-(NSMenu*) menuForEvent:(NSEvent *)event {
    NSMenu *menu = [[NSMenu alloc] init];
    
    NSMenuItem *item2 = [[NSMenuItem alloc] initWithTitle:NSLocalizedString(@"Insert Above",nil) action:@selector(insertObject) keyEquivalent:@""];
    item2.target = self;
    [menu addItem:item2];
    item2 = [[NSMenuItem alloc] initWithTitle:NSLocalizedString(@"Insert Below",nil) action:@selector(insertObjectBelow) keyEquivalent:@""];
    item2.target = self;
    [menu addItem:item2];
    NSMenuItem *item21 = [[NSMenuItem alloc] initWithTitle:NSLocalizedString(@"Insert at top",nil) action:@selector(prepend) keyEquivalent:@""];
    item21.target = self;
    [menu addItem:item21];

    NSMenuItem *item = [[NSMenuItem alloc] initWithTitle:NSLocalizedString(@"Remove",nil) action:@selector(remove:) keyEquivalent:@""];
    item.target =self;
    [menu addItem:item];
    NSMenuItem *item1 = [[NSMenuItem alloc] initWithTitle:NSLocalizedString(@"Toggle Expand To Fill",nil) action:@selector(toggleExpanded) keyEquivalent:@""];
    item1.target = self;
    [menu addItem:item1];
    return menu;
}


-(void) toggleExpanded {
    CGSize targetSize;
    if (self.parentLayout.typeOfLayout == AHLayoutHorizontal) {
        CGFloat width = expanded  ? originalSize.width : self.parentLayout.bounds.size.width;
        targetSize = CGSizeMake(width, self.bounds.size.height);
    } else {
        CGFloat height = expanded  ? originalSize.height : self.parentLayout.bounds.size.height;
        targetSize = CGSizeMake(self.bounds.size.width, height);
    }
    [self.parentLayout beginUpdates];
    [self.parentLayout resizeViewAtIndex:self.tag toSize:targetSize animationBlock:nil  completionBlock:^{
        expanded = !expanded;
    }];
    [self.parentLayout endUpdates];
}

-(void) insertObject{
    [_objects addObject:[NSMutableDictionary dictionary]];
    [self.parentLayout insertViewAtIndex:self.tag];
}

-(void) insertObjectBelow{
    [_objects addObject:[NSMutableDictionary dictionary]];
    [self.parentLayout insertViewAtIndex:self.tag-1];
}

-(void) prepend {
    [_objects addObject:[NSMutableDictionary dictionary]];
    [self.parentLayout prependNumOfViews:1 animationBlock:nil completionBlock:nil];
}

-(IBAction)remove:(id)sender {
    [_objects removeObjectAtIndex:self.tag];
    [self.parentLayout removeViewsAtIndexes:[NSIndexSet indexSetWithIndex:self.tag ] animationBlock:nil completionBlock:nil ];
}

- (void)drawRect:(CGRect)rect
{
	CGRect b = self.bounds;
	CGContextRef ctx = TUIGraphicsGetCurrentContext();
    
    originalSize = CGSizeEqualToSize(CGSizeZero, originalSize) ? self.bounds.size : originalSize;
	
	if(self.selected) {
		// selected background
		CGContextSetRGBFillColor(ctx, .87, .87, .87, 1);
		CGContextFillRect(ctx, b);
	} else {
		// light gray background
		CGContextSetRGBFillColor(ctx, .97, .97, .97, 1);
		CGContextFillRect(ctx, b);
		
		// emboss
		CGContextSetRGBFillColor(ctx, 1, 1, 1, 0.9); // light at the top
		CGContextFillRect(ctx, CGRectMake(0, b.size.height-1, b.size.width, 1));
		CGContextSetRGBFillColor(ctx, 0, 0, 0, 0.08); // dark at the bottom
		CGContextFillRect(ctx, CGRectMake(0, 0, b.size.width, 1));
	}
	
	// text
	CGRect textRect = CGRectOffset(b, 15, -15);
	textRenderer.frame = textRect; // set the frame so it knows where to draw itself
	[textRenderer draw];
	
}


@end
