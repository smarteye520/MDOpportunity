//
//  ChemicalMixCell.m
//  ShortGrass
//
//  Created by XAGON on 2013-05-05.
//  Copyright (c) 2013 Shortgrass. All rights reserved.
//

#import "ChemicalMixCell.h"

@implementation ChemicalMixCell

-(void)Load
{
    dataController = [[DatabaseController alloc] init];
}

-(void)Save
{
    [dataController UpdateReportChemicalMixID:self.ChemicalID Chemical:self.ChemicalField.text Concentration:self.ConcentrationField.text Units:self.UnitsField.text ApplicationMethod:self.ApplicationMethod.text VolumeSprayed:self.VolumeSprayed.text ChemicalUsed:self.ChemicalUsed.text];
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    if ( UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad )
    {
        storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard-iPhone" bundle:nil];
    }
    
    if (textField == self.ChemicalField || textField == self.UnitsField || textField == self.ApplicationMethod) {
        
        OptionsPopoverViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"OptionsPopover"];
        [viewController setDelegate:self];
        if (textField == self.ChemicalField) {
            viewController.Name = @"Chemical";
            viewController.TextField = self.ChemicalField;
        }
        else if (textField == self.ApplicationMethod) {
            viewController.Name = @"Application Method";
            viewController.TextField = self.ApplicationMethod;
        }
        else {
            viewController.Name = @"Units";
            viewController.TextField = self.UnitsField;
        }
        /*(
        if (CustomPopoverController == nil) {
            CustomPopoverController = [[UIPopoverController alloc] initWithContentViewController:viewController];
        }
        CustomPopoverController.delegate = self;
        CGRect frame = [textField convertRect:textField.bounds toView:self.superview];
        [CustomPopoverController presentPopoverFromRect:frame inView:self.superview permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        return NO;
         */
        
        self.selectedVC = viewController;
        
        
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
        {
            viewController.modalPresentationStyle = UIModalPresentationPopover;
            
            CustomPopoverController  = [viewController popoverPresentationController];
            CustomPopoverController.permittedArrowDirections = UIPopoverArrowDirectionAny;
            CustomPopoverController.sourceView = viewController.view;
            CustomPopoverController.sourceRect = textField.frame;
            CustomPopoverController.delegate = self;
            
        }
        
        [self.mainVC presentViewController:viewController animated:YES completion:nil];
        
//        [self endEditing:NO];
        
        return NO;
    }
    return YES;
}

-(NSMutableArray *)OptionsPopoverAddObjectsName:(NSString *)name
{
    if ([name isEqual:@"Chemical"]) {
        return [dataController GetChemicals];
    }
    else if ([name isEqual:@"Application Method"]) {
        return [@[@"", @"Hand Gun", @"Boom"] mutableCopy];
    }
    else {
        return [@[@"", @"L/G", @"g/G"] mutableCopy];
    }
}

-(void)OptionsPopoverDoneButtonName:(NSString *)name Object:(NSString *)object TextField:(UITextField *)textField
{
    textField.text = object;
    
    CustomPopoverController = nil;
    if ([name isEqual:@"Chemical"] || [name isEqual:@"Application Method"]) {
        if ([_ApplicationMethod.text isEqual:@""] || [_ChemicalField.text isEqual:@""]) {
            [self Save];
            return;
        }        
        NSString *applicationMethod;
        if ([_ApplicationMethod.text isEqual:@"Hand Gun"]) {
            applicationMethod = @"Hand";
        }
        else {
            applicationMethod = @"Boom";
        }
        NSMutableArray *chemicalMix = [dataController GetChemicalMixFromChemical:_ChemicalField.text ApplicationMethod:applicationMethod];
        if (chemicalMix.count > 0) {
            _ConcentrationField.text = [[chemicalMix objectAtIndex:0] objectAtIndex:2];
            _UnitsField.text = [[chemicalMix objectAtIndex:0] objectAtIndex:3];
        }
    }
    [self CheckChemicalUsed];
    [self Save];
}

-(void)OptionsPopoverCancelButton
{
    
//    [self endEditing:YES];

//    [CustomPopoverController dismissPopoverAnimated:YES];
    
    [self.selectedVC dismissViewControllerAnimated:YES completion:nil];
    
    CustomPopoverController = nil;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self CheckChemicalUsed];
    [self Save];
    return YES;
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self CheckChemicalUsed];
    [self Save];
    return YES;
}

//- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
//{
//    CustomPopoverController = nil;
//}

-(void)CheckChemicalUsed
{
    if (![_VolumeSprayed.text isEqual:@""] && ![_ConcentrationField.text isEqual:@""] && ![_UnitsField.text isEqual:@""])
    {
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
        NSNumber *volume = [formatter numberFromString:_VolumeSprayed.text];
        if (volume == nil) {
            return;
        }
        NSNumber *concentration = [formatter numberFromString:_ConcentrationField.text];
        if (concentration == nil) {
            return;
        }
        if (![_UnitsField.text isEqual:@"L/G"] && ![_UnitsField.text isEqual:@"g/G"]) {
            return;
        }
        double ChemicalUsed = [volume doubleValue] * [concentration doubleValue];
        _ChemicalUsed.text = [NSString stringWithFormat:@"%.2f", ChemicalUsed];
    }
}

@end
