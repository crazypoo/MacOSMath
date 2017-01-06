//
//  MTFontMathTable.m
//  iosMath
//
//  Created by Kostub Deshmukh on 8/28/13.
//  Copyright (C) 2013 MathChat
//
//  This software may be modified and distributed under the terms of the
//  MIT license. See the LICENSE file for details.
//

#import "MTFontMathTable.h"
#import "MTFont.h"
#import "MTFont+Internal.h"


@interface MTGlyphPart ()

@property (assign, nonatomic) CGGlyph glyph;
@property (assign, nonatomic) CGFloat fullAdvance;
@property (assign, nonatomic) CGFloat startConnectorLength;
@property (assign, nonatomic) CGFloat endConnectorLength;
@property (assign, nonatomic) BOOL isExtender;

@end

@implementation MTGlyphPart

@end

@interface MTFontMathTable ()

// The font for this math table.
@property (assign, nonatomic, readonly) MTFont *font;

@end

@implementation MTFontMathTable
{
    NSUInteger _unitsPerEm;
    CGFloat _fontSize;
    NSDictionary *_mathTable;
}

- (instancetype)initWithFont:(MTFont *)font mathTable:(NSDictionary *)mathTable
{
    self = [super init];
    if (self != nil) {
        NSParameterAssert(font);
        NSParameterAssert(font.ctFont);
        _font = font;
        // do domething with font
        _unitsPerEm = CTFontGetUnitsPerEm(font.ctFont);
        _fontSize = font.fontSize;
        _mathTable = [mathTable retain];
    }
    return self;
}

- (void)dealloc
{
    [_mathTable release];
    [super dealloc];
}

- (CGFloat)fontUnitsToPt:(int)fontUnits
{
    return fontUnits * _fontSize / _unitsPerEm;
}

- (CGFloat)muUnit
{
    return _fontSize / 18;
}

static NSString *const kConstants = @"constants";

- (CGFloat)constantFroMTable:(NSString *)constName
{
    NSDictionary *consts = (NSDictionary *)_mathTable[kConstants];
    NSNumber *val = (NSNumber *)consts[constName];
    return [self fontUnitsToPt:val.intValue];
}

- (CGFloat)percentFroMTable:(NSString *)percentName
{
    NSDictionary *consts = (NSDictionary *)_mathTable[kConstants];
    NSNumber *val = (NSNumber *)consts[percentName];
    return val.floatValue / 100;
}

#pragma mark - Fractions
- (CGFloat)fractionNumeratorDisplayStyleShiftUp
{
    return [self constantFroMTable:@"FractionNumeratorDisplayStyleShiftUp"];
}

- (CGFloat)fractionNumeratorShiftUp
{
    return [self constantFroMTable:@"FractionNumeratorShiftUp"];
}

- (CGFloat)fractionDenominatorDisplayStyleShiftDown
{
    return [self constantFroMTable:@"FractionDenominatorDisplayStyleShiftDown"];
}

- (CGFloat)fractionDenominatorShiftDown
{
    return [self constantFroMTable:@"FractionDenominatorShiftDown"];
}

- (CGFloat)fractionNumeratorDisplayStyleGapMin
{
    return [self constantFroMTable:@"FractionNumDisplayStyleGapMin"];
}

- (CGFloat)fractionNumeratorGapMin
{
    return [self constantFroMTable:@"FractionNumeratorGapMin"];
}

- (CGFloat)fractionDenominatorDisplayStyleGapMin
{
    return [self constantFroMTable:@"FractionDenomDisplayStyleGapMin"];
}

- (CGFloat)fractionDenominatorGapMin
{
    return [self constantFroMTable:@"FractionDenominatorGapMin"];
}

- (CGFloat)fractionRuleThickness
{
    return [self constantFroMTable:@"FractionRuleThickness"];
}

- (CGFloat)skewedFractionHorizontalGap
{
    return [self constantFroMTable:@"SkewedFractionHorizontalGap"];
}

- (CGFloat)skewedFractionVerticalGap
{
    return [self constantFroMTable:@"SkewedFractionVerticalGap"];
}

#pragma mark Non-standard

