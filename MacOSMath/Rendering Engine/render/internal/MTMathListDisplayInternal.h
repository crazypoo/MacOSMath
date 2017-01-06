//
//  MTMathListDisplay+Internal.h
//  iosMath
//
//  Created by Kostub Deshmukh on 6/21/16.
//
//  This software may be modified and distributed under the terms of the
//  MIT license. See the LICENSE file for details.
//

#import "MTMathListDisplay.h"

@interface MTDisplay ()

@property (assign, nonatomic) CGFloat ascent;
@property (assign, nonatomic) CGFloat descent;
@property (assign, nonatomic) CGFloat width;
@property (assign, nonatomic) NSRange range;
@property (assign, nonatomic) BOOL hasScript;

@end

// The Downshift protocol allows an MTDisplay to be shifted down by a given amount.
@protocol DownShift <NSObject>

@property (assign, nonatomic) CGFloat shiftDown;

@end

@interface MTMathListDisplay ()

- (instancetype)init NS_UNAVAILABLE;

- (instancetype) initWithDisplays:(NSArray *)displays range:(NSRange) range;

@property (nonatomic, readwrite) MTLinePosition type;
@property (nonatomic, readwrite) NSUInteger index;

@end

@interface MTCTLineDisplay ()

- (instancetype)initWithString:(NSAttributedString *)attrString position:(CGPoint)position range:(NSRange) range font:(MTFont *)font atoms:(NSArray *)atoms;

- (instancetype)init NS_UNAVAILABLE;

@end

@interface MTFractionDisplay ()

- (instancetype)initWithNumerator:(MTMathListDisplay *)numerator denominator:(MTMathListDisplay *)denominator position:(CGPoint)position range:(NSRange) range;

- (instancetype)init NS_UNAVAILABLE;

@property (assign, nonatomic) CGFloat numeratorUp;
@property (assign, nonatomic) CGFloat denominatorDown;
@property (assign, nonatomic) CGFloat linePosition;
@property (assign, nonatomic) CGFloat lineThickness;

@end

@interface MTRadicalDisplay ()

- (instancetype)initWitRadicand:(MTMathListDisplay *)radicand glpyh:(MTDisplay *)glyph position:(CGPoint)position range:(NSRange)range;

- (void)setDegree:(MTMathListDisplay *)degree fontMetrics:(MTFontMathTable *)fontMetrics;

@property (assign, nonatomic) CGFloat topKern;
@property (assign, nonatomic) CGFloat lineThickness;

@end

// Rendering of an large glyph as an MTDisplay
@interface MTGlyphDisplay() <DownShift>

- (instancetype)initWithGlpyh:(CGGlyph)glyph range:(NSRange)range font:(MTFont *)font;

@end

// Rendering of a constructed glyph as an MTDisplay
@interface MTGlyphConstructionDisplay : MTDisplay<DownShift>

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithGlyphs:(NSArray *)glyphs offsets:(NSArray *)offsets font:(MTFont *)font;

@end

@interface MTLargeOpLimitsDisplay ()

- (instancetype)initWithNucleus:(MTDisplay *)nucleus upperLimit:(MTMathListDisplay *)upperLimit lowerLimit:(MTMathListDisplay *)lowerLimit limitShift:(CGFloat)limitShift extraPadding:(CGFloat)extraPadding;

- (instancetype)init NS_UNAVAILABLE;

@property (assign, nonatomic) CGFloat upperLimitGap;
@property (assign, nonatomic) CGFloat lowerLimitGap;

@end

@interface MTLineDisplay ()

- (instancetype)initWithInner:(MTMathListDisplay *)inner position:(CGPoint)position range:(NSRange)range;

// How much the line should be moved up.
@property (assign, nonatomic) CGFloat lineShiftUp;
@property (assign, nonatomic) CGFloat lineThickness;

@end

@interface MTAccentDisplay ()

- (instancetype)initWithAccent:(MTGlyphDisplay *)glyph accentee:(MTMathListDisplay *)accentee range:(NSRange)range;

@end
