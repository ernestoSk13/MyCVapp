//
//  MyCVPDFDesignOptionsViewController.m
//  MyCV
//
//  Created by Ernesto Sánchez Kuri on 05/09/14.
//  Copyright (c) 2014 SK Labs. All rights reserved.
//

#import "MyCVPDFDesignOptionsViewController.h"
#import "UIImage+customProperties.h"

@interface MyCVPDFDesignOptionsViewController ()
{
    NSString *finalPath;
}
@end

@implementation MyCVPDFDesignOptionsViewController

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
    self.title = @"PDF Designs";
    if (!_imgViewDesign.image) {
        [_btnDesign setHidden:YES];
        [_lblDesignTitle setHidden:YES];
    }
    
    theDesignNumber = DesignOne;
    _scrollPage.delegate = self;
    designs = @[@"Design 1", @"Design 2", @"Design 3"];
    imageDict = @{@"Design 1" : @"Dummy_CV1",
                  @"Design 2" : @"Dummy_CV2",
                  @"Design 3" : @"Dummy_CV3"};
    [self populatePagingController];
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(getImagePreview:)];
    gesture.numberOfTapsRequired = 1;
    _imgViewDesign.userInteractionEnabled = YES;
    [_imgViewDesign addGestureRecognizer:gesture];
    
    gesture.numberOfTapsRequired = 1;
    currentBasicInfo = [self.confirmedBasicInfo objectAtIndex:0];
    [_btnDesign addTarget:self action:@selector(validateData:) forControlEvents:UIControlEventTouchUpInside];
    
    [_btnHome setTarget:self];
    [_btnHome setAction:@selector(popToRoot)];
    interstitial = [[ADInterstitialAd alloc]init];
    interstitial.delegate = self;
}

-(void)populatePagingController
{
    [_scrollPage setContentSize:CGSizeMake(_imgViewDesignThree.frame.origin.x + _imgViewDesignThree.frame.size.width + 40, _scrollPage.frame.size.height)];
    /* [_imgViewDesign removeFromSuperview];
    CGRect imgFrame = _imgViewDesign.frame;
    int i = 0;
    for (NSString *designName in imageDict){
        UIImageView *designImage = _imgViewDesign;
        
        imgFrame.origin.x = self.scrollPage.frame.size.width * i + 10;
        designImage.frame = imgFrame;
        NSString *value = [imageDict objectForKey:designName];
        UIImage *designPreview = [UIImage imageNamed:value];
        designPreview = [UIImage imageWithImage:designPreview scaledToSize:CGSizeMake(240, 333)];
        [designImage setImage:designPreview];
        designImage.contentMode = UIViewContentModeScaleAspectFit;
        [_lblDesignTitle setText:designName];
        
        [_scrollPage addSubview:designImage];
        _scrollPage.pagingEnabled = YES;
        i++;
    }
    [_scrollPage setContentSize:CGSizeMake(_scrollPage.frame.size.width * imageDict.count, _scrollPage.frame.size.height)];*/
}


-(void)showTutorialView
{
    _shadowView = [[UIView alloc]initWithFrame:self.navigationController.view.frame];
    [_shadowView setBackgroundColor:[[UIColor blackColor]colorWithAlphaComponent:0.6]];
    UIImageView *swipeHand = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"swipeHand"]];
    [swipeHand setFrame:CGRectMake(_shadowView.frame.size.width - 120, _shadowView.frame.size.height / 2, 100, 100)];

    UILabel *swipeLabel = [[UILabel alloc]initWithFrame:CGRectMake(_shadowView.center.x - 120, swipeHand.frame.origin.y - 50, 300, 50)];
    [swipeLabel setText:@"Swipe to select different designs"];
    [swipeLabel setTextColor:[UIColor whiteColor]];
    
    [_shadowView addSubview:swipeHand];
    [_shadowView addSubview:swipeLabel];
    [self.navigationController.view addSubview:_shadowView];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissTutorial)];
    tapGesture.numberOfTapsRequired = 1;
    _shadowView.userInteractionEnabled = YES;
    [_shadowView addGestureRecognizer:tapGesture];
}

