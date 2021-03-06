import "copy-hosts-file.pp"
import "create-hosts-file.pp"
import "install-zookeeper.pp"
import "install-kafka.pp"
import "install-storm.pp"
import "create-boss-scripts.pp"
import "create-worker-scripts.pp"
import "create-boss-supervisord-conf.pp"
import "create-worker-supervisord-conf.pp"
import "create-flush-queue-daemon-logdir.pp"
import "create-dbpedia-logdir.pp"
import "sync-time-worker.pp"
import "run-boss-servers.pp"
import "run-worker-servers.pp"

node '_BOSS_NAME_' {
  include copy-hosts-file
  include install-zookeeper
  include install-kafka
  include install-storm
  include create-boss-scripts
  include create-boss-supervisord-conf
  include create-flush-queue-daemon-logdir
  include run-boss-servers
}

node default {
  include sync-time-worker
  include create-hosts-file
  include install-storm
  include create-worker-scripts
  include create-worker-supervisord-conf
  include create-dbpedia-logdir
  include run-worker-servers
}
