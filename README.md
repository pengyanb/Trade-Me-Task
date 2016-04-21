# Trade-Me-Task
#### By Peng Yanbing (Peter)

### Project Structure
![Project Tree] (https://github.com/pengyanb/PhonegapVlcStreamPlayerDemo/blob/master/images/Screen%20Shot%202016-04-22%20at%2008.13.23.png)

### Model 
* TradeMeTaskApiAccessModel - contains APIs for categories browsing, searching, and listing details requests that consumed by viewcontrollers.
* TradeMeOauthHelper - a Helper class that handles all OAuth related tasks

### View
* TmtSubCategoriesTableViewCell - custom UITableView Cell
* TmtListingTableViewCell - custom UITableView Cell

### Controller
* TmtHomeViewController - Home screen viewController
* TmtBrowseCategoriesTableViewController - ViewController displays main categories list
* TmtSubCategoriesTableViewController - ViewController displays sub categories list
* TmtListingsTableViewController - ViewController displays listing items base on certain criteria
* TmtListingDetailsViewController - ViewController displays information regards a single listing

### Custom Class
* ClassExtension
* ConstantsAndEnums
* TmtCategory
* TmtSearchResultRelatedClass
* TmtListingDetailsRelatedClass
