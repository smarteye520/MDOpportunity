//
//  DirectionController.h
//  ShortGrass
//
//  Created by XAGON on 2013-05-24.
//  Copyright (c) 2013 Shortgrass. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DirectionPopoverDelegate <NSObject>
-(void)DirectionPopoverDoneButtonName:(NSString *)name Object:(NSString *)object TextField:(UITextField*)textField;
@end

@interface DirectionController : UIViewController
@property (nonatomic) NSString *Name;
@property (nonatomic) UITextField *TextField;
@property (nonatomic, assign) id<DirectionPopoverDelegate> delegate;
@end
