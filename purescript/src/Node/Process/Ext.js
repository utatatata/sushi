"use strict";


exports.columns = function() {
  return process.stdout.columns
}

exports.rows = function() {
  return process.stdout.rows
}

