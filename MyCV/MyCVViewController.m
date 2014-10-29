//
//  MyCVViewController.m
//  MyCV
//
//  Created by Ernesto Sánchez Kuri on 06/08/14.
//  Copyright (c) 2014 SK Labs. All rights reserved.
//

#import "MyCVViewController.h"
#import "UIColor+customProperties.h"
#import "UILabel+customProperties.h"
#import "MyCVUtilities.h"
@import CoreImage;
@import QuartzCore;

@interface MyCVViewController () <MyCVMenuDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *menuItems;
@end

@implementation MyCVViewController

-(void)awakeFromNib
{
    [super awakeFromNib];
    
}
-(void)initialSetup
{
    [[MyCVUtilities sharedInstance]setViewControllerObject:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[UINavigationBar appearance] setTintColor:[UIColor blackColor]];
    self.menuItems = @[@"Profile", @"Coming soon!"/*, @"About"*/];
    self.menuController = [MenuController sharedMenu];
    self.menuController.menuDelegate = self;
    [self captureBlur];
    [self.view addSubview:self.menuController.view];
    [self addChildViewController:self.menuController];
}

-(void)captureBlur
{
    UIGraphicsBeginImageContext(self.view.frame.size);
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *currentImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //Blur
    CIImage *imageToBlur = [CIImage imageWithCGImage:currentImage.CGImage];
    CIFilter *gaussianBlur = [CIFilter filterWithName:@"CIGaussianBlur"];
    [gaussianBlur setValue:imageToBlur forKey:@"inputImage"];
    CIImage *outputImage = [gaussianBlur valueForKey:@"outputImage"];
    
    UIImage *blurredI = [[UIImage alloc]initWithCIImage:outputImage];
    
    UIImageView *newView = [[UIImageView alloc]initWithFrame:self.view.bounds];
    newView.image = blurredI;
    [self.view insertSubview:newView belowSubview:self.blurredView];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)blurredBackground
{
    
}

#pragma mark - Navigation


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"TableViewSegue"]) {
        self.tableView = ((UITableViewController *)segue.destinationViewController).tableView;
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
    }
}

#pragma mark - Menu Delegate


-(UIViewController *)menu:(MenuController *)menu viewControllerAtIndexpath:(NSIndexPath *)indexpath
{
    UIStoryboard *storyboard = self.storyboard;
    UIViewController *vc = nil;
    
    vc.view.autoresizesSubviews = YES;
    vc.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    switch (indexpath.row) {
        case 0:
            vc = [storyboard instantiateViewControllerWithIdentifier:@"HomeVC"];
            break;
        case 1:
            vc = [storyboard instantiateViewControllerWithIdentifier:@"ResumeVC"];
        default:
            break;
    }
    return vc;
}
-(UITableView *)tableViewForMenu:(MenuController *)menu
{
    return self.tableView;
}
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

#pragma mark -TableView DataSource
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    return 44.0f;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.menuItems count];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier;
    UITableViewCell *cell;
   
        CellIdentifier = @"ItemCell";
       cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        if(cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:CellIdentifier];
        }
        
        
        // Configure the cell...
        //cell.backgroundColor = [UIColor darkGrayColor];
        UILabel *menuItemLabel = (UILabel *)[cell viewWithTag:2001];
        [menuItemLabel setText:self.menuItems[indexPath.row]];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 200.0f;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectNull];
    UIImageView *profileImageView = [[UIImageView alloc]initWithFrame:CGRectMake(30, 10, 114, 114)];
    [profileImageView setImage:[UIImage imageNamed:@"ProfileThumbnail"]];
    [profileImageView.layer setCornerRadius:profileImageView.frame.size.height / 2];
    [profileImageView.layer setMasksToBounds:YES];
    [profileImageView setContentMode:UIViewContentModeScaleAspectFill];
    
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, profileImageView.frame.origin.y + profileImageView.frame.size.height + 10, tableView.frame.size.width - 20, 16)];
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, nameLabel.frame.origin.y + nameLabel.frame.size.height + 10, tableView.frame.size.width - 20, 16)];
    [nameLabel primaryTextForNames];
    [titleLabel primaryTextForTitles];
    [nameLabel setText:@"E. Sanchez Kuri"];
    [titleLabel setText:@"IT Engineer"];
    [nameLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [headerView addSubview:profileImageView];
    [headerView addSubview:nameLabel];
    [headerView addSubview:titleLabel];
    [headerView setBackgroundColor:[UIColor clearColor]];
    return headerView;
}


@end
