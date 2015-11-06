//
//  RTHXCustomTextField.m
//  RTHXiOSApp
//
//  Created by ZP on 15/11/2.
//  Copyright © 2015年 ZP. All rights reserved.
//

#import "ZPAutoAdjustTextField.h"
#import "UIView+Extension.h"
#import "UIBarButtonItem+Extension.h"

@interface ZPAutoAdjustTextField ()
@property (strong, nonatomic) UILabel *placeLbl;
@property (weak, nonatomic) UIView *adjustView;
@property (assign, nonatomic) CGFloat adjustY;
@end

@implementation ZPAutoAdjustTextField

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setToolbarWithTextType:CustomTextFieldTypePreviousNextCancelEnsure];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setToolbarWithTextType:CustomTextFieldTypePreviousNextCancelEnsure];
        self.adjustHeight = 260 - [self textFieldAdjustHeightWhenKeyBoardShow];
    }
    return self;
}

- (void)awakeFromNib
{
    [self setToolbarWithTextType:CustomTextFieldTypePreviousNextCancelEnsure];
    self.adjustHeight = 260 - [self textFieldAdjustHeightWhenKeyBoardShow];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}

- (CGFloat)textFieldAdjustHeightWhenKeyBoardShow
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(customTextFieldKeyboardDidChange:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(customTextFieldDidBeginEdting:) name:UITextFieldTextDidEndEditingNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(customTextFieldDidBeginEdting:) name:UITextFieldTextDidChangeNotification object:nil];
    UIView *view = self.superview;
    return [UIScreen mainScreen].bounds.size.height - self.height - self.y - view.y - 44;
}

- (void)customTextFieldKeyboardDidChange:(NSNotification *)note
{
    if ([note.name isEqualToString:UIKeyboardWillShowNotification]) {
        
    }else{
        [UIView animateWithDuration:0.25 animations:^{
            self.adjustView.y = 0;
        } completion:^(BOOL finished) {
            
        }];
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidEndEditingNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)adjustTextFieldFrameWhenBeginEdtingWithView:(UIView *)view
{
    self.adjustView = view;
    if (_adjustHeight > 0) {
        [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            view.y = - _adjustHeight;
        } completion:^(BOOL finished) {
            
        }];
    }else{
        [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            view.y = 0;
        } completion:^(BOOL finished) {
            
        }];
    }
}

- (void)customTextFieldDidBeginEdting:(NSNotification *)note
{
    self.placeLbl.text = self.placeholder;
        if (self.text.length >= 1) {
            if (self.placeLbl.y != -self.height * 0.5){
                [self addSubview:self.placeLbl];
                
                [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    _placeLbl.y = -self.height * 0.5;
                    _placeLbl.alpha = 1;
                } completion:^(BOOL finished) {
                    
                }];
            }
        }else{
            if (_placeLbl.y == -self.height * 0.5) {
                [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    _placeLbl.y = 0;
                    _placeLbl.alpha = 0.01;
                } completion:^(BOOL finished) {
                    [_placeLbl removeFromSuperview];
                }];
            }
        }
}

- (void)setToolbarWithTextType:(CustomTextFieldType)type
{
    self.placeLbl = [[UILabel alloc]init];
    self.placeLbl.font = [UIFont systemFontOfSize:14];
    self.placeLbl.frame = CGRectMake(0, 0, self.width, self.height * 0.4);
    self.placeLbl.alpha = 0.01;
    self.placeLbl.textColor = [UIColor colorWithRed:(62/255.0) green:(162/255.0) blue:(250/255.0) alpha:1];
    self.clipsToBounds = NO;
    
    UIToolbar *toolbar = [[UIToolbar alloc] init];
    toolbar.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.height, 44);
    [toolbar setBarStyle:UIBarStyleDefault];
    
    UIBarButtonItem *previousBarButton = [UIBarButtonItem itemWithTarget:self type:buttonBackType action:@selector(previousButtonClicked:)];
    UIBarButtonItem *nextBarButton     = [UIBarButtonItem itemWithTarget:self type:buttonForwardType action:@selector(nextButtonClicked:)];
    UIBarButtonItem *flexBarButton     = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *cancelBarButton   = [[UIBarButtonItem alloc] initWithTitle:@"取消" target:self action:@selector(cancelButtonClicked:)];
    UIBarButtonItem *doneBarButton     = [[UIBarButtonItem alloc] initWithTitle:@"确定" target:self action:@selector(ensureButtonClicked:)];
    // 如果不想使用VBFPopFlatButton使用下面的代码即可(需要把UIBarButtonItem+Extension里使用到VBFPopFlatButton的代码删除)
