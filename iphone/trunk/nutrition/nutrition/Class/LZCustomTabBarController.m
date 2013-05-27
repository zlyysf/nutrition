//
//  LZCustomTabBarController.m
//  nutrition
//
//  Created by liu miao on 5/27/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import "LZCustomTabBarController.h"

@interface LZCustomTabBarController ()

@end

@implementation LZCustomTabBarController
@synthesize currentSelectedIndex;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self hideExistingTabBar];
	[self customTabBar];
}
- (void)hideExistingTabBar
{
	for(UIView *view in self.view.subviews)
	{
		if([view isKindOfClass:[UITabBar class]])
		{
			view.hidden = YES;
			break;
		}
	}
}
- (void)customTabBar
{
//    self.tabbarImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0,self.tabBar.frame.origin.y+4, 320, 45)];
//    
//    [self.tabbarImageView setImage:[UIImage imageNamed:@"tab-bar.png"]];
//	[self.view addSubview:tabbarImageView];
//    
//	self.buttons = [NSMutableArray arrayWithCapacity:KeyTotalButton];
//    
    CGRect miniBarFrame = self.tabBar.frame;
//    NSString *path1 = [[NSBundle mainBundle] pathForResource:@"button_back@2x" ofType:@"png"];
//    UIImage * buttonBackImage = [UIImage imageWithContentsOfFile:path1];

    UIButton *foodListButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [foodListButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [foodListButton setBackgroundColor:[UIColor colorWithRed:15/255.f green:148/255.f blue:26/255.f alpha:1.0f]];
    foodListButton.bounds = CGRectMake(0, 0, 320/3, 49);
    foodListButton.center = CGPointMake(miniBarFrame.origin.x+160/3, miniBarFrame.origin.y+49/2);
    foodListButton.tag = 0;
    [foodListButton setTitle:@"食物" forState:UIControlStateNormal];
    [foodListButton addTarget:self action:@selector(selectedTab:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:foodListButton];
    
    UIButton *recommendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [recommendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [recommendButton setBackgroundColor:[UIColor colorWithRed:15/255.f green:148/255.f blue:26/255.f alpha:1.0f]];
    recommendButton.bounds = CGRectMake(0, 0, 320/3, 49);
    recommendButton.center = CGPointMake(miniBarFrame.origin.x+160, miniBarFrame.origin.y+49/2);
    recommendButton.tag = 1;
    [recommendButton setTitle:@"推荐" forState:UIControlStateNormal];
    [recommendButton addTarget:self action:@selector(selectedTab:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:recommendButton];

    UIButton *settingsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [settingsButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [settingsButton setBackgroundColor:[UIColor colorWithRed:15/255.f green:148/255.f blue:26/255.f alpha:1.0f]];
    settingsButton.bounds = CGRectMake(0, 0, 320/3, 49);
    settingsButton.center = CGPointMake(miniBarFrame.origin.x+320-160/3, miniBarFrame.origin.y+49/2);
    settingsButton.tag = 2;
    [settingsButton setTitle:@"设置" forState:UIControlStateNormal];
    [settingsButton addTarget:self action:@selector(selectedTab:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:settingsButton];

    
    
//    self.addPhotoButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    addPhotoButton.bounds = CGRectMake(0,0,31,30);
//    addPhotoButton.center = CGPointMake(30, miniBarFrame.origin.y+22.5);
//    [addPhotoButton setImage:[UIImage imageNamed:@"camera.png"] forState:UIControlStateNormal];
//    [addPhotoButton setImage:[UIImage imageNamed:@"camera-highlight.png"] forState:UIControlStateHighlighted];
//    [addPhotoButton addTarget:self action:@selector(AddPhoto) forControlEvents:UIControlEventTouchUpInside];
//    [self.buttons addObject:addPhotoButton];
//    [self.view  addSubview:addPhotoButton];
//    
//    self.nearbyButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    nearbyButton.bounds = CGRectMake(0,0,21,22);
//    nearbyButton.center = CGPointMake(85, miniBarFrame.origin.y+27.5);
//    
//    [nearbyButton setImage:[UIImage imageNamed:@"nearby-on.png"] forState:UIControlStateNormal];
//    [nearbyButton addTarget:self action:@selector(selectedTab:) forControlEvents:UIControlEventTouchUpInside];
//    nearbyButton.tag = 0;
//    [self.buttons addObject:nearbyButton];
//    [self.view  addSubview:nearbyButton];
//    
//    self.newsfeedButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    newsfeedButton.bounds = CGRectMake(0,0,21,22);
//    newsfeedButton.center = CGPointMake(135, miniBarFrame.origin.y+27.5);
//    [newsfeedButton setImage:[UIImage imageNamed:@"feed-off.png"] forState:UIControlStateNormal];
//    [newsfeedButton addTarget:self action:@selector(selectedTab:) forControlEvents:UIControlEventTouchUpInside];
//    newsfeedButton.tag = 1;
//    [self.buttons addObject:newsfeedButton];
//    [self.view  addSubview:newsfeedButton];
//    
//    self.profileButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    profileButton.bounds = CGRectMake(0,0,21,22);
//    profileButton.center = CGPointMake(185, miniBarFrame.origin.y+27.5);
//    [profileButton setImage:[UIImage imageNamed:@"profile-off.png"] forState:UIControlStateNormal];
//    [profileButton addTarget:self action:@selector(selectedTab:) forControlEvents:UIControlEventTouchUpInside];
//    profileButton.tag = 2;
//    [self.buttons addObject:profileButton];
//    [self.view  addSubview:profileButton];
//    
//    self.dateListButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    dateListButton.bounds = CGRectMake(0,0,22,22);
//    dateListButton.center = CGPointMake(235, miniBarFrame.origin.y+27.5);
//    [dateListButton setImage:[UIImage imageNamed:@"date-list-off.png"] forState:UIControlStateNormal];
//    
//    [dateListButton addTarget:self action:@selector(selectedTab:) forControlEvents:UIControlEventTouchUpInside];
//    dateListButton.tag = 3;
//    [self.buttons addObject:dateListButton];
//    [self.view  addSubview:dateListButton];
//    
//    self.createDateButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    
//    createDateButton.bounds = CGRectMake(0,0,31,30);
//    createDateButton.center = CGPointMake(290, miniBarFrame.origin.y+22.5);
//    [createDateButton setImage:[UIImage imageNamed:@"date-proposal.png"] forState:UIControlStateNormal];
//    [createDateButton setImage:[UIImage imageNamed:@"date-proposal-highlight.png"] forState:UIControlStateHighlighted];
//    [createDateButton addTarget:self action:@selector(createDate) forControlEvents:UIControlEventTouchUpInside];
//    createDateButton.tag = 4;
//    [self.buttons addObject:createDateButton];
//    [self.view  addSubview:createDateButton];
//    [self selectedTab:self.nearbyButton];
    
    [self setSelectedIndex:0];
}
- (void)selectedTab:(UIButton *)button{
//    if (self.currentSelectedIndex != button.tag)
//    {
//        
//        switch (button.tag)
//        {
//            case 0:
//                [nearbyButton setImage:[UIImage imageNamed:@"nearby-on.png"] forState:UIControlStateNormal];
//                break;
//            case 1:
//                [newsfeedButton setImage:[UIImage imageNamed:@"feed-on.png"] forState:UIControlStateNormal];
//                break;
//            case 2:
//                [profileButton setImage:[UIImage imageNamed:@"profile-on.png"] forState:UIControlStateNormal];
//                break;
//            case 3:
//                [dateListButton setImage:[UIImage imageNamed:@"date-list-on.png"] forState:UIControlStateNormal];
//                break;
//            default:
//                break;
//        }
//        switch (self.currentSelectedIndex)
//        {
//            case 0:
//                [nearbyButton setImage:[UIImage imageNamed:@"nearby-off.png"] forState:UIControlStateNormal];
//                break;
//            case 1:
//                [newsfeedButton setImage:[UIImage imageNamed:@"feed-off.png"] forState:UIControlStateNormal];
//                break;
//            case 2:
//                [profileButton setImage:[UIImage imageNamed:@"profile-off.png"] forState:UIControlStateNormal];
//                break;
//            case 3:
//                [dateListButton setImage:[UIImage imageNamed:@"date-list-off.png"] forState:UIControlStateNormal];
//                break;
//            default:
//                break;
//        }
//    }
    self.currentSelectedIndex = button.tag;
    self.selectedIndex = self.currentSelectedIndex;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
