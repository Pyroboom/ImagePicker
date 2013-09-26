//
//  ViewController.m
//  ImagePicker
//
//  Created by NinhNB on 17/9/13.
//  Copyright (c) 2013 NinhNB. All rights reserved.
//

#import "ImageViewController.h"

@interface ImageViewController () <UIScrollViewDelegate>
@end

@implementation ImageViewController
@synthesize imageView= _imageView;
@synthesize scrollView = _scrollView;
@synthesize slider;
@synthesize beginImage;
@synthesize activityIndicator;

-(IBAction)buttonClicked{
    picker = [[UIImagePickerController alloc]init];
    picker.delegate = self;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else{
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    [self presentViewController:picker animated:YES completion:nil]; 
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.scrollView.delegate = self;
	// Do any additional setup after loading the view, typically from a nib.

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)imagePickerControllerDidCancel: (UIImagePickerController *) Picker{
    [[Picker parentViewController] dismissViewControllerAnimated: YES  completion:nil];
}

-(void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    _imageView.image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [self dismissViewControllerAnimated:YES completion:nil];
        
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    if ((self.imageView.image.size.width >= screenRect.size.width)
        && self.imageView.image.size.height >= screenRect.size.height)
    {
        self.scrollView.contentSize = self.imageView.image.size;
        self.imageView.frame = CGRectMake(0, 0, self.imageView.image.size.width, self.imageView.image.size.height);
    }
    else {
     
        self.scrollView.contentSize = screenRect.size;

        float a = screenRect.size.width  / self.imageView.image.size.width;
        float b = screenRect.size.height / self.imageView.image.size.height;
 
        if (a<=b){
            self.imageView.frame = CGRectMake(0, 0, screenRect.size.width, self.imageView.image.size.height * a);
        } else{
            self.imageView.frame = CGRectMake(0, 0, self.imageView.image.size.width * b, screenRect.size.height);
        }
        
    //  self.imageView.frame = CGRectMake(0, 0, screenRect.size.width, screenRect.size.height);
    }
    
    beginImage = [[CIImage alloc] initWithCGImage:_imageView.image.CGImage];
    self.slider.value = 0.5;
 
}

-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return self.imageView;
}

- (void)sliderAction:(id)sender
{

	// Redraw the view with the new settings
/*   float value = self.slider.value * 2;
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur" keysAndValues:kCIInputImageKey, beginImage, @"inputRadius", @(value),nil];
    CIImage *outputImage = [filter outputImage];
    
    UIImage *newImage = [UIImage imageWithCIImage:outputImage];
    self.imageView.image = newImage;
*/

  //  if (!self.slider.isHidden){
        float value = self.slider.value * 10;
        
        [self.slider setHidden:YES];        
        [activityIndicator startAnimating];

        dispatch_queue_t blurQueue = dispatch_queue_create("blur queue", NULL);
        dispatch_async(blurQueue, ^{
            NSLog(@"1 %d", self.slider.isHidden);
            CIContext *context = [CIContext contextWithOptions:nil];
            CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur" keysAndValues:kCIInputImageKey, beginImage, @"inputRadius", @(value),nil];
            CIImage *outputImage = [filter outputImage];
            CGImageRef cgImage = [context createCGImage:outputImage fromRect:[beginImage extent]];
            
            UIImage *newImage = [UIImage imageWithCGImage:cgImage];

            dispatch_async(dispatch_get_main_queue(), ^{
                self.imageView.image = newImage;
                [self.slider setHidden:NO];
                [activityIndicator stopAnimating];
    //            NSLog(@"%d", self.slider.isHidden);
              
        });
    });

}

-(IBAction)buttonClear{
    
   /*
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docs = [paths objectAtIndex:0];
    NSString *path = [docs stringByAppendingFormat:@"/image1.jpg"];
        NSLog(@"%@", path);
    if (self.imageView.image) NSLog(@"OK");

    BOOL ok = [[NSFileManager defaultManager] createFileAtPath:path contents:nil attributes:nil];
    if(ok){
        NSFileHandle *myFileHandle = [NSFileHandle fileHandleForReadingAtPath:path];
        [myFileHandle writeData:UIImagePNGRepresentation(self.imageView.image)];
        NSLog(@"sds");
        [myFileHandle closeFile];
    }
       else {
           NSLog(@"NOK");
       }

 
    NSData* imageData = [NSData dataWithData: UIImageJPEGRepresentation(self.imageView.image, 1)];
    NSError *writeError = nil;
    
    [imageData writeToFile:path options:NSDataWritingAtomic error:&writeError];
    

    if (writeError!=nil){
        NSLog(@"%@: Error saving image %@", [self class], [writeError localizedDescription]);
    }
   

    self.imageView.image = NULL;
    self.scrollView.contentSize = CGSizeMake(0, 0);*/
    if (self.imageView.image == NULL){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No photos selected"
                                                        message:nil
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    else{
        UIImageWriteToSavedPhotosAlbum(self.imageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    }
    
    
}

-(void) image: (UIImage *) image didFinishSavingWithError:(NSError *)error contextInfo: (void *) contextInfo{
    if (error != nil)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Could not save photo"
                                                        message:nil
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Photo saved"
                                                        message:nil
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    
}

@end
