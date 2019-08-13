#!/bin/bash 
 kubectl patch service my-app-bg -p '{"spec":{"selector":{"version":"v2.0.0"}}}'
 echo "Switch traffic v2"