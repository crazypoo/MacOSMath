# MacOSMath
Great iOS LaTeX rendering engine (iosMath) ported to Mac OS!

`MacOSMath` is a library for displaying beautifully rendered math equations
in Mac applications. It typesets formulae written using the LaTeX in a
`NSTextField` equivalent class. It uses the same typesetting rules as LaTeX
and so the equations are rendered exactly as LaTeX would render them. It is based on Kostub's iosMath library. All credits go to Kostub, he did all the hard work and makes iosMath better and better. I only ported it to Mac platform and reformatted code a little bit. Also, part of this readme (actually, most of it), is based on his original one. Please do check out [iosMath](https://github.com/kostub/iosMath).

## Example
Here is a screenshot of Quadratic Formula this library renders:

![Quadratic Formula](img/MacOSMath.png) 

## Requirements
`MacOSMath` works on OS X 10.8+, and uses advanced memory management (aka. Manual Retain Release). It depends on the following Apple frameworks:

* Foundation.framework
* Cocoa.framework
* CoreGraphics.framework
* QuartzCore.framework
* CoreText.framework

## Usage

The library provides a class `MTMathUILabel` which is a `NSView` that
supports rendering math equations. To display an equation simply create
an `MTMathUILabel` as follows:

```objective-c
#import "MTMathUILabel.h"

MTMathULabel *label = [[MTMathUILabel alloc] init];
label.latex = @"x = \\frac{-b \\pm \\sqrt{b^2-4ac}}{2a}";

```
In storyboard (or nib file), drag and place a `NSView` to `NSWindow`, and change its class in Identity Inspector to `MTMathUILabel` as will render the quadratic formula example shown above. Or you can create a `MTMathUILabel` programmatically.

### Included Features
This is a list of formula types that the library currently supports:

* Simple algebraic equations
* Fractions and continued fractions
* Exponents and subscripts
* Trigonometric formulae
* Square roots and n-th roots
* Calculus symbos - limits, derivatives, integrals
* Big operators (e.g. product, sum)
* Big delimiters (using \\left and \\right)
* Greek alphabet
* Combinatorics (\\binom, \\choose etc.)
* Geometry symbols (e.g. angle, congruence etc.)
* Ratios, proportions, percents
* Math spacing
* Overline and underline
* Math accents
* Matrices
* Equation alignment
* Most commonly used math symbols

### Advanced configuration

`MTMathUILabel` supports some advanced configuration options:

##### Math mode

You can change the mode of the `MTMathUILabel` between Display Mode
(equivalent to `$$` or `\[` in LaTeX) and Text Mode (equivalent to `$`
or `\(` in LaTeX). The default style is Display. To switch to Text
simply:

```objective-c
label.labelMode = kMTMathUILabelModeText;
```

##### Text Alignment
The default alignment of the equations is left. This can be changed to
center or right as follows:

```objective-c
label.textAlignment = kMTTextAlignmentCenter;
```

##### Font size
The default font-size is 20pt. You can change it as follows:

```objective-c
label.fontSize = 30;
```
##### Font
The default font is *XITS Math*. This can be changed as:

```objective-c
label.font = [MTFont latinModernFontWithSize:20];
```

This project has 3 fonts bundled with it, but you can use any OTF math
font.

##### Color
The default color of the rendered equation is black. You can change
it to any other color as follows:

```objective-c
label.textColor = [NSColor redColor];
```

It is also possible to set different colors for different parts of the
equation. Just access the `displayList` field and set the `textColor`
on the underlying displays that you want to change the color of. 

##### Padding
The `MTMathUILabel` has top, bottom, left and right padding for finer
control of placement of the equation in relation to the view. However,
if you use auto-layout it is preferable to use constraints instead.

If you need to set it you can do as follows:

```objective-c
label.paddingRight = 20;
label.paddingTop = 10;
```

##### Error handling

If the LaTeX text given to `MTMathUILabel` is
invalid or if it contains commands that aren't currently supported then
an error message will be displayed instead of the label.

This error can be programmatically retrieved as `label.error`. If you
prefer not to display anything then set:

```objective-c
label.displayErrorInline = NO;
```

## Future Enhancements

Note this is not a complete implementation of LaTeX math mode. There are
some important pieces that are missing and will be included in future
updates. This includes:

* Support for explicit big delimiters (bigl, bigr etc.)
* Support for specifing fonts such as `\cal` or `\rm`
* Addition of missing plain TeX commands 

## Related Projects

For people who wants to render math equation on iOS, even those who don't, I recommend to check Kostub's:

* [iosMath](https://github.com/kostub): Beautiful math equation rendering on iOS.

It is the original project, and MacOSMath is just a ported version for Mac.

There are also other wonderful libraries written by Kostub:

* [MathEditor](https://github.com/kostub/MathEditor): A WYSIWYG editor
  for math equations on iOS.
* [MathSolver](https://github.com/kostub/MathSolver): A library for
  solving math equations.

## License

MacOSMath is available under the MIT license, the same as iosMath. See the [LICENSE](./LICENSE)
file for more info.

### Fonts
This distribution contains the following fonts. These fonts are
licensed as follows:
* Latin Modern Math: 
    [GUST Font License](./MacOSMath/Rendering\ Engine/font/GUST-FONT-LICENSE.txt)
* Tex Gyre Termes:
    [GUST Font License](./MacOSMath/Rendering\ Engine/font/GUST-FONT-LICENSE.txt)
* [XITS Math](https://github.com/khaledhosny/xits-math):
    [Open Font License](./MacOSMath/Rendering\ Engine/font/OFL.txt)
