//
//  UIAlertController+CustomBlocks.m
//  Qsirch
//
//  Created by Harshal Wani on 9/18/17.
//  Copyright © 2017 healmax. All rights reserved.
//

#import "UIAlertController+CustomBlocks.h"

static NSInteger const UIAlertControllerBlocksCancelButtonIndex = 0;
static NSInteger const UIAlertControllerBlocksFirstOtherButtonIndex = 1;
//static NSInteger const UIAlertControllerBlocksDestructiveButtonIndex = 2;

@implementation UIAlertController (CustomBlocks)

+ (nullable instancetype)showAlertViewWithTitle:(nullable NSString *)title
                                        message:(nullable NSString *)message
                                        button1:(nullable NSString *)cancelButtonTitle {
  UIAlertController *strongController = [self alertControllerWithTitle:title
                                                               message:message
                                                        preferredStyle:UIAlertControllerStyleAlert];

  __weak UIAlertController *controller = strongController;

  if (cancelButtonTitle) {
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelButtonTitle
                                                           style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction *action) {
    }];
    [controller addAction:cancelAction];
  }

  UIWindow *alertWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
  alertWindow.rootViewController = [[UIViewController alloc] init];
  alertWindow.windowLevel = UIWindowLevelAlert + 1;
  [alertWindow makeKeyAndVisible];
  [alertWindow.rootViewController presentViewController:controller animated:YES completion:nil];

  return controller;
}

+ (nullable instancetype)showAlertViewWithTitle:(nullable NSString *)title
                                        message:(nullable NSString *)message
                                        button1:(nullable NSString *)cancelButtonTitle
                                       tapBlock:(nullable UIAlertControllerCompletionBlock)tapBlock {
  UIAlertController *strongController = [self alertControllerWithTitle:title
                                                               message:message
                                                        preferredStyle:UIAlertControllerStyleAlert];

  __weak UIAlertController *controller = strongController;

  if (cancelButtonTitle) {
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelButtonTitle
                                                           style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction *action) {
      if (tapBlock) {
        tapBlock(controller, UIAlertControllerBlocksCancelButtonIndex);
      }
    }];
    [controller addAction:cancelAction];
  }

  UIWindow *alertWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
  alertWindow.rootViewController = [[UIViewController alloc] init];
  alertWindow.windowLevel = UIWindowLevelAlert + 1;
  [alertWindow makeKeyAndVisible];
  [alertWindow.rootViewController presentViewController:controller animated:YES completion:nil];

  return controller;
}

+ (nullable instancetype)showAlertWithTitle:(nullable NSString *)title
                                    message:(nullable NSString *)message
                          cancelButtonTitle:(nullable NSString *)cancelButtonTitle
                           otherButtonTitle:(nullable NSString *)otherButtonTitle
                                   tapBlock:(nullable UIAlertControllerCompletionBlock)tapBlock {
  UIAlertController *strongController = [self alertControllerWithTitle:title
                                                               message:message
                                                        preferredStyle:UIAlertControllerStyleAlert];

  __weak UIAlertController *controller = strongController;

  if (cancelButtonTitle) {
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelButtonTitle
                                                           style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction *action) {
      if (tapBlock) {
        tapBlock(controller, UIAlertControllerBlocksCancelButtonIndex);
      }
    }];
    [controller addAction:cancelAction];
  }
  if (otherButtonTitle) {
    UIAlertAction *othetAction = [UIAlertAction actionWithTitle:otherButtonTitle
                                                          style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction *action) {
      if (tapBlock) {
        tapBlock(controller, UIAlertControllerBlocksFirstOtherButtonIndex);
      }
    }];
    [controller addAction:othetAction];
  }

  UIWindow *alertWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
  alertWindow.rootViewController = [[UIViewController alloc] init];
  alertWindow.windowLevel = UIWindowLevelAlert + 1;
  [alertWindow makeKeyAndVisible];
  [alertWindow.rootViewController presentViewController:controller animated:YES completion:nil];

  return controller;
}

