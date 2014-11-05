Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-qg0-f48.google.com ([209.85.192.48]:59744 "EHLO
	mail-qg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755585AbaKERKY (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 5 Nov 2014 12:10:24 -0500
Received: by mail-qg0-f48.google.com with SMTP id q108so12327749qgd.7
        for <fio@vger.kernel.org>; Wed, 05 Nov 2014 09:10:23 -0800 (PST)
Received: from vass-desktop (ool-18e4aba6.dyn.optonline.net. [24.228.171.166])
        by mx.google.com with ESMTPSA id s3sm3613491qat.4.2014.11.05.09.10.22
        for <fio@vger.kernel.org>
        (version=TLSv1.2 cipher=RC4-SHA bits=128/128);
        Wed, 05 Nov 2014 09:10:23 -0800 (PST)
Date: Wed, 5 Nov 2014 12:10:24 -0500
From: Vasily Tarasov <tarasov@vasily.name>
Subject: Fix for a race when fio prints I/O statistics periodically
Message-ID: <20141105171024.GC25731@vass-desktop>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="gj572EiMnwbLXET9"
Content-Disposition: inline
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org


--gj572EiMnwbLXET9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Below is the demonstration for the latest code in git:

Job-file:

[job]
filename=/dev/sda
rw=randread
blocksize=4096
direct=1
time_based=1
runtime=300
numjobs=16

Command line:

fio --output-format=json --status-interval=10  /tmp/job.file | tee /tmp/fio.out

After parsing json and printing per-job "read->runtime" and "read->iops" in two
columns, one can see this:

runtime iops
9854 4762
19861 4724
29867 4711
39873 4705
49880 4701
59886 4698
69894 4696
79900 4694
89907 4693
99913 4692
109919 4692
119926 4691
129933 4691
139940 4691
149946 4691
159953 4690
169959 4690
179966 4690
189972 4690
199978 4690
209984 4690
219990 4690
229996 4690
240002 4690
250009 4690
260015 4690
270021 4690
280027 4690
290033 4690
600043 2344 <--- You can see a spurious jump in runtime here
300001 4690

The problem is two-fold, IMHO:

1) td->ts.runtime[DDIR_READ/DDIR_WRITE/DDIR_TRIM] are set in microseconds
   instead of milliseconds in thread_main() function. The values are later
   converted to milliseconds (after exiting from the loop in thread_main()),
   but it is too late for the out-of-band access by the helper_thread
   (the one that prints periodic statistics).
   
2) The helper_thread in __show_running_run_stats() temporarily adds to
   td->ts.runtime[DDIR_READ/DDIR_WRITE/DDIR_TRIM]
   the time that has passed since the beginning of the loop (td->start).
   However, the same addition happens in thread_main() by the job
   thread and td->start is not reset atomically with this addition.
   As a result, the runtime can be added twice. (That's why in the output
   we see 600043, which is approximately twice larger than the  
   previous reading).

My proposal is to make the job threads updating both td->ts.runtime and
td->start atomically by using an already existing stat_mutex.
__show_running_run_stats() already takes this mutex where needed. 

A proposed patch is attached.


--gj572EiMnwbLXET9
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: inline; filename="running-stats-race.diff"

diff --git a/backend.c b/backend.c
index d19d870..d05faf4 100644
--- a/backend.c
+++ b/backend.c
@@ -1485,18 +1485,21 @@ static void *thread_main(void *data)
 
 		clear_state = 1;
 
+		fio_mutex_down(stat_mutex);
 		if (td_read(td) && td->io_bytes[DDIR_READ]) {
-			elapsed = utime_since_now(&td->start);
+			elapsed = mtime_since_now(&td->start);
 			td->ts.runtime[DDIR_READ] += elapsed;
 		}
 		if (td_write(td) && td->io_bytes[DDIR_WRITE]) {
-			elapsed = utime_since_now(&td->start);
+			elapsed = mtime_since_now(&td->start);
 			td->ts.runtime[DDIR_WRITE] += elapsed;
 		}
 		if (td_trim(td) && td->io_bytes[DDIR_TRIM]) {
-			elapsed = utime_since_now(&td->start);
+			elapsed = mtime_since_now(&td->start);
 			td->ts.runtime[DDIR_TRIM] += elapsed;
 		}
+		fio_gettime(&td->start, NULL);
+		fio_mutex_up(stat_mutex);
 
 		if (td->error || td->terminate)
 			break;
@@ -1512,16 +1515,16 @@ static void *thread_main(void *data)
 
 		do_verify(td, verify_bytes);
 
-		td->ts.runtime[DDIR_READ] += utime_since_now(&td->start);
+		fio_mutex_down(stat_mutex);
+		td->ts.runtime[DDIR_READ] += mtime_since_now(&td->start);
+		fio_gettime(&td->start, NULL);
+		fio_mutex_up(stat_mutex);
 
 		if (td->error || td->terminate)
 			break;
 	}
 
 	update_rusage_stat(td);
-	td->ts.runtime[DDIR_READ] = (td->ts.runtime[DDIR_READ] + 999) / 1000;
-	td->ts.runtime[DDIR_WRITE] = (td->ts.runtime[DDIR_WRITE] + 999) / 1000;
-	td->ts.runtime[DDIR_TRIM] = (td->ts.runtime[DDIR_TRIM] + 999) / 1000;
 	td->ts.total_run_time = mtime_since_now(&td->epoch);
 	td->ts.io_bytes[DDIR_READ] = td->io_bytes[DDIR_READ];
 	td->ts.io_bytes[DDIR_WRITE] = td->io_bytes[DDIR_WRITE];
diff --git a/stat.c b/stat.c
index 84d9eef..b7f3992 100644
--- a/stat.c
+++ b/stat.c
@@ -14,7 +14,7 @@
 #include "lib/getrusage.h"
 #include "idletime.h"
 
-static struct fio_mutex *stat_mutex;
+struct fio_mutex *stat_mutex;
 
 void update_rusage_stat(struct thread_data *td)
 {
diff --git a/stat.h b/stat.h
index 8aefe03..8b4416c 100644
--- a/stat.h
+++ b/stat.h
@@ -214,6 +214,8 @@ struct jobs_eta {
 	uint8_t run_str[];
 } __attribute__((packed));
 
+extern struct fio_mutex *stat_mutex;
+
 extern struct jobs_eta *get_jobs_eta(int force, size_t *size);
 
 extern void stat_init(void);

--gj572EiMnwbLXET9--
