//
//  MainController.swift
//  SwiftWall
//  主页面
//  Created by NashLegend on 15/12/5.
//  Copyright © 2015年 NashLegend. All rights reserved.
//

import UIKit

class MainController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.selectedIndex = 0
        self.tabBar.barTintColor = UIColor.whiteColor()
        
        let articleTab = ArticleSetController()
        articleTab.tabBarItem = UITabBarItem(title: "科学人", image:  R.image.first , tag: 0)
        
        let postTab = PostSetController()
        postTab.tabBarItem = UITabBarItem(title: "小组", image: R.image.second, tag: 1)
        
        let questionTab = QuestionSetController()
        questionTab.tabBarItem = UITabBarItem(title: "问答", image: R.image.first, tag: 2)
        
        let profileTab = UserInfoController()
        profileTab.tabBarItem = UITabBarItem(title: "我", image: R.image.second, tag: 2)
        
        
        self.viewControllers = [
            NavigationController(rootViewController: articleTab),
            NavigationController(rootViewController: postTab),
            NavigationController(rootViewController: questionTab),
            NavigationController(rootViewController: profileTab)
        ]
        
    }
}
