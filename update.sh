#!/bin/sh
(export $(cat config.env | xargs) && docker compose up -d)
