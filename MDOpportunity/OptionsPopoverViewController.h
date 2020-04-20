//
//  OptionsPopoverViewController.h
//  ShortGrass
//
//  Created by XAGON on 2013-04-28.
//  Copyright (c) 2013 Shortgrass. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol OptionsPopoverDelegate <NSObject>
-(void)OptionsPopoverDoneButtonName:(NSString *)name Object:(NSString *)object TextField:(UITextField*)textField;
-(void)OptionsPopoverCancelButton;
-(NSMutableArray *)OptionsPopoverAddObjectsName:(NSString *)name;
@end

@interface OptionsPopoverViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate>
@property (nonatomic) NSString *Name;
@property (nonatomic) UITextField *TextField;
@property (nonatomic, assign) id<OptionsPopoverDelegate> delegate;

@property (strong, nonatomic) id mainVC;
@end
