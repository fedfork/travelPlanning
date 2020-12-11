//
//  PlaceCellManager.swift
//  travelApp
//
//  Created by Fedor Korshikov on 25.10.2020.
//  Copyright © 2020 Fedor Korshikov. All rights reserved.
//

import Foundation
import CoreGraphics
import UIKit

enum PlaceVCCellTypes{
    case details, note, map, control
}

class PlaceVCCellFactory {
//    var collectionView: UICollectionView
//    init (collectionView: UICollectionView) {
//        self.collectionView = collectionView
//    }
    class Cell {
        var name: String
        var type: PlaceVCCellTypes
        var mult: CGFloat
        var height: CGFloat
        internal init(name: String, type: PlaceVCCellTypes, mult: CGFloat, height: CGFloat) {
            self.name = name
            self.type = type
            self.mult = mult
            self.height = height
        }
    }
    class ControlCell: Cell {
        internal init(name: String, type: PlaceVCCellTypes, image: UIImage?, color: UIColor, mult: CGFloat, height: CGFloat) {
            self.color = color
            self.image = image
            super.init(name: name, type: type, mult: mult, height: height)
        }
        var image: UIImage?
        var color: UIColor
    }
    class DetailsCell: Cell {
        internal init(name: String, type: PlaceVCCellTypes, mult: CGFloat, height: CGFloat, descript: String?, imageEmpty: UIImage?, imageFilled: UIImage?) {
            super.init(name: name, type: type, mult: mult, height: height)
            self.descript = descript
            self.imageEmpty = imageEmpty
            self.imageFilled = imageFilled
            if descript != nil {
                self.image = imageFilled
            } else {
                self.image = imageEmpty
            }
        }
        var descript: String?
        var image: UIImage?
        var imageEmpty: UIImage?
        var imageFilled: UIImage?

    }
    class NoteCell: Cell {
        internal init(name: String, type: PlaceVCCellTypes, mult: CGFloat, height: CGFloat, text: String?) {
            super.init(name: name, type: type, mult: mult, height: height)
            self.text = text
        }
        
        var text: String?
    }
    
    class MapCell: Cell {
        internal init(name: String, annotation: PlaceMapAnnotation, type: PlaceVCCellTypes, mult: CGFloat, height: CGFloat, image: UIImage?) {
            self.annotation = annotation
            super.init(name: name, type: type, mult: mult, height: height)
            self.image = image
        }
        var image: UIImage?
        var annotation: PlaceMapAnnotation
    }
    
    var cells = [Cell]()
    
    var count: Int { return cells.count }
    
    func addDetailsCell (name: String, descript: String?, imageEmpty: UIImage?, imageFilled: UIImage?, mult: CGFloat, height: CGFloat){
        let detailsCell = DetailsCell (name: name, type: .details, mult: mult, height: height, descript: descript, imageEmpty: imageEmpty, imageFilled: imageFilled)
        cells.append(detailsCell)
    }
    
    func addControlCell (name: String, image: UIImage?, color: UIColor, mult: CGFloat, height: CGFloat){
        let controlCell = ControlCell(name: name, type: .control, image: image, color: color, mult: mult, height: height)
        cells.append(controlCell)
    }
    
    func addNoteCell (name: String, text: String?, mult: CGFloat, height: CGFloat){
        let noteCell = NoteCell (name: name, type: .note, mult: mult, height: height, text: text)
        cells.append(noteCell)
    }
    
    func addMapCell (name: String, annotation: PlaceMapAnnotation, mult: CGFloat, height: CGFloat, image: UIImage?){
        let mapCell = MapCell(name: name, annotation: annotation, type: .map, mult: mult, height: height, image: image)
        cells.append(mapCell)
    }
    
    
    func updateDetailsCell (withIndex index: Int, descript:String, imageTypeIsFilled: Bool) {
        if index>=cells.count {print ("index out of range"); return}
        if let detailsCell = cells[index] as? DetailsCell{
            
            detailsCell.descript = descript
            if imageTypeIsFilled {
                
                detailsCell.image = detailsCell.imageFilled
            } else {
                
                detailsCell.image = detailsCell.imageEmpty
            }
        }
        
    }
    
    func updateNoteCell (withIndex: Int, text:String){
        if withIndex >= cells.count { print("index out of range"); return}
        if let noteCell = cells[withIndex] as? NoteCell{
            noteCell.text = text
        }
    }
    
    func getCellType (withIndex: Int) -> PlaceVCCellTypes?{
        if withIndex>=cells.count {print ("index out of range"); return nil}
        return cells[withIndex].type
    }
    
    func getCellMultiplier (withIndex: Int) -> CGFloat?{
        if withIndex>=cells.count {print ("index out of range"); return nil}
        return cells[withIndex].mult
    }
    
    func getUICell (withIndex: Int, collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        if withIndex>=cells.count {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "placeCollectionViewCell", for: indexPath)
            return cell
        }
        let cellModel = cells[withIndex]
        
        switch cellModel.type {
        case .details:
            let detailsCellModel = cellModel as! DetailsCell
            let detailsCell = collectionView.dequeueReusableCell(withReuseIdentifier: "placeDetailsCollectionViewCell", for: indexPath) as! placeDetailsCollectionViewCell
            detailsCell.setupLabels(name: detailsCellModel.name, descript: detailsCellModel.descript ?? "", image: detailsCellModel.image)
            detailsCell.setupDesign()
            return detailsCell
        case .note:
            let noteCellModel = cellModel as! NoteCell
            let noteCell = collectionView.dequeueReusableCell(withReuseIdentifier: "placeNoteCollectionViewCell", for: indexPath) as! placeNoteCollectionViewCell
            noteCell.setupLabels(name: noteCellModel.name, text: noteCellModel.text)
            noteCell.setupDesign()
            return noteCell
        case .map:
            let mapCellModel = cellModel as! MapCell
            let mapCell = collectionView.dequeueReusableCell(withReuseIdentifier: "PlaceMapCollectionViewCell", for: indexPath) as! PlaceMapCollectionViewCell
            mapCell.setupLabels(name: mapCellModel.name, image: mapCellModel.image)
            mapCell.configureMap(annotation: mapCellModel.annotation)
            mapCell.setupDesign()
            return mapCell
        case .control:
            let controlCellModel = cellModel as! ControlCell
            let controlCell = collectionView.dequeueReusableCell(withReuseIdentifier: "PlaceControlCollectionViewCell", for: indexPath) as! PlaceControlCollectionViewCell
            controlCell.setupLabels(name: controlCellModel.name, image: controlCellModel.image, color: controlCellModel.color)
            controlCell.setupDesign()
            return controlCell
    }
    
}
    func getCellName(withIndex: Int) -> String{
        return cells[withIndex].name
    }
    
    func getCellHeight (withIndex: Int) -> CGFloat?{
        if withIndex>=cells.count {print ("index out of range"); return nil}
        return cells[withIndex].height
    }
    
}

