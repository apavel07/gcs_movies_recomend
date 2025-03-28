# This snippet has been automatically generated and should be regarded as a
# code template only.
# It will require modifications to work:
# - It may require correct/in-range values for request initialization.
# - It may require specifying regional endpoints when creating the service
#   client as shown in:
#   https://googleapis.dev/python/google-api-core/latest/client_options.html
from google.cloud import discoveryengine_v1beta


def sample_recommend():
    # Create a client
    client = discoveryengine_v1beta.RecommendationServiceClient()

    # Initialize request argument(s)
    user_event = discoveryengine_v1beta.UserEvent()
    user_event.user_pseudo_id = "12623708"

    # # Option 1
    # user_event.event_type = "view-home-page"

    # Option 3
    user_event.event_type = "view-home-page"
    user_event.page_info = {"page_category": "Animowany" }

    # # Option 2
    # user_event.event_type = "view-item"
    # user_event.documents = [{"id":"38514"},{"id":"37901"},{"id":"24205"}]



    # Научился запрашивать GCP рекомендацию обращаясь из python и консоли на  компе.


    PROJECT = "142998836949"
    LOCATION = "global"
    COLLECTION = "default_collection"
    ENGINE_ID = "apavel-recommendations_1741885368373"
    SERVING_CONFIG_ID = "apavel-recommendations_1741885368373"
    serving_config = "projects/142998836949/locations/global/collections/default_collection/engines/apavel-recommendations_1741885368373/servingConfigs/apavel-recommendations_1741885368373"

    request = discoveryengine_v1beta.RecommendRequest(
        serving_config=serving_config,
        user_event=user_event,
        page_size = 5
    )

    # Make the request
    response = client.recommend(request=request)

    # Handle the response
    print(response)

sample_recommend()