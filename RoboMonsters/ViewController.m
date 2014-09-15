//
//  ViewController.m
//  RoboMonsters
//
//  Created by Marcelo Sampaio on 9/14/14.
//  Copyright (c) 2014 Marcelo Sampaio. All rights reserved.
//

#import "ViewController.h"
#define SHARE_CONSTANT              @"Share"
#define CANCEL_CONSTANT             @"Cancel"
#define FACEBOOK_CONSTANT           @"Facebook"
#define EMAIL_CONSTANT              @"Email"
#define ABOUT_CONSTANT              @"About"
#define APP_COLOR                   [UIColor colorWithRed:31.0/255.0 green:187.0/255.0 blue:166.0/255.0 alpha:1.0];



@interface ViewController ()

@end

@implementation ViewController

@synthesize refreshOutlet;
@synthesize labelText,imageView;
@synthesize flag,spinner,searchCache;

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.searchCache=[[UIBarButtonItem alloc]init];
    self.labelText.text=@"";
    self.flag=0;
    [self loadRandomImage];
    [self loadQuotes];
    
    
}

#pragma mark - Working Methods
-(void)loadRandomImage {
    self.spinner.hidden=NO;
    // Random set
    int randomSet=arc4random()%3;
    randomSet++;
    
    // Generate a random value to the roboFace
    long randomNumber=arc4random() % 99999999;
    if (randomNumber<0) {
        randomNumber=randomNumber * -1;
    }
    
    NSString *urlString=[NSString stringWithFormat:@"http://robohash.org/%ld.png?set=set%d",randomNumber,randomSet];
    
//    // Load image from web
//    NSData *data=[NSData dataWithContentsOfURL:[NSURL URLWithString:urlString]];
//    self.imageView.image=[UIImage imageWithData:data];
    
    
    
    ///
    self.flag++;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // Loading quotes from web  <----------------
        NSURL *url=[NSURL URLWithString:urlString];
        NSData *data=[NSData dataWithContentsOfURL:url];
        
        // dispatch sync
        dispatch_async(dispatch_get_main_queue(), ^{
            
            // Got it. Back to  main queue
            self.imageView.image=[UIImage imageWithData:data];
            [self checkSpinner];
            
            
        }); // dispatch_get_main_queue
        
    }); //dispatch_async
    
    
    
}

-(void)loadQuotes {
    self.spinner.hidden=NO;
    self.flag++;
    // dispatch async
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // Loading quotes from web  <----------------
        NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"http://www.iheartquotes.com/api/v1/random?format=json"]];
        NSData *data=[NSData dataWithContentsOfURL:url];
        
        // dispatch sync
        dispatch_async(dispatch_get_main_queue(), ^{

            // Got it. Back to  main queue
            NSError *e=nil;
            NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error: &e];
            self.labelText.text=[dic1 objectForKey:@"quote"];
            self.labelText.numberOfLines = 0;
            [self checkSpinner];
            
        }); // dispatch_get_main_queue
        
    }); //dispatch_async

}


#pragma mark - UI Actions
- (IBAction)refresh:(id)sender {
//    self.searchCache=sender;
    // activity indicator

    [self.spinner startAnimating];

    
    [self loadRandomImage];
    [self loadQuotes];
}
- (IBAction)action:(id)sender {
    UIActionSheet *actionSheet=[[UIActionSheet alloc]initWithTitle:SHARE_CONSTANT delegate:self cancelButtonTitle:CANCEL_CONSTANT destructiveButtonTitle:nil otherButtonTitles:FACEBOOK_CONSTANT,EMAIL_CONSTANT,ABOUT_CONSTANT, nil];
    [actionSheet showInView:self.view];
}

#pragma mark - Action Sheet Delegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0) {
        [self shareFacebook];
    }else if (buttonIndex==1) {
        [self shareEmail];
    }else if (buttonIndex==2) {
        // A collection of quotes, fortunes, anecdotes, and quips
        [self performSegueWithIdentifier:@"showInfo" sender:self];
    }else if (buttonIndex==3) {
        // this is cancel button. do nothing.
    }
    
}
- (void)willPresentActionSheet:(UIActionSheet *)actionSheet
{
    for (UIView *subview in actionSheet.subviews) {
        if ([subview isKindOfClass:[UIButton class]]) {
            UIButton *button = (UIButton *)subview;
            //            button.titleLabel.textColor = APP_COLOR;
            if ([button.titleLabel.text isEqualToString:@"Cancel"]) {
                button.titleLabel.textColor = [UIColor redColor];
            }
        }
    }
}

#pragma mark - Email Delegate
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - Sharing Methods
-(void)shareFacebook
{
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook])
    {
        SLComposeViewController *social=[[SLComposeViewController alloc]init];
        social=[SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        NSString *postMessage=self.labelText.text;
        [social setInitialText: postMessage];
        [social addImage:self.imageView.image];
        
        [self presentViewController:social animated:YES completion:nil];
        
        [social setCompletionHandler:^(SLComposeViewControllerResult result) {
            NSString *output;
            switch (result) {
                case SLComposeViewControllerResultCancelled:
                    output=@"post cancelado";
                    break;
                case SLComposeViewControllerResultDone:
                    output=@"post publicado";
                    break;
                default:
                    break;
            }
        }];
    }
}

-(void)shareEmail {
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
	picker.mailComposeDelegate = self;
	
	[picker setSubject:[NSString stringWithFormat:@"RoboMonsters quotes"]];
    
    //    [picker setToRecipients:[NSArray arrayWithObjects:@"contato@crieportal.com", nil]];
    [picker setMessageBody:[self getMailBody] isHTML:YES];
    
    // Attach an image to the email
    //	NSString *path = [[NSBundle mainBundle] pathForResource:@"202151" ofType:@"jpg"];
    //    NSData *myData = [NSData dataWithContentsOfFile:path];
    //    NSData *myData=[self.document getImageDataFromDocumentsLibraryWithName:self.graph.title];
    NSData *imgData= UIImageJPEGRepresentation(self.imageView.image,0.0);
	[picker addAttachmentData:imgData mimeType:@"image/jpg" fileName:@"fileName"];

    
    [self presentViewController:picker animated:YES completion:NULL];
}

#pragma mark - Working Methods
-(NSString *)getMailBody {
    return self.labelText.text;
}

-(void)checkSpinner {

    if (self.flag>=2) {
        [self.spinner stopAnimating];
        self.flag=0;
        self.spinner.hidden=YES;
    }
}

@end
