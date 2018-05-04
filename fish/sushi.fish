#!/usr/bin/env fish

set columns $COLUMNS
set lines $LINES

clear


#
# screen size check
#

if test $columns -lt 11; or test $lines -lt 7
  echo \n\nmore than 11 columns and 7 lines required\n\n
  exit
end


#
# build lane
#

function repeat
  echo (echo $argv[1] | string repeat -n $argv[2])
end

set lane +(repeat - (math $columns - 2))+
set lane $lane '|'(repeat ' ' (math $columns - 2))'|'
set lane $lane '| +'(repeat - (math $columns - 6))'+ |'

for i in (seq (math $lines - 7))
  set lane $lane '| |'(repeat ' ' (math $columns - 6))'| |'
end

set lane $lane '| +'(repeat - (math $columns - 6))'+ |'
set lane $lane '|'(repeat ' ' (math $columns - 2))'|'
set lane $lane +(repeat - (math $columns - 2))+


#
# render lane
#

for l in $lane
  echo $l
end

