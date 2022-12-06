import os
path = os.path.dirname(os.path.abspath(__file__))
#print(path)

import zipfile
with zipfile.ZipFile(path+"/mysqlsampledatabase.zip","r") as zip_ref:
    zip_ref.extractall(path+"/")

#############

import mysql.connector

# connect to the MySQL server
cnx = mysql.connector.connect(
                                user='admin', 
                                password='password',
                                host='${test_node_host_ip}',
                                database='test1'
                                )

# create a cursor
cursor = cnx.cursor()

# read the .sql file
with open(path+'/mysqlsampledatabase.sql') as f:
    sql = f.read()

# execute the SQL commands
cursor.execute(sql)

# close the cursor and connection
cursor.close()
cnx.close()


###############################
# connect to the MySQL server
cnx = mysql.connector.connect(
                                user='admin', 
                                password='password',
                                host='${test_node_host_ip}',
                                database='test1'
                                )

#define the SQL query
#create a cursor
cursor = cnx.cursor()


query = 'SHOW DATABASES'

# execute the query
cursor.execute(query)

# get the results
results = cursor.fetchall()

# print the results
for result in results:
    print(result[0])

# close the cursor and connection
cursor.close()
cnx.close()







