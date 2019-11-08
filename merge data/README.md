# Merging and Indexing Data Setup

A Python simple python script and development environment to index and merge data for the fire-risk project.

## Setup and Run

Requirements:

- python3
- pip3
- docker and docker-compose

Steps:

```bash
# install requirements
$ cd elastic-kibana
$ sudo pip3 install -r requirements.txt
..
# make sure the script compiles
$ python3 merge_data.py --help
$ docker-compose up -d
...
# index data into local endpoint
$ python merge_data.py
```

## Authors

- David Goldstein [dgoldstein1](https://github.com/dgoldstein1)

