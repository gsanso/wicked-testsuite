#! /bin/bash

action="$1"
text="$2"

logs=/var/log/testsuite
scenario=$logs/scenario
step=$scenario/step

function _usage
{
  echo "Usage: log.sh --reset|--results" >&2
  echo "              --scenario|--results <text>" >&2
  exit 1
}

function _reset
{
  rm -rf   $logs
  mkdir -p $logs

  date +'%Y-%m-%d %T.%6N' > $logs/date_begin
  ln -s scenario_001        $logs/scenario
}

function _results
{
  rm                        $logs/scenario
  date +'%Y-%m-%d %T.%6N' > $logs/date_end

  (cd /var/log && tar czvf /tmp/wicked_log.tgz testsuite)
}

function _scenario_begin
{
  local num
  [ -z "$text" ] && _usage

  num=$(readlink $scenario | sed 's/^scenario_//')
  mkdir $logs/scenario_$num

  date  +'%Y-%m-%d %T.%6N' > $scenario/date_begin
  echo  "$text"            > $scenario/name
  ln -s step_001             $scenario/step
}

function _scenario_end
{
  local num

  num=$(readlink $scenario | sed 's/^scenario_//')
  [ -d  $logs/scenario_$num ] || return

  rm                        $scenario/step
  date +'%Y-%m-%d %T.%6N' > $scenario/date_end

  num=$(printf "%03d\n" $((10#$num + 1)))
  rm                        $scenario
  ln -s scenario_$num       $scenario
}

function _step_begin
{
  local num
  [ -z "$text" ] && _usage

  num=$(readlink $step | sed 's/^step_//')
  mkdir $scenario/step_$num

  date +'%Y-%m-%d %T.%6N' > $step/date_begin
  echo "$text"            > $step/name
}

function _step_end
{
  local num beginning

  num=$(readlink $step | sed 's/^step_//')
  [ -d  $scenario/step_$num ] || return

  beginning=$(sed 's/\.[0-9]*$//' $logs/scenario/step/date_begin)
  journalctl -b -o short-precise --since="$beginning" | tail -n +2 \
                                > $step/journalctl.log
  wicked ifstatus --verbose all > $step/wicked_ifstatus.log
  wicked show-config            > $step/wicked_config.log
  wicked show-xml               > $step/wicked_xml.log
  ip addr show                  > $step/ip_addr.log
  ip route show table all       > $step/ip_route.log
  date +'%Y-%m-%d %T.%6N'       > $step/date_end

  num=$(printf "%03d\n" $((10#$num + 1)))
  rm                              $step
  ln -s step_$num                 $step
}

echo "$0 $@" >> $logs/history
case "$action" in
  "--reset")    _reset ;;
  "--scenario") _step_end; _scenario_end; _scenario_begin ;;
  "--step")     _step_end; _step_begin ;;
  "--results")  _step_end; _scenario_end; _results ;;
  *)            _usage ;;
esac
