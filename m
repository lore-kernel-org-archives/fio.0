Return-Path: <axboe@kernel.dk>
Message-ID: <53BE5286.2060203@kernel.dk>
Date: Thu, 10 Jul 2014 10:44:54 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: fio hangs with --status-interval
References: <CAE56cDuAUkhEnjMqCSWDcWrdwJrbffMcDG+FeCw6+7GN+jrWUg@mail.gmail.com>
In-Reply-To: <CAE56cDuAUkhEnjMqCSWDcWrdwJrbffMcDG+FeCw6+7GN+jrWUg@mail.gmail.com>
Content-Type: multipart/mixed;
 boundary="------------000304060109040407050803"
To: Michael Mattsson <michael.mattsson@gmail.com>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

This is a multi-part message in MIME format.
--------------000304060109040407050803
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2014-07-10 00:56, Michael Mattsson wrote:
> Hey,
> I've got 8 identical CentOS 6.5 clients that randomly keeps hanging
> fio when using --status-interval. I've tried fio 2.1.4 and fio 2.1.10
> they both behave the same. I've also tried piping the output to tee
> instead of redirecting to a file. I also tried --output and specified
> output file, still same problem. My fio command runs through its tests
> flawlessly without --status-interval and exits cleanly every time.
> There could be anywhere from 0 to 5 clients that gets affected.
> Running strace on the process that seem hung yields the following
> output:
>
> $ strace -p 31055
> Process 31055 attached - interrupt to quit
> futex(0x7f346ede802c, FUTEX_WAIT, 1, NULL

Strange, it must be stuck on the stat mutex, but I don't immediately see 
why that would happen. Does the attached patch make any difference for 
you, both in getting rid of the hang but still producing output at the 
desired intervals?

-- 
Jens Axboe


--------------000304060109040407050803
Content-Type: text/x-patch;
 name="stat.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="stat.patch"

diff --git a/stat.c b/stat.c
index 979c8100d378..93316a239f7b 100644
--- a/stat.c
+++ b/stat.c
@@ -1466,11 +1466,12 @@ static void *__show_running_run_stats(void fio_unused *arg)
  * in the sig handler, but we should be disturbing the system less by just
  * creating a thread to do it.
  */
-void show_running_run_stats(void)
+int show_running_run_stats(void)
 {
 	pthread_t thread;
 
-	fio_mutex_down(stat_mutex);
+	if (fio_mutex_down_trylock(stat_mutex))
+		return 1;
 
 	if (!pthread_create(&thread, NULL, __show_running_run_stats, NULL)) {
 		int err;
@@ -1479,10 +1480,11 @@ void show_running_run_stats(void)
 		if (err)
 			log_err("fio: DU thread detach failed: %s\n", strerror(err));
 
-		return;
+		return 0;
 	}
 
 	fio_mutex_up(stat_mutex);
+	return 1;
 }
 
 static int status_interval_init;
@@ -1531,8 +1533,8 @@ void check_for_running_stats(void)
 			fio_gettime(&status_time, NULL);
 			status_interval_init = 1;
 		} else if (mtime_since_now(&status_time) >= status_interval) {
-			show_running_run_stats();
-			fio_gettime(&status_time, NULL);
+			if (!show_running_run_stats())
+				fio_gettime(&status_time, NULL);
 			return;
 		}
 	}
diff --git a/stat.h b/stat.h
index 2e46175053e8..82b8e973e4be 100644
--- a/stat.h
+++ b/stat.h
@@ -218,7 +218,7 @@ extern void show_group_stats(struct group_run_stats *rs);
 extern int calc_thread_status(struct jobs_eta *je, int force);
 extern void display_thread_status(struct jobs_eta *je);
 extern void show_run_stats(void);
-extern void show_running_run_stats(void);
+extern int show_running_run_stats(void);
 extern void check_for_running_stats(void);
 extern void sum_thread_stats(struct thread_stat *dst, struct thread_stat *src, int nr);
 extern void sum_group_stats(struct group_run_stats *dst, struct group_run_stats *src);

--------------000304060109040407050803--

