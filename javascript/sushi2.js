const os = require('os')
const readline = require('readline')

const initField = ({ rows, cols }) => {
  const outerFrame = `+${'-'.repeat(cols - 2)}+`
  const lane = `|${' '.repeat(cols - 2)}|`
  const innerFrame = `| +${'-'.repeat(cols - 6)}+ |`
  const inner = `| |${' '.repeat(cols - 6)}| |`

  return [
    outerFrame,
    lane,
    innerFrame,
    ...Array(rows - 6).fill(inner),
    innerFrame,
    lane,
    outerFrame,
  ]
}

const beltLength = ({ rows, cols }) => rows * 2 + cols * 2 - 12

const initBelt = win => `${' '.repeat(beltLength(win))}`

const setOnBelt = (n, str) => belt =>
  `${belt.slice(0, n)}${str}${belt.slice(n + str.length)}`

const splitBelt = ({ rows, cols }) => belt => {
  const EOT = cols - 2
  const EOL = cols + rows - 5
  const EOB = cols * 2 + rows - 8
  const EOR = cols * 2 + rows * 2 - 11

  return {
    top: belt.slice(0, EOT),
    left: belt.slice(EOT, EOL),
    bottom: belt.slice(EOL, EOB),
    right: belt.slice(EOB, EOR),
  }
}

const run = () => {
  let i = 0

  const index = (() => {
    let i = 0
    return win => {
      const l = beltLength(win)
      i = i > l ? i - l : i
      return i++
    }
  })()

  const loop = () => {
    const win = { rows: process.stdout.rows, cols: process.stdout.columns }

    {
      const l = beltLength(win)
      i = i > l ? i - l : i
    }

    const field = initField(win)
    const belt = setOnBelt(i, 'sushi')(initBelt(win))

    readline.cursorTo(process.stdout, 0, 0)
    field.forEach(r => process.stdout.write(r))

    const splitedBelt = splitBelt(win)(belt)

    splitedBelt.top.split('').forEach((c, i) => {
      readline.cursorTo(process.stdout, i + 1, 1)
      process.stdout.write(c)
    })
    splitedBelt.left.split('').forEach((c, i) => {
      readline.cursorTo(process.stdout, win.cols - 2, i + 1)
      process.stdout.write(c)
    })
    splitedBelt.bottom.split('').forEach((c, i, lane) => {
      readline.cursorTo(process.stdout, lane.length - i + 1, win.rows - 2)
      process.stdout.write(c)
    })
    splitedBelt.right.split('').forEach((c, i, lane) => {
      readline.cursorTo(process.stdout, 1, lane.length - i + 1)
      process.stdout.write(c)
    })

    i = i + 1
  }

  // Hide cursor
  process.stdout.write('\x1b[?25l')

  readline.emitKeypressEvents(process.stdin)
  if (process.stdin.isTTY) process.stdin.setRawMode(true)

  readline.cursorTo(process.stdout, 0, 0)
  readline.clearScreenDown(process.stdout)
  const intervalId = setInterval(loop, 15)

  process.stdin.on('keypress', (c, k) => {
    if (
      k.name === 'q' ||
      k.name === 'escape' ||
      (k.ctrl === true && (k.name === 'c' || k.name === 'd'))
    ) {
      clearInterval(intervalId)

      readline.cursorTo(process.stdout, 0, process.stdout.rows + 1)
      readline.clearLine(process.stdout, 0)
      process.stdout.write('Bye!' + os.EOL)

      // Show cursor
      process.stdout.write('\x1b[?25h')

      process.exit()
    }
  })
}

run()
