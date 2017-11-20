#!/bin/sh

echo
echo "========================================"
echo "Press enter to see the server unit tests"
echo "========================================"
read -n 1 -s line

bash npm run unit

echo "========================================"
echo "press enter to see the server test run"
echo "========================================"
read -n 1 -s line

bash npm run test

echo "========================================"
echo "press enter to exit."
echo "========================================"
read -n 1 -s line
