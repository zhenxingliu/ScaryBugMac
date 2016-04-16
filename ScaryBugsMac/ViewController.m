//
//  ViewController.m
//  ScaryBugsMac
//
//  Created by 刘振兴 on 16/4/15.
//  Copyright © 2016年 zoneland. All rights reserved.
//

#import "ViewController.h"
#import "ScaryBugDoc.h"
#import "ScaryBugData.h"
#import "EDStarRating.h"
#import <Quartz/Quartz.h>
#import "NSImage+Extras.h"

@interface ViewController() <NSTableViewDataSource,NSTableViewDelegate,EDStarRatingProtocol>

@property(nonatomic, strong) NSMutableArray *bugs;
@property (weak) IBOutlet NSTableView *tableView;
@property (weak) IBOutlet NSTextField *bugTitleView;
@property (weak) IBOutlet EDStarRating *bugRating;
@property (weak) IBOutlet NSImageView *butImageView;
@property (weak) IBOutlet NSButton *deleteButton;
@property (weak) IBOutlet NSButton *changePictureButton;

@end


@implementation ViewController

-(NSMutableArray *)bugs{
    if (_bugs==nil) {
        ScaryBugDoc *bug1 = [[ScaryBugDoc alloc] initWithTitle:@"Potato Bug" rating:4 thumbImage:[NSImage imageNamed:@"potatoBugThumb.jpg"] fullImage:[NSImage imageNamed:@"potatoBug.jpg"]];
        ScaryBugDoc *bug2 = [[ScaryBugDoc alloc] initWithTitle:@"House Centipede" rating:3 thumbImage:[NSImage imageNamed:@"centipedeThumb.jpg"] fullImage:[NSImage imageNamed:@"centipede.jpg"]];
        ScaryBugDoc *bug3 = [[ScaryBugDoc alloc] initWithTitle:@"Wolf Spider" rating:5 thumbImage:[NSImage imageNamed:@"wolfSpiderThumb.jpg"] fullImage:[NSImage imageNamed:@"wolfSpider.jpg"]];
        ScaryBugDoc *bug4 = [[ScaryBugDoc alloc] initWithTitle:@"Lady Bug" rating:1 thumbImage:[NSImage imageNamed:@"ladybugThumb.jpg"] fullImage:[NSImage imageNamed:@"ladybug.jpg"]];
        _bugs = [NSMutableArray arrayWithObjects:bug1, bug2, bug3, bug4, nil];
    }
    return _bugs;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;

    // Do any additional setup after loading the view.
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    
    // Get a new ViewCell
    NSTableCellView *cellView = [tableView makeViewWithIdentifier:tableColumn.identifier owner:self];
    
    // Since this is a single-column table view, this would not be necessary.
    // But it's a good practice to do it in order by remember it when a table is multicolumn.
    if( [tableColumn.identifier isEqualToString:@"BugColumn"] )
    {
        ScaryBugDoc *bugDoc = [self.bugs objectAtIndex:row];
        cellView.imageView.image = bugDoc.thumbImage;
        cellView.textField.stringValue = bugDoc.data.title;
        return cellView;
    }
    return cellView;
}

//select a row event

-(void)tableViewSelectionDidChange:(NSNotification *)notification{
    ScaryBugDoc *bugDoc = [self selectedBugDoc];
    
    BOOL buttonsEnabled = (bugDoc!=nil);
    [self.deleteButton setEnabled:buttonsEnabled];
    [self.changePictureButton setEnabled:buttonsEnabled];
    [self.bugRating setEditable:buttonsEnabled];
    [self.bugTitleView setEnabled:buttonsEnabled];
    
    [self setDetailBug:bugDoc];
}

-(void)loadView{
    [super loadView];
    self.bugRating.starImage = [NSImage imageNamed:@"star.png"];
    self.bugRating.starHighlightedImage = [NSImage imageNamed:@"shockedface2_full.png"];
    self.bugRating.starImage = [NSImage imageNamed:@"shockedface2_empty.png"];
    self.bugRating.maxRating = 5.0;
    self.bugRating.delegate = (id<EDStarRatingProtocol>) self;
    self.bugRating.horizontalMargin = 12;
    self.bugRating.editable=NO;
    self.bugRating.displayMode=EDStarRatingDisplayFull;
    
    
    self.bugRating.rating= 0.0;
}

