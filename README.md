# Essential Feed iOS Application

![CI-iOS](https://github.com/fserrazes/EssentialFeed/actions/workflows/CI-iOS.yml/badge.svg)
![CI-macOS](https://github.com/fserrazes/EssentialFeed/actions/workflows/CI-macOS.yml/badge.svg)
![iOS](https://img.shields.io/badge/iOS-16.0-orange.svg)
![macOS](https://img.shields.io/badge/macOS-13+-orange.svg)

## Test Coverage Stats

| Module           | Tests | Lines | Coverage |
|------------------|-------|-------|----------|
| EssentialApp     |  48   | 555   | 93,0%    |
| EssentialFeed    |  96   | 476   | 98,7%    |
| EssentialFeediOS |   7   | 410   | 97,1%    |

## Requirements

## Behaviour Driven Development Specs (BDD)

### Story: Customer requests to see their image feed

### Narrative #1

```
As an online customer
I want the app to automatically load my latest image feed
So I can always enjoy the newest images of my friends
```

#### Scenarios (Acceptance criteria)

```
Given the customer has connectivity
When the customer requests to see their feed
  Then the app should display the latest feed from remote
  And replace the cache with the new feed
```

### Narrative #2

```
As an offline customer
I want the app to show the latest saved version of my image feed
So I can always enjoy images of my friends
```

#### Scenarios (Acceptance criteria)

```
Given the customer doesn't have connectivity
And there’s a cached version of the feed
   And the cache is less than seven days old
  When the customer requests to see the feed
  Then the app should display the latest feed saved

Given the customer doesn't have connectivity
And there’s a cached version of the feed
   And the cache is seven days old or more
  When the customer requests to see the feed
  Then the app should display an error message

 Given the customer doesn't have connectivity
   And the cache is empty
  When the customer requests to see the feed
  Then the app should display an error message
```

### Story: Customer requests to see image comments

### Narrative

```
As an online customer
I want the app to load image comments
So I can see how people are engaging with images in my feed
```

#### Scenarios (Acceptance criteria)

```
Given the customer has connectivity
 When the customer requests to see comments on an image
 Then the app should display all comments for that image
```

```
Given the customer doesn't have connectivity
 When the customer requests to see comments on an image
 Then the app should display an error message
```

## Use Cases

### Load Feed From Remote Use Case

#### Data:
- URL

#### Primary course (happy path):
1. Execute "Load Image Feed" command with above data.
2. System downloads data from the URL.
3. System validates downloaded data.
4. System creates image feed from valid data.
5. System delivers image feed.

#### Invalid data – error course (sad path):
1. System delivers invalid data error.

#### No connectivity – error course (sad path):
1. System delivers connectivity error.

---

### Load Feed Image Data From Remote Use Case

 #### Data:
 - URL

 #### Primary course (happy path):
 1. Execute "Load Image Data" command with above data.
 2. System downloads data from the URL.
 3. System validates downloaded data.
 4. System delivers image data.

 #### Cancel course:
 1. System does not deliver image data nor error.

 #### Invalid data – error course (sad path):
 1. System delivers invalid data error.

 #### No connectivity – error course (sad path):
 1. System delivers connectivity error.

---

 ### Load Feed From Cache Use Case

#### Primary course:
1. Execute "Load Image Feed" command with above data..
2. System retrieves feed data from cache.
3. System validates cache is less than seven days old.
4. System creates image feed from cached data.
5. System delivers image feed.

#### Error course (sad path):
 1. System delivers error.

#### Expired cache course (sad path):
1. System delivers no feed images.

#### Empty cache course (sad path):
1. System delivers no feed images.

---

### Load Feed Image Data From Cache Use Case

 #### Data:
 - URL

 #### Primary course (happy path):
 1. Execute "Load Image Data" command with above data.
 2. System retrieves data from the cache.
 3. System delivers cached image data.

 #### Cancel course:
 1. System does not deliver image data nor error.

#### Retrieval error course (sad path):
 1. System delivers error.

 #### Empty cache course (sad path):
 1. System delivers not found error.

---

### Validate Feed Cache Use Case

#### Primary course:
1. Execute "Validate Cache" command with above data..
2. System retrieves feed data from cache.
3. System validates cache is less than seven days old.

#### Error course (sad path):
 1. System deletes caches.

#### Expired cache course (sad path):
1. System deletes cache.

---

### Cache Feed Use Case

#### Data:
- Image Feed

#### Primary course (happy path):
1. Execute "Save Image Feed" command with above data.
2. System deletes old cache data.
3. System encodes image feed.
4. System timestamps the new cache.
5. System saves new cache data.
6. System delivers success message.

#### Deleting error course (sad path):
1. System delivers error.

#### Saving error course (sad path):
1. System delivers error.

---

### Flowchart

![Feed Loading Feature](./images/feed_flowchart.png)

## Model Specs

### Image Feed

| Property     | Type                 |
|--------------|--------------------- |
| `id`         | `UUID`               |
| `description`| `String` (optional)  |
| `location`   | `String` (optional)  |
| `url`        | `URL`                |

### Payload contract

```
GET /feed

200 RESPONSE

{
    "items": [
        {
            "id": "a UUID",
            "description": "a description",
            "location": "a location",
            "image": "https://a-image.url",
        },
        {
            "id": "another UUID",
            "description": "another description",
            "image": "https://another-image.url"
        },
        {
            "id": "even another UUID",
            "location": "even another location",
            "image": "https://even-another-image.url"
        },
        {
            "id": "yet another UUID",
            "image": "https://yet-another-image.url"
        }
        ...
    ]
}
```
### Load Image Comments From Remote Use Case

#### Data:
- ImageID

#### Primary course (happy path):
1. Execute "Load Image Comments" command with above data.
2. System loads data from remote service.
3. System validates data.
4. System creates comments from valid data.
5. System delivers comments.

#### Invalid data – error course (sad path):
1. System delivers invalid data error.

#### No connectivity – error course (sad path):
1. System delivers connectivity error.

---

## Model Specs

### Image Comment

| Property        | Type                    |
|-----------------|-------------------------|
| `id`            | `UUID`                  |
| `message` 	    | `String`			          |
| `created_at`    | `Date` (ISO8601 String) |
| `author` 		    | `CommentAuthorObject`   |

### Image Comment Author

| Property          | Type                |
|-------------------|---------------------|
| `username` 	      | `String`			      |

### Payload contract

```
GET /image/{image-id}/comments

2xx RESPONSE

{
	"items": [
		{
			"id": "a UUID",
			"message": "a message",
			"created_at": "2020-05-20T11:24:59+0000",
			"author": {
				"username": "a username"
			}
		},
		{
			"id": "another UUID",
			"message": "another message",
			"created_at": "2020-05-19T14:23:53+0000",
			"author": {
				"username": "another username"
			}
		},
		...
	]
}
```

## Architecture

![EssentialFeed](./.images/architecture_overview.png)

### Business Logic (loaders)

![Dependency Rejection](./.images/dependency-rejection.png)

### Presentation

The presentation were reused for both `Feed` and `Image Comments`

![Reusable Presentation](./.images/reusable-presentation.png)

### UI

Also, the same table view were reused to display the feed and comments

![Reusable UI](./.images/reusable-ui.png)
