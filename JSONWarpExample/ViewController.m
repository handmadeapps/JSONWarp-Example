//
//  ViewController.m
//  JSONWarpExample
//
//  Created by Konstantinos Kontos on 8/13/15.
//  Copyright (c) 2015 Saturated Colors. All rights reserved.
//

#import "ViewController.h"
#import <JSONWarp/JSONWarp.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
//    [self example1];
//    [self example2];

    [self example3];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Example 1


-(void)example1 {
    SCLJSONWarp *jsonWarp=[[SCLJSONWarp alloc] initWithManagedObjectContext:[AppDelegate instance].managedObjectContext];
    NSURL *sampleJSONURL=[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"sample" ofType:@"json"]];
    
    SCLJSONNode *jsonGraph=[jsonWarp sclJSONNodeFromJSONURL:sampleJSONURL];
    
    NSMutableDictionary *rootDict=[jsonWarp sclJSONNodeValueForKey:kSCLRootNodeID usingRootJSONObject:jsonGraph];
    
    NSArray *terms=rootDict[@"terms"];
    [self printout:terms];
}


-(void)printout:(NSArray *)termsArr {
    
    for (NSDictionary *dict in termsArr) {
        DebugLog(@"%@\n\n",dict);
        
        self.textView.text=[self.textView.text stringByAppendingString:dict.description];
    }
    
}


#pragma mark - Example 2

-(void)example2 {
    SCLJSONWarp *jsonWarp=[[SCLJSONWarp alloc] initWithManagedObjectContext:[AppDelegate instance].managedObjectContext];
    NSURL *sampleJSONURL=[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"rubric" ofType:@"json"]];
    
    SCLJSONNode *jsonGraph=[jsonWarp sclJSONNodeFromJSONURL:sampleJSONURL];
    
    NSMutableDictionary *rootDict=[jsonWarp sclJSONNodeValueForKey:kSCLRootNodeID usingRootJSONObject:jsonGraph];
    
    NSString *statusStr=rootDict[@"status"];
    
    NSDictionary *dataDict=rootDict[@"data"];
    
    DebugLog(@"Status: %@",statusStr);
    
    NSArray *sectionsArr=dataDict[@"sections"];
    
    for (NSDictionary *sectionDict in sectionsArr) {
        DebugLog(@"Section: %@",sectionDict[@"title"]);
        
        for (NSDictionary *gradeLevelDict in sectionDict[@"grade_levels"]) {
            DebugLog(@"Grade Level: %@",gradeLevelDict[@"title"]);
            
            for (NSDictionary *gradeLineDict in gradeLevelDict[@"grade_lines"]) {
                
                DebugLog(@"Grade Line: %@ (%0.1f points)",gradeLineDict[@"title"],[gradeLineDict[@"points"] floatValue]);
                
            }
            
        }
    }
    
}


#pragma mark - Example 3

-(void)example3 {
    SCLJSONWarp *jsonWarp=[[SCLJSONWarp alloc] initWithManagedObjectContext:[AppDelegate instance].managedObjectContext];
    NSURL *sampleJSONURL=[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"rubric" ofType:@"json"]];
    
    SCLJSONNode *jsonGraph=[jsonWarp sclJSONNodeFromJSONURL:sampleJSONURL];
    
    NSMutableDictionary *rootDict=[jsonWarp sclJSONNodeValueForKey:kSCLRootNodeID usingRootJSONObject:jsonGraph];
    
    NSString *statusStr=rootDict[@"status"];

    SCLJSONNode *statusNode=[rootDict sclNodeForKey:@"status" withManagedObjectContext:[AppDelegate instance].managedObjectContext];
    
    NSDictionary *dataDict=rootDict[@"data"];
    
    SCLJSONNode *dataNode=[rootDict sclNodeForKey:@"data" withManagedObjectContext:[AppDelegate instance].managedObjectContext];
    
    NSArray *sectionsArr=dataDict[@"sections"];
    
    SCLJSONNode *sectionsNode=[dataDict sclNodeForKey:@"sections" withManagedObjectContext:[AppDelegate instance].managedObjectContext];

    for (NSDictionary *sectionDict in sectionsArr) {

        SCLJSONNode *sectionNode=[sectionDict sclNodeForKey:nil withManagedObjectContext:[AppDelegate instance].managedObjectContext];
        
        for (SCLJSONNode *sectionContentNode in sectionNode.object) {
            
            if ([sectionContentNode.key isEqualToString:@"grade_levels"]) {
                
                for (SCLJSONNode *gradeLevelNode in sectionContentNode.object) {
                    
                    DebugLog(@"Grade Level: %@",[gradeLevelNode sclValueForNodeKey:@"title"]);
                    
                    if ([[gradeLevelNode sclValueForNodeKey:@"title"] isEqualToString:@"Exceeds Expectations"]) {
                        
                        SCLJSONNode *titleNode=[gradeLevelNode sclNodeForNodeKey:@"title"];
                        
                        titleNode.value=@"MORE THAN Exceeds Expectations";
                        
                        [[AppDelegate instance] saveContext];
                    }
                }
                
            }
            
        }
        
        
    }
    
    
    // Modified
    DebugLog(@"\n\n\nMODIFIED\n\n\n");
    
    for (NSDictionary *sectionDict in sectionsArr) {
        
        SCLJSONNode *sectionNode=[sectionDict sclNodeForKey:nil withManagedObjectContext:[AppDelegate instance].managedObjectContext];
        
        for (SCLJSONNode *sectionContentNode in sectionNode.object) {
            
            if ([sectionContentNode.key isEqualToString:@"grade_levels"]) {
                
                for (SCLJSONNode *gradeLevelNode in sectionContentNode.object) {
                    
                    DebugLog(@"Grade Level: %@",[gradeLevelNode sclValueForNodeKey:@"title"]);
                    
                    if ([[gradeLevelNode sclValueForNodeKey:@"title"] isEqualToString:@"Exceeds Expectations"]) {
                        
                        SCLJSONNode *titleNode=[gradeLevelNode sclNodeForNodeKey:@"title"];
                        
                        titleNode.value=@"MORE THAN Exceeds Expectations";
                        
                        [[AppDelegate instance] saveContext];
                    }
                }
                
            }
            
        }
        
        
    }
    
}

@end
