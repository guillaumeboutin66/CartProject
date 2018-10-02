//
//  ViewController.swift
//  project-ios-2-BOUTIN-DOMANGE
//
//  Created by Guillaume boutin on 11/09/2018.
//  Coded with Baptiste domange.
//  Copyright © 2018 Guillaume boutin. All rights reserved.
//

import UIKit

// Controller de la page principale, on lui dis qu'il sera lui même DataSource et Delegate
class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // Ma ListView
    @IBOutlet weak var tableView: UITableView!
    // Entête de liste
    let headers : [String] = ["Mon Panier", "Produits"]
    // Tableau pour DataSource
    var tableViewData: [[String]] = [[], []]
    
    // Bouton pour vider le panier après les courses effectuées
    @IBAction func actionClear(_ sender: Any) {
        for (_, element) in tableViewData[0].enumerated() {
            tableViewData[1].append(element)
        }
        tableViewData[0] = []
        
        self.tableView.reloadData()
        
        // Appel de la fonction de la sauvegarde
        saveUserCartFromUserDefaults()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
        // Active l'edit
        tableView.isEditing = true
        
        // On essaie de charger les données depuis les UsersDefault
        let resultOfLoad : Bool = loadUserCartToUserDefaults()
        
        // Si on a rencontré une erreur (on a pas réussis à charger les données)
        // On prend un tableau de Test
        if(resultOfLoad){
            tableViewData[0] = ["🥐 Produit 1", "🍟 Produit 2", "🥕 Produit 3", "🍔 Produit 4"]
            tableViewData[1] = ["🥐 Produit 1", "🍟 Produit 2", "🥕 Produit 3", "🍔 Produit 4"]
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // Renvoie le nombre de lignes de la section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return tableViewData[section].count
    }
    
    // Fonction Delegate qui assige les Data à la vue
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell : UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cart_cell", for: indexPath)
        cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "cart_cell")
        if tableViewData.count > 0 {
            cell.textLabel?.text = tableViewData[indexPath.section][indexPath.row]
        }
        return cell
    }
    
    // Nombre d'entête
    func numberOfSections(in tableView: UITableView) -> Int {
        return headers.count
    }
    
    // Renvoie le nombre de lignes de la section
    func numberOfRows(inSection section: Int) -> Int{
        return tableViewData[section].count
    }
    
    // Renvoie le tableau d'entête
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?  {
        return headers[section]
    }
    
    // Active les actions row
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // Gestion des actions (insert / delete)
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            tableViewData[1].append(tableViewData[indexPath.section][indexPath.row])
            tableViewData[0].remove(at: indexPath.row)
        }
        if (editingStyle == .insert) {
            tableViewData[0].append(tableViewData[indexPath.section][indexPath.row])
            tableViewData[1].remove(at: indexPath.row)
        }
        self.tableView.reloadData()
        // Appel de la fonction de la sauvegarde
        saveUserCartFromUserDefaults()
    }
    
    // Gestion de l'action  à rendre disponible
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        if (indexPath.section == 1)
        {
            return .insert
        }
        else
        {
            return .delete
        }
    }
    
    // Sauvegarde tout simplement l'array dans les UserDefaults
    func saveUserCartFromUserDefaults(){
        UserDefaults.standard.set(tableViewData[0], forKey: "Mon panier")
        UserDefaults.standard.set(tableViewData[1], forKey: "Produits")
    }
    
    // Charge tout simplement l'array dans les UserDefaults
    // Avec test si la donnée trouvée est bien un Array de String
    func loadUserCartToUserDefaults() -> Bool{
        var err: Int = 0
        if let arrPanier = UserDefaults.standard.array(forKey: "Mon panier") as? [String]{
            print(arrPanier)
            tableViewData[0] = arrPanier
        }else{
            err += 1
        }
        
        if let arrProduits = UserDefaults.standard.array(forKey: "Produits") as? [String]{
            print(arrProduits)
            tableViewData[1] = arrProduits
        }else{
            err += 1
        }
        
        return err >= 1
    }

}
