Return-Path: <fio-owner@vger.kernel.org>
Received: from pasmtpa.tele.dk ([80.160.77.114]:53804 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753118AbYJHLSZ (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 8 Oct 2008 07:18:25 -0400
Date: Wed, 8 Oct 2008 13:17:54 +0200
From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: BUG: option runtime not working during a particular failure mode.
Message-ID: <20081008111754.GO19428@kernel.dk>
References: <7a2ad2470810061504x2b973b80v3caa136d6d883dd8@mail.gmail.com> <20081007093014.GT19428@kernel.dk> <7a2ad2470810070928v6e016700rce84c79026489b11@mail.gmail.com> <20081008110106.GN19428@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081008110106.GN19428@kernel.dk>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Shawn Lewis <shawnlewis@google.com>
Cc: fio <fio@vger.kernel.org>

On Wed, Oct 08 2008, Jens Axboe wrote:
> On Tue, Oct 07 2008, Shawn Lewis wrote:
> > On Tue, Oct 7, 2008 at 2:30 AM, Jens Axboe <jens.axboe@oracle.com> wrote:
> > > On Mon, Oct 06 2008, Shawn Lewis wrote:
> > >> Hi,
> > >>
> > >> I have a random read load in which fio hung on a machine. It is
> > >> time_based with runtime=60. A few of the disks in question experienced
> > >> errors at the same time so I would expect fio to fail or stop after
> > >> 60- seconds.
> > >>
> > >> I haven't tried to debug this in depth yet. Jens I thought an answer
> > >> might jump out at you. If not I'll take a look.
> > >>
> > >> Full disclosure: I modified the config and the strace output to show
> > >> fewer disks then were actually being accessed.
> > >>
> > >> Here is the config file:
> > >> [sda-randomaccess]
> > >> filename=/export/sda3/
> > >> datafile.tmp
> > >> rw=randread
> > >> bs=64k
> > >> ioengine=sync
> > >> time_based=1
> > >> runtime=3600
> > >> bwavgtime=5000
> > >> direct=1
> > >> thread=1
> > >>
> > >> [sdb-randomaccess]
> > >> filename=/export/sdb3/datafile.tmp
> > >> rw=randread
> > >> bs=64k
> > >> ioengine=sync
> > >> time_based=1
> > >> runtime=3600
> > >> bwavgtime=5000
> > >> direct=1
> > >> thread=1
> > >>
> > >> [sdc-randomaccess]
> > >> filename=/export/sdc3/datafile.tmp
> > >> rw=randread
> > >> bs=64k
> > >> ioengine=sync
> > >> time_based=1
> > >> runtime=3600
> > >> bwavgtime=5000
> > >> direct=1
> > >> thread=1
> > >>
> > >> [sdd-randomaccess]
> > >> filename=/export/sdd3/datafile.tmp
> > >> rw=randread
> > >> bs=64k
> > >> ioengine=sync
> > >> time_based=1
> > >> runtime=3600
> > >> bwavgtime=5000
> > >> direct=1
> > >> thread=1
> > >>
> > >>
> > >> We get some hints from strace. It looks like we're just doing the
> > >> sig_alrm loop. But why aren't hitting runtime? Are the other threads
> > >> stopped already for some reason?
> > >>
> > >> static void sig_alrm(int sig)
> > >> {
> > >>         if (threads) {
> > >>                 update_io_ticks();
> > >>                 print_thread_status();
> > >>                 status_timer_arm();
> > >>         }
> > >> }
> > >
> > > Good question. What are the other threads doing, have you poked around
> > > to see what they are up to? You mention IO errors, so are some of the
> > > threads stuck in error handling or did they all exit? If they did exit,
> > > did they exit nicely or did they get killed by the kernel?
> > There was only one thread running as far as I could tell. I don't
> > think the kernel killed them.
> 
> Unless you have an oops in the kernel, they were likely not killed. What
> version of fio is this? Fio used to have problems detecting missing
> threads/processes, but it should be solid now.
> 
> I haven't been able to (artificially) reproduce this case. I guess, for
> safety, I could add a forced exit in the sigalrm loop if we exceeded
> ther untime (plus a little margin).

Something like this should force fio to quit, when it detects such a
situation. I guess it would be hard for you to reproduce this situation,
correct?


diff --git a/fio.c b/fio.c
index 773f106..1ba227e 100644
--- a/fio.c
+++ b/fio.c
@@ -71,7 +71,7 @@ void td_set_runstate(struct thread_data *td, int runstate)
 	td->runstate = runstate;
 }
 
-static void terminate_threads(int group_id)
+static void terminate_threads(int group_id, int force)
 {
 	struct thread_data *td;
 	int i;
@@ -88,7 +88,7 @@ static void terminate_threads(int group_id)
 			/*
 			 * if the thread is running, just let it exit
 			 */
-			if (td->runstate < TD_RUNNING)
+			if (td->runstate < TD_RUNNING || force)
 				kill(td->pid, SIGQUIT);
 			else {
 				struct ioengine_ops *ops = td->io_ops;
@@ -107,8 +107,32 @@ static void status_timer_arm(void)
 	setitimer(ITIMER_REAL, &itimer, NULL);
 }
 
+static int overtime(void)
+{
+	unsigned long elapsed;
+
+	if (!def_thread.o.timeout)
+		return 0;
+
+	/*
+	 * Allow for 10 seconds of slack, this is supposed to be a last
+	 * measure to make fio exit
+	 */
+	elapsed = mtime_since_genesis() / 1000;
+	if (elapsed > def_thread.o.timeout + 10) {
+		log_err("fio: runtime seems way exceeded, yet fio is still "
+			"alive. Forcing quit.\n");
+		terminate_threads(TERMINATE_ALL, 1);
+		return 1;
+	}
+
+	return 0;
+}
+
 static void sig_alrm(int fio_unused sig)
 {
+	if (overtime())
+		return;
 	if (threads) {
 		update_io_ticks();
 		print_thread_status();
@@ -121,7 +145,7 @@ static void sig_int(int sig)
 	if (threads) {
 		printf("\nfio: terminating on signal %d\n", sig);
 		fflush(stdout);
-		terminate_threads(TERMINATE_ALL);
+		terminate_threads(TERMINATE_ALL, 1);
 	}
 }
 
@@ -132,7 +156,7 @@ static void sig_ill(int fio_unused sig)
 
 	log_err("fio: illegal instruction. your cpu does not support "
 		"the sse4.2 instruction for crc32c\n");
-	terminate_threads(TERMINATE_ALL);
+	terminate_threads(TERMINATE_ALL, 1);
 	exit(4);
 }
 
@@ -631,7 +655,7 @@ sync_done:
 
 			if (check_min_rate(td, &comp_time)) {
 				if (exitall_on_terminate)
-					terminate_threads(td->groupid);
+					terminate_threads(td->groupid, 0);
 				td_verror(td, EIO, "check_min_rate");
 				break;
 			}
@@ -1053,7 +1077,7 @@ static void *thread_main(void *data)
 	}
 
 	if (exitall_on_terminate)
-		terminate_threads(td->groupid);
+		terminate_threads(td->groupid, 0);
 
 err:
 	if (td->error)
@@ -1189,7 +1213,7 @@ reaped:
 	}
 
 	if (*nr_running == cputhreads && !pending && realthreads)
-		terminate_threads(TERMINATE_ALL);
+		terminate_threads(TERMINATE_ALL, 0);
 }
 
 /*
diff --git a/fio.h b/fio.h
index 63cd83f..3ec0591 100644
--- a/fio.h
+++ b/fio.h
@@ -705,6 +705,7 @@ extern unsigned long done_secs;
 extern char *job_section;
 
 extern struct thread_data *threads;
+extern struct thread_data def_thread;
 
 #define td_read(td)		((td)->o.td_ddir & TD_DDIR_READ)
 #define td_write(td)		((td)->o.td_ddir & TD_DDIR_WRITE)

-- 
Jens Axboe

