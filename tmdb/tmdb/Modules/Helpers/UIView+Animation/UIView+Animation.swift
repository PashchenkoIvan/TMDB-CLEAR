//
//  UIExtention.swift
//  tmdb
//
//  Created by Пащенко Иван on 06.06.2024.
//

import Foundation
import UIKit

extension UIView {
    static func playCheckmarkAnimation(on view: UIView) {
        // Создание CAShapeLayer для галочки
        let checkmarkLayer = CAShapeLayer()
        checkmarkLayer.strokeColor = UIColor.systemPink.cgColor
        checkmarkLayer.lineWidth = 4
        checkmarkLayer.fillColor = UIColor.clear.cgColor // Изменено на clear для прозрачности
        view.layer.addSublayer(checkmarkLayer)
        
        // Создание пути для галочки
        let checkmarkPath = UIBezierPath()
        let center = view.center
        checkmarkPath.move(to: CGPoint(x: center.x - 50, y: center.y))
        checkmarkPath.addLine(to: CGPoint(x: center.x, y: center.y + 50))
        checkmarkPath.addLine(to: CGPoint(x: center.x + 100, y: center.y - 50))
        checkmarkLayer.path = checkmarkPath.cgPath
        
        // Создание анимации 'strokeEnd' для галочки
        let checkmarkAnimation = CABasicAnimation(keyPath: "strokeEnd")
        checkmarkAnimation.fromValue = 0
        checkmarkAnimation.toValue = 1
        checkmarkAnimation.duration = 0.3
        
        // Установка блока завершения с помощью CATransaction
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            checkmarkLayer.removeFromSuperlayer()
        }
        
        // Добавление анимации к checkmarkLayer
        checkmarkLayer.add(checkmarkAnimation, forKey: "strokeEnd")
        
        CATransaction.commit()
    }
}
