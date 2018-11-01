const fn = require('./fn')

const matVConcat = (...mats) => [].concat(...mats)

const matHConcat = (...mats) => fn.map((...rows) => [].concat(...rows), ...mats)

const vector = arr => arr.map(n => [n])

const transpose = mat => matHConcat(...mat.map(row => vector(row)))

module.exports = {
  matVConcat,
  matHConcat,
  vector,
  transpose,
}