-(void)dismissTutorial
{
    [_shadowView removeFromSuperview];
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat pageWidth = self.scrollPage.frame.size.width;
    int page = floor((self.scrollPage.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    switch (page) {
        case 0:
            [_lblDesignTitle setText:@"Design 1"];
            theDesignNumber = DesignOne;
            break;
        case 1:
             [_lblDesignTitle setText:@"Design 2"];
            theDesignNumber = DesignTwo;
            break;
        case 2:
             [_lblDesignTitle setText:@"Design 3"];
            theDesignNumber = DesignThree;
            break;
        default:
            break;
    }
    self.pageControl.currentPage = page;
}


-(void)interstitialAdDidLoad:(ADInterstitialAd *)interstitialAd
{
    if (interstitialAd.loaded) {
        
        CGRect interstitialFrame = self.view.bounds;
        interstitialFrame.origin = CGPointMake(0, 0);
        AdView = [[UIView alloc] initWithFrame:interstitialFrame];
        [self.navigationController.view addSubview:AdView];
        
        [interstitial presentInView:AdView];
        
        UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button addTarget:self action:@selector(closeAd:) forControlEvents:UIControlEventTouchDown];
        button.backgroundColor = [UIColor clearColor];
        [button setBackgroundImage:[UIImage imageNamed:@"closeButton"] forState:UIControlStateNormal];
        button.frame = CGRectMake(5, 20, 30, 30);
        [AdView addSubview:button];
        
        [UIView beginAnimations:@"animateAdBannerOn" context:nil];
        [UIView setAnimationDuration:1];
        [AdView setAlpha:1];
        [UIView commitAnimations];
        
    }

}
-(void)closeAd:(id)sender {
    [UIView beginAnimations:@"animateAdBannerOff" context:nil];
    [UIView setAnimationDuration:1];
    [AdView setAlpha:0];
    [UIView commitAnimations];
   [self showTutorialView];
    [AdView removeFromSuperview];
    AdView=nil;
    //_requestingAd = NO;
}


-(void)interstitialAdActionDidFinish:(ADInterstitialAd *)interstitialAd
{
    
    interstitial = nil;
    interstitialAd = nil;
}

-(void)interstitialAd:(ADInterstitialAd *)interstitialAd didFailWithError:(NSError *)error
{
    
}

-(void)interstitialAdDidUnload:(ADInterstitialAd *)interstitialAd
{
    
}

-(void)popToRoot
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)getImagePreview:(UIGestureRecognizer *)sender
{
    UIImageView *imageView = (UIImageView *)sender.view;
    UIImageView *previewImage = [[UIImageView alloc]initWithFrame:CGRectMake(imageView.frame.origin.x, imageView.frame.origin.y, imageView.frame.size.width, imageView.frame.size.height)];
    returningRect = imageView.frame;
    [previewImage setImage:imageView.image];
    [self.scrollView addSubview:previewImage];
    
    [UIView animateWithDuration:1 animations:^{
        CGRect newRect = CGRectMake(0, 0, self.view.frame.size.width, self.navigationController.view.frame.size.height - self.navigationController.navigationBar.frame.size.height);
        previewImage.frame = newRect;
    } completion:^(BOOL finished) {
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(disappearImage:)];
        gesture.numberOfTapsRequired = 1;
        previewImage.userInteractionEnabled = YES;
        [previewImage addGestureRecognizer:gesture];
    }];
    
}

-(void)disappearImage:(UIGestureRecognizer *)sender
{
    UIImageView *imageView = (UIImageView *)sender.view;
    [UIView animateWithDuration:1
                     animations:^{
                         imageView.frame = returningRect;
                     }
                     completion:^(BOOL finished) {
                         [imageView removeFromSuperview];
                     }];
}


-(void)validateData: (UIButton *)sender
{
   
    
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    
    NSString *path = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithString:[NSString stringWithFormat:@"%@_%@_design%ld.pdf", currentBasicInfo.firstName, currentBasicInfo.lastName, (long)theDesignNumber]]];
    [self CreaPDFconPath:path andDesignNumber:(int)theDesignNumber];
    
}


#pragma mark - PDF