// FractionDelimiterSize and FractionDelimiterDisplayStyleSize are not constants
// specified in the OpenType Math specification. Rather these are proposed LuaTeX extensions
// for the TeX parameters \sigma_20 (delim1) and \sigma_21 (delim2). Since these do not
// exist in the fonts that we have, we use the same approach as LuaTeX and use the fontSize
// to determine these values. The constants used are the same as LuaTeX and KaTeX and match the
// metrics values of the original TeX fonts.
// Note: An alternative approach is to use DelimitedSubFormulaMinHeight for \sigma21 and use a factor
// of 2 to get \sigma 20 as proposed in Vieth paper.
// The XeTeX implementation sets \sigma21 = fontSize and \sigma20 = DelimitedSubFormulaMinHeight which
// will produce smaller delimiters.
// Of all the approaches we've implemented LuaTeX's approach since it mimics LaTeX most accurately.
- (CGFloat)fractionDelimiterSize
{
    return 1.01 * _fontSize;
}

- (CGFloat)fractionDelimiterDisplayStyleSize
{
    // Modified constant from 2.4 to 2.39, it matches KaTeX and looks better.
    return 2.39 * _fontSize;
}

#pragma mark - Sub/Superscripts

- (CGFloat)superscriptShiftUp
{
    return [self constantFroMTable:@"SuperscriptShiftUp"];
}

- (CGFloat)superscriptShiftUpCramped
{
    return [self constantFroMTable:@"SuperscriptShiftUpCramped"];
}

- (CGFloat)subscriptShiftDown
{
    return [self constantFroMTable:@"SubscriptShiftDown"];
}

- (CGFloat)superscriptBaselineDropMax
{
    return [self constantFroMTable:@"SuperscriptBaselineDropMax"];
}

- (CGFloat)subscriptBaselineDropMin
{
    return [self constantFroMTable:@"SubscriptBaselineDropMin"];
}

- (CGFloat)superscriptBottomMin
{
    return [self constantFroMTable:@"SuperscriptBottomMin"];
}

- (CGFloat)subscriptTopMax
{
    return [self constantFroMTable:@"SubscriptTopMax"];
}

- (CGFloat)subSuperscriptGapMin
{
    return [self constantFroMTable:@"SubSuperscriptGapMin"];
}

- (CGFloat)superscriptBottomMaxWithSubscript
{
    return [self constantFroMTable:@"SuperscriptBottomMaxWithSubscript"];
}

- (CGFloat)spaceAfterScript
{
    return [self constantFroMTable:@"SpaceAfterScript"];
}

#pragma mark - Radicals

- (CGFloat)radicalRuleThickness
{
    return [self constantFroMTable:@"RadicalRuleThickness"];
}

- (CGFloat)radicalExtraAscender
{
    return [self constantFroMTable:@"RadicalExtraAscender"];
}

- (CGFloat)radicalVerticalGap
{
    return [self constantFroMTable:@"RadicalVerticalGap"];
}

- (CGFloat)radicalDisplayStyleVerticalGap
{
    return [self constantFroMTable:@"RadicalDisplayStyleVerticalGap"];
}

- (CGFloat)radicalKernBeforeDegree
{
    return [self constantFroMTable:@"RadicalKernBeforeDegree"];
}

- (CGFloat)radicalKernAfterDegree
{
    return [self constantFroMTable:@"RadicalKernAfterDegree"];
}

- (CGFloat)radicalDegreeBottomRaisePercent
{
    return [self percentFroMTable:@"RadicalDegreeBottomRaisePercent"];
}

#pragma mark - Limits

- (CGFloat)upperLimitGapMin
{
    return [self constantFroMTable:@"UpperLimitGapMin"];
}

- (CGFloat)upperLimitBaselineRiseMin
{
    return [self constantFroMTable:@"UpperLimitBaselineRiseMin"];
}

- (CGFloat)lowerLimitGapMin
{
    return [self constantFroMTable:@"LowerLimitGapMin"];
}

- (CGFloat)lowerLimitBaselineDropMin
{
    return [self constantFroMTable:@"LowerLimitBaselineDropMin"];
}

- (CGFloat)limitExtraAscenderDescender
{
    // not present in OpenType fonts.
    return 0;
}

#pragma mark - Constants

-(CGFloat)axisHeight
{
    return [self constantFroMTable:@"AxisHeight"];
}

