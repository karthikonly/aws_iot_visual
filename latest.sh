# kill running rails process
kill -9 $(cat tmp/pids/server.pid)
# sync latest code
git pull
# run rails server again
rails server -d