+ (nullable instancetype)showInputAlertViewWithTitle:(nullable NSString *)title
                                             message:(nullable NSString *)message
                                placeholderInputText:(nullable NSString *)placeholderText
                                    defaultInputText:(nullable NSString *)inputText
                                   cancelButtonTitle:(nullable NSString *)cancelButtonTitle
                                    otherButtonTitle:(nullable NSString *)otherButtonTitle
                                            tapBlock:(nullable UIAlertControllerCompletionBlock)tapBlock {
  UIAlertController *strongController = [self alertControllerWithTitle:title
                                                               message:message
                                                        preferredStyle:UIAlertControllerStyleAlert];

  __weak UIAlertController *controller = strongController;

  [controller addTextFieldWithConfigurationHandler:^(UITextField *_Nonnull textField) {
    if (placeholderText) {
      textField.placeholder = placeholderText;
    }
    if (inputText) {
      textField.text = inputText;
    }
  }];

  if (cancelButtonTitle) {
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelButtonTitle
                                                           style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction *action) {
      if (tapBlock) {
        tapBlock(controller, UIAlertControllerBlocksCancelButtonIndex);
      }
    }];
    [controller addAction:cancelAction];
  }
  if (otherButtonTitle) {
    UIAlertAction *othetAction = [UIAlertAction actionWithTitle:otherButtonTitle
                                                          style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction *action) {
      if (tapBlock) {
        tapBlock(controller, UIAlertControllerBlocksFirstOtherButtonIndex);
      }
    }];
    [controller addAction:othetAction];
  }

  UIWindow *alertWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
  alertWindow.rootViewController = [[UIViewController alloc] init];
  alertWindow.windowLevel = UIWindowLevelAlert + 1;
  [alertWindow makeKeyAndVisible];
  [alertWindow.rootViewController presentViewController:controller animated:YES completion:nil];

  return controller;

  //    QFBlockAlertView *alert = [[QFBlockAlertView alloc] initWithTitle:inTitle message:nil delegate:nil cancelButtonTitle:btn1 otherButtonTitles:btn2,nil];
  //    alert.delegate = alert;
  //
  //    UITextField *inputKeyword;
  //
  //    if ([QFBlockAlertView isOSVersion5AndAbove])
  //    {
  //        alert.alertViewStyle = UIAlertViewStylePlainTextInput;
  //        inputKeyword = [alert textFieldAtIndex:0];
  //        inputKeyword.text = text;
  //    }
  //    else
  //    {
  //        alert.message = @"\n\n";
  //        inputKeyword = [[[UITextField alloc] initWithFrame:CGRectMake(12.0, 45.0, 260.0, 30.0)] autorelease];
  //        [inputKeyword setBackgroundColor: [UIColor clearColor]];
  //        [inputKeyword setBorderStyle: UITextBorderStyleRoundedRect];
  //        [inputKeyword becomeFirstResponder];
  //        [inputKeyword setText:text];
  //        [inputKeyword setReturnKeyType:UIReturnKeyDone];
  //        inputKeyword.delegate = alert;
  //        [alert addSubview:inputKeyword];
  //        alert.inputKeyword = inputKeyword;
  //    }
  //
  //    alert.inputAlertBlock = [block1 copy];
  //    alert._block2 = [block2 copy];
  //    [alert show];
  //
  //    UITextRange *textRange = [inputKeyword textRangeFromPosition:inputKeyword.beginningOfDocument toPosition:inputKeyword.endOfDocument];
  //    [inputKeyword setSelectedTextRange:textRange];
  //
  //    id appdelegate= [[UIApplication sharedApplication] delegate];
  //    if ([appdelegate respondsToSelector:@selector(updatePopupMsg:op:)])
  //    {
  //        [appdelegate performSelector:@selector(updatePopupMsg:op:) withObject:alert withObject:[NSNumber numberWithBool:YES]];
  //    }
  //
  //    return alert;
}

- (NSInteger)firstOtherButtonIndex {
  return UIAlertControllerBlocksFirstOtherButtonIndex;
}

- (NSInteger)cancelButtonIndex {
  return UIAlertControllerBlocksCancelButtonIndex;
}

@end
