import os
path = os.path.dirname(os.path.abspath(__file__))
#print(path)

################################
import mysql.connector
# connect to the MySQL server
cnx = mysql.connector.connect(
                                user='admin', 
                                password='password',
                                host='52.42.186.119',
                                database='classicmodels'
                                )


# create a cursor
cursor = cnx.cursor()

import random

# define the query with placeholders for the dynamic values
query = """
SELECT 
    customername, 
    country, 
    state, 
    creditlimit
FROM
    customers
WHERE
    country = 'USA' AND 
    state = 'CA' AND 
    creditlimit > {};
"""

# loop 10 times
for i in range(1000):
    # generate a random integer for the creditlimit value
    creditlimit = random.randint(1000, 500000)

    # format the query with the dynamic values
    formatted_query = query.format(creditlimit)
    print(formatted_query)
    # execute the query
    cursor.execute(formatted_query)

    # get the results
    results = cursor.fetchall()

    # print the results
    # for result in results:
    #     print(result)

# close the cursor and connection
cursor.close()
cnx.close()


query = """
SELECT 
    lastName, 
    firstName, 
    jobTitle, 
    officeCode
FROM
    employees
WHERE
    jobtitle = 'Sales Rep' OR 
    officeCode = 1
ORDER BY 
    officeCode , 
    jobTitle;
"""



query = """
SELECT 
    customername, 
    country, 
    state, 
    creditlimit
FROM
    customers
WHERE
    country = 'USA' AND 
    state = 'CA' AND 
    creditlimit > 100000;
"""

query = """
SELECT 
    productCode, 
    productName, 
    buyPrice
FROM
    products
WHERE
    buyPrice < 20 OR buyPrice > 100;
"""

query = """
SELECT
	customers.customerName,
	COUNT(orders.orderNumber) total
FROM
	customers
INNER JOIN orders ON customers.customerNumber = orders.customerNumber
GROUP BY
	customerName
ORDER BY
	total DESC
"""

query = """
SELECT 
    customers.customerNumber, 
    customerName, 
    orderNumber, 
    status
FROM
    customers
LEFT JOIN orders ON 
    orders.customerNumber = customers.customerNumber;
"""