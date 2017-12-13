## Debug

```
helm install --dry-run --debug ./reactioncommerce > /tmp/manifest
```


## Makefile

#### install minikube

minikube, kubctl, and helm are updated often, it can't hurt to run this accordingly

```
make reqs
```


#### helm install .

this is the default for this makefile

```
make
```

#### make debug

you can also save a debug copy of what manifest file will be generated
using:

```
make debug
```

This will produce output pointing you to the saved manifest file in your
temp directory:

```
make debug
helm install --dry-run --debug . > /tmp/tmp.zZGCOwCCoqDOCKERTMP/manifest
ls -lh /tmp/tmp.zZGCOwCCoqDOCKERTMP/manifest
-rw-r--r-- 1 thoth thoth 5.0K Nov 22 15:44
/tmp/tmp.zZGCOwCCoqDOCKERTMP/manifest
```


#### Perftest

```
make timeme
```

How long to spin up the cluster?
Travis-CI builds it in just over two minutes:

```
Wait on Reactionetes to become available.....
hissing-manta-reactionetes-75ccf68d59-jsdrc   0/1       Running   3          1m
Reactionetes is now up and running.
	Command being timed: "bash ./bootstrap"
	User time (seconds): 11.17
	System time (seconds): 1.78
	Percent of CPU this job got: 9%
	Elapsed (wall clock) time (h:mm:ss or m:ss): 2:18.34
	Average shared text size (kbytes): 0
	Average unshared data size (kbytes): 0
	Average stack size (kbytes): 0
	Average total size (kbytes): 0
	Maximum resident set size (kbytes): 50612
	Average resident set size (kbytes): 0
	Major (requiring I/O) page faults: 118
	Minor (reclaiming a frame) page faults: 172368
	Voluntary context switches: 19451
	Involuntary context switches: 16907
	Swaps: 0
	File system inputs: 25184
	File system outputs: 1280448
	Socket messages sent: 0
	Socket messages received: 0
	Signals delivered: 0
	Page size (bytes): 4096
	Exit status: 0
```

This now waits on all three mongo containers to spin up and the
reactionetes container to be 'Running'.
