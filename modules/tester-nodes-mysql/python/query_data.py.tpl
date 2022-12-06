### QUERY CACHING WITH REDIS
# Import the necessary libraries
import mysql.connector
import redis
import hashlib
import pickle
import random

################################  Connections to MySQL and Redis Db
import mysql.connector
# connect to the MySQL server
cnx = mysql.connector.connect(
                                user='admin', 
                                password='password',
                                host='${test_node_host_ip}',
                                database='classicmodels'
                                )


# Create a connection to the Redis server
r = redis.Redis(host="${redis-db-endpoint}", port=${redis-db-port})


######## Query Caching Function
##### Define a function to execute a SQL query and cache it in Redis

def execute_query(query):
  # First, check if the query has been previously executed and the result is in the cache
    query_hash = hashlib.sha1(query.encode()).hexdigest()
    if query_hash in cache:
        print("Retrieving result from cache")
        # Deserialize the result from the cache
        result = pickle.loads(r.get(query_hash))
        #print(result)
        return result
    
    # If the query has not been previously executed, execute it now
    #print("Executing query")
    cursor = conn.cursor()
    cursor.execute(query)
    result = cursor.fetchall()
    
    # Serialize the result before storing it in the cache using Redis
    #result_str = pickle.dumps(result)
    #print(result_str)
    #r.set(query_hash, result_str)
    
    
    # Create a pipeline object
    pipeline = r.pipeline()
    
    # Use the pipeline to set the query result in the cache
    pipeline.set(query_hash, pickle.dumps(result))
    # Set a time to live for the string in the cache
    pipeline.expire(query_hash, 600)
    
    # Execute the pipeline
    pipeline.execute()
    
    
    
    # Set a time to live for the string in the cache
    #r.expire(query_hash, 60)
    
    # Return the result of the query
    return result


#########################
####### Query Generator
# define the query with placeholders for the dynamic values
query = """
    SELECT 
        c.customerNumber,
        c.customerName,
        c.contactLastName,
        c.contactFirstName,
        c.phone,
        c.addressLine1,
        c.addressLine2,
        c.city,
        c.state,
        c.postalCode,
        c.country,
        c.salesRepEmployeeNumber,
        c.creditLimit,
        o.orderNumber,
        o.orderDate,
        o.requiredDate,
        o.shippedDate,
        o.status,
        o.comments,
        o.customerNumber
    FROM
    customers c
LEFT JOIN orders o 
    ON c.customerNumber = o.customerNumber
    WHERE
    o.orderNumber > {} AND o.orderNumber < {}
    LIMIT {}
    ;
"""

# create an empty list for the formatted queries
formatted_queries = []

# loop n times
for i in range(10000):
    # generate a random integer for the creditlimit value
    minOrderNumber = random.randint(10099, 10262)
    maxOrderNumber = random.randint(10263, 10426)
    limit          = random.randint(0, 326)

    # format the query with the dynamic values
    random_query = query.format(minOrderNumber, maxOrderNumber, limit)
    
    # define the list of fields to add or drop from the query
    fields = [
        "c.customerName,",
        "c.contactLastName,",
        "c.contactFirstName,",
        "c.phone,",
        "c.addressLine1,",
        "c.addressLine2,",
        "c.city,",
        "c.state,",
        "c.postalCode,",
        "c.country,",
        "c.salesRepEmployeeNumber,",
        "c.creditLimit,",
        "o.orderDate,",
        "o.requiredDate,",
        "o.shippedDate,",
        "o.status,",
        "o.comments,"
    ]
    
    # generate a random number to determine whether to add or drop fields
    rand = random.randint(0, 1)

    # if the number is 0, drop a random field from the query
    if rand == 0:
        # choose a random field to drop
        chosen_values = random.sample(fields,3)
        # remove the field from the list of available fields
        # Remove the chosen values from the list
        for value in chosen_values:
            fields.remove(value)
            
            # Remove values from query
            for field in fields:
                random_query = random_query.replace(field, "")
        # remove white space        
        formatted_query = " ".join(random_query.split())
    else:
        # else, use the random query
        # remove white space 
        formatted_query = " ".join(random_query.split())
    
    # append the formatted query to the list
    formatted_queries.append(formatted_query)


############################
###### Run Queries Through Cache Function

# Create a cache to store the results of previous queries
cache = {}

# loop n times
for i in range(1000):

    chosen_query = random.choice(formatted_queries)

    result = execute_query(chosen_query)
    #print(result)

# loop n times
for i in range(1000):

    chosen_query = random.choice(formatted_queries)

    result = execute_query(chosen_query)