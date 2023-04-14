import multiprocessing as mp

def worker_function(item, q):
    """
    do some work, put results in queue
    """
    res = f'item: {item} - result: {item ** 2}'
    print(res)
    q.put(res)




def listener(output,q):
    """
    continue to listen for messages on the queue and writes to file when receive one
    if it receives a '#done#' message it will exit
    """
    with open(output, 'a') as f:
        while True:
            m = q.get()
            if m == '#done#':
                break
            f.write(str(m) + '\n')
            f.flush()


if __name__ == '__main__':
    manager = mp.Manager()
    q = manager.Queue()
    file_pool = mp.Pool(1)
    file_pool.apply_async(listener, ("bla",q, ))

    pool = mp.Pool(16)
    jobs = []
    for item in range(10):
        job = pool.apply_async(worker_function, (item, q))
        jobs.append(job)

    for job in jobs:
        job.get()

    q.put('#done#')  # all workers are done, we close the output file
    pool.close()
    pool.join()
