//
//  MessageThreadViewController.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 3/01/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import UIKit
import CoreData
import WarmshowersData

class MessageThreadViewController: UIViewController, Delegator, DataSource {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var errorView: UIView!
    
    var threadID: Int?
    var fetchedResultsController: NSFetchedResultsController<MOMessage>?
    var downloadsInProgress = Set<String>()
    var alert: UIAlertController?
    let formatter = DateFormatter()
    
    var needsUpdate: Bool = false
    
    weak var delegate: MessageThreadViewControllerDelegate?
    
    lazy var previewActions: [UIPreviewActionItem] = {
        let title = NSLocalizedString("Reply", tableName: "Read", comment: "3D touch menu item for replying to messages.")
        let replyAction = UIPreviewAction(title: title, style: .default, handler: { (action, viewController) in
            // Get the message threads table view controller to show the reply to message view modally.
            guard let viewController = viewController as? MessageThreadViewController else { return }
            viewController.delegate?.replyToMessageForMessageThreadViewController(viewController)
        })
        return [replyAction]
    }()
    
    override var previewActionItems : [UIPreviewActionItem] {
        return previewActions
    }
    
    // MARK: View life cycle
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view title
        navigationItem.title = ""
        
        // Set up the date formatter.
        let template = "HHmmddMMMyyyy"
        let locale = Locale.current
        formatter.dateFormat = DateFormatter.dateFormat(fromTemplate: template, options: 0, locale: locale)
        
        // Set the refresh controller for the tableview
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(MessageThreadViewController.update), for: UIControlEvents.valueChanged)
        
        // Set the view title
        navigationItem.title = subjectForMessageThreadWithID(threadID ?? 0)
        
        // Set up the fetch results controller
        initialiseFetchResultsController(withStore: store)
        
        // Mark the thread as read.
        if let threadID = threadID {
            markThread(threadID, asRead: true)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: WarmShowersColor.Green, NSFontAttributeName: WarmShowersFont.SueEllenFrancisco(18)]
        
        do {
            try self.fetchedResultsController?.performFetch()
        } catch {
            fatalError("MessageThreadViewController Fetched results controller failed with error: \(error)")
        }
        
        // If the data has been deleted show an error view.
        hide(errorView)
        guard
            let sections = fetchedResultsController?.sections,
            sections.count > 0,
            sections[0].numberOfObjects > 0
        else {
            show(errorView)
            return
        }
        
        // Scroll to the bottom of the thread (i.e. the most recent message)
        let row = tableView.dataSource!.tableView(tableView, numberOfRowsInSection: 0) - 1
        if row >= 0 {
            let indexPath = IndexPath(row: row, section: 0)
            DispatchQueue.main.async { [unowned self] in
                self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: false)
            }
        }
        
        if needsUpdate {
            DispatchQueue.main.async { [unowned self] in
                self.tableView.refreshControl?.beginRefreshing()
            }
            update()
            needsUpdate = false
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        guard
            let sections = fetchedResultsController?.sections,
            sections.count > 0,
            sections[0].numberOfObjects > 0
            else { return }
        
        loadImagesForObjectsOnScreen()
    }
    
    func initialiseFetchResultsController(withStore store: StoreDelegate) {
        let request = MOMessage.fetchRequest() as! NSFetchRequest<MOMessage>
        request.predicate = NSPredicate(format: "thread.p_thread_id==%i", threadID ?? 0)
        request.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: true)]
        self.fetchedResultsController = NSFetchedResultsController(
            fetchRequest: request,
            managedObjectContext: store.managedObjectContext,
            sectionNameKeyPath: nil,
            cacheName: nil)
        fetchedResultsController?.delegate = self
    }
    
    func show(_ errorView: UIView) {
        DispatchQueue.main.async { [unowned self] in
            self.errorView.frame = self.tableView.frame
            self.view.addSubview(errorView)
        }
    }
    
    func hide(_ errorView: UIView) {
        DispatchQueue.main.async {
            errorView.removeFromSuperview()
        }
    }
    

    // MARK: Utilities
    
    /** Returns the subject of a message thread given the thread ID. */
    func subjectForMessageThreadWithID(_ threadID: Int) -> String? {
        let predicate = NSPredicate(format: "p_thread_id == %d", threadID)
        guard let thread: MOMessageThread = try! store.retrieve(inContext: store.managedObjectContext, withPredicate: predicate, andSortBy: nil, isAscending: true).first
            else {
            return nil
        }
        return thread.subject
    }
    
    /** Updates the messages. */
    func update() {
        
        guard let threadID = threadID else {
            DispatchQueue.main.async { [unowned self] in
                self.tableView.refreshControl?.endRefreshing()
            }
            return
        }
        
        api.contact(endPoint: .messageThread, withMethod: .post, andPathParameters: nil, andData: threadID, thenNotify: self, ignoreCache: false)
    }
    
    /** Mark message thread as read. */
    func markThread(_ threadID: Int, asRead read: Bool) {
        let readState = MessageThreadReadState(threadID: threadID, read: true)
        api.contact(endPoint: .markThreadRead, withMethod: .post, andPathParameters: nil, andData: readState, thenNotify: self, ignoreCache: false)
    }
    
    func startImageDownloadForIndexPath(_ indexPath: IndexPath) {
        
        // Check the section and row still exist. 
        // This check is necessary in case the user has deleted the cached data.
        guard
            let sections = fetchedResultsController?.sections,
            indexPath.section < sections.count,
            indexPath.row < sections[indexPath.section].numberOfObjects,
            let message = self.fetchedResultsController?.object(at: indexPath),
            message.author?.image == nil
            else { return }
        
        if let url = message.author?.image_url {
            api.contact(endPoint: .imageResource, withMethod: .get, andPathParameters: url, andData: nil, thenNotify: self, ignoreCache: false)
        } else if let uid = message.author?.uid , !downloadsInProgress.contains(String(uid)) {
            // We first need to get the image URL from the authors profile.
            downloadsInProgress.insert(String(uid))
            api.contact(endPoint: .user, withMethod: .get, andPathParameters: uid, andData: nil, thenNotify: self, ignoreCache: false)
        }
    }
    
    func loadImagesForObjectsOnScreen() {
        guard let visiblePaths = tableView.indexPathsForVisibleRows else { return }
        for indexPath in visiblePaths {
            startImageDownloadForIndexPath(indexPath)
        }
    }
    
    /** Sets the image for a host in the list with the given image URL. */
    func setImage(_ image: UIImage, forHostWithImageURL imageURL: String) {
        
        let predicate = NSPredicate(format: "image_url LIKE %@", imageURL)
        
        guard let participant: MOUser = try! store.retrieve(inContext: store.managedObjectContext, withPredicate: predicate, andSortBy: nil, isAscending: true).first else {
            return
        }
        
        participant.image = image
        try! store.managedObjectContext.save()
        
        // Set the image in any message table view cells where the user in the author.
        DispatchQueue.main.async { [weak self] in
            guard let visiblePaths = self?.tableView.indexPathsForVisibleRows else { return }
            for indexPath in visiblePaths {
                if
                    let cell = self?.tableView.cellForRow(at: indexPath) as? MessageTableViewCell,
                    let message = self?.fetchedResultsController?.object(at: indexPath),
                    let url = message.author?.image_url,
                    url == imageURL
                {
                    cell.authorImageView.image = image
                }
            }
        }
    }
    
    func textForMessageDate(_ date: Date?) -> String? {
        guard let date = date else { return "" }
        return formatter.string(from: date)
    }
    
}
