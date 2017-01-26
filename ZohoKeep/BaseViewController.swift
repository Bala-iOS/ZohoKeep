//
//  BaseViewController.swift
//  ZohoKeep
//
//  Created by Bala on 1/25/17.
//  Copyright © 2017 Bala. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    func alert(_ title: String?, message: String!, okTitle: String! = "OK", okCallBack: (() -> Void)? = nil, cancelTitle:String? = nil,cancelCallBack: (()-> Void)? = nil)
    {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert);
        
        alertController.addAction(UIAlertAction(title: okTitle, style: UIAlertActionStyle.default, handler: { (action: UIAlertAction) -> Void in
            okCallBack?();
        }));
        if (cancelTitle != nil)
        {
            alertController.addAction(UIAlertAction(title: cancelTitle, style: UIAlertActionStyle.cancel, handler: { (action: UIAlertAction) -> Void in
                cancelCallBack?();
            }));
        }
        self.present(alertController, animated: true, completion: nil);
    }
    
    func formatteDate(date:Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, EEE, yyyy hh:mm aa"
        return dateFormatter.string(from: date)
    }
}
