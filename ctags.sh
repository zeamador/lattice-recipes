#!/bin/bash

# Run this to generate a tags file for vim.

ctags -R --exclude=.git --exclude=log . $(bundle list --paths)
