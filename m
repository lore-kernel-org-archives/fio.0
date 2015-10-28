Return-Path: <axboe@kernel.dk>
Subject: Re: FIO creating empty latency log files
References: <CAKPij3xg4=H0R506nT5gV7Lrz3Lpn_a3ML27F0ZNt6ws5svp-Q@mail.gmail.com>
 <562FE8E3.90106@kernel.dk>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <563014DE.60400@kernel.dk>
Date: Wed, 28 Oct 2015 09:20:46 +0900
MIME-Version: 1.0
In-Reply-To: <562FE8E3.90106@kernel.dk>
Content-Type: multipart/mixed;
 boundary="------------020301090600010104070205"
To: Buttetsu Batou <doubledense@gmail.com>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

This is a multi-part message in MIME format.
--------------020301090600010104070205
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/28/2015 06:13 AM, Jens Axboe wrote:
> On 10/28/2015 12:41 AM, Buttetsu Batou wrote:
>> On 06/04/2015 05:09 PM, Reed Crowe wrote:
>>> Using this version of FIO:
>>> * io-threads
>>>      master
>>> rcrowe@rcrowe-desktop:~/fio_iothreads/fio$ ./fio --version
>>> fio-2.2.7-14-g00b2
>>>
>>> I have a job file which looks like this:
>>>
>>> [global]
>>> ioengine=libaio
>>> direct=1
>>> numjobs=1
>>> bs=4k
>>> iodepth=300
>>> rw=randwrite
>>> randrepeat=0
>>> io_submit_mode=offload
>>> rate_iops=8070
>>> time_based=1
>>> runtime=1m
>>>
>>> [slow_write]
>>> filename=/mnt/test1/testfile.io
>>> write_lat_log=/tmp/fio_lat
>>>
>>> And it produces empty files:
>>> -rw-r--r-- 1 root   root         0 Jun  4 14:34 fio_lat_clat.1.log
>>> -rw-r--r-- 1 root   root         0 Jun  4 14:34 fio_lat_lat.1.log
>>> -rw-r--r-- 1 root   root         0 Jun  4 14:34 fio_lat_slat.1.log
>>>
>>> What am I missing?
>>
>> I am seeing this behavior in the latest release fio-2.2.10 and in
>> master fio-2.2.10-29-g8a68 but I am not using offload.
>>
>> Is anyone currently able to successfully generate log output? If so
>> could you share your fio version and your config?
>>
>> Here is the job file I am using at the moment.. have tried variations
>> on these settings and different fio versions back to 2.0.15 but always
>> the same empty output:
>>
>> [write]
>> group_reporting=1
>> numjobs=8
>> ioengine=posixaio
>> io_submit_mode=inline
>> stonewall
>> rw=write
>> bs=32k
>> time_based=1
>> runtime=10
>> filesize=64k
>> directory=/tmp
>> per_job_logs=1
>> write_bw_log=write_bw
>> write_iops_log=write_iops
>>
>> Updated the issue reported here:
>>
>> https://github.com/axboe/fio/issues/29
>>
>> Thank you for any ideas you may have!
>
> I think your issue is because you set filesize=64k. Your job basically
> sets up 8 files of 64k each, then writes to them for 10 seconds. This
> means that the fio main loop keeps re-entering for every 64k for each
> thread. The bandwidth/iops is averaged over a window of 500msec by
> default, and the main loop runs for much shorter than that since it only
> does 64k each time. Hence you never get logged any entries.
>
> Now, it should work. If you comment out these two lines:
>
> memcpy(&td->bw_sample_time, &td->start, sizeof(td->start));
> memcpy(&td->iops_sample_time, &td->start, sizeof(td->start));
>
> in backend.c around 1568/1569, then I suspect the logging should improve
> for you. I'll have to see if we can safely do that without making other
> changes, before committing a change like that.t

Try the attached patch, we need to retain the stat block and byte counts 
too.

-- 
Jens Axboe


--------------020301090600010104070205
Content-Type: text/x-patch;
 name="short-logging.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="short-logging.patch"

diff --git a/backend.c b/backend.c
index b180196e4c4e..5f3bbd44f3ea 100644
--- a/backend.c
+++ b/backend.c
@@ -1559,25 +1559,26 @@ static void *thread_main(void *data)
 
 	fio_gettime(&td->epoch, NULL);
 	fio_getrusage(&td->ru_start);
+	memcpy(&td->bw_sample_time, &td->epoch, sizeof(td->epoch));
+	memcpy(&td->iops_sample_time, &td->epoch, sizeof(td->epoch));
+
+	if (o->ratemin[DDIR_READ] || o->ratemin[DDIR_WRITE] ||
+			o->ratemin[DDIR_TRIM]) {
+	        memcpy(&td->lastrate[DDIR_READ], &td->bw_sample_time,
+					sizeof(td->bw_sample_time));
+	        memcpy(&td->lastrate[DDIR_WRITE], &td->bw_sample_time,
+					sizeof(td->bw_sample_time));
+	        memcpy(&td->lastrate[DDIR_TRIM], &td->bw_sample_time,
+					sizeof(td->bw_sample_time));
+	}
+
 	clear_state = 0;
 	while (keep_running(td)) {
 		uint64_t verify_bytes;
 
 		fio_gettime(&td->start, NULL);
-		memcpy(&td->bw_sample_time, &td->start, sizeof(td->start));
-		memcpy(&td->iops_sample_time, &td->start, sizeof(td->start));
 		memcpy(&td->tv_cache, &td->start, sizeof(td->start));
 
-		if (o->ratemin[DDIR_READ] || o->ratemin[DDIR_WRITE] ||
-				o->ratemin[DDIR_TRIM]) {
-		        memcpy(&td->lastrate[DDIR_READ], &td->bw_sample_time,
-						sizeof(td->bw_sample_time));
-		        memcpy(&td->lastrate[DDIR_WRITE], &td->bw_sample_time,
-						sizeof(td->bw_sample_time));
-		        memcpy(&td->lastrate[DDIR_TRIM], &td->bw_sample_time,
-						sizeof(td->bw_sample_time));
-		}
-
 		if (clear_state)
 			clear_io_state(td);
 
diff --git a/libfio.c b/libfio.c
index d4cad3ec5aba..d5110d4a1c2b 100644
--- a/libfio.c
+++ b/libfio.c
@@ -82,12 +82,14 @@ static void reset_io_counters(struct thread_data *td)
 	int ddir;
 
 	for (ddir = 0; ddir < DDIR_RWDIR_CNT; ddir++) {
+#if  0
 		td->stat_io_bytes[ddir] = 0;
 		td->this_io_bytes[ddir] = 0;
 		td->stat_io_blocks[ddir] = 0;
 		td->this_io_blocks[ddir] = 0;
 		td->rate_bytes[ddir] = 0;
 		td->rate_blocks[ddir] = 0;
+#endif
 		td->bytes_done[ddir] = 0;
 		td->rate_io_issue_bytes[ddir] = 0;
 		td->rate_next_io_time[ddir] = 0;

--------------020301090600010104070205--

