//
//  SQLiteDB.swift
//  LineaExpres
//
//

import Foundation
import SQLite3

class DB_Manager {
    var db: OpaquePointer?
    var path:String = "User.sqlite"
    
    init() {
        self.db = createDB()
        self.CreateTableUsers()
        self.CreateTableNotas()
        self.CreateTableCitas()
        self.CreateTableNavigation()
    }
    
    func createDB() -> OpaquePointer? {
        let filePath = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent(path);
        
        var db: OpaquePointer? = nil
        
        if sqlite3_open(filePath.path, &db) != SQLITE_OK {
            print("Table There is error in creating DB")
            return nil
        }else {
            print("Table Database has been created with path \(path)")
            return db
        }
    }
    
    //Start creation of tables
    func CreateTableNavigation() {
        let query = "CREATE TABLE IF NOT EXISTS Navigation(id INTEGER PRIMARY KEY AUTOINCREMENT, NavigationName TEXT);"
        var statement:OpaquePointer? = nil
        
        if sqlite3_prepare_v2(self.db, query, -1, &statement, nil) == SQLITE_OK {
            if sqlite3_step(statement) == SQLITE_DONE {
                print("Table creation success")
            }else {
                print("Table creation failed")
            }
        }else {
            print("Table Preparation failed")
        }
    }
    
    func CreateTableUsers() {
        let query = "CREATE TABLE IF NOT EXISTS User(id INTEGER PRIMARY KEY, Email TEXT, Name TEXT, FirebaseToken TEXT, LoginToken TEXT, UserSetPwd TEXT, Sentri TEXT, FechaSentri TEXT, facRazonSocial TEXT DEFAULT '', facRFC TEXT DEFAULT '', facDomFiscal TEXT DEFAULT '', facCP TEXT DEFAULT '', facEmail TEXT DEFAULT '', facTelefono TEXT DEFAULT '');"
        var statement:OpaquePointer? = nil
        
        if sqlite3_prepare_v2(self.db, query, -1, &statement, nil) == SQLITE_OK {
            if sqlite3_step(statement) == SQLITE_DONE {
                print("Table creation success")
            }else {
                print("Table creation failed")
            }
        }else {
            print("Table Preparation failed")
        }
    }
    
    func CreateTableNotas() {
        let query = "CREATE TABLE IF NOT EXISTS Notas(id INTEGER PRIMARY KEY, Title TEXT, Body TEXT, ImageURL TEXT)"
        var statement:OpaquePointer? = nil
        
        if sqlite3_prepare_v2(self.db, query, -1, &statement, nil) == SQLITE_OK {
            if sqlite3_step(statement) == SQLITE_DONE {
                print("Table Notas created successfully")
            }else {
                print("Table Notas has error creating")
            }
        }else {
            print("Table Notas preparation failed")
        }
    }
    
    func CreateTableCitas() {
        let query = "CREATE TABLE IF NOT EXISTS Cita(id INTEGER PRIMARY KEY, TramiteID TEXT, ProcedureID TEXT, idProcedureStatus TEXT, TramiteStatus TEXT);"
        var statement:OpaquePointer? = nil
        
        if sqlite3_prepare_v2(self.db, query, -1, &statement, nil) == SQLITE_OK {
            if sqlite3_step(statement) == SQLITE_DONE {
                print("Table creation success")
            }else {
                print("Table creation failed")
            }
        }else {
            print("Table Preparation failed")
        }
    }
    
    //Finish creation of tables
    
    //Start Navigation History
    
    public func InsertNavigation(NavigationName: String) {
        let query = "INSERT INTO Navigation (NavigationName) VALUES (?);"
        var statement : OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK {
            sqlite3_bind_text(statement, 1, (NavigationName as NSString).utf8String, -1, nil)
            if sqlite3_step(statement) == SQLITE_DONE {
                print("Insert on init, correct")
            }else {
                print("Insert on init, failed")
            }
            
        }else {
            print("Query is not as per requirement")
            
        }
    }
    
    func getNavigation() -> String {
        var NavigationName:String = ""
        let query = "SELECT NavigationName FROM Navigation ORDER BY id DESC LIMIT 1;"
        var statement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK{
            while sqlite3_step(statement) == SQLITE_ROW {
                NavigationName = String(describing: String(cString: sqlite3_column_text(statement, 0)))
                                    
            }
        }
    return NavigationName
    }
    
    public func DeleteFromNavigation() {
        let query = "DELETE FROM Navigation ORDER BY id DESC LIMIT 1;"
        var statement: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK{
            if sqlite3_step(statement) == SQLITE_DONE {
                print("Data delete success")
            }else {
                print("Data is not deleted in table")
            }
        }
    }
    
