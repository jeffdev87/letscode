import time

start_time = time.perf_counter()

sum_test = 0
for val in range(1, 2):
    sum_test += val

time.sleep(2)

end_time = time.perf_counter()

print(f"Total time {end_time - start_time:0.4f} seconds")
