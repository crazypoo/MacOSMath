//
//  MathUILabel.m
//  iosMath
//
//  Created by Kostub Deshmukh on 8/26/13.
//  Copyright (C) 2013 MathChat
//
//  This software may be modified and distributed under the terms of the
//  MIT license. See the LICENSE file for details.
//

#import "MTMathUILabel.h"
#import "MTMathListDisplay.h"
#import "MTMathListBuilder.h"
#import "MTTypesetter.h"

@implementation MTMathUILabel {
    NSTextField *_errorLabel;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self != nil) {
        [self initCommon];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self != nil) {
        [self initCommon];
    }
    return self;
}

- (void)initCommon
{
    _layer.geometryFlipped = NO;  // For ease of interaction with the CoreText coordinate system.
    // default font size
    _fontSize = 20;
    _contentInsets = NSEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f);
    _labelMode = kMTMathUILabelModeDisplay;
    MTFont *font = [MTFont defaultFont];
    _font = font;
    [_font retain];
    _textAlignment = kMTTextAlignmentLeft;
    _displayList = nil;
    _displayErrorInline = true;
    [self setWantsLayer:YES];
    _layer.backgroundColor = [NSColor clearColor].CGColor;
    _textColor = [[NSColor blackColor] retain];
    _errorLabel = [[NSTextField alloc] init];
    _errorLabel.hidden = YES;
    _errorLabel.layer.geometryFlipped = YES;
    _errorLabel.textColor = [NSColor redColor];
    [self addSubview:_errorLabel];
}

- (void)dealloc
{
    [_font release];
    [_textColor release];
    [_errorLabel release];
    [_mathList release];
    [_latex release];
    [_displayList release];
    [super dealloc];
}

- (BOOL)isFlipped
{
    return NO;
}

- (void)setFont:(MTFont *)font
{
    NSParameterAssert(font);
    if (_font != font) {
        [_font release];
        _font = font;
        [_font retain];
        [self invalidateIntrinsicContentSize];
        //        [self resizeSubviewsWithOldSize:self.frame.size];//setNeedsLayout];
        [self setNeedsLayout:YES];
    }
}

- (void)setFontSize:(CGFloat)fontSize
{
    if (_fontSize != fontSize) {
        _fontSize = fontSize;
        MTFont *font = [_font copyFontWithSize:_fontSize];
        self.font = font;
        [font release];
    }
}

- (void)setContentInsets:(NSEdgeInsets)contentInsets
{
    if ((_contentInsets.top == contentInsets.top) && ((_contentInsets.bottom == contentInsets.bottom)) && ((_contentInsets.left == contentInsets.left)) && ((_contentInsets.right == contentInsets.right))) {
        _contentInsets = contentInsets;
        [self invalidateIntrinsicContentSize];
        [self setNeedsLayout:YES];
    }
}

- (void)setMathList:(MTMathList *)mathList
{
    if (![_mathList isEqual:mathList]) {
        [_mathList release];
        _mathList = mathList;
        [_mathList retain];
        _error = nil;
        [_latex release];
        _latex = [MTMathListBuilder mathListToString:mathList];
        [_latex retain];
        [self invalidateIntrinsicContentSize];
        [self setNeedsLayout:YES];
    }
}

- (void)setLatex:(NSString *)latex
{
    if (![_latex isEqual:latex]) {
        [_latex release];
        _latex = latex;
        [_latex retain];
        _error = nil;
        NSError *error = nil;
        [_mathList release];
        _mathList = [MTMathListBuilder buildFromString:latex error:&error];
        [_mathList retain];
        if (error != nil) {
            _mathList = nil;
            _error = error;
            _errorLabel.stringValue = error.localizedDescription;
            _errorLabel.frame = self.bounds;
            _errorLabel.hidden = !self.displayErrorInline;
        } else {
            _errorLabel.hidden = YES;
        }
        [self invalidateIntrinsicContentSize];
        [self setNeedsLayout:YES];
    }
}

- (void)setLabelMode:(MTMathUILabelMode)labelMode
{
    if (_labelMode != labelMode) {
        _labelMode = labelMode;
        [self invalidateIntrinsicContentSize];
        [self setNeedsLayout:YES];
    }
}

- (void)setTextColor:(NSColor *)textColor
{
    NSParameterAssert(textColor);
    
    if (![_textColor isEqual:textColor]) {
        [_textColor release];
        _textColor = textColor;
        [_textColor retain];
        _displayList.textColor = textColor;
        [self setNeedsDisplay:YES];
    }
}

