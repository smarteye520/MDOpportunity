//
//  ColorPopoverViewController.m
//  ShortGrass
//
//  Created by XAGON on 2013-05-22.
//  Copyright (c) 2013 Shortgrass. All rights reserved.
//

#import "ColorPopoverViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface ColorPopoverViewController ()
@property (weak, nonatomic) IBOutlet UIButton *Black;
@property (weak, nonatomic) IBOutlet UIButton *Gray;
@property (weak, nonatomic) IBOutlet UIButton *Brown;
@property (weak, nonatomic) IBOutlet UIButton *Blue;
@property (weak, nonatomic) IBOutlet UIButton *Cyan;
@property (weak, nonatomic) IBOutlet UIButton *Green;
@property (weak, nonatomic) IBOutlet UIButton *Pink;
@property (weak, nonatomic) IBOutlet UIButton *Purple;
@property (weak, nonatomic) IBOutlet UIButton *Orange;
@property (weak, nonatomic) IBOutlet UIButton *Red;
@property (weak, nonatomic) IBOutlet UIButton *Yellow;
@property (weak, nonatomic) IBOutlet UIButton *White;
- (IBAction)ColorSelected:(id)sender;
@end

@implementation ColorPopoverViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.Black.titleLabel.text = @"Black";
    self.Black.titleLabel.textColor = [UIColor whiteColor];
    self.Black.layer.backgroundColor = [[UIColor blackColor] CGColor];
    self.Gray.titleLabel.text = @"Gray";
    self.Gray.titleLabel.textColor = [UIColor whiteColor];
    self.Gray.layer.backgroundColor = [[UIColor grayColor] CGColor];
    self.Brown.titleLabel.text = @"Brown";
    self.Brown.titleLabel.textColor = [UIColor whiteColor];
    self.Brown.layer.backgroundColor = [[UIColor brownColor] CGColor];
    self.Blue.titleLabel.text = @"Blue";
    self.Blue.titleLabel.textColor = [UIColor whiteColor];
    self.Blue.layer.backgroundColor = [[UIColor blueColor] CGColor];
    self.Cyan.titleLabel.text = @"Cyan";
    self.Cyan.titleLabel.textColor = [UIColor whiteColor];
    self.Cyan.layer.backgroundColor = [[UIColor cyanColor] CGColor];
    self.Green.titleLabel.text = @"Green";
    self.Green.titleLabel.textColor = [UIColor whiteColor];
    self.Green.layer.backgroundColor = [[UIColor greenColor] CGColor];
    self.Pink.titleLabel.text = @"Pink";
    self.Pink.titleLabel.textColor = [UIColor whiteColor];
    self.Pink.layer.backgroundColor = [[UIColor magentaColor] CGColor];
    self.Purple.titleLabel.text = @"Purple";
    self.Purple.titleLabel.textColor = [UIColor whiteColor];
    self.Purple.layer.backgroundColor = [[UIColor purpleColor] CGColor];
    self.Orange.titleLabel.text = @"Orange";
    self.Orange.titleLabel.textColor = [UIColor whiteColor];
    self.Orange.layer.backgroundColor = [[UIColor orangeColor] CGColor];
    self.Red.titleLabel.text = @"Red";
    self.Red.titleLabel.textColor = [UIColor whiteColor];
    self.Red.layer.backgroundColor = [[UIColor redColor] CGColor];
    self.Yellow.titleLabel.text = @"Yellow";
    self.Yellow.titleLabel.textColor = [UIColor blackColor];
    self.Yellow.layer.backgroundColor = [[UIColor yellowColor] CGColor];
    self.White.titleLabel.text = @"White";
    self.White.titleLabel.textColor = [UIColor blackColor];
    self.White.layer.backgroundColor = [[UIColor whiteColor] CGColor];
}

- (IBAction)ColorSelected:(id)sender 
{
    UIButton *button = (UIButton *)sender;
    [self.delegate ColorPopoverPickedColor:[UIColor colorWithCGColor:button.layer.backgroundColor]];;
}

@end
