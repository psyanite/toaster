### Upsert Store
```
mutation {
  upsertStore(
    zId: "sydney/le-le-meow-surry-hills", 
    zUrl: "https://www.zomato.com/sydney/le-le-meow-surry-hills",
    name: "Le Meow",
    phoneCountry: "+61",
    phoneNumber: "(02) 9211 3568",
    coverImage: "https://b.zmtcdn.com/data/reviews_photos/21e/cc0377b2af177b44aade56e1ed7eb21e_1542718407.jpg",
    addressFirstLine: null,
    addressSecondLine: null,
    addressStreetNumber: "83",
    addressStreetName: "Foveaux Street",
    cuisines: "Modern Australian, Cafe",
    location: "Super Hill",
    suburb: "Surry Hills",
    city: "Sydney",
    lat: -33.874001,
    lng: 151.208362,
    moreInfo: "Breakfast,Takeaway Available,No Alcohol Available",
    avgCost: 40,
    hours: "Mon~Closed$$$Tue~5:30pm - 10pm$$$Wed~5:30pm - 10pm$$$Thu~5:30pm - 10pm$$$Fri~11am-2pm, 5:30pm - 10pm$$$Sat~Closed$$$Sun~Closed"
  ) {
    id,
    name,
    coords {
      coordinates
    }
  } 
}
```
