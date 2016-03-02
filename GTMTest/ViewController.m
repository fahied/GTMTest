//
//  ViewController.m
//  GTMTest
//
//  Created by Fahied on 2/10/16.
//  Copyright © 2016 OLX Arabia. All rights reserved.
//

#import "ViewController.h"
#import <TAGManager.h>
#import <TAGContainerOpener.h>

#define WINNER_NAME_KEY @"winnerName"

@interface ViewController ()<TAGContainerOpenerNotifier>

@property (weak, nonatomic) IBOutlet UILabel *winnerNameLabel;
@property (nonatomic, strong) TAGManager *gtmManager;
@property (nonatomic, strong) TAGContainer *gtmContainer;
- (IBAction)updateWinner:(id)sender;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.winnerNameLabel.text = @"John";
    
    self.gtmManager = [TAGManager instance];
    [self.gtmManager.logger setLogLevel:kTAGLoggerLogLevelVerbose];
    self.gtmManager.dispatchInterval = 1.0;
    
    NSTimeInterval timeout = 5.0;
    [TAGContainerOpener openContainerWithId:@"GTM-TLRZPK"
                                 tagManager:self.gtmManager
                                   openType:kTAGOpenTypePreferFresh
                                    timeout:&timeout
                                   notifier:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)containerAvailable:(TAGContainer *)container
{
    self.gtmContainer = container;
    // Note that containerAvailable may be called on any thread, so you may need to dispatch back to
    // your main thread.
    dispatch_async(dispatch_get_main_queue(), ^{
        self.winnerNameLabel.text = [self.gtmContainer stringForKey:WINNER_NAME_KEY];
    });

}


- (IBAction)updateWinner:(id)sender {

    // force refresh container
    [self.gtmContainer refresh];
    self.winnerNameLabel.text = [self.gtmContainer stringForKey:WINNER_NAME_KEY];

}
@end
