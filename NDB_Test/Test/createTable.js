const mysql = require("mysql");
let conn;

function createTable(params) {

    return new Promise(function(resolve, reject) {
        if (!conn) {
            conn = mysql.createConnection({
                host: params.cdbHost,
                user: params.cdbUser,
                password: params.cdbPass,
                database: params.cdbDatabase
            })
            conn.connect();
        }

        let query = `CREATE TABLE ${params.cdbTable}
                    (no INT NOT NULL AUTO_INCREMENT,
                    title VARCHAR(50),
                    author VARCHAR(30),
                    publisher VARCHAR(30),
                    PRIMARY KEY(no))`;
        conn.query(query, function (error, results, fields){
            if (error) {
                reject({error: error});
            }
            resolve(results);
        });
    })
}

exports.main = createTable;