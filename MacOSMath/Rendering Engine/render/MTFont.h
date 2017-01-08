//
//  MTFont.h
//  iosMath
//
//  Created by Kostub Deshmukh on 5/18/16.
//
//  This software may be modified and distributed under the terms of the
//  MIT license. See the LICENSE file for details.
//

#import <CoreText/CoreText.h>
#import <CoreGraphics/CoreGraphics.h>
#import <Foundation/Foundation.h>

/** MTFont wraps the inconvenient distinction between CTFont and CGFont as well
 as the data loaded from the math table.
 */
@interface MTFont : NSObject

/** Initializer. */
- (instancetype)initFontWithName:(NSString *)name size:(CGFloat)size;

/** Returns a copy of this font but with a different size. */
- (MTFont *)copyFontWithSize:(CGFloat)size NS_RETURNS_RETAINED;

/** Fonts helper method. */
+ (MTFont *)latinModernFontWithSize:(CGFloat)size;
+ (MTFont *)xitsFontWithSize:(CGFloat)size;
+ (MTFont *)termesFontWithSize:(CGFloat)size;
+ (MTFont *)xitsFontAndChineseExtensionWithSize:(CGFloat)size;

/** Default font helper method. */
+ (MTFont *)defaultFont;

/** The size of this font in points. */
@property (assign, nonatomic, readonly) CGFloat fontSize;

@end
