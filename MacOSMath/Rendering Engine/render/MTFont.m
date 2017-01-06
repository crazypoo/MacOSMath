//
//  MTFont.m
//  iosMath
//
//  Created by Kostub Deshmukh on 5/18/16.
//
//  This software may be modified and distributed under the terms of the
//  MIT license. See the LICENSE file for details.
//

#import "MTFont.h"
#import "MTFont+Internal.h"

@interface MTFont ()

@property (assign, nonatomic) CGFontRef defaultCGFont;
@property (assign, nonatomic) CTFontRef ctFont;
@property (retain, nonatomic) MTFontMathTable *mathTable;
@property (retain, nonatomic) NSDictionary *rawMathTable;

@end

@implementation MTFont

- (instancetype)initFontWithName:(NSString *)name size:(CGFloat)size
{
    self = [super init];
    if (self != nil) {
        // CTFontCreateWithName does not load the complete math font, it only has about half the glyphs of the full math font.
        // In particular it does not have the math italic characters which breaks our variable rendering.
        // So we first load a CGFont from the file and then convert it to a CTFont.
        NSBundle *bundle = [NSBundle mainBundle];
        NSString *fontPath = [bundle pathForResource:name ofType:@"otf"];
        CGDataProviderRef fontDataProvider = CGDataProviderCreateWithFilename(fontPath.UTF8String);
        _defaultCGFont = CGFontCreateWithDataProvider(fontDataProvider);
        CFRelease(fontDataProvider);
        
        _ctFont = CTFontCreateWithGraphicsFont(_defaultCGFont, size, nil, nil);
        
        _rawMathTable = [[NSDictionary alloc] initWithContentsOfFile:[bundle pathForResource:name ofType:@"plist"]];
        _mathTable = [[MTFontMathTable alloc] initWithFont:self mathTable:_rawMathTable];
    }
    return self;
}

- (void)dealloc
{
    CGFontRelease(_defaultCGFont);
    CFRelease(_ctFont);
    [_rawMathTable release];
    [_mathTable release];
    [super dealloc];
}

- (MTFont *)fontWithName:(NSString *)name size:(CGFloat)size
{
    MTFont *f = [[[MTFont alloc] initFontWithName:name size:size] autorelease];
    
    if (f.fontSize == size) {
        return f;
    } else {
        return [[f copyFontWithSize:size] autorelease];
    }
}

+ (MTFont *)latinModernFontWithSize:(CGFloat)size
{
    return [[[MTFont alloc] initFontWithName:@"latinmodern-math" size:size] autorelease];
}

+ (MTFont *)xitsFontWithSize:(CGFloat)size
{
    return [[[MTFont alloc] initFontWithName:@"xits-math" size:size] autorelease];
}

+ (MTFont *)termesFontWithSize:(CGFloat)size
{
    return [[[MTFont alloc] initFontWithName:@"texgyretermes-math" size:size] autorelease];
}

+ (MTFont *)defaultFont
{
    return [[[MTFont alloc] initFontWithName:@"xits-math" size:20] autorelease];
}

- (MTFont *)copyFontWithSize:(CGFloat)size
{
    MTFont *copyFont = [[MTFont alloc] init];
    copyFont.defaultCGFont = self.defaultCGFont;
    // Retain the font as we are adding another reference to it.
    CGFontRetain(_defaultCGFont);
    copyFont->_ctFont = CTFontCreateWithGraphicsFont(copyFont.defaultCGFont, size, nil, nil);
    copyFont.rawMathTable = self.rawMathTable;
    copyFont.mathTable = [[[MTFontMathTable alloc] initWithFont:copyFont mathTable:copyFont.rawMathTable] autorelease];
    return copyFont;
}

-(NSString *)getGlyphName:(CGGlyph)glyph
{
    NSString *name = CFBridgingRelease(CGFontCopyGlyphNameForGlyph(self.defaultCGFont, glyph));
    return name;
}

- (CGGlyph)getGlyphWithName:(NSString *)glyphName
{
    return CGFontGetGlyphWithGlyphName(self.defaultCGFont, (__bridge CFStringRef)glyphName);
}

- (CGFloat)fontSize
{
    return CTFontGetSize(self.ctFont);
}

@end
