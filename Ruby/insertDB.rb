#!/usr/bin/ruby

require 'pg'
require 'json'

jsonFileName = "beverages.json"
tableName = "Products"
prodCat = "Beverages"
begin

    con = PG.connect :dbname => 'development', :user => 'postgres'
    con.prepare 'insertStm', "INSERT INTO " +  tableName + " (cat, name, price, img_url, created_at, updated_at) VALUES($1, $2, $3, $4, $5, $6)"
    
    productJsonStringArray = File.open(jsonFileName).read.split("#")


	productJsonStringArray.each do |productJsonString|
		productJson = JSON.parse(productJsonString)
		con.exec_prepared 'insertStm', [prodCat, productJson["Name"], productJson["Price"].split(" ")[0], productJson["Image"], DateTime.now, DateTime.now]
	end

rescue PG::Error => e

    puts e.message 
    
ensure

    con.close if con
    
end
