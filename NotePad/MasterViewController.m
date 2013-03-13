
#import "MasterViewController.h"

#import "DetailViewController.h"
#import "EditingVwCtlr.h"
#import "Note.h"


@interface MasterViewController () {
}
@end


@implementation MasterViewController {
    NSFetchedResultsController* m_oFetchResCtlr ;
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if( nil == self )
        return nil ;
    
    self.title = @"NotePad" ;

    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewNote:)];
    self.navigationItem.rightBarButtonItem = addButton;
    
    
    // 저장된 note들을 읽어오기
    NSFetchRequest* oFetchReq = [ [NSFetchRequest alloc] init ] ;
    NSEntityDescription* oEntity =
        [ NSEntityDescription entityForName:@"Note"
                     inManagedObjectContext:_managedObjectContext ] ;
    [ oFetchReq setEntity:oEntity ] ;
    
    // 순서 정하기
    NSSortDescriptor* oSortDesc =
        [ NSSortDescriptor sortDescriptorWithKey:@"date"
                                       ascending:NO ] ;
    [ oFetchReq setSortDescriptors:@[oSortDesc] ] ;
    
    // 실행
    oFetchReq.FetchBatchSize = 20 ;
    m_oFetchResCtlr = [ [NSFetchedResultsController alloc] initWithFetchRequest:oFetchReq
                                                           managedObjectContext:_managedObjectContext
                                                             sectionNameKeyPath:nil
                                                                      cacheName:@"Root" ] ;
    m_oFetchResCtlr.delegate = self ;
    NSError* oErr = nil ;
    [ m_oFetchResCtlr performFetch:&oErr ] ;
    
    
}


- (void)insertNewNote:(id)sender
{
    EditingVwCtlr* oEditingVwCtlr =
        [ [EditingVwCtlr alloc] initWithNibName:@"EditingVwCtlr"
                                         bundle:nil ] ;
    
    oEditingVwCtlr.managedObjectContext = _managedObjectContext ;
    oEditingVwCtlr->m_oPrevCtlr = self ;
    
    [ super.navigationController presentModalViewController:oEditingVwCtlr
                                                   animated:YES ] ;
}


-(void) didIndertNewNote:(Note *)a_oNewNote
{
}


#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [ m_oFetchResCtlr.sections[section] numberOfObjects ] ;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * const CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }

    // 내용 추가
    FillCell( cell, [ m_oFetchResCtlr objectAtIndexPath:indexPath ] ) ;
    
    return cell;
}


static void FillCell( UITableViewCell* a_oCell, Note* a_oNote )
{
    NSNumber* oNumOfImgs = [ a_oNote valueForKeyPath:@"pictures.@count" ] ;
    a_oCell.textLabel.text = [ NSString stringWithFormat:@"%@(%@)",
                              a_oNote.title, oNumOfImgs ];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    EditingVwCtlr* oEditingVwCtlr =
    [ [EditingVwCtlr alloc] initWithNibName:@"EditingVwCtlr"
                                     bundle:nil ] ;
    
    oEditingVwCtlr.managedObjectContext = _managedObjectContext ;
    oEditingVwCtlr->m_oPrevCtlr = self ;
    oEditingVwCtlr->m_oNote = [ m_oFetchResCtlr objectAtIndexPath:indexPath ]  ;
    
    [self.navigationController pushViewController:oEditingVwCtlr animated:YES];
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        Note* oNoteToDel =  [ m_oFetchResCtlr objectAtIndexPath:indexPath ] ;
        
        // note를 지우고 저장
        [ _managedObjectContext deleteObject:oNoteToDel ] ;
        oNoteToDel = nil ;
        NSError* oErr = nil ;
        [ _managedObjectContext save:&oErr ] ;
        
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - NSFetchedResultsControllerDelegate

-(void) controllerWillChangeContent:(NSFetchedResultsController*)a_oFetchResCtlr
{
    [ super.tableView beginUpdates ] ;
}


-(void) controller:(NSFetchedResultsController*)a_oFetchResCtlr
   didChangeObject:(id)anObject atIndexPath:(NSIndexPath*)a_oIndexPath
     forChangeType:(NSFetchedResultsChangeType)a_type
      newIndexPath:(NSIndexPath*)a_oNewIndexPath
{
    
    UITableView* oTv = super.tableView ;
    
    switch( a_type )
    {
        case NSFetchedResultsChangeInsert:
            [ oTv insertRowsAtIndexPaths:@[a_oNewIndexPath] withRowAnimation:UITableViewRowAnimationFade ] ;
            break;
            
        case NSFetchedResultsChangeDelete:
            [ oTv deleteRowsAtIndexPaths:@[a_oIndexPath] withRowAnimation:UITableViewRowAnimationFade ] ;
            break;
            
        case NSFetchedResultsChangeUpdate:
            FillCell( [oTv cellForRowAtIndexPath:a_oIndexPath],
                      [m_oFetchResCtlr objectAtIndexPath:a_oIndexPath] ) ;
            break;
            
        case NSFetchedResultsChangeMove:
            [ oTv deleteRowsAtIndexPaths:@[a_oIndexPath] withRowAnimation:UITableViewRowAnimationFade ] ;
            [ oTv insertRowsAtIndexPaths:@[a_oNewIndexPath] withRowAnimation:UITableViewRowAnimationFade ] ;
            break;
    }
}


-(void) controller:(NSFetchedResultsController*)a_oFetchResCtlr
  didChangeSection:(id)a_oSectionInfo
           atIndex:(NSUInteger)a_uSectionIndex
     forChangeType:(NSFetchedResultsChangeType)a_type
{
    switch( a_type )
    {
        case NSFetchedResultsChangeInsert:
            [ super.tableView insertSections:[NSIndexSet indexSetWithIndex:a_uSectionIndex]
                            withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [ super.tableView deleteSections:[NSIndexSet indexSetWithIndex:a_uSectionIndex]
                            withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}


-(void) controllerDidChangeContent:(NSFetchedResultsController*)a_oFetchResCtlr
{
    [ super.tableView endUpdates ] ;
}

@end
