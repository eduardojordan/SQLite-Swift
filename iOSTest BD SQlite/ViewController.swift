//
//  ViewController.swift
//  iOSTest BD SQlite
//
//  Created by Eduardo on 30/01/2019.
//  Copyright © 2019 Eduardo Jordan Muñoz. All rights reserved.
//

import UIKit
import SQLite


class ViewController: UIViewController , UITableViewDelegate, UITableViewDataSource{

  //  var people = [String]()
    
    var database: Connection!
    
    let userTable = Table("personas")
    let id = Expression<Int>("id")
    let nombre = Expression<String>("nombre")
    let apellido1 = Expression<String>("apellido1")
    let apellido2 = Expression<String>("apellido2")
    let x = Expression<Int>("x")
    let y = Expression<Int>("y")

    
    
    @IBOutlet weak var tableView: UITableView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        do {
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let fileUrl = documentDirectory.appendingPathComponent("users").appendingPathExtension("sqlite3")
            let database = try Connection(fileUrl.path)
            self.database = database
        } catch {
            print(error)
        }
        createTable()
        
        
    }
    
    func createTable(){
        let createTable = self.userTable.create { (table) in
            table.column(self.id, primaryKey: true)
            table.column(self.nombre)
            table.column(self.apellido1)
            table.column(self.apellido2)
            table.column(self.x)
            table.column(self.y)
        }
        
        do {
            try self.database.run(createTable)
            print("---> Created Table")
        } catch {
            print(error)
        }
        
        let insertPersonCarmen = self.userTable.insert(self.nombre <- "Carmen",self.apellido1 <- "Lopez",self.apellido2 <- "Gonzalez", self.x <- 0, self.y <- 0)
        let insertPersonPedro = self.userTable.insert(self.nombre <- "Pedro",self.apellido1 <- "Sanchez",self.apellido2 <- "Sanchez", self.x <- 9, self.y <- 13)
        let insertPersonRodolfo = self.userTable.insert(self.nombre <- "Rodolfo",self.apellido1 <- "Axigüos",self.apellido2 <- "Caçan", self.x <- 5, self.y <- 8)
        let insertPersonAgnes = self.userTable.insert(self.nombre <- " Agnes",self.apellido1 <- "Caño",self.apellido2 <- "Agmes", self.x <- 4, self.y <- 13)
        
               do{
                guard self.database != nil else {return}
                        try self.database.run(insertPersonCarmen)
                        try self.database.run(insertPersonPedro)
                        try self.database.run(insertPersonRodolfo)
                        try self.database.run(insertPersonAgnes)
                print("---> Actualizando Agregando PersonaBase")
                   }catch{
                print(error)
                    }
        
    }
    
    @IBAction func addPerson() {
        let alert = UIAlertController(title: "Inserte Datos", message: nil, preferredStyle: .alert)
        alert.addTextField{ (tf) in tf.placeholder = "Nombre"}
        alert.addTextField{ (tf) in tf.placeholder = "Apellido 1"}
        alert.addTextField{ (tf) in tf.placeholder = "Apellido 2"}
        alert.addTextField{ (tf) in tf.placeholder = "Coordenanda X"}
        alert.addTextField{ (tf) in tf.placeholder = "Coordenanda Y"}
        
        let action = UIAlertAction (title: "Enviar", style: .default) { (_) in
            guard let nombre = alert.textFields?[0].text,
                let apellido1 = alert.textFields?[1].text,
                let apellido2 = alert.textFields?[2].text,
                let coordenadaX = alert.textFields?[3].text,
                let coordenadaY = alert.textFields?[4].text
                else {return}
            print(nombre,apellido1,apellido2,"Cordenada X:\(coordenadaX), Coordenada Y: \(coordenadaY)")
            print("---> Persona Agregada")
            
            let insertPerson = self.userTable.insert(self.nombre <- nombre, self.apellido1 <- apellido1, self.apellido2 <- apellido2, self.x <- self.x, self.y <- self.y)
            
            do{
                guard self.database != nil else {return}
                try self.database.run(insertPerson)
                print("---> Actualizando Agregando Persona")
               
            }catch{
                print(error)
            }
            
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func listPerson() {
        print("---> Lista de Personas:")
        do{
           // guard self.database != nil else {return}
            let personas = try self.database.prepare(self.userTable)
            for person in personas {
                print("Nombre: \(person[self.nombre]), Apellido1: \(person[self.apellido1]),Apellido2: \(person[self.apellido2])")
                 //, Coordenada x: \(person[self.x]), Coordenada y: \(person[self.y])
            }
        } catch{
            print(error)
        }
    }
 
// TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7  }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "TheCEll")!
       // var dict = self.database.prepare(self.userTable)
        
       
        do{
            let personas = try self.database.prepare(self.userTable)
            for person in personas {
            let people = ( "\(person[self.nombre]), \(person[self.apellido1]), \(person[self.apellido2])")
                cell.textLabel?.text = people
            }
        } catch{
            print(error)
        }
       
        
        return cell
    }
    
}


// Nota: Vale decir que no habia trabajando con persistencia de Datos con SQlite en Swift, lo que he manejado lo he realizado con CoreData, Sin embargo
//asumi el reto de tratar de realizar el ejercicio en el tiempo indicando.
// Quedo pendiente la vista del mapa y  las cordenadas de las personas.

