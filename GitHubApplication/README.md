
# Implementation:
1st Screen -> ViewController 
    UserDisplayCell -> tableviewCell of Displaying GitHub Users
2nd Screen -> ShowDetailsVC
     RepoDisplayCell -> tableviewCell of Displying repository list.


#   Requirements



1. Search-as-you-type

* UISearchBarDelegate method
* update to your Controller.

Problem:
* rate limit: 10 searches / minute
* long names instantly timeout
* detect if the user is still typing:
    1. if they are typing: don't search yet
    2. if they stop typing: search
    * compromise to meet requirements for as-you-type and not hit rate limit.
    
    * DispatchWorkItem
    * create a work item to be performed when the user stops typing (after a timed-delay)
    * if the user keeps typing, cancel the previous-existing workItem.
    
    DONE.


2. User Repo Count

second screen is hitting "url" point
Should move this call to the first screen, and only do once-per-user
    * repo count is on this "url"
    



