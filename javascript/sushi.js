const fn = require('./fn')
const mat = require('./matrix')
const readline = require('readline')

const lane = (width, height, laneStr) => {
  const top = laneStr.slice(0, width - 2).split('')
  const right = laneStr.slice(width - 2, width + height - 6).split('')
  const bottom = laneStr
    .slice(width + height - 6, width * 2 + height - 8)
    .split('')
    .reverse()
  const left = laneStr
    .slice(width * 2 + height - 8)
    .split('')
    .reverse()

  return { top, right, bottom, left }
}

const border = (topRow, rightCol, bottomRow, leftCol, insideMat) =>
  mat.matVConcat(
    [topRow],
    mat.matHConcat(mat.vector(leftCol), insideMat, mat.vector(rightCol)),
    [bottomRow]
  )

const frame = (width, height, laneStr) => {
  const horizontalEdge = ('+' + '-'.repeat(width - 2) + '+').split('')
  const verticalEdge = '|'.repeat(height - 2).split('')

  const insideMat = [
    '+' + '-'.repeat(width - 6) + '+',
    ...Array(height - 6).fill('|' + ' '.repeat(width - 6) + '|'),
    '+' + '-'.repeat(width - 6) + '+',
  ].map(str => str.split(''))

  const { top, right, bottom, left } = lane(width, height, laneStr)

  return border(
    horizontalEdge,
    verticalEdge,
    horizontalEdge,
    verticalEdge,
    border(top, right, bottom, left, insideMat)
  )
}

const laneLength = (width, height) => (width + height - 6) * 2

const loop = ({ str, n }) => {
  const width = process.stdout.columns
  const height = process.stdout.rows

  const initLaneStr = fn.replaceAt(
    0,
    str,
    ' '.repeat(laneLength(width, height))
  )
  const laneStr = initLaneStr.slice(-n).concat(initLaneStr.slice(0, -n))

  const frameMat = frame(width, height, laneStr)

  const frameStr = frameMat.map(row => row.join('')).join('\n')

  readline.cursorTo(process.stdout, 0, 0)
  process.stdout.write(frameStr)

  setTimeout(() => loop({ str, n: n + 1 }), 100)
}

const start = () => {
  const init = {
    str: 'sushi',
    n: 0,
  }
  loop(init)
}

start()
