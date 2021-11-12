# flutter_axelor_sdk

 Powerful, helpful, extensible and highly customizable API's that wrap http client to make communication easier with [Axelor](https://axelor.com/) server with boilerplate code free.
 
## Table of contents
- [Get Started](#get-started)

- [Example](#example)

- [Features](#features)

- [Axelor APIs](#axelor-apis)

- [Advanced Use](#advanced-use)

- [Contributing](#contributing)

## Get Started

#### Add dependency

```yaml
flutter_axelor_sdk:  
    git:    
     url: https://github.com/Abdktefane/flutter-axelor-sdk.git
     ref: v0.0.1  # you can track the development version => ref: master
```
#### initial in `main.dart`
```dart
void main()  {
  Axelor.initialize(
    builder: AxelorBuilder(
      client: Dio(),
      domain: 'com.axelor.testserver.base.db.', // replace with your axelor server prefix
    ),
  );
  runApp(const App());
}
```

## Example
#### Let's take searching for contacts example (with pagination and complex search criteria)

```dart
Axelor.search(
  model: Contacts.model,                      // auto end point construct
  baseDomain: Contacts.baseDomain,            // auto end point construct
  mapper: Contacts.fromJson,                  // Auto json decode and map to class object
  page: 0,                                    // page pagination support
  body: AxelorBody(                           // Syntactic sugar to construct body
    fields: const ['fullName', 'email'],
    sortBy: const ['fullName', '-createdOn'],
    criteria: AxelorCriteria.or([
      'email'.like('%gmail.com'),
      'lang'.equal('FR'),
      'age'.between('18', '40'),
      AxelorCriteria.and(['firstName'.like('j%'), 'lastName'.like('s%')])
    ]),
  ),
);
```
#### If we want to achieve the same function without Axelor Sdk 
```dart
try {
  final response = await client.post(
    '/ws/rest/com.axelor.contact.db.Contact/search',
    data: {
      'offset': 0,
      'limit': 10,
      'fields': ['fullName', 'email'],
      'sortBy': ['fullName', '-createdOn'],
      'data': {
        'criteria': [
          {
            'operator': 'or',
            'criteria': [
              {'fieldName': 'email', 'operator': 'like', 'value': '%gmail.com'},
              {'fieldName': 'lang', 'operator': '=', 'value': 'FR'},
              {'fieldName': 'age', 'operator': 'between', 'value': 18, 'value2': 40},
              {
                'operator': 'and',
                'criteria': [
                  {'fieldName': 'firstName', 'operator': 'like', 'value': 'j%'},
                  {'fieldName': 'lastName', 'operator': 'like', 'value': 's%'}
                ]
              }
            ]
          }
        ]
      }
    },
  );
  // decode to json
  final Map<String, dynamic> jsonResponse = jsonDecode(response.data);
  // check if success response or error happen
  if ((jsonResponse['status'] as int?) != 0) {
    // propagate error to ui
    return;
  }

  // map json to Contact Class
  final contacts = Contacts.fromJson(jsonResponse['data']);
} catch (ex, st) {
  // propagate general error to ui
}
```
## Features
- **Compatible**: Compatible with all your existing code so you can adopt when and where you want.
- **Less code**: Do more with less code and avoid entire classes of bugs, so code is simple and easy to maintain.
- **Highly customizable** : The defaults settings will cover you but if not almost every thing is customizable.
- **Architecture-agnostic**: Works with any architecture approach.
- **enterprise-ready**: All code is fully tested so it's save to use in production.
- **well documented**: Each feature is well documented.


## Axelor APIs
#### You can discover all api's features in documentation. Each api is well documented .
- [x] [Search](https://docs.axelor.com/adk/5.4/dev-guide/web-services/rest.html#find-records)
- [x] [Advanced Search](https://docs.axelor.com/adk/5.4/dev-guide/web-services/advanced.html#advanced-search)
- [x] [Fetch](https://docs.axelor.com/adk/5.4/dev-guide/web-services/rest.html#find-records)
- [x] [Advanced Fetch](https://docs.axelor.com/adk/5.4/dev-guide/web-services/advanced.html#advanced-read)
- [x] [Delete](https://docs.axelor.com/adk/5.4/dev-guide/web-services/rest.html#update-a-record)
- [x] [Advanced Delete](https://docs.axelor.com/adk/5.4/dev-guide/web-services/advanced.html#advanced-delete)
- [x] [Create](https://docs.axelor.com/adk/5.4/dev-guide/web-services/rest.html#create-a-record)
- [x] [Update](https://docs.axelor.com/adk/5.4/dev-guide/web-services/rest.html#update-a-record)
- [ ] [Auth Services](https://docs.axelor.com/adk/5.4/dev-guide/web-services/auth.html) ⛏️
- [ ] [Document Services](https://docs.axelor.com/adk/5.4/dev-guide/web-services/dms.html) ⛏️
- [ ] [MetaData Services](https://docs.axelor.com/adk/5.4/dev-guide/web-services/meta.html) ⛏️
- [ ] [Action Service](https://docs.axelor.com/adk/5.4/dev-guide/web-services/advanced.html#action-service) ⛏️

## Advanced Use
- **Pagination**:
- **Token Refresh**:
- **Log Error**:
- **Retry logic**:

## Contributing
You can help us make this project better, feel free to open an new issue or a pull request.