-(ScaryBugDoc *)selectedBugDoc{
    NSInteger selectedRow = [self.tableView selectedRow];
    if (selectedRow >=0 && self.bugs.count >selectedRow) {
        ScaryBugDoc *bugDoc = [self.bugs objectAtIndex:selectedRow];
        return bugDoc;
    }
    return nil;
}

-(void)setDetailBug:(ScaryBugDoc *)bugDoc{
    NSString *title = @"";
    NSImage *image = nil;
    float rating = 0.0;
    if (bugDoc!=nil) {
        title = bugDoc.data.title;
        image = bugDoc.fullImage;
        rating = bugDoc.data.rating;
    }
    [self.bugTitleView setStringValue:title];
    [self.butImageView  setImage:image];
    [self.bugRating setRating:rating];
}


- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return [self.bugs count];
}


- (IBAction)addBugDoc:(id)sender {
    
    ScaryBugDoc *newBug = [[ScaryBugDoc alloc] initWithTitle:@"newBug" rating:0.0 thumbImage:nil fullImage:nil];
    
    //insert bugs
    [self.bugs addObject:newBug];
    NSInteger newRowIndex = self.bugs.count - 1;
    
    //insert row in tableview
    [self.tableView insertRowsAtIndexes:[NSIndexSet indexSetWithIndex:newRowIndex] withAnimation:NSTableViewAnimationEffectGap];
    
    //selected new Row
    [self.tableView selectRowIndexes:[NSIndexSet indexSetWithIndex:newRowIndex] byExtendingSelection:NO];
    [self.tableView scrollRowToVisible:newRowIndex];
    
}
- (IBAction)deleteBugDoc:(id)sender {
    ScaryBugDoc *selectedBug = [self selectedBugDoc];
    if (selectedBug!=nil) {
        [self.bugs removeObject:selectedBug];
        [self.tableView removeRowsAtIndexes:[NSIndexSet indexSetWithIndex:self.tableView.selectedRow] withAnimation:NSTableViewAnimationSlideRight];
        [self setDetailBug:nil];
    }
}

- (IBAction)bugTitleDidEndEdit:(id)sender {
    
    ScaryBugDoc *bugDoc = [self selectedBugDoc];
    if (bugDoc!=nil) {
        bugDoc.data.title = [self.bugTitleView stringValue];
        NSIndexSet * indexSet = [NSIndexSet indexSetWithIndex:[self.bugs indexOfObject:bugDoc]];
        NSIndexSet * columnSet = [NSIndexSet indexSetWithIndex:0];
        [self.tableView reloadDataForRowIndexes:indexSet columnIndexes:columnSet];

    }
}

-(void)starsSelectionChanged:(EDStarRating *)control rating:(float)rating{
    ScaryBugDoc *bugDoc = [self selectedBugDoc];
    if (bugDoc!=nil) {
        bugDoc.data.rating = self.bugRating.rating;
    }
}
- (IBAction)changePicture:(id)sender {
    ScaryBugDoc *selectedDoc = [self selectedBugDoc];
    if( selectedDoc )
    {
        [[IKPictureTaker pictureTaker] beginPictureTakerSheetForWindow:self.view.window withDelegate:self didEndSelector:@selector(pictureTakerDidEnd:returnCode:contextInfo:) contextInfo:nil];
    }
}

- (void) pictureTakerDidEnd:(IKPictureTaker *) picker
                 returnCode:(NSInteger) code
                contextInfo:(void*) contextInfo
{
    NSImage *image = [picker outputImage];
    if( image !=nil && (code == NSModalResponseOK) )
    {
        [self.butImageView setImage:image];
        ScaryBugDoc * selectedBugDoc = [self selectedBugDoc];
        if( selectedBugDoc )
        {
            selectedBugDoc.fullImage = image;
            selectedBugDoc.thumbImage = [image imageByScalingAndCroppingForSize:CGSizeMake( 44, 44 )];
            NSIndexSet * indexSet = [NSIndexSet indexSetWithIndex:[self.bugs indexOfObject:selectedBugDoc]];
            
            NSIndexSet * columnSet = [NSIndexSet indexSetWithIndex:0];
            [self.tableView reloadDataForRowIndexes:indexSet columnIndexes:columnSet];
        }
    }
}


- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

@end
