#!/usr/bin/python

from argparse import ArgumentParser
from google.cloud import storage
from sys import argv


def main(argv):
    project_name = ''
    bucket_name = ''
    input_file = ''
    file_name = ''

    parser = ArgumentParser()
    parser.add_argument("project", help="Project name")
    parser.add_argument("bucket", help="Bucket name")
    parser.add_argument("input", help="Input filename")
    parser.add_argument("output", help="Bucket filename")
    args = parser.parse_args()

    storage_client = storage.Client(project=args.project)
    storage_bucket = storage_client.bucket(args.bucket)
    storage_blob = storage_bucket.blob(args.output)

    f = open(args.input, 'r')
    storage_blob.upload_from_string(f.read(), 'application/gzip')

    print(storage_blob.public_url)


if __name__ == "__main__":
    main(argv[1:])
