@dir = "/app/"

worker_processes 2
working_directory @dir

timeout 30

pid "/unicorn/unicorn.pid"
listen "/unicorn/unicorn.sock", :backlog => 64

stderr_path "/unicorn/logs/unicorn.stderr.log"
stdout_path "/unicorn/logs/unicorn.stdout.log"

