{ Pathflow } = require 'pathflow'

CWD = process.cwd()
SRC = "#{CWD}/src"
LIB = "#{CWD}/lib"

Pathflow
  source: SRC
  target: LIB
  log: yes