-(void)CreaPDFconPath:(NSString*)pdfFilePath andDesignNumber:(int)designNumber{
    
     [self showLoadingIndicator];
    UIFont*font = [UIFont fontWithName:@"HelveticaNeue-Light" size:22.0];
    
    UIColor*color = [UIColor blackColor];
    NSDictionary*att = @{NSFontAttributeName: font, NSForegroundColorAttributeName:color};
    
    NSString* text = [NSString stringWithFormat:@"%@ \n\n%@", currentBasicInfo.firstName, currentBasicInfo.lastName];
    
    CGFloat stringSize = [text boundingRectWithSize:CGSizeMake(980, CGFLOAT_MAX)// use CGFLOAT_MAX to dinamically calculate the height of a string
                                            options:NSStringDrawingUsesLineFragmentOrigin
                                         attributes:att context:nil].size.height;
    
    //creo pdf e vi aggiungo testo e immagini
    PDFHelper *pdfFile = [[PDFHelper alloc]init];
    [pdfFile initContentOfFile];
    [pdfFile setSize:CGSizeMake(612, 792)];
    pdfFile.designNumber = designNumber;
    [pdfFile addHeadertWithRect:currentBasicInfo.firstName inRect:CGRectMake(10, 10, 980, 60)];
    UIImage *imageData = [UIImage imageWithData:[NSData dataWithContentsOfFile:currentBasicInfo.profilePicUrl]];
    
    [pdfFile addImageWithRect:imageData inRect:CGRectMake(10, 80, 250, 250)];
    
    NSString*stringInfo = [NSString stringWithFormat:@"%@:%@ \n\n%@",currentBasicInfo.email,currentBasicInfo.mobile,currentBasicInfo.country];
    [pdfFile addHeadertWithRect:stringInfo inRect:CGRectMake(300, 190, 500, 120)];
    
    [pdfFile addTextWithRect:text inRect:CGRectMake(10, 350, 980, CGFLOAT_MAX)];
    
    
    //disegno header immagine e testo
    // [pdfFile drawHeader];
    // [pdfFile drawImage];
    // [pdfFile drawText];
    //genero pdf
    
    switch (designNumber) {
        case 1:
        {
             [pdfFile drawHeaderWithBasicInfo:self.confirmedBasicInfo];
            if ([self.confirmedCareerObjective count] > 0) {
                [pdfFile drawCareerObjective:self.confirmedCareerObjective];
            }
            if ([self.confirmedEducation count]>0) {
                [pdfFile drawEducationSection:self.confirmedEducation];
            }
            if ([self.confirmedWorkHistory count]>0) {
                [pdfFile drawWorkExperience:self.confirmedWorkHistory];
            }
            if ([self.confirmedSkills count]>0) {
                [pdfFile drawSkills:self.confirmedSkills];
            }
            if ([self.confirmedAdditionalSections count]>0) {
                [pdfFile drawOtherSection:self.confirmedAdditionalSections];
            }
            
            
        }
            break;
        case 2:
        {
            [pdfFile drawHeaderforDesignTwoWithBasicInfo:self.confirmedBasicInfo];
            if ([self.confirmedCareerObjective count] > 0) {
                [pdfFile drawCareerObjectiveForDesignTwo:self.confirmedCareerObjective];
            }
            if ([self.confirmedEducation count]>0) {
                [pdfFile drawEducationSectionForDesignTwo:self.confirmedEducation];
            }
            if ([self.confirmedWorkHistory count]>0) {
                [pdfFile drawWorkExperience:self.confirmedWorkHistory];
            }
            if ([self.confirmedSkills count]>0) {
                [pdfFile drawSkills:self.confirmedSkills];
            }
            if ([self.confirmedAdditionalSections count]>0) {
                [pdfFile drawOtherSection:self.confirmedAdditionalSections];
            }
        }
        case 3:
        {
            
            [pdfFile drawHeaderWithBasicInfo:self.confirmedBasicInfo];
            if (self.confirmedEducation) {
                [pdfFile drawEducationSection:self.confirmedEducation];
            }
            if (self.confirmedWorkHistory) {
                [pdfFile drawWorkExperience:self.confirmedWorkHistory];
            }
            if (self.confirmedSkills) {
                [pdfFile drawSkills:self.confirmedSkills];
            }
            if (self.confirmedAdditionalSections) {
                [pdfFile drawOtherSection:self.confirmedAdditionalSections];
            }
            
            
        }
            break;
        default:
            break;
    }
    
    generatedFile = [NSMutableData data];
   
    [pdfFile generatePdfWithFilePath:pdfFilePath withSuccess:^(NSMutableData *pdfFile) {
        if (pdfFile) {
            generatedFile = pdfFile;
            finalPath = pdfFilePath;
            [self openWith];
            [self hideLoadingIndicator];
           // [self performSegueWithIdentifier:@"previewSegue" sender:self];
           // [self sendEmail];
            
        }
    }];
    
    
}
-(void)openWith
{
    
    NSURL *imageURL = [NSURL fileURLWithPath:finalPath];
    self.documentController = [[UIDocumentInteractionController alloc]init];
    if (imageURL) {
        // Initialize Document Interaction Controller
        self.documentController = [UIDocumentInteractionController interactionControllerWithURL:imageURL];
        
        // Configure Document Interaction Controller
        [self.documentController setDelegate:self];
        
        // Preview PDF
        [self.documentController presentPreviewAnimated:YES];
    }
}

- (UIViewController *) documentInteractionControllerViewControllerForPreview: (UIDocumentInteractionController *) controller {
    return self;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"previewSegue"]) {
        MyCVPDFPreviewViewController *detailsVC = (MyCVPDFPreviewViewController *)segue.destinationViewController;
        detailsVC.finalFile = generatedFile;
        detailsVC.currentUser = currentBasicInfo;
        detailsVC.filePath = finalPath;
    }
}


@end
