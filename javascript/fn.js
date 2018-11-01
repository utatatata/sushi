const map = (f, ...xss) => xss[0].map((_, i) => f(...xss.map(xs => xs[i])))

const range = (start, end = null, step = 1) => {
  if (end === null) {
    end = start
    start = 0
  }
  step = Math.abs(step)
  step = end >= start ? step : -step
  const size = Math.floor(Math.abs(end - start) / Math.abs(step)) + 1

  return [...Array(size).keys()].map(i => start + step * i)
}

const replaceAt = (index, replacement, source) =>
  console.log(replacement) ||
  (
    source.substr(0, index) +
    replacement +
    source.substr(index + replacement.length)
  ).substr(0, source.length)

module.exports = {
  map,
  range,
  replaceAt,
}
