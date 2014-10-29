//
//  MyCVPDFPreviewViewController.m
//  MyCV
//
//  Created by Ernesto Sánchez Kuri on 05/09/14.
//  Copyright (c) 2014 SK Labs. All rights reserved.
//

#import "MyCVPDFPreviewViewController.h"

@interface MyCVPDFPreviewViewController ()

@end

@implementation MyCVPDFPreviewViewController

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
    [_pdfWebView loadData:_finalFile MIMEType:@"application/pdf" textEncodingName:@"utf-8" baseURL:nil];
    [_btnSave addTarget:self action:@selector(openWith) forControlEvents:UIControlEventTouchUpInside];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)showActionSheet
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:@"What's next?" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Send email",@"Open with...", @"Dropbox", @"Google Drive", nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleDefault; [actionSheet showInView:self.view];
}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex)
    {
        case 0:
        {
            [self sendEmail];
        }
            break;
        case 1:
        {
            [self openWith];
        }
            break;
        case 2:
        case 3:
        {
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Coming soon" message:@"This feature will be coming soon" delegate:self cancelButtonTitle:@"OK :(" otherButtonTitles: nil];
            [alertView show];
        }
            break;
        default:
            break;
    }
}

-(void)openWith
{
    
     NSURL *imageURL = [NSURL fileURLWithPath:_filePath];
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

-(void)sendEmail{
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *composeViewController = [[MFMailComposeViewController alloc] initWithNibName:nil bundle:nil];
        [composeViewController setMailComposeDelegate:self];
        [composeViewController setToRecipients:@[_currentUser.email]];
        [composeViewController setSubject:[NSString stringWithFormat:@"%@ %@ Resumé", _currentUser.firstName, _currentUser.lastName]];
        [composeViewController setMessageBody:@"This is my resumé, I build it in less than 10 minutes! Download SK CV Builder from the appstore" isHTML:YES];
        [composeViewController addAttachmentData:_finalFile mimeType:@"application/pdf" fileName:[NSString stringWithFormat:@"%@%@_resume", _currentUser.lastName, _currentUser.firstName]];
        [self presentViewController:composeViewController animated:YES completion:nil];
    }
}


- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    //Add an alert in case of failure
    if (error) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Failed" message:@"We couldn't send your resumé right now" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alertView show];
    }else{
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Success" message:@"Congratulations you have successfully sended your resumé" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alertView show];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
