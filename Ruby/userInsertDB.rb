#!/usr/bin/ruby

require 'pg'
require 'json'

jsonFileName = "users.json"
tableName = "Users"

begin

    con = PG.connect :dbname => 'development', :user => 'postgres'
    con.prepare 'insertStm', "INSERT INTO " +  tableName + " (email, pwd, created_at, updated_at) VALUES($1, $2, $3, $4)"
    
    userJsonStringArray = File.open(jsonFileName).read.split("#")


	userJsonStringArray.each do |userJsonString|
		userJson = JSON.parse(userJsonString)
		con.exec_prepared 'insertStm', [userJson["email"], userJson["pwd"], DateTime.now, DateTime.now]
	end

rescue PG::Error => e

    puts e.message 
    
ensure

    con.close if con
    
end
