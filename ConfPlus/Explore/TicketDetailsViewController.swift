//
//  TicketDetailsViewController.swift
//  confDemo
//
//  Created by Matthew Boroczky on 15/03/2016.
//  Copyright © 2016 CY Lim. All rights reserved.
//

import Foundation
import UIKit

class TicketDetailsViewController: UIViewController {
    
	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var totalPrice: UIBarButtonItem!
	
	let user = NSUserDefaults.standardUserDefaults()
	
	
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		navigationController?.hidesBarsOnSwipe = true
    }
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(true)
		
		guard let _ = user.stringForKey("email") else {
			performLogin()
			return
		}
	}
	
	func performLogin(){
		let storyboard : UIStoryboard = UIStoryboard(name: "Account", bundle: nil)
		let vc : LoginViewController = storyboard.instantiateViewControllerWithIdentifier("LoginViewController") as! LoginViewController
		
		let navigationController = UINavigationController(rootViewController: vc)
		
		self.presentViewController(navigationController, animated: true, completion: nil)
	}
	
	//MARK - IBActions
	@IBAction func cancelPurchaseTicket(sender: AnyObject) {
		self.dismissViewControllerAnimated(true, completion: nil)
	}
}

extension TicketDetailsViewController: UITableViewDelegate{
	func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 2
	}
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 1
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		
		let cell = tableView.dequeueReusableCellWithIdentifier("ticketCell", forIndexPath: indexPath) as! TicketTableViewCell
		
		cell.ticketCount.text = "0"
		cell.ticketName.text = "Ticket Name"
		cell.ticketPrice.text = "AUD 1.00"
		
		return cell
	}
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if segue.identifier == "goToUserInfoView"{
			var totalTicket = 0
			let totalTicketType = tableView.numberOfRowsInSection(0)
			for row in 0..<totalTicketType{
				let cell:TicketTableViewCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: row, inSection: 0)) as! TicketTableViewCell
				totalTicket += Int(cell.ticketCount.text!)!
			}
			
			let vc = segue.destinationViewController as! PersonalDetailsViewController
			vc.TOTAL_TICKET_QUANTITY = totalTicket
		}
	}
}