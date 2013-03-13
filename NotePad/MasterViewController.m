
#import "MasterViewController.h"

#import "DetailViewController.h"
#import "EditingVwCtlr.h"
#import "Note.h"


@interface MasterViewController () {
    NSMutableArray *_objects;
}
@end


@implementation MasterViewController {
    NSMutableArray* m_oNotes ;
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
    NSError* oErr = nil ;
    NSArray* oNotes =
        [ _managedObjectContext executeFetchRequest:oFetchReq
                                              error:&oErr ] ;
    
    m_oNotes = [ NSMutableArray arrayWithArray:oNotes ] ;
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
    [ m_oNotes insertObject:a_oNewNote atIndex:0];
    NSIndexPath* oIndexPath = [ NSIndexPath indexPathForRow:0
                                                  inSection:0];
    [ super.tableView insertRowsAtIndexPaths:@[oIndexPath]
                            withRowAnimation:UITableViewRowAnimationAutomatic];
}


#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return m_oNotes.count ;
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
    Note* oNote = m_oNotes[ indexPath.row ] ;
    NSNumber* oNumOfImgs = [ oNote valueForKeyPath:@"pictures.@count" ] ;
    cell.textLabel.text = [ NSString stringWithFormat:@"%@(%@)",
                                            oNote.title, oNumOfImgs ];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    EditingVwCtlr* oEditingVwCtlr =
    [ [EditingVwCtlr alloc] initWithNibName:@"EditingVwCtlr"
                                     bundle:nil ] ;
    
    oEditingVwCtlr.managedObjectContext = _managedObjectContext ;
    oEditingVwCtlr->m_oPrevCtlr = self ;
    oEditingVwCtlr->m_oNote = m_oNotes[ indexPath.row ] ;
    
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
        [_objects removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
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

@end