//    UIBarButtonItem *previousBarButton = [[UIBarButtonItem alloc] initWithTitle:@"上一个" target:self action:@selector(cancelButtonClicked:)];
//    UIBarButtonItem *nextBarButton     = [[UIBarButtonItem alloc] initWithTitle:@"下一个" target:self action:@selector(cancelButtonClicked:)];
//    UIBarButtonItem *flexBarButton     = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
//    UIBarButtonItem *cancelBarButton   = [[UIBarButtonItem alloc] initWithTitle:@"取消" target:self action:@selector(cancelButtonClicked:)];
//    UIBarButtonItem *doneBarButton     = [[UIBarButtonItem alloc] initWithTitle:@"确定" target:self action:@selector(ensureButtonClicked:)];
    NSArray *barButtonItems;
    switch (_textType) {
        case CustomTextFieldTypeCancelEnsure:
        {
            barButtonItems = @[cancelBarButton,flexBarButton, doneBarButton];
        }
            break;
        case CustomTextFieldTypePreviousNextEnsure:
        {
            barButtonItems = @[previousBarButton, nextBarButton, flexBarButton, doneBarButton];
        }
            break;
        case CustomTextFieldTypePreviousNextCancelEnsure:
        {
            barButtonItems = @[previousBarButton, nextBarButton, flexBarButton,cancelBarButton, doneBarButton];
        }
            break;
            
        default:
            break;
    }
    toolbar.items = barButtonItems;
    self.inputAccessoryView = toolbar;
}

- (void)setTextType:(CustomTextFieldType)textType
{
    _textType = textType;
    [self setToolbarWithTextType:textType];
}

- (void)previousButtonClicked:(UIBarButtonItem *)btn
{
    if (self.previousBlock != nil) {
        self.previousBlock(btn,self);
    }
    NSDictionary *dict = @{RTHXCustomTextFieldBarButtonItem : btn, RTHXCustomTextFieldCustomTextField : self};
    NSNotification *notice = [NSNotification notificationWithName:RTHXCustomTextFieldDidClickedPreviousBarButtonItem object:nil userInfo:dict];
    [[NSNotificationCenter defaultCenter] postNotification:notice];
}

- (void)nextButtonClicked:(UIBarButtonItem *)btn
{
    if (self.nextBlock != nil) {
        self.nextBlock(btn,self);
    }
    NSDictionary *dict = @{RTHXCustomTextFieldBarButtonItem : btn, RTHXCustomTextFieldCustomTextField : self};
    NSNotification *notice = [NSNotification notificationWithName:RTHXCustomTextFieldDidClickedNextBarButtonItem object:nil userInfo:dict];
    [[NSNotificationCenter defaultCenter] postNotification:notice];
}

- (void)cancelButtonClicked:(UIBarButtonItem *)btn
{
    self.text = nil;
    [self resignFirstResponder];
    if (self.cancelBlock != nil) {
        self.cancelBlock(btn,self);
    }
    NSDictionary *dict = @{RTHXCustomTextFieldBarButtonItem : btn, RTHXCustomTextFieldCustomTextField : self};
    NSNotification *notice = [NSNotification notificationWithName:RTHXCustomTextFieldDidClickedCancelBarButtonItem object:nil userInfo:dict];
    [[NSNotificationCenter defaultCenter] postNotification:notice];
}

- (void)ensureButtonClicked:(UIBarButtonItem *)btn
{
    [self resignFirstResponder];
    if (self.ensureBlock != nil) {
        self.ensureBlock(btn,self);
    }
    NSDictionary *dict = @{RTHXCustomTextFieldBarButtonItem : btn, RTHXCustomTextFieldCustomTextField : self};
    NSNotification *notice = [NSNotification notificationWithName:RTHXCustomTextFieldDidClickedEnsureBarButtonItem object:nil userInfo:dict];
    [[NSNotificationCenter defaultCenter] postNotification:notice];
}

@end