    public func DeleteAllFromNavigation() {
        let query = "DELETE FROM Navigation;"
        var statement: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK{
            if sqlite3_step(statement) == SQLITE_DONE {
                print("Data delete success")
            }else {
                print("Data is not deleted in table")
            }
        }
    }
    
    public func InsertNavigationOnInit(NavigationName: String) {
        let query = "INSERT INTO Navigation (NavigationName) VALUES (?);"
        var statement : OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK {
            sqlite3_bind_text(statement, 1, (NavigationName as NSString).utf8String, -1, nil)
            if sqlite3_step(statement) == SQLITE_DONE {
                print("Insert on init, correct")
            }else {
                print("Insert on init, failed")
            }
            
        }else {
            print("Query is not as per requirement")
            
        }
    }
    
    
    //Finish Navigation History
    
    
    
    //Start Table "Users" functions
    public func addUser(EmailVal: String, NameVal: String, LoginTokenVal: String, UserSetPwdVal: String, Sentri: String, SentriFecha: String) {
               let query = "UPDATE User SET Email='\(EmailVal)', Name='\(NameVal)', LoginToken='\(LoginTokenVal)', UserSetPwd='\(UserSetPwdVal)', Sentri='\(Sentri)', FechaSentri='\(SentriFecha)'"
               var statement : OpaquePointer? = nil
               
               if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK {
                
                   if sqlite3_step(statement) == SQLITE_DONE {
                       print("Data updated success")
                   }else {
                       print("Data is not updated in table")
                   }
                   
               }else {
                   print("Query is not as per requirement")
                   
               }
       }
    
    public func updateSentri(Sentri: String, SentriFecha: String) {
               let query = "UPDATE User SET Sentri='\(Sentri)', FechaSentri='\(SentriFecha)'"
               var statement : OpaquePointer? = nil
               
               if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK {
                
                   if sqlite3_step(statement) == SQLITE_DONE {
                       print("Data updated success")
                   }else {
                       print("Data is not updated in table")
                   }
                   
               }else {
                   print("Query is not as per requirement")
                   
               }
       }
    public func updateOnlySentri(Sentri: String) {
               let query = "UPDATE User SET Sentri='\(Sentri)'"
               var statement : OpaquePointer? = nil
               
               if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK {
                
                   if sqlite3_step(statement) == SQLITE_DONE {
                       print("Data updated success")
                   }else {
                       print("Data is not updated in table")
                   }
                   
               }else {
                   print("Query is not as per requirement")
                   
               }
       }
    
    
    public func addPswdCheck(UserSetPwdVal: String) {
        let query = "UPDATE User SET UserSetPwd='\(UserSetPwdVal)'"
        var statement : OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK {
         
            if sqlite3_step(statement) == SQLITE_DONE {
                print("Data updated success")
            }else {
                print("Data is not updated in table")
            }
            
        }else {
            print("Query is not as per requirement")
            
        }
    }
    
    public func addFireToken(FireToken: String) {
        let query = "UPDATE User SET FirebaseToken='\(FireToken)'"
        var statement : OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK {
            if sqlite3_step(statement) == SQLITE_DONE {
                print("Data updated success")
            }else {
                print("Data is not updated in table")
            }
            
        }else {
            print("Query is not as per requirement")
            
        }
    }
    
    public func addBillingData(RazonSocial: String, RFC: String, DomFiscal: String, CP: String, Email: String, Telefono: String) {
        let query = "UPDATE User SET facRazonSocial='\(RazonSocial)', facRFC='\(RFC)', facDomFiscal='\(DomFiscal)', facCP='\(CP)', facEmail='\(Email)', facTelefono='\(Telefono)'"
        var statement : OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK {
            if sqlite3_step(statement) == SQLITE_DONE {
                print("Data updated success")
            }else {
                print("Data is not updated in table")
            }
            
        }else {
            print("Query is not as per requirement")
            
        }
    }
    
    public func UserInsertOnInit() {
        let query = "INSERT INTO User (id) VALUES (?);"
        var statement : OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK {
            
            sqlite3_bind_int(statement, 1, Int32(1))
            
            if sqlite3_step(statement) == SQLITE_DONE {
                print("Insert on init, correct")
            }else {
                print("Insert on init, failed")
            }
            
        }else {
            print("Query is not as per requirement")
            
        }
    }

