from google.cloud import bigquery

# Initialize the client
client = bigquery.Client()

# Define your SQL query
query = """SELECT documents[0].id as doc_id FROM `mware-data.mware_curated.view_item` LIMIT 10"""

# Run the query
query_job = client.query(query)

# Fetch the results
for row in query_job:
    print(row)