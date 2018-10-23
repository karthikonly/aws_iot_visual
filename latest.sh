# kill running rails process
kill -9 $(cat tmp/pids/server.pid)
# sync latest code
git pull
# run rails server again
sudo rails server -d -p 80 -b 0.0.0.0