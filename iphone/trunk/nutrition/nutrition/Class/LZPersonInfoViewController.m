//
//  LZPersonInfoViewController.m
//  nutrition
//
//  Created by liu miao on 4/26/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import "LZPersonInfoViewController.h"
#define kFatFactor 1/9
#define kCarbFactor 1/4
@interface LZPersonInfoViewController ()

@end

@implementation LZPersonInfoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (IBAction)doneButtonTapped:(id)sender
{
    int energy;
    float weight = [self.weightTextField.text floatValue];
    float height = [self.heightTextField.text floatValue]/100.f;
    float age=[self.ageTextField.text floatValue];
    float PA;
    int carboStandard;
    int fatStandard;
    int proteinStandard;
    if (self.sexSegmentControl.selectedSegmentIndex == 0)//male
    {
        if (age>=1 && age<3)
        {
            energy = 89*weight-100+20;
        }
        else if (age>=3 && age<9)
        {
            switch (self.activityLevelSegmentControl.selectedSegmentIndex) {
                case 0:
                    PA = 1.0;
                    break;
                case 1:
                    PA = 1.13;
                    break;
                case 2:
                    PA = 1.26;
                    break;
                case 3:
                    PA = 1.42;
                    break;
                default:
                    PA = 1.0;
                    break;
            }
            energy = 88.5 - 61.5*age +PA*(26.7 *weight +903*height)+20;
        }
        else if (age>=9 && age<19)
        {
            switch (self.activityLevelSegmentControl.selectedSegmentIndex) {
                case 0:
                    PA = 1.0;
                    break;
                case 1:
                    PA = 1.13;
                    break;
                case 2:
                    PA = 1.26;
                    break;
                case 3:
                    PA = 1.42;
                    break;
                default:
                    PA = 1.0;
                    break;
            }
            
            energy = 88.5 - 61.5*age +PA*(26.7 *weight +903*height)+25;
        }
        else
        {
            switch (self.activityLevelSegmentControl.selectedSegmentIndex) {
                case 0:
                    PA = 1.0;
                    break;
                case 1:
                    PA = 1.11;
                    break;
                case 2:
                    PA = 1.25;
                    break;
                case 3:
                    PA = 1.48;
                    break;
                default:
                    PA = 1.0;
                    break;
            }
            
            energy = 662 - 9.53*age +PA*(15.91 *weight +539.6*height);
        }
        
    }
    else//female
    {
        if (age>=1 && age<3)
        {
            energy = 89*weight-100+20;
        }
        else if (age>=3 && age<9)
        {
            switch (self.activityLevelSegmentControl.selectedSegmentIndex) {
                case 0:
                    PA = 1.0;
                    break;
                case 1:
                    PA = 1.16;
                    break;
                case 2:
                    PA = 1.31;
                    break;
                case 3:
                    PA = 1.56;
                    break;
                default:
                    PA = 1.0;
                    break;
            }
            
            energy = 135.3 - 30.8*age +PA*(10 *weight +934*height)+20;
        }
        else if (age>=9 && age<19)
        {
            switch (self.activityLevelSegmentControl.selectedSegmentIndex) {
                case 0:
                    PA = 1.0;
                    break;
                case 1:
                    PA = 1.16;
                    break;
                case 2:
                    PA = 1.31;
                    break;
                case 3:
                    PA = 1.56;
                    break;
                default:
                    PA = 1.0;
                    break;
            }
            
            energy = 135.3 - 30.8*age +PA*(10 *weight +934*height)+25;
        }
        else
        {
            switch (self.activityLevelSegmentControl.selectedSegmentIndex) {
                case 0:
                    PA = 1.0;
                    break;
                case 1:
                    PA = 1.12;
                    break;
                case 2:
                    PA = 1.27;
                    break;
                case 3:
                    PA = 1.45;
                    break;
                default:
                    PA = 1.0;
                    break;
            }
            
            energy = 354 - 6.91*age +PA*(9.36 *weight +726*height);
        }
        
        
    }
    //self.energyLabel.text = [NSString stringWithFormat:@"%d kcal",energy];

    carboStandard = (int)(energy*0.45*kCarbFactor+0.5);//(int)(energy*0.65*kCarbFactor+0.5);
    
    if (age>=1 && age<4)
    {
        fatStandard = 0;//[NSString stringWithFormat:@"0 ~ %d", (int)(energy*0.4*kFatFactor+0.5)];
    }
    else
    {
        if(age >= 4 && age<19)
        {
            fatStandard = (int)(energy*0.25*kFatFactor+0.5);//, (int)(energy*0.35*kFatFactor+0.5)];
        }
        else
        {
            fatStandard = (int)(energy*0.2*kFatFactor+0.5);//, (int)(energy*0.35*kFatFactor+0.5)];
        }
    }
    
    float proteinFactor;

    if (age>=1 && age<4)
    {
        proteinFactor = 1.05;
    }
    else if (age>=4 && age<14)
    {
        proteinFactor = 0.95;
    }
    else if (age>=14 && age<19)
    {
        proteinFactor =0.85;
    }
    else
    {
        proteinFactor = 0.8;
    }

    proteinStandard =(int)( weight*proteinFactor+0.5);
    NSLog(@"Energy : %d /n Carbo : %d /n Fat : %d /n Protein : %d",energy,carboStandard,fatStandard,proteinStandard);
    [self.navigationController popViewControllerAnimated:YES];
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField        // return NO to disallow editing.
{
    //1[textField becomeFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField;
{
    [textField resignFirstResponder];
    return YES;
    
}// called when 'return' key pressed. return NO to
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
