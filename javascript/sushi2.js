const os = require("os");
const readline = require("readline");

const initField = ({ rows, cols }) => {
  const outerFrame = cols => `+${"-".repeat(cols - 2)}+`;
  const lane = cols => `|${" ".repeat(cols - 2)}|`;
  const innerFrame = cols => `| +${"-".repeat(cols - 6)}+ |`;
  const inner = cols => `| |${" ".repeat(cols - 6)}| |`;

  return [
    outerFrame(cols),
    lane(cols),
    innerFrame(cols),
    ...Array(rows - 6).fill(inner(cols)),
    innerFrame(cols),
    lane(cols),
    outerFrame(cols)
  ];
};

const beltLength = ({ rows, cols }) => rows * 2 + cols * 2 - 12;

const initBelt = win => `sushi${" ".repeat(beltLength(win) - 5)}`;

const putForward = belt => n =>
  `${belt.slice(-n)}${belt.slice(0, belt.length - n)}`;

const EOT = ({ rows, cols }) => cols - 2;
const EOL = ({ rows, cols }) => cols + rows - 5;
const EOB = ({ rows, cols }) => cols * 2 + rows - 8;
const EOR = ({ rows, cols }) => cols * 2 + rows * 2 - 11;

const topLane = win => belt => belt.slice(0, EOT(win));
const leftLane = win => belt => belt.slice(EOT(win), EOL(win));
const bottomLane = win => belt => belt.slice(EOL(win), EOB(win));
const rightLane = win => belt => belt.slice(EOB(win), EOR(win));

const run = () => {
  let i = 0;

  const loop = () => {
    const win = { rows: process.stdout.rows, cols: process.stdout.columns };

    const field = initField(win);
    const belt = putForward(initBelt(win))(i);

    {
      const l = beltLength(win);
      i = i > l ? i - l : i;
    }

    readline.cursorTo(process.stdout, 0, 0);
    field.forEach(r => process.stdout.write(r));

    topLane(win)(belt)
      .split("")
      .forEach((c, i) => {
        readline.cursorTo(process.stdout, i + 1, 1);
        process.stdout.write(c);
      });
    leftLane(win)(belt)
      .split("")
      .forEach((c, i) => {
        readline.cursorTo(process.stdout, win.cols - 2, i + 1);
        process.stdout.write(c);
      });
    bottomLane(win)(belt)
      .split("")
      .forEach((c, i, lane) => {
        readline.cursorTo(process.stdout, lane.length - i + 1, win.rows - 2);
        process.stdout.write(c);
      });
    rightLane(win)(belt)
      .split("")
      .forEach((c, i, lane) => {
        readline.cursorTo(process.stdout, 1, lane.length - i + 1);
        process.stdout.write(c);
      });

    i = i + 1;
  };

  // Hide cursor
  process.stdout.write("\x1b[?25l");

  readline.emitKeypressEvents(process.stdin);
  if (process.stdin.isTTY) process.stdin.setRawMode(true);

  readline.cursorTo(process.stdout, 0, 0);
  readline.clearScreenDown(process.stdout);
  const intervalId = setInterval(loop, 15);

  process.stdin.on("keypress", (c, k) => {
    if (k.name === "q" || k.name === "escape") {
      clearInterval(intervalId);

      readline.cursorTo(process.stdout, 0, process.stdout.rows + 1);
      readline.clearLine(process.stdout, 0);
      process.stdout.write("Bye!" + os.EOL);

      process.exit();
    }
  });
};

run();
