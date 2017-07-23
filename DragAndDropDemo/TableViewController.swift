//
//  TableViewController.swift
//  DragAndDropDemo
//
//  Created by gentle on 2017/07/20.
//  Copyright © 2017年 gentlesoft. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {

    var parents: [Int] = []
    var isMaster: Bool { return splitViewController?.viewControllers.first == self }
    var isTop: Bool { return parents.count == 0 }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if isMaster {
            if let controller = (self.splitViewController?.viewControllers.last as? UINavigationController)?.viewControllers.first as? TableViewController {
                controller.parents = [0]
            }
        } else {
            navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
        }
        if !isTop {
            self.title = DemoData.shared.text(indexes: parents)
        }

// 1. Drag
//        tableView.dragDelegate = self
// 2. Drop
//        tableView.dropDelegate = self
//        tableView.isSpringLoaded = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !isMaster && isTop {
            return 0
        } else {
            return DemoData.shared.count(indexes: parents) + 1
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row < DemoData.shared.count(indexes: parents) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.text = DemoData.shared.text(indexes: parents + [indexPath.row])
            return cell
        } else {
            return tableView.dequeueReusableCell(withIdentifier: "inputCell", for: indexPath)
        }
    }

    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return indexPath.row < DemoData.shared.count(indexes: parents)
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .fade)
            DemoData.shared.remove(at: parents + [indexPath.row])
            tableView.endUpdates()
        }
    }
    
    override func tableView(_ tableView: UITableView, shouldSpringLoadRowAt indexPath: IndexPath, with context: UISpringLoadedInteractionContext) -> Bool {
        return indexPath.row < DemoData.shared.count(indexes: parents)
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "detailSegue"?:
            guard let cell = sender as? UITableViewCell,
                let indexPath = tableView.indexPath(for: cell),
                let controller = (segue.destination as? UINavigationController)?
                        .viewControllers.first as? TableViewController else { return }
            
            controller.parents = parents + [indexPath.row]
        default:
            break
        }
    }
}

extension TableViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text else { return }
        guard text.characters.count > 0 else { return }
        
        textField.text = nil
        tableView.beginUpdates()
        
        DemoData.shared.append(text: text, parents: parents)
        tableView.insertRows(at: [IndexPath(row: DemoData.shared.count(indexes: parents) - 1, section: 0)], with: .automatic)
        
        tableView.endUpdates()
    }
}

// 1. Drag
//extension TableViewController: UITableViewDragDelegate {
//    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
//        guard let text = tableView.cellForRow(at: indexPath)?.textLabel?.text else { return [] }
//        let dragItem = UIDragItem(itemProvider: NSItemProvider(object: text as NSString))
//        dragItem.localObject = (indexes: (parents + [indexPath.row]), tableView: tableView)
//        return [dragItem]
//    }
//}

// 2. Drop
//extension TableViewController: UITableViewDropDelegate {
//    func tableView(_ tableView: UITableView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UITableViewDropProposal {
//        if let _ = session.localDragSession {
//            return UITableViewDropProposal(operation: .move,
//                                           intent: .insertAtDestinationIndexPath)
//        } else {
//            return UITableViewDropProposal(operation: .copy)
//        }
//    }
//
//    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {
//        guard let indexPath = coordinator.destinationIndexPath else { return }
//
//        tableView.beginUpdates()
//
//        for item in coordinator.items {
//            if let sourceIndexPath = item.sourceIndexPath {
//// 2. Move in TableView
////                tableView.moveRow(at: sourceIndexPath, to: indexPath)
////                DemoData.shared.insert(text: DemoData.shared.text(indexes: parents + [sourceIndexPath.row]),
////                                       at: indexPath.row,
////                                       parents: parents)
////                DemoData.shared.remove(at: parents + [sourceIndexPath.row])
//
//            } else if let (indexes, sourceTableView) = item.dragItem.localObject as? ([Int], UITableView) {
//// 3. Move to Othore TableView (same App)
////                guard parents != indexes else { return }
////
////                let index = indexPath.row + (indexPath.row > 0 && indexPath.row >= DemoData.shared.count(indexes: parents) ? -1 : 0)
////                DemoData.shared.insert(text: DemoData.shared.text(indexes: indexes),
////                                       at: index,
////                                       parents: parents)
////                tableView.insertRows(at: [indexPath], with: .automatic)
////                DemoData.shared.remove(at: indexes)
////                sourceTableView.reloadSections(IndexSet(integer: 0), with: .automatic)
//
//            } else {
//// 4. Copy from Othre App
////                guard item.dragItem.itemProvider.canLoadObject(ofClass: NSString.self) else { return }
////                let placeholder = coordinator.drop(item.dragItem, toPlaceholderInsertedAt: indexPath, withReuseIdentifier: "cell", rowHeight: tableView.rowHeight, cellUpdateHandler: { (cell) in
////                    cell.textLabel?.text = "..."
////                })
////                item.dragItem.itemProvider.loadObject(ofClass: NSString.self) { [weak self] (obj, _) in
////                    guard let wself = self,
////                        let text = obj as? NSString else {
////                            placeholder.deletePlaceholder()
////                            return
////                        }
////                    Thread.sleep(forTimeInterval: 1)
////                    DispatchQueue.main.async {
////                        placeholder.commitInsertion(dataSourceUpdates: { (indexPath) in
////                            DemoData.shared.insert(text: text as String,
////                                                   at: indexPath.row,
////                                                   parents: wself.parents)
////                        })
////                    }
////                }
//            }
//        }
//        tableView.endUpdates()
//    }
//}

