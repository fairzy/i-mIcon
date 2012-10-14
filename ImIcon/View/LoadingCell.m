//
//  LoadingCell.m
//  ImIcon
//
//  Created by fairzy fan on 12-6-21.
//  Copyright (c) 2012年 PConline. All rights reserved.
//

#import "LoadingCell.h"

@implementation LoadingCell

@synthesize loadingText, loadingIndicator;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:243.0f/255.0f green:239.0f/255.0f blue:234.0f/255.0f alpha:1.0f];
        // 
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(60, 10, 200, 30)];
        label.backgroundColor = [UIColor colorWithRed:243.0f/255.0f green:239.0f/255.0f blue:234.0f/255.0f alpha:1.0f];
        label.text = @"更多...";
        label.textColor = [UIColor grayColor];
        label.textAlignment = UITextAlignmentCenter;
        [self.contentView addSubview:label];
        self.loadingText = label;
        [label release];
        
        // Initialization code
        UIActivityIndicatorView * activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        CGSize actsize = activity.frame.size;
        [activity setFrame:CGRectMake(260, 15, actsize.width, actsize.height)];
        [self.contentView addSubview:activity];
        activity.hidden = YES;
        activity.hidesWhenStopped = YES;
        self.loadingIndicator = activity;
        [activity release];
    }
    return self;
}

- (void)setLoading:(BOOL)isload{
    NSLog(@"isload:%d", isload);
    if ( isload ) {
        self.loadingText.text = @"正在加载...";
        self.loadingIndicator.hidden = NO;
        [self.loadingIndicator startAnimating];
    }else{
        self.loadingText.text = @"更多...";
        self.loadingIndicator.hidden = YES;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc{
    [loadingText release];
    [loadingIndicator release];
    
    [super dealloc];
}

@end
