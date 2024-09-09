import readline
readline.write_history_file = lambda *args: None

del readline
