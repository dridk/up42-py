# :postbox: Ordering

**Order images and download them** via the ordering and assets. 
You can filter by various parameters e.g. time period, area of interest, cloud cover etc, using Catalog Search.
Then, you can order an image into the UP42 Storage and download it to inspect the result - all with the convenience of the UP42 Python SDK!

!!! Info "Supported Provider"
    Currently ordering supports these data providers: **OneAtlas**.


[![Binder](https://mybinder.org/badge_logo.svg)](https://mybinder.org/v2/gh/up42/up42-py/master?filepath=examples%2Fguides%2Fordering.ipynb)

## Initialize Catalog

```python
import up42
up42.authenticate(project_id="123", project_api_key="456")
#up42.authenticate(cfg_file="config.json")

catalog = up42.initialize_catalog()
```

## Search scenes in aoi

```python
aoi = up42.get_example_aoi(location="Berlin", as_dataframe=True)
#aoi = up42.read_vector_file("data/aoi_washington.geojson", 
#                            as_dataframe=False)
```

```python
search_parameters = catalog.construct_parameters(geometry=aoi, 
                                                 start_date="2018-01-01",
                                                 end_date="2020-12-31",
                                                 sensors=["pleiades"],
                                                 max_cloudcover=5,
                                                 sortby="cloudCoverage", 
                                                 limit=1)
# Select only immediately available images
# Use {"in": ["MINUTES", "HOURS"]} for archive data
search_parameters["query"]["deliveryTime"] = {"in": ["MINUTES"]}
search_results = catalog.search(search_parameters=search_parameters)
search_results
```

## Estimate the order price

```python
catalog.estimate_order(aoi, search_results.loc[0])
```

!!! Info "Catalog Search"
    For more detail on how to perform a catalog search, and additional options,
    go to [Catalog Search](./catalog.md).

## Place an order for the image, tracking it's status

```python
order = catalog.place_order(aoi, search_results.loc[0])
order.track_status()
```

## Get the assets or results of the order

```python
assets = order.get_assets()
assets[0].download()
```

You can also get previously ordered assets from UP42 Storage:

```python
storage = up42.initialize_storage()
assets = storage.get_assets()
```

<br>

!!! Success "Success!"
    Continue with the [Detailed Example](/guides/detailed-example/)!
