# Ibento
A prrof of concept application for MSPF events, issues and notifications.

RFD: https://github.com/toyota-connected/mspf-rfd/blob/master/rfd/0001/README.md

### To run the server:
```
$ iex -S mix phx.server
```

### To generate some events quickly from browser:

```
http://localhost:4000/events/create?type=geofence_enter

http://localhost:4000/events/create?type=geofence_exit
```

### To fetch events from browser:

```
http://localhost:4000/events?type=GeofenceEnterEvent

http://localhost:4000/events?type=GeofenceExitEvent
```

### To run graphiql for the edge app:
```
http://localhost:4000/edge/graphiql
```

#### Example of a query to fetch events from edge:
```
query ListEvents {
   events(type: "GeofenceExitEvent") {
    id
    type
    correlation
    causation
    data
    metadata
  }
}
```

### To run graphiql for the core app:
```
http://localhost:4000/core/graphiql
```

#### Example of a query to generate events in core:
```
mutation PutEvent($input: PutEventInput!) {
  putEvent(input: $input) {
    event {
      id
    }
  }
}

### Query Variables
{
  "input": {
    "id": "b85faf89-6f81-4e5e-99be-5a50241c40b9",
    "type": "GeofenceEnterEvent",
    "data": "{\"geofence\":{\"id\":\"123456789\",\"something\":\"some data\"},\"vehicle\":{\"id\":\"abcd878787\",\"something\":\"some data\"},\"zone\":{\"id\":\"7654321\",\"something\":\"some data\"}}"
  }
}
```

#### Example of a query to fetch events in core:
```
query ListEvents {
  events(type: "GeofenceExitEvent") {
    id
    type
    correlation
    causation
    data
    metadata
    insertedAt
  }
}
```