- (CGFloat)scriptScaleDown
{
    return [self percentFroMTable:@"ScriptPercentScaleDown"];
}

- (CGFloat)scriptScriptScaleDown
{
    return [self percentFroMTable:@"ScriptScriptPercentScaleDown"];
}

- (CGFloat)mathLeading
{
    return [self constantFroMTable:@"MathLeading"];
}

- (CGFloat)delimitedSubFormulaMinHeight
{
    return [self constantFroMTable:@"DelimitedSubFormulaMinHeight"];
}

#pragma mark - Accents

- (CGFloat)accentBaseHeight
{
    return [self constantFroMTable:@"AccentBaseHeight"];
}

- (CGFloat)flattenedAccentBaseHeight
{
    return [self constantFroMTable:@"FlattenedAccentBaseHeight"];
}

#pragma mark - Large Operators

- (CGFloat)displayOperatorMinHeight
{
    return [self constantFroMTable:@"DisplayOperatorMinHeight"];
}

#pragma mark - Over and Underbar

- (CGFloat)overbarExtraAscender
{
    return [self constantFroMTable:@"OverbarExtraAscender"];
}

- (CGFloat)overbarRuleThickness
{
    return [self constantFroMTable:@"OverbarRuleThickness"];
}

- (CGFloat)overbarVerticalGap
{
    return [self constantFroMTable:@"OverbarVerticalGap"];
}

- (CGFloat)underbarExtraDescender
{
    return [self constantFroMTable:@"UnderbarExtraDescender"];
}

- (CGFloat)underbarRuleThickness
{
    return [self constantFroMTable:@"UnderbarRuleThickness"];
}

- (CGFloat)underbarVerticalGap
{
    return [self constantFroMTable:@"UnderbarVerticalGap"];
}

#pragma mark - Stacks

-(CGFloat)stackBottomDisplayStyleShiftDown {
    return [self constantFroMTable:@"StackBottomDisplayStyleShiftDown"];
}

- (CGFloat)stackBottomShiftDown {
    return [self constantFroMTable:@"StackBottomShiftDown"];
}

- (CGFloat)stackDisplayStyleGapMin {
    return [self constantFroMTable:@"StackDisplayStyleGapMin"];
}

- (CGFloat)stackGapMin {
    return [self constantFroMTable:@"StackGapMin"];
}

- (CGFloat)stackTopDisplayStyleShiftUp {
    return [self constantFroMTable:@"StackTopDisplayStyleShiftUp"];
}

- (CGFloat)stackTopShiftUp {
    return [self constantFroMTable:@"StackTopShiftUp"];
}

- (CGFloat)stretchStackBottomShiftDown {
    return [self constantFroMTable:@"StretchStackBottomShiftDown"];
}

- (CGFloat)stretchStackGapAboveMin {
    return [self constantFroMTable:@"StretchStackGapAboveMin"];
}

- (CGFloat)stretchStackGapBelowMin {
    return [self constantFroMTable:@"StretchStackGapBelowMin"];
}

- (CGFloat)stretchStackTopShiftUp {
    return [self constantFroMTable:@"StretchStackTopShiftUp"];
}

#pragma mark - Variants

static NSString *const kVertVariants = @"v_variants";
static NSString *const kHorizVariants = @"h_variants";

- (NSArray *)getVerticalVariantsForGlyph:(CGGlyph) glyph
{
    NSDictionary *variants = (NSDictionary *)_mathTable[kVertVariants];
    return [self getVariantsForGlyph:glyph inDictionary:variants];
}

- (NSArray *)getHorizontalVariantsForGlyph:(CGGlyph) glyph
{
    NSDictionary *variants = (NSDictionary *)_mathTable[kHorizVariants];
    return [self getVariantsForGlyph:glyph inDictionary:variants];
}

- (NSArray *)getVariantsForGlyph:(CGGlyph) glyph inDictionary:(NSDictionary *)variants
{
    NSString *glyphName = [self.font getGlyphName:glyph];
    NSArray *variantGlyphs = (NSArray *)variants[glyphName];
    NSMutableArray *glyphArray = [NSMutableArray arrayWithCapacity:variantGlyphs.count];
    if (!variantGlyphs) {
        // There are no extra variants, so just add the current glyph to it.
        CGGlyph glyph = [self.font getGlyphWithName:glyphName];
        [glyphArray addObject:@(glyph)];
        return glyphArray;
    }
    for (NSString *glyphVariantName in variantGlyphs) {
        CGGlyph variantGlyph = [self.font getGlyphWithName:glyphVariantName];
        [glyphArray addObject:@(variantGlyph)];
    }
    return glyphArray;
}

