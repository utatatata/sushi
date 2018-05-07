#!/usr/bin/env fish

if true
  # columns and lines is never used later
  set -l columns $COLUMNS
  set -l lines $LINES

  # screen size check
  if test $columns -lt 11; or test $lines -lt 7
    echo more than 11 columns and 7 lines required
    exit
  end

  tput clear

  # instead use these 
  set lane_width (math $columns - 2)
  set lane_height (math $lines - 3)
end



#
# serialized position
#
# ----|
# |   |
# |----
#
# - top, bottom lane
# | right, left lane 
#

set top_max (math $lane_width - 2)
set right_max (math $top_max + $lane_height - 1)
set left_reverse_max (math $lane_height - 1)
set bottom_reverse_max (math $left_reverse_max + $lane_width - 1 )
set pos_max (math $lane_width \* 2 + $lane_height \* 2 - 5)

#
# build lane
#

function repeat
  echo (echo $argv[1] | string repeat -n $argv[2])
end

set lane +(repeat - $lane_width)+
set lane $lane '|'(repeat ' ' $lane_width)'|'
set lane $lane '| +'(repeat - (math $lane_width - 4))'+ |'

for i in (seq (math $lane_height - 4))
  set lane $lane '| |'(repeat ' ' (math $lane_width - 4))'| |'
end

set lane $lane '| +'(repeat - (math $lane_width - 4))'+ |'
set lane $lane '|'(repeat ' ' $lane_width)'|'
set lane $lane +(repeat - $lane_width)+


#
# render lane
#

for l in $lane
  echo $l
end


#
# set sushi
#

function toCoord
  set -l x_offset 1
  set -l y_offset 1

  set -l pos $argv[1]
  set -l reverse_pos (math $pos_max + 1 - $pos)

  set -l ret

  if test $pos -le $top_max
    set ret (math $pos + $x_offset) $y_offset
  else if  test $pos -le $right_max
    set ret (math $top_max + 1  + $x_offset) (math $pos - $top_max - 1 + $y_offset)
  else if test $reverse_pos -le $left_reverse_max
    set ret $x_offset (math $reverse_pos + $y_offset)
  else if test $reverse_pos -le $bottom_reverse_max
    set ret (math $reverse_pos - $left_reverse_max + $x_offset) (math $left_reverse_max + $y_offset)
  end

  echo $ret
end

function setDish
  set -l p (toCoord $argv[1] | tr ' ' \n)

  tput sc
  tput cup $p[2] $p[1]
  echo $argv[2]
  tput rc
end

set sushi_pos 0 1 2 3 4
set sushi s u s h i

# set sushi
for i in (seq 5)
  setDish $sushi_pos[$i] $sushi[$i]
end

set timer (date "+%s")

while true
  set -l now (date "+%s%N")
  if test $now -lt (math $timer + 200000000)
    continue
  end
  set timer $now

  # erase sushi
  for i in (seq 5)
    setDish $sushi_pos[$i] ' '
  end

  set -l old_pos (echo $sushi_pos | tr ' ' \n)
  set sushi_pos
  for pos in $old_pos
    set sushi_pos $sushi_pos (math (math $pos + 1) \% (math $pos_max + 1))
  end

  # set sushi
  for i in (seq 5)
    setDish $sushi_pos[$i] $sushi[$i]
  end
end
