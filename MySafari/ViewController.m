//
//  ViewController.m
//  MySafari
//
//  Created by Diego Cichello on 1/7/15.
//  Copyright (c) 2015 Mobile Makers. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UIWebViewDelegate,UITextFieldDelegate, UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIButton *stopButton;
@property (weak, nonatomic) IBOutlet UIButton *forwardButton;
@property (weak, nonatomic) IBOutlet UIButton *clearButton;
@property (weak, nonatomic) IBOutlet UITextField *urlTextField;
@property (weak, nonatomic) IBOutlet UINavigationItem *navigationBar;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property  NSString *home ;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.home =@"http://mobilemakers.co";
    [self goToURLWithString:self.home];
    self.webView.scrollView.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self goToURLWithString:self.urlTextField.text];
    return true;
}
- (IBAction)onClearButtonPressed:(id)sender
{
    self.urlTextField.text = @"";
}

//-------------------------------- Bottom Bar Buttons ------------------------------------------------------


- (IBAction)onReloadButtonPressed:(id)sender
{
    [self.webView reload];
}
- (IBAction)onStopLoadingButtonPressed:(id)sender
{
    [self.webView stopLoading];
    self.spinner.hidden = true;
    [self.spinner stopAnimating];
}
- (IBAction)onBackButtonPressed:(id)sender
{
    [self.webView goBack];
}
- (IBAction)onForwardButtonPressed:(id)sender
{
    [self.webView goForward];


}
- (IBAction)onPreviewButtonPressed:(id)sender
{

    UIAlertView *alertView = [[UIAlertView alloc]init];
    alertView.title = @"Coming Soon!!!";
    alertView.message = @"Sooner than you think!!!";
    [alertView show];

}

// ---------------------------------- Web View Methods ---------------------------------------------------

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [self.spinner startAnimating];
    self.spinner.hidden = FALSE;
    [self updateButtons];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self.spinner stopAnimating];
    self.spinner.hidden = true;
    [self updateButtons];
    self.urlTextField.text = [[self.webView.request URL] absoluteString];

    self.navigationBar.title = [webView stringByEvaluatingJavaScriptFromString: @"document.title"];
    NSDictionary *size = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"Arial" size:14.0],NSFontAttributeName, nil];

    self.navigationController.navigationBar.titleTextAttributes = size;
    
}



- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{


    return true;
}



- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    self.urlTextField.backgroundColor = [UIColor whiteColor];
    self.urlTextField.textColor = [UIColor blackColor];
    self.clearButton.enabled = true;
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    self.urlTextField.backgroundColor = [UIColor clearColor];
    self.urlTextField.textColor = [UIColor clearColor];
    self.clearButton.enabled = false;
}





//------------------------------------- Other Methods --------------------------------------------------
- (void) updateButtons
{
    self.backButton.enabled = self.webView.canGoBack;
    self.forwardButton.enabled = self.webView.canGoForward;
    self.stopButton.enabled = self.webView.loading;

}

- (void) goToURLWithString:(NSString *)string
{
    if (![string hasPrefix:@"http://"])
    {
        string = [NSString stringWithFormat:@"http://%@", string];
    }

    NSURL *addressUrl = [NSURL URLWithString:string];
    NSURLRequest *addressRequest = [NSURLRequest requestWithURL:addressUrl];
    [self.webView loadRequest:addressRequest];

}



@end
