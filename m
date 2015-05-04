Return-Path: <bfulton@google.com>
MIME-Version: 1.0
In-Reply-To: <5547D99E.4080103@kernel.dk>
References: <CAFFT=UmoooCznxAkUREsC5rGN-hxD++PYbL94s-m11jdycDM0w@mail.gmail.com>
	<5547D99E.4080103@kernel.dk>
Date: Mon, 4 May 2015 14:25:45 -0700
Message-ID: <CANff2=M1nm3GhJ-3RWVyzMHx9WE-SdO=eUUdwOKmC39HT9HQ-A@mail.gmail.com>
Subject: Re: [Bug report] Runtime, IOPS, bandwidth recorded incorrectly if
 small size with time_based
From: Brian Fulton <bfulton@google.com>
Content-Type: text/plain; charset=UTF-8
To: Jens Axboe <axboe@kernel.dk>
Cc: Akash Verma <akashv@google.com>, fio <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

Hi Jens,

I've been actively looking at this bug.  It was introduced with change
e5437a073e658e8154b9e87bab5c7b3b06ed4255
(https://github.com/axboe/fio/commit/e5437a073e658e8154b9e87bab5c7b3b06ed4255).

In this change, the time granularity was changed from microseconds to
milliseconds.  This change assumes that all loops take at least 1ms to
complete.  This is not always true and tests where the loop gets
processed, regularly, in sub-millisecond time result in many zeroes
being summed which, ultimately, causes a completely inaccurate
runtime.

I have a fix for this, but I want to verify that it doesn't break
anything as it is changing the way the runtime is being calculated.

We are using fio version 2.2.6, though this issue should still be
present in the latest version (2.2.7).


Below is a patch fix based of the latest version of fio 2.2.7:


From f74e28614bfc7fcc87a3e43b4583a44ec7641dac Mon Sep 17 00:00:00 2001
From: Brian Fulton <bfulton@google.com>
Date: Mon, 4 May 2015 14:09:13 -0700
Subject: [PATCH] Fix Runtime, IOPS, bandwidth recorded incorrectly if small
 size with time_based. Change runtime tabulation back to microseconds to
 handle sub millisecond loops.

---
 backend.c | 26 ++++++++++++++++++--------
 1 file changed, 18 insertions(+), 8 deletions(-)

diff --git a/backend.c b/backend.c
index 65a3e18..591bdf7 100644
--- a/backend.c
+++ b/backend.c
@@ -363,6 +363,19 @@ static inline int runtime_exceeded(struct
thread_data *td, struct timeval *t)
  return 0;
 }

+/*
+ * We need to update the runtime consistently in ms, but keep a running
+ * tally of the current elapsed time in microseconds for sub millisecond
+ * updates.
+ */
+static inline void update_runtime(struct thread_data *td,
+       unsigned long long *elapsed_us, const int ddir)
+{
+  td->ts.runtime[ddir] -= (elapsed_us[ddir] + 999) / 1000;
+  elapsed_us[ddir] += utime_since_now(&td->start);
+  td->ts.runtime[ddir] += (elapsed_us[ddir] + 999) / 1000;
+}
+
 static int break_on_this_error(struct thread_data *td, enum fio_ddir ddir,
        int *retptr)
 {
@@ -1306,7 +1319,7 @@ static void io_workqueue_fn(struct thread_data
*td, struct io_u *io_u)
  */
 static void *thread_main(void *data)
 {
- unsigned long long elapsed;
+ unsigned long long elapsed_us[DDIR_TRIM+1] = {0};
  struct thread_data *td = data;
  struct thread_options *o = &td->o;
  pthread_condattr_t attr;
@@ -1545,16 +1558,13 @@ static void *thread_main(void *data)

  fio_mutex_down(stat_mutex);
  if (td_read(td) && td->io_bytes[DDIR_READ]) {
- elapsed = mtime_since_now(&td->start);
- td->ts.runtime[DDIR_READ] += elapsed;
+ update_runtime(td, elapsed_us, DDIR_READ);
  }
  if (td_write(td) && td->io_bytes[DDIR_WRITE]) {
- elapsed = mtime_since_now(&td->start);
- td->ts.runtime[DDIR_WRITE] += elapsed;
+ update_runtime(td, elapsed_us, DDIR_WRITE);
  }
  if (td_trim(td) && td->io_bytes[DDIR_TRIM]) {
- elapsed = mtime_since_now(&td->start);
- td->ts.runtime[DDIR_TRIM] += elapsed;
+ update_runtime(td, elapsed_us, DDIR_TRIM);
  }
  fio_gettime(&td->start, NULL);
  fio_mutex_up(stat_mutex);
@@ -1579,7 +1589,7 @@ static void *thread_main(void *data)
  check_update_rusage(td);

  fio_mutex_down(stat_mutex);
- td->ts.runtime[DDIR_READ] += mtime_since_now(&td->start);
+ update_runtime(td, elapsed_us, DDIR_READ);
  fio_gettime(&td->start, NULL);
  fio_mutex_up(stat_mutex);

-- 
2.2.0.rc0.207.ga3a616c


I am currently performing regression tests on machines with this fix
to verify that the issues we were seeing are no longer present and to
verify that I didn't introduce any new issues.

- Brian



On Mon, May 4, 2015 at 1:42 PM, Jens Axboe <axboe@kernel.dk> wrote:
> On 04/24/2015 04:50 PM, Akash Verma wrote:
>>
>> If there's a load with a very small size, but forced to repeat using
>> time_based, the runtime reported at the end, as well as IOPS,
>> bandwidth are wrong.
>>
>> E.g. using this control file:
>>
>> [short_and_suite]
>> rw=randread
>> bs=128k
>> size=128k
>> ioengine=libaio
>> time_based=1
>> runtime=1
>> filename=datafile.tmp
>>
>> (where datafile.tmp already exists, for a more dramatic demonstration)
>> The results I'm seeing on a hard drive are:
>> read : io=304128KB, bw=24750MB/s, iops=198000, runt=    12msec
>>
>> This is a regression from FIO 2.0.5, which gives the following results:
>> read : io=242176KB, bw=242418KB/s, iops=1893 , runt=   999msec
>>
>> which is much more reasonable.
>
>
> Looks like a shorter run, try runtime=1s. And that makes me wonder if the
> default conversion is buggy. What version are you comparing 2.0.5 to?
>
> --
> Jens Axboe
>

