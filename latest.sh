# kill running rails process
kill -9 $(cat tmp/pids/server.pid)
# sync latest code
git pull
# run rails server again
sudo nohup rails server -p 80 -b 0.0.0.0 &