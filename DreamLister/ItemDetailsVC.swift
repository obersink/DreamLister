//
//  ItemDetailsVC.swift
//  DreamLister
//
//  Created by Simon Zhen on 5/5/17.
//  Copyright © 2017 Simon Zhen. All rights reserved.
//

import UIKit
import CoreData

class ItemDetailsVC: UIViewController {

    @IBOutlet weak var storePicker: UIPickerView!
    @IBOutlet weak var titleField: CustomTextField!
    @IBOutlet weak var priceField: CustomTextField!
    @IBOutlet weak var detailsField: CustomTextField!
    @IBOutlet weak var typePicker: UIPickerView!
    
    var stores = [Store]()
    var categories = [String]()
    
    var itemToEdit: Item?
    var imagePicker: UIImagePickerController!
    
    @IBOutlet weak var thumbImg: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let topItem = self.navigationController?.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        }
        
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self

        //pickers need to be set before loadItemData is called
        getStores()
        categories = ["Electronics", "Vehicles", "Consumables", "Apparel"]

        if itemToEdit != nil {
            loadItemData()
        }
        
        
    }
    
    @IBAction func savePressed(_ sender: Any) {
        var item: Item!
        
        if itemToEdit != nil {
            item = itemToEdit!
        }
        else {
            item = Item(context: context)
        }
        
        if let title = titleField.text {
            item.title = title
        }
        
        if let price = priceField.text {
            item.price = (price as NSString).doubleValue
        }
        
        if let details = detailsField.text {
            item.details = details
        }
        
        let picture = Image(context: context)
        picture.image = thumbImg.image
        
        
        let itemType = ItemType(context: context)
        itemType.type = categories[typePicker.selectedRow(inComponent: 0)]
        
        
        item.toImage = picture
        item.toStore = stores[storePicker.selectedRow(inComponent: 0)]
        item.toItemType = itemType
        
        ad.saveContext()
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func deletePressed(_ sender: Any) {
        if itemToEdit != nil {
            context.delete(itemToEdit!)
            ad.saveContext()
        }
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func addImage(_ sender: UIButton) {
        present(imagePicker, animated: true, completion: nil)
    }
    
    //sets the detail view = to item selected
    func loadItemData() {
        if let item = itemToEdit {
            titleField.text = item.title
            priceField.text = "\(item.price)"
            detailsField.text = item.details
            thumbImg.image = item.toImage?.image as? UIImage
            
            //store = store item was from
            if let store = item.toStore {
                var index = 0
                repeat {
                    let s = stores[index]
                    //set picker to index of 'store'
                    if s.name == store.name {
                        storePicker.selectRow(index, inComponent: 0, animated: false)
                        break
                    }
                    index += 1
                } while (index < stores.count)
            }
            
            //category
            if let type = item.toItemType {
                var index = 0
                repeat {
                    let s = categories[index]
                    if s == type.type {
                        typePicker.selectRow(index, inComponent: 0, animated: false)
                        break
                    }
                    index += 1
                } while (index < categories.count)
            }

        }
    }
    
    //set stores from coredata to stores array
    func getStores() {
        let fetchRequest: NSFetchRequest<Store> = Store.fetchRequest()
        do {
            self.stores = try context.fetch(fetchRequest)
            self.storePicker.reloadAllComponents()
        } catch {
            
        }
    }
}

//Image Picker
extension ItemDetailsVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let img = info[UIImagePickerControllerOriginalImage] as? UIImage {
            thumbImg.image = img
            imagePicker.dismiss(animated: true, completion: nil)
        }
    }
}

//Picker(s)
extension ItemDetailsVC: UIPickerViewDelegate, UIPickerViewDataSource {
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 1 {
            return stores.count
        }
        else {
            return categories.count
        }
    }
    
    //populate picker(s)
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 1 {
            let store = stores[row]
            return store.name
        }
        else {
            let type = categories[row]
            return type
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
}