- (CGGlyph) getLargerGlyph:(CGGlyph) glyph
{
    NSDictionary *variants = (NSDictionary *)_mathTable[kVertVariants];
    NSString *glyphName = [self.font getGlyphName:glyph];
    NSArray *variantGlyphs = (NSArray *)variants[glyphName];
    if (!variantGlyphs) {
        // There are no extra variants, so just returnt the current glyph.
        return glyph;
    }
    // Find the first variant with a different name.
    for (NSString *glyphVariantName in variantGlyphs) {
        if (![glyphVariantName isEqualToString:glyphName]) {
            CGGlyph variantGlyph = [self.font getGlyphWithName:glyphVariantName];
            return variantGlyph;
        }
    }
    // We did not find any variants of this glyph so return it.
    return glyph;
}

#pragma mark - Italic Correction

static NSString *const kItalic = @"italic";

- (CGFloat)getItalicCorrection:(CGGlyph)glyph
{
    NSDictionary *italics = (NSDictionary *)_mathTable[kItalic];
    NSString *glyphName = [self.font getGlyphName:glyph];
    NSNumber *val = (NSNumber *)italics[glyphName];
    // if val is nil, this returns 0.
    return [self fontUnitsToPt:val.intValue];
}

#pragma mark - Top Accent Adjustment

static NSString *const kAccents = @"accents";
- (CGFloat)getTopAccentAdjustment:(CGGlyph) glyph
{
    NSDictionary *accents = (NSDictionary *)_mathTable[kAccents];
    NSString *glyphName = [self.font getGlyphName:glyph];
    NSNumber *val = (NSNumber *)accents[glyphName];
    if (val) {
        return [self fontUnitsToPt:val.intValue];
    } else {
        // If no top accent is defined then it is the center of the advance width.
        CGSize advances;
        CTFontGetAdvancesForGlyphs(self.font.ctFont, kCTFontHorizontalOrientation, &glyph, &advances, 1);
        return advances.width/2;
    }
}

#pragma mark - Glyph Assembly

- (CGFloat)minConnectorOverlap
{
    return [self constantFroMTable:@"MinConnectorOverlap"];
}

static NSString *const kVertAssembly = @"v_assembly";
static NSString *const kAssemblyParts = @"parts";

- (NSArray *)getVerticalGlyphAssemblyForGlyph:(CGGlyph)glyph
{
    NSDictionary *assemblyTable = (NSDictionary *)_mathTable[kVertAssembly];
    NSString *glyphName = [self.font getGlyphName:glyph];
    NSDictionary *assemblyInfo = (NSDictionary *)assemblyTable[glyphName];
    if (!assemblyInfo) {
        // No vertical assembly defined for glyph
        return nil;
    }
    NSArray *parts = (NSArray *)assemblyInfo[kAssemblyParts];
    if (!parts) {
        // parts should always have been defined, but if it isn't return nil
        return nil;
    }
    NSMutableArray *rv = [NSMutableArray array];
    for (NSDictionary *partInfo in parts) {
        MTGlyphPart *part = [[MTGlyphPart alloc] init];
        NSNumber *adv = (NSNumber *)partInfo[@"advance"];
        part.fullAdvance = [self fontUnitsToPt:adv.intValue];
        NSNumber *end = (NSNumber *)partInfo[@"endConnector"];
        part.endConnectorLength = [self fontUnitsToPt:end.intValue];
        NSNumber *start = (NSNumber *)partInfo[@"startConnector"];
        part.startConnectorLength = [self fontUnitsToPt:start.intValue];
        NSNumber *ext = (NSNumber *)partInfo[@"extender"];
        part.isExtender = ext.boolValue;
        NSString *glyphName = (NSString *)partInfo[@"glyph"];
        part.glyph = [self.font getGlyphWithName:glyphName];
        
        [rv addObject:part];
        [part release];
    }
    return rv;
}

@end
