//
//  LSToastView.m
//  Pods
//
//  Created by Lyson on 2019/11/9.
//

#import "LSToastView.h"

#define IsValidateString(str)                                                  \
    ((nil != str) && ([str isKindOfClass:[NSString class]]) &&                 \
     ([str length] > 0) && (![str isEqualToString:@"(null)"]) &&               \
     (![str isEqualToString:@"null"]) && ((NSNull *) str != [NSNull null]))

static const CGFloat kDuration = 2;

static NSMutableArray *toasts;

@interface LSToastView ()
@property (nonatomic, readonly) UILabel *textLabel;

@end

@implementation LSToastView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithText:(NSString *)text {
    if ((self = [self initWithFrame:CGRectZero])) {
        // Add corner radius
        self.backgroundColor =
            [UIColor colorWithRed:0 green:0 blue:0 alpha:.65];
        self.layer.cornerRadius = 18.0f;
        self.autoresizingMask = UIViewAutoresizingNone;
        self.autoresizesSubviews = NO;

        // Init and add label
        _textLabel = [[UILabel alloc] init];
        _textLabel.text = text;
        //        _textLabel.font = [UIFont boldSystemFontOfSize:16.f];
        _textLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:14];
        //        _textLabel.textColor = [UIColor whiteColor];
        _textLabel.textColor = [UIColor colorWithRed:255 / 255.0
                                               green:255 / 255.0
                                                blue:255 / 255.0
                                               alpha:1 / 1.0];
        _textLabel.adjustsFontSizeToFitWidth = NO;
        _textLabel.backgroundColor = [UIColor clearColor];
        _textLabel.numberOfLines = 0;
        _textLabel.textAlignment = NSTextAlignmentCenter;
        [_textLabel sizeToFit];
        [self addSubview:_textLabel];
    }

    return self;
}

#pragma mark - Public

+ (void)toastInView:(UIView *)parentView
           withText:(NSString *)text
           duration:(CGFloat)duration {
    // Add new instance to queue
    LSToastView *view = [[LSToastView alloc] initWithText:text];

    CGFloat lWidth = view.textLabel.frame.size.width;
    CGFloat lHeight = view.textLabel.frame.size.height;
    CGFloat pWidth = parentView.frame.size.width;
    CGFloat pHeight = parentView.frame.size.height;

    NSInteger screenWidth = [[UIScreen mainScreen] bounds].size.width;
    NSInteger screenHeight = [[UIScreen mainScreen] bounds].size.height;

    CGSize textSize = [LSToastView sizeWithContent:text
                                              font:view.textLabel.font
                                             width:screenWidth - 20.f];

    // Change toastview frame
    if ((pWidth - lWidth - 20) / 2. <= 0) {
        view.frame = CGRectMake(5.0, (pHeight - lHeight - 80) / 2,
                                screenWidth - 10.f, textSize.height + 40.0);
        view.textLabel.frame =
            CGRectMake(5.0, 20.0, screenWidth - 20.f, textSize.height);
    } else {
        view.frame = CGRectMake(5.0, (pHeight - lHeight - 80) / 2,
                                screenWidth - 10.f, lHeight + 50);
        view.textLabel.frame = CGRectMake(10.0, 25.0, screenWidth - 20.f, 20.0);
    }
    view.alpha = 0.0f;
    view.frame = CGRectMake((screenWidth - textSize.width - 60) / 2,
                            4.0 / 5.0 * screenHeight, textSize.width + 60, 36);
    view.textLabel.frame =
        CGRectMake(0, 0, view.frame.size.width, view.frame.size.height);
    if (toasts == nil) {
        toasts = [[NSMutableArray alloc] initWithCapacity:1];
        [toasts addObject:view];
        [LSToastView nextToastInView:parentView duration:duration];
    } else {
        if (toasts.count > 1) {
            [toasts removeAllObjects];
        }
        [toasts addObject:view];
    }
}

+ (CGSize)sizeWithContent:(NSString *)content
                     font:(UIFont *)font
                    width:(CGFloat)width {
    if (IsValidateString(content) && font && width > 0) {
        CGRect rect =
            [content boundingRectWithSize:CGSizeMake(width, 10000.0)
                                  options:NSStringDrawingUsesLineFragmentOrigin
                               attributes:@{
                                   NSFontAttributeName : font
                               }
                                  context:nil];
        return rect.size;
    }
    return CGSizeMake(0, 0);
}

#pragma mark - Private

- (void)fadeToastOut:(NSNumber *)duration {
    // Fade in parent view
    [UIView animateWithDuration:0.5
        delay:0
        options:UIViewAnimationOptionTransitionNone

        animations:^{
            self.alpha = 0.f;
        }
        completion:^(BOOL finished) {
            UIView *parentView = self.superview;
            [self removeFromSuperview];

            // Remove current view from array
            [toasts removeObject:self];
            if ([toasts count] == 0) {
                toasts = nil;
            } else
                [LSToastView nextToastInView:parentView
                                    duration:[duration floatValue]];
        }];
}

+ (void)nextToastInView:(UIView *)parentView duration:(CGFloat)duration {

    if ([toasts count] > 0) {
        LSToastView *view = [toasts lastObject];
        [toasts removeAllObjects];

        // Fade into parent view
        [parentView addSubview:view];
        [UIView animateWithDuration:.1
                              delay:0
                            options:UIViewAnimationOptionTransitionNone
                         animations:^{
                             view.alpha = 1.0;
                         }
                         completion:^(BOOL finished){
                         }];

        // Start timer for fade out
        [view performSelector:@selector(fadeToastOut:)
                   withObject:@(duration)
                   afterDelay:duration];
    }
}

/// 显示Toast
/// @param view view
/// @param message message
/// @param duration 周期
+ (void)showToast:(UIView *)view
          message:(NSString *)message
         duration:(CGFloat)duration {
    [LSToastView toastInView:view withText:message duration:duration];
}

@end
