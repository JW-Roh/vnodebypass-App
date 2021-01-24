//
//  ViewController.m
//  vnodebypass
//
//  Created by xsf1re on 2021/01/24.
//

#import "ViewController.h"
#import <spawn.h>

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UILabel *status;
@property (weak, nonatomic) IBOutlet UIButton *btn;

@end

@implementation ViewController

- (void)enable {
    pid_t pid;
    const char* args[] = {"vnodebypass", "-s", NULL};
    posix_spawn(&pid, "/usr/bin/vnodebypass", NULL, NULL, (char* const*)args, NULL);
    
    sleep(2);

    const char* args2[] = {"vnodebypass", "-h", NULL};
    posix_spawn(&pid, "/usr/bin/vnodebypass", NULL, NULL, (char* const*)args2, NULL);
    
    sleep(2);
}

- (void)disable {
    pid_t pid;
    const char* args[] = {"vnodebypass", "-r", NULL};
    posix_spawn(&pid, "/usr/bin/vnodebypass", NULL, NULL, (char* const*)args, NULL);
    
    sleep(2);

    const char* args2[] = {"vnodebypass", "-R", NULL};
    posix_spawn(&pid, "/usr/bin/vnodebypass", NULL, NULL, (char* const*)args2, NULL);
    
    sleep(2);
}

- (IBAction)tappedBtn:(UIButton *)sender {
    if([sender.currentTitle isEqualToString:@"Enable"]) {
        NSLog(@"starting enable vnodebypass...");
        [sender setTitle:@"Please wait..." forState:UIControlStateNormal];
        
        [self performSelectorOnMainThread:@selector(enable) withObject:nil waitUntilDone:YES];
        
        if(access("/tmp/vnodeMem.txt", F_OK == 0) && access("/bin/sh", F_OK) == -1) {
            self.status.text = @"Status: Enabled";
            [sender setTitle:@"Disable" forState:UIControlStateNormal];
        } else {
            [sender setTitle:@"Failed" forState:UIControlStateNormal];
        }
    }
    else if([sender.currentTitle isEqualToString:@"Disable"]) {
        NSLog(@"starting disable vnodebypass...");
        [sender setTitle:@"Please wait..." forState:UIControlStateNormal];
        
//        [self disable];
        [self performSelectorOnMainThread:@selector(disable) withObject:nil waitUntilDone:YES];
        
        if(access("/tmp/vnodeMem.txt", F_OK == -1) && access("/bin/sh", F_OK) == 0) {
            self.status.text = @"Status: Disabled";
            [sender setTitle:@"Enable" forState:UIControlStateNormal];
        } else {
            [sender setTitle:@"Failed" forState:UIControlStateNormal];
        }
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if(access("/tmp/vnodeMem.txt", F_OK == 0) && access("/bin/sh", F_OK) == -1) {
        self.status.text = @"Status: Enabled";
        [self.btn setTitle:@"Disable" forState:UIControlStateNormal];
    }
}


@end
