//
//  UIAlertController+CustomBlocks.h
//  Qsirch
//
//  Created by Harshal Wani on 9/18/17.
//  Copyright © 2017 healmax. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^UIAlertControllerCompletionBlock) (UIAlertController *__nonnull controller, NSInteger buttonIndex);

@interface UIAlertController (CustomBlocks)

@property (readonly, nonatomic) NSInteger cancelButtonIndex;
@property (readonly, nonatomic) NSInteger firstOtherButtonIndex;

+ (nullable instancetype)showAlertViewWithTitle:(nullable NSString *)title
                                        message:(nullable NSString *)message
                                        button1:(nullable NSString *)cancelButtonTitle;

+ (nullable instancetype)showAlertViewWithTitle:(nullable NSString *)title
                                        message:(nullable NSString *)message
                                        button1:(nullable NSString *)cancelButtonTitle
                                       tapBlock:(nullable UIAlertControllerCompletionBlock)tapBlock;

+ (nullable instancetype)showAlertWithTitle:(nullable NSString *)title
                                    message:(nullable NSString *)message
                          cancelButtonTitle:(nullable NSString *)cancelButtonTitle
                           otherButtonTitle:(nullable NSString *)otherButtonTitle
                                   tapBlock:(nullable UIAlertControllerCompletionBlock)tapBlock;

+ (nullable instancetype)showInputAlertViewWithTitle:(nullable NSString *)title
                                             message:(nullable NSString *)message
                                placeholderInputText:(nullable NSString *)placeholderText
                                    defaultInputText:(nullable NSString *)inputText
                                   cancelButtonTitle:(nullable NSString *)cancelButtonTitle
                                    otherButtonTitle:(nullable NSString *)otherButtonTitle
                                            tapBlock:(nullable UIAlertControllerCompletionBlock)tapBlock;
@end
