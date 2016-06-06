//
//  TimeTableViewController.swift
//  confDemo
//
//  Created by CY Lim on 15/03/2016.
//  Copyright © 2016 CY Lim. All rights reserved.
//

import Foundation
import UIKit
import PKHUD

class SessionTicketsViewController: UIViewController {
	
	@IBOutlet weak var tableView: UITableView!
	
	var sessionTickets = Dictionary<String, [Tickets]>()
	var ticket:Coupon!
	var event:Event!
	var col:Int!
	//var titles = [String]()
	
	var dataSortedByDates = Dictionary<String, [Tickets]>()
	var dates = [String]()
	
	var selectedSessions = Dictionary<String, [Tickets]>()
	
	var delegate:selectSessionTicketDelegate?
	
	override func viewDidLoad() {
		super.viewDidLoad()
	}
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		
		setDataForPresent()
	}
	
	@IBAction func performCancel(sender: AnyObject) {
		self.dismissViewControllerAnimated(true, completion: nil)
	}
	
	@IBAction func updateSessionTickets(sender: AnyObject) {
		if shouldPerformSegueWithIdentifier("goToSessionTicketSelection", sender: nil){
			performSegueWithIdentifier("goToSessionTicketSelection", sender: nil)
		}
	}
	
	func setDataForPresent(){
		dates.removeAll()
		dataSortedByDates.removeAll()
		
		HUD.show(.Progress)
		for session in sessionTickets  {
			print("TEST \(session.0)")
			if session.1.count > 0 {
				let ticket = session.1[0]
				
				let date = GeneralLibrary().getStringFromDate(ticket.startTime!)
				
				if self.dataSortedByDates.indexForKey(date) == nil {
					self.dataSortedByDates[date] = [ticket]
				} else {
					self.dataSortedByDates[date]?.append(ticket)
				}
				self.dataSortedByDates[date]?.sortInPlace({ $0.startTime!.compare($1.startTime!) == NSComparisonResult.OrderedAscending })
			}
		}
		dates = Array(dataSortedByDates.keys).sort(<)
		
		dates = dates.filter{ $0 >= GeneralLibrary().getStringFromDate(ticket.ticket[0].startTime!) && $0 <= GeneralLibrary().getStringFromDate(ticket.ticket[0].endTime!) }
		
		tableView.reloadData()
		HUD.hide()
	}
	
	override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
		if identifier == "goToSessionTicketSelection" {
			selectedSessions.removeAll()
			for section in 0..<tableView.numberOfSections{
				for row in 0..<tableView.numberOfRowsInSection(section){
					let cell:SessionTicketsTableViewCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: row, inSection: section)) as! SessionTicketsTableViewCell
					
					if cell.backgroundColor == UIColor.init(red: 0, green: 0.8, blue: 0, alpha: 0.2) {
						let itemSection = dataSortedByDates[dates[section]]
						let item = itemSection![row]
						
						
						selectedSessions[item.title!] = sessionTickets[item.title!]
						
					}
				}
			}
			return true
		}
		return false
	}
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if segue.identifier == "goToSessionDetail"{
			let vc = segue.destinationViewController as! SessionDetailViewController
			vc.event = event
			
			let row = sender!.row
			let sec = sender!.section
			
			let itemSection = dataSortedByDates[dates[sec]]
			let item = itemSection![row]
			vc.ticket = item
		} else if segue.identifier == "goToSessionTicketSelection" {
			let vc = segue.destinationViewController as! AddSessionTicketViewController
			vc.col = col
			vc.delegate = delegate
			vc.ticket = ticket
			vc.selectedSessions = selectedSessions
		}
	}
}

//MARK:- TableView Related
extension SessionTicketsViewController: UITableViewDelegate{
	func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return dates.count
	}
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return dataSortedByDates[dates[section]]!.count
	}
	
	func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		return dates[section]
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		
		let cell = tableView.dequeueReusableCellWithIdentifier("sessionTicketCell", forIndexPath: indexPath) as! SessionTicketsTableViewCell
		let row = indexPath.row
		let sec = indexPath.section
		
		let itemSection = dataSortedByDates[dates[sec]]
		let item = itemSection![row]
		cell.backgroundColor = UIColor.clearColor()
		
		cell.presentationName.text = item.title
		cell.presentationTime.text = "\(GeneralLibrary().getTimeFromDate(item.startTime!)) - \(GeneralLibrary().getTimeFromDate(item.endTime!))"
		cell.presentationLocation.text = item.room ?? ""
		
		return cell
	}
	
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		self.performSegueWithIdentifier("goToSessionDetail", sender: indexPath)
	}
}