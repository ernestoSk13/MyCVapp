//
//  MyCVPDFPreviewViewController.h
//  MyCV
//
//  Created by Ernesto Sánchez Kuri on 05/09/14.
//  Copyright (c) 2014 SK Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMessageComposeViewController.h>
#import "UserInfo.h"

@interface MyCVPDFPreviewViewController : UIViewController <UIActionSheetDelegate, MFMailComposeViewControllerDelegate, UIDocumentInteractionControllerDelegate>
{
    NSURL *fileURL;
}
@property (weak, nonatomic) IBOutlet UIWebView *pdfWebView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIButton *btnSave;
@property (nonatomic, strong) NSMutableData *finalFile;
@property (nonatomic, strong) NSString *filePath;
@property (nonatomic, strong) UserInfo *currentUser;
@property (nonatomic, strong) UIDocumentInteractionController *documentController;
@end