- (void)setTextAlignment:(MTTextAlignment)textAlignment
{
    if (_textAlignment != textAlignment) {
        _textAlignment = textAlignment;
        [self invalidateIntrinsicContentSize];
        [self setNeedsLayout:YES];
    }
}

- (MTLineStyle)currentStyle
{
    switch (_labelMode) {
        case kMTMathUILabelModeDisplay:
            return kMTLineStyleDisplay;
        case kMTMathUILabelModeText:
            return kMTLineStyleText;
    }
}


- (void)drawRect:(NSRect)dirtyRect
{
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    [super drawRect:dirtyRect];
    
    if (!_mathList) {
        return;
    }
    
    // Drawing code
    CGContextRef context = [[NSGraphicsContext currentContext] graphicsPort];
    CGContextSaveGState(context);
    
    [_displayList draw:context];
    
    CGContextRestoreGState(context);
    
}

- (void)layout
{
    // Override this method if your custom view needs to perform custom
    // layout not expressible using the constraint-based layout system. In
    // this case you are responsible for calling setNeedsLayout: when
    // something that impacts your custom layout changes.
    if (_mathList) {
        [_displayList release];
        _displayList = [[MTTypesetter createLineForMathList:_mathList font:_font style:self.currentStyle] retain];
        _displayList.textColor = _textColor;
        
        // Determine x position based on alignment
        CGFloat textX = 0;
        switch (self.textAlignment) {
            case kMTTextAlignmentLeft:
                textX = self.contentInsets.left;
                break;
            case kMTTextAlignmentCenter:
                textX = (self.bounds.size.width - self.contentInsets.left - self.contentInsets.right - _displayList.width) / 2 + self.contentInsets.left;
                break;
            case kMTTextAlignmentRight:
                textX = (self.bounds.size.width - _displayList.width - self.contentInsets.right);
                break;
        }
        
        CGFloat availableHeight = self.bounds.size.height - self.contentInsets.bottom - self.contentInsets.top;
        // center things vertically
        CGFloat height = _displayList.ascent + _displayList.descent;
        if (height < _fontSize/2) {
            // Set the height to the half the size of the font
            height = _fontSize/2;
        }
        CGFloat textY = (availableHeight - height) / 2 + _displayList.descent + self.contentInsets.bottom;
        _displayList.position = CGPointMake(textX, textY);
    } else {
        [_displayList release];
        _displayList = nil;
    }
    _errorLabel.frame = self.bounds;
    [self setNeedsDisplay:YES];
    
    [super layout];
}
//
//- (void)layoutSubviews
//{
//    if (_mathList) {
//        [_displayList release];
//        _displayList = [[MTTypesetter createLineForMathList:_mathList font:_font style:self.currentStyle] retain];
//        _displayList.textColor = _textColor;
//        
//        // Determine x position based on alignment
//        CGFloat textX = 0;
//        switch (self.textAlignment) {
//            case kMTTextAlignmentLeft:
//                textX = self.contentInsets.left;
//                break;
//            case kMTTextAlignmentCenter:
//                textX = (self.bounds.size.width - self.contentInsets.left - self.contentInsets.right - _displayList.width) / 2 + self.contentInsets.left;
//                break;
//            case kMTTextAlignmentRight:
//                textX = (self.bounds.size.width - _displayList.width - self.contentInsets.right);
//                break;
//        }
//        
//        CGFloat availableHeight = self.bounds.size.height - self.contentInsets.bottom - self.contentInsets.top;
//        // center things vertically
//        CGFloat height = _displayList.ascent + _displayList.descent;
//        if (height < _fontSize/2) {
//            // Set the height to the half the size of the font
//            height = _fontSize/2;
//        }
//        CGFloat textY = (availableHeight - height) / 2 + _displayList.descent + self.contentInsets.bottom;
//        _displayList.position = CGPointMake(textX, textY);
//    } else {
//        [_displayList release];
//        _displayList = nil;
//    }
//    _errorLabel.frame = self.bounds;
//    [self setNeedsDisplay:YES];
//}

- (CGSize)sizeThatFits:(CGSize)size
{
    MTMathListDisplay *displayList = nil;
    if (_mathList) {
        displayList = [MTTypesetter createLineForMathList:_mathList font:_font style:self.currentStyle];
    }
    
    size.width = displayList.width + self.contentInsets.left + self.contentInsets.right;
    size.height = displayList.ascent + displayList.descent + self.contentInsets.top + self.contentInsets.bottom;
    return size;
}

- (CGSize)intrinsicContentSize
{
    return [self sizeThatFits:CGSizeZero];
}

@end
