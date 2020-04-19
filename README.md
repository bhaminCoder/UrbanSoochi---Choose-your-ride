##  UrbanSoochi
### As the name suggests it shows a list of urban cities grouped by their respective countries


#### Implements an MVVM architectural approach to communiacting between data and views 

## NetWork Layer
1. APIRequest: Provides interface /`protocol` with attributes and behaviours need to conreuct a `URLRequest` object
2. APIRequestManager: The purpose of this class would be execute or initiate any `URLSession` data task for a given APIRequest
    
#### Usage  
    1. Create a Request class for the URLRequest and confirm to APIRequest protocol
    2. Leverage the same in respective viewmodel class to initiate a URLSession data task / API
    3. Map the data to the respective `ModelType` which is `Codable` in order to decode and return the same from view model
    
    This lets us mock the request object and mock the data while testing.

###Utilities - All extensions and other required files that would be leveraged under the app

> Assumptions
  1. A `City` cannot exist without a name and without belonging to a country, hence a city is not displayed in case it is without either or both of the attributes.
  2. A `Countries` collection from the json/api is not considered, because it does not have any related between `cities` and `countries` collection under the json/api.

>Things that can be improved:
1. Functional unit test coverage is approx 90% as of now which can still be improved.
>>> Note: Contains tests for functional part not for UI tests.
2. Code structuring can be improved as per one's understanding
