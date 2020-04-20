//
//  DatePopoeverViewController.h
//  ShortGrass
//
//  Created by XAGON on 2013-04-20.
//  Copyright (c) 2013 Shortgrass. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DatePopoverDelegate <NSObject>
-(void)DatePopoverDoneDate:(NSString *)date TextField:(UITextField*)textField;
-(void)DatePopoverCancel;
@end

@interface DatePopoeverViewController : UIViewController

@property (nonatomic) NSString *Name;
@property (nonatomic) UITextField *textField;
@property (nonatomic, assign) id<DatePopoverDelegate> delegate;

@end
