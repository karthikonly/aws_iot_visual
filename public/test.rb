# Optional: set the process name to something easy to type<br>$PROGRAM_NAME = "rubydaemon"<br>
# Make the current process into a daemon
Process.daemon()

# Once per second, log the current time to a file
loop do
  File.open("/Users/klakshminarayanan/enphase/ens-summit/public/output.log", "a") { |f| f.puts(Time.now) }
  sleep(1)
end