    func getUsuario() -> Array<String> {
        var Lista:Array<String> = []
        let query = "SELECT Email, Name, FirebaseToken, LoginToken, UserSetPwd, Sentri, FechaSentri, facRazonSocial, facRFC, facDomFiscal, facCP, facEmail, facTelefono FROM User WHERE id = 1 AND LoginToken is not NULL  "
        var statement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK{
            while sqlite3_step(statement) == SQLITE_ROW {
                let Email = String(describing: String(cString: sqlite3_column_text(statement, 0)))
                let FName = String(describing: String(cString: sqlite3_column_text(statement, 1)))
                let FirebaseToken = String(describing: String(cString: sqlite3_column_text(statement, 2)))
                let LoginToken = String(describing: String(cString: sqlite3_column_text(statement, 3)))
                let UserSetPwd = String(describing: String(cString: sqlite3_column_text(statement, 4)))
                let Sentri = String(describing: String(cString: sqlite3_column_text(statement, 5)))
                let SentriFecha = String(describing: String(cString: sqlite3_column_text(statement, 6)))
                //Begginning billing data
                let facRazonSocial = String(describing: String(cString: sqlite3_column_text(statement, 7)))
                let facRFC = String(describing: String(cString: sqlite3_column_text(statement, 8)))
                let facDomFiscal = String(describing: String(cString: sqlite3_column_text(statement, 9)))
                let facCP = String(describing: String(cString: sqlite3_column_text(statement, 10)))
                let facEmail = String(describing: String(cString: sqlite3_column_text(statement, 11)))
                let facTelefono = String(describing: String(cString: sqlite3_column_text(statement, 12)))
                
                let newList:String = Email + "∑" + FName + "∑" + FirebaseToken + "∑" + LoginToken + "∑" + UserSetPwd + "∑" + Sentri + "∑" + SentriFecha + "∑" + facRazonSocial + "∑" + facRFC + "∑" + facDomFiscal + "∑" + facCP + "∑" + facEmail + "∑" + facTelefono
                
                Lista.append(newList)
                                    
            }
        }
    return Lista
    }
    
    public func DeleteAllFromUserTable() {
        let query = "DELETE FROM User;"
        var statement: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK{
            if sqlite3_step(statement) == SQLITE_DONE {
                print("Data delete success")
            }else {
                print("Data is not deleted in table")
            }
        }
    }
    //End Table "Users" functions
    
    //Start table "Citas" function
    public func addCita(TramiteID: String, ProcedureID: String, idProcedureStatus: String, TramiteStatus: String) {
               let query = "UPDATE Cita SET TramiteID='\(TramiteID)', ProcedureID='\(ProcedureID)', idProcedureStatus='\(idProcedureStatus)', TramiteStatus='\(TramiteStatus)'"
               var statement : OpaquePointer? = nil
               
               if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK {
                
                   if sqlite3_step(statement) == SQLITE_DONE {
                       print("Data updated success")
                   }else {
                       print("Data is not updated in table")
                   }
                   
               }else {
                   print("Query is not as per requirement")
                   
               }
       }
    
    func getCita() -> String {
        var Lista:String = ""
        let query = "SELECT TramiteID, ProcedureID, idProcedureStatus, TramiteStatus FROM Cita WHERE id = 1"
        var statement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK{
            while sqlite3_step(statement) == SQLITE_ROW {
                let TramiteID = String(describing: String(cString: sqlite3_column_text(statement, 0)))
                let ProcedureID = String(describing: String(cString: sqlite3_column_text(statement, 1)))
                let idProcedureStatus = String(describing: String(cString: sqlite3_column_text(statement, 2)))
                let TramiteStatus = String(describing: String(cString: sqlite3_column_text(statement, 3)))
                
                Lista = TramiteID + "∑" + ProcedureID + "∑" + idProcedureStatus + "∑" + TramiteStatus
                
               
                                    
            }
        }
    return Lista
    }
    
    
    public func CitaInsertOnInit() {
        let query = "INSERT INTO Cita (id) VALUES (?);"
        var statement : OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK {
            
            sqlite3_bind_int(statement, 1, Int32(1))
            
            if sqlite3_step(statement) == SQLITE_DONE {
                print("Insert on init, correct")
            }else {
                print("Insert on init, failed")
            }
            
        }else {
            print("Query is not as per requirement")
            
        }
    }
    
    public func DeleteAllFromCitaTable() {
        let query = "DELETE FROM Cita;"
        var statement: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK{
            if sqlite3_step(statement) == SQLITE_DONE {
                print("Data delete success")
            }else {
                print("Data is not deleted in table")
            }
        }
    }
    
    //End table "Citas" function
    
    
    //Start Table "Notas" functions
    public func InsertNotas(NotaID: Int, NotaTitle: String, NotaBody: String, NotaImageURL: String) {
        let query = "INSERT INTO Notas (id, Title, Body, ImageURL) VALUES (?,?,?,?);"
        var statement: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK {
            
            sqlite3_bind_int(statement, 1, Int32(Int(NotaID)))
            sqlite3_bind_text(statement, 2, (NotaTitle as NSString).utf8String, -1, nil)
            sqlite3_bind_text(statement, 3, (NotaBody as NSString).utf8String, -1, nil)
            sqlite3_bind_text(statement, 4, (NotaImageURL as NSString).utf8String, -1, nil)
            
            if sqlite3_step(statement) == SQLITE_DONE {
                print("Inserting nota, correct")
            }else {
                print("Inserting nota, failed")
            }
            
        }else {
            print("Inserting nota, has a problem preparing")
            
        }
    }
    
    func getNota(id:Int) -> Array<String> {
        var Lista:Array<String> = []
        let query = "SELECT Title, Body, ImageURL FROM Notas WHERE id = \(id) "
        var statement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK{
            while sqlite3_step(statement) == SQLITE_ROW {
                let Title = String(describing: String(cString: sqlite3_column_text(statement, 0)))
                let Body = String(describing: String(cString: sqlite3_column_text(statement, 1)))
                let ImageURL = String(describing: String(cString: sqlite3_column_text(statement, 2)))
                
                let newList:String = Title + "∑" + Body + "∑" + ImageURL
                
                Lista.append(newList)
                                    
            }
        }
    return Lista
    }
    
    func getNotasForCarousel() -> Array<String> {
        var Lista:Array<String> = []
        let query = "SELECT Title FROM Notas WHERE Title != '' ORDER BY id DESC"
        var statement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK{
            while sqlite3_step(statement) == SQLITE_ROW {
                let Title = String(describing: String(cString: sqlite3_column_text(statement, 0)))
                Lista.append(Title)
                                    
            }
        }
    return Lista
    }
    
    func getNotaID() -> Array<String> {
        var Lista:Array<String> = []
        let query = "SELECT id FROM Notas WHERE Title != '' ORDER BY id DESC"
        var statement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK{
            while sqlite3_step(statement) == SQLITE_ROW {
                let id = String(describing: String(cString: sqlite3_column_text(statement, 0)))
                Lista.append(id)
                                    
            }
        }
    return Lista
    }
    
    //BEGINING SubNotas -- Getting Prev and Next Notes --
    func getPrevAndNextNote(actualID: Int, neg: String) -> Array<String> {
        var Lista:Array<String> = []
        var query = "SELECT id, Title, Body, ImageURL FROM Notas WHERE id < \(actualID) ORDER BY id DESC LIMIT 1;"
        
        if neg.contains("Prev") {
            query = "SELECT id, Title, Body, ImageURL FROM Notas WHERE id > \(actualID) ORDER BY id LIMIT 1;"
        }
        var statement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK{
            while sqlite3_step(statement) == SQLITE_ROW {
                
                let id =  String(describing: String(cString: sqlite3_column_text(statement, 0)))
                let Title = String(describing: String(cString: sqlite3_column_text(statement, 1)))
                let Body = String(describing: String(cString: sqlite3_column_text(statement, 2)))
                let ImageURL = String(describing: String(cString: sqlite3_column_text(statement, 3)))
                
                let newList:String = id + "∑" + Title + "∑" + Body + "∑" + ImageURL
                
                
                print("Vamos a ver")
                print(newList as Any)
                Lista.append(newList)
                
            }
        }else {
            print("Error al leer anterior y siguiente nota")
        }
        return Lista
    }
    
    //BEGINING SubNotas -- Getting Last 4 Notes --
    func getLastFourNotas() -> Array<String> {
        var Lista:Array<String> = []
            let query = "SELECT id, Title, ImageURL FROM Notas ORDER BY id DESC LIMIT 5, 4"
            var statement : OpaquePointer? = nil
            if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK{
                while sqlite3_step(statement) == SQLITE_ROW {
                    let id = Int(sqlite3_column_int(statement, 0))
                    let Title = String(describing: String(cString: sqlite3_column_text(statement, 1)))
                    let ImageURL = String(describing: String(cString: sqlite3_column_text(statement, 2)))
                    
                    let newList:String = String(id) + "∑" + Title + "∑" + ImageURL
                    
                    Lista.append(newList)
                                        
                }
            }
        return Lista
        }
    //END SubNotas -- Getting Lasst 4 Notes --

    public func DeleteAllFromNotasTable() {
        let query = "DELETE FROM Notas;"
        var statement: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK{
            if sqlite3_step(statement) == SQLITE_DONE {
                print("Data delete success")
            }else {
                print("Data is not deleted in table")
            }
        }
    }
    
    //End Notas
    
}
