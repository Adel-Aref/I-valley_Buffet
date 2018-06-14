//
//  UIViewControllerExt.swift
//  GoalPost
//
//  Created by Have a Mission on 4/5/18.
//  Copyright © 2018 Have a Mission. All rights reserved.
//

import UIKit
extension UIViewController{
    func presentDtails(viewControllerToPresent:UIViewController)
    {
        let transation = CATransition()
        transation.duration = 0.4
        transation.type = kCATransitionPush
        transation.subtype = kCATransitionFromRight
        self.view.window?.layer.add(transation ,forKey: kCATransition)
        present(viewControllerToPresent, animated: true, completion: nil)
    }
    func presentSeconderyDetail(_ viewControllerToPresent: UIViewController)
    {
        let transation = CATransition()
        transation.duration = 0.4
        transation.type = kCATransitionPush
        transation.subtype = kCATransitionFromRight
        self.view.window?.layer.add(transation ,forKey: kCATransition)
        guard let presentedViewController = presentedViewController else {return}
        presentedViewController.dismiss(animated: false){
            self.view.window?.layer.add(transation, forKey: kCATransition)
            self.present(viewControllerToPresent, animated: false, completion: nil	)
        }
    }
    // dissmis detail
    func  dissmisDetail()
    {
        let transation = CATransition()
        transation.duration = 0.4
        transation.type = kCATransitionPush
        transation.subtype = kCATransitionFromLeft
        self.view.window?.layer.add(transation ,forKey: kCATransition)
        self.view.window?.layer.add(transation, forKey: kCATransition)
        dismiss(animated: true, completion: nil)
    }
    
    
}
