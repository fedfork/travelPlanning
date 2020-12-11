//
//  PieChartViewController.swift
//  travelApp
//
//  Created by Fedor Korshikov on 04.12.2020.
//  Copyright © 2020 Fedor Korshikov. All rights reserved.
//

import UIKit
import PieCharts
import ChartLegends


class PieChartViewController: UIViewController, PieChartDelegate {
    func onSelected(slice: PieSlice, selected: Bool) {
    }
    

    @IBOutlet var legendsView: ChartLegendsView!
    
    @IBOutlet var navItem: UINavigationItem!
    
    @IBOutlet var chartView: PieChart!
    
    @IBOutlet var totalLabel: UILabel!
    
    
    var trip: Trip?
    var pieDataDict = [String : Double] ()
    var legends = [(text:String, color: UIColor)] ()
    var totalPrice = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        generateElementsData()
        generateLegends()
        legendsView.setLegends(.circle(radius: 7), legends)
        
        
        totalLabel.text = "Всего потрачено: \(totalPrice)"
        // Do any additional setup after loading the view.
    }
    
    func generateElementsData (){
        guard let trip = trip else {return}
        let purchases = trip.triptopurchase?.allObjects as! [Purchase]
        for purchase in purchases {
            if purchase.isBought == false {continue}
            guard let category = Category.getCategoryNameById(id: purchase.categoryId!) else { continue }
            if pieDataDict[category] != nil {
                pieDataDict[category] =  pieDataDict[category]! + purchase.price
            } else {
                pieDataDict[category] = purchase.price
            }
        }
    }
    
    
    func generateLegends () {
        var i=0
        totalPrice = 0.0
        for (name,price) in pieDataDict {
            legends.append ( (text: "\(name): \(price)", color: colors[i % colors.count] ) )
            i+=1
            totalPrice += price
        }
        
    }
    
    
    fileprivate static let alpha: CGFloat = 0.5
    let colors = [
        UIColor.yellow.withAlphaComponent(alpha),
        UIColor.green.withAlphaComponent(alpha),
        UIColor.purple.withAlphaComponent(alpha),
        UIColor.cyan.withAlphaComponent(alpha),
        UIColor.darkGray.withAlphaComponent(alpha),
        UIColor.red.withAlphaComponent(alpha),
        UIColor.magenta.withAlphaComponent(alpha),
        UIColor.orange.withAlphaComponent(alpha),
        UIColor.brown.withAlphaComponent(alpha),
        UIColor.lightGray.withAlphaComponent(alpha),
        UIColor.gray.withAlphaComponent(alpha),
    ]
    fileprivate var currentColorIndex = 0

    
    override func viewDidAppear(_ animated: Bool) {

        chartView.layers = [ createTextWithLinesLayer()]
        chartView.delegate = self
        chartView.models = createModels() // order is important - models have to be set at the end
    }
    
//    // MARK: - PieChartDelegate
//
//    func onSelected(slice: PieSlice, selected: Bool) {
//        print("Selected: \(selected), slice: \(slice)")
//    }
    
    // MARK: - Models
    
    fileprivate func createModels() -> [PieSliceModel] {

        var models = [PieSliceModel]()
//            PieSliceModel(value: 2, color: colors[0]),
//            PieSliceModel(value: 2, color: colors[1]),
//            PieSliceModel(value: 2, color: colors[2])
//        ]
        var i = 0
        for (categoryName, price) in pieDataDict {
            models.append(PieSliceModel(value: price, color: colors [i % colors.count], obj: categoryName))
            i+=1
        }
        
        currentColorIndex = models.count
        return models
    }
    

    
    // MARK: - Layers
    
    fileprivate func createPlainTextLayer() -> PiePlainTextLayer {
        
        let textLayerSettings = PiePlainTextLayerSettings()
        textLayerSettings.viewRadius = 55
        textLayerSettings.hideOnOverflow = true
        textLayerSettings.label.font = UIFont.systemFont(ofSize: 8)
        
        textLayerSettings.label.textGenerator = {slice in
            return "\(slice.data.model.value)"
        }
        
        let textLayer = PiePlainTextLayer()
        textLayer.settings = textLayerSettings
        return textLayer
    }
    
    fileprivate func createTextWithLinesLayer() -> PieLineTextLayer {
        let lineTextLayer = PieLineTextLayer()
        var lineTextLayerSettings = PieLineTextLayerSettings()
        lineTextLayerSettings.lineColor = UIColor.lightGray
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 1
        lineTextLayerSettings.label.font = UIFont.systemFont(ofSize: 14)
        lineTextLayerSettings.label.textGenerator = {slice in
//            let nam = slice.data.model.obj as? String
//            guard let name = nam else {return ""}
//            return name
            return "\(slice.data.model.value)"
        }
        
        lineTextLayer.settings = lineTextLayerSettings
        return lineTextLayer
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
