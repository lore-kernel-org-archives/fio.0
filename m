Return-Path: <fio-owner@vger.kernel.org>
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:34408 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750835Ab0IXIJw (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 24 Sep 2010 04:09:52 -0400
Message-ID: <4C9C5CB6.7000200@fusionio.com>
Date: Fri, 24 Sep 2010 10:09:26 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
Subject: Re: fio causes segfault after particular of random writes
References: <4C9B4A53.1080302@uni-rostock.de> <4C9C4BC4.9020503@fusionio.com>
In-Reply-To: <4C9C4BC4.9020503@fusionio.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Nikolaus Jeremic <nikolaus.jeremic@uni-rostock.de>
Cc: fio@vger.kernel.org

On 2010-09-24 08:57, Jens Axboe wrote:
> On 2010-09-23 14:38, Nikolaus Jeremic wrote:
>>  Hello,
>>
>> I am using  fio for benchmarking of SSDs and noticed that fio causes a
>> segfault after writing about 260000 MB with block size of 4069 bytes
>> at random in one job. Writing the same or just bigger amount of data
>> sequentially in 1 MB blocks works well. The situation is reproducible
>> with several fio versions, i.e. 1.34, 1.41, 1.43, 1.43.2 as of
>> 09/16/2010.
> 
> That's not good. To help me with this, please do:
> 
> - Edit the Makefile in fio, remove the -O2 in there.
> - make clean && make
> - Run ulimit -c10000000000 or something large like that
> - Now reproduce the problem. Fio will segfault again, and produce
>   a core file.
> - compress the fio executable and core file and send them to me.

One idea is that the logs grow way too large with your job descriptions.
You could try this patch, it'll prevent the log from overflowing. It
will also slow down the workload, a real fix would need to flush the log
out-of-line.

But give it a spin.

diff --git a/fio.c b/fio.c
index d20fc24..1306acf 100644
--- a/fio.c
+++ b/fio.c
@@ -1188,34 +1188,14 @@ static void *thread_main(void *data)
 	td->ts.io_bytes[1] = td->io_bytes[1];
 
 	fio_mutex_down(writeout_mutex);
-	if (td->ts.bw_log) {
-		if (td->o.bw_log_file) {
-			finish_log_named(td, td->ts.bw_log,
-						td->o.bw_log_file, "bw");
-		} else
-			finish_log(td, td->ts.bw_log, "bw");
-	}
-	if (td->ts.lat_log) {
-		if (td->o.lat_log_file) {
-			finish_log_named(td, td->ts.lat_log,
-						td->o.lat_log_file, "lat");
-		} else
-			finish_log(td, td->ts.lat_log, "lat");
-	}
-	if (td->ts.slat_log) {
-		if (td->o.lat_log_file) {
-			finish_log_named(td, td->ts.slat_log,
-						td->o.lat_log_file, "slat");
-		} else
-			finish_log(td, td->ts.slat_log, "slat");
-	}
-	if (td->ts.clat_log) {
-		if (td->o.lat_log_file) {
-			finish_log_named(td, td->ts.clat_log,
-						td->o.lat_log_file, "clat");
-		} else
-			finish_log(td, td->ts.clat_log, "clat");
-	}
+	if (td->ts.bw_log)
+		finish_log(td->ts.bw_log);
+	if (td->ts.lat_log)
+		finish_log(td->ts.lat_log);
+	if (td->ts.slat_log)
+		finish_log(td->ts.slat_log);
+	if (td->ts.clat_log)
+		finish_log(td->ts.clat_log);
 	fio_mutex_up(writeout_mutex);
 	if (td->o.exec_postrun)
 		exec_string(td->o.exec_postrun);
@@ -1680,8 +1660,8 @@ int main(int argc, char *argv[])
 		return 0;
 
 	if (write_bw_log) {
-		setup_log(&agg_io_log[DDIR_READ]);
-		setup_log(&agg_io_log[DDIR_WRITE]);
+		__setup_log(&agg_io_log[DDIR_READ], "agg-read_bw.log");
+		__setup_log(&agg_io_log[DDIR_WRITE], "agg-write_bw.log");
 	}
 
 	startup_mutex = fio_mutex_init(0);
@@ -1699,9 +1679,8 @@ int main(int argc, char *argv[])
 	if (!fio_abort) {
 		show_run_stats();
 		if (write_bw_log) {
-			__finish_log(agg_io_log[DDIR_READ], "agg-read_bw.log");
-			__finish_log(agg_io_log[DDIR_WRITE],
-					"agg-write_bw.log");
+			finish_log(agg_io_log[DDIR_READ]);
+			finish_log(agg_io_log[DDIR_WRITE]);
 		}
 	}
 
diff --git a/init.c b/init.c
index fe4dbf2..f13d3e4 100644
--- a/init.c
+++ b/init.c
@@ -578,12 +578,25 @@ static int add_job(struct thread_data *td, const char *jobname, int job_add_num)
 		goto err;
 
 	if (td->o.write_lat_log) {
-		setup_log(&td->ts.lat_log);
-		setup_log(&td->ts.slat_log);
-		setup_log(&td->ts.clat_log);
+		if (td->o.lat_log_file)
+			setup_log_named(&td->ts.lat_log, td->o.lat_log_file, "lat");
+		else
+			setup_log(td, &td->ts.lat_log, "lat");
+		if (td->o.lat_log_file)
+			setup_log_named(&td->ts.slat_log, td->o.lat_log_file, "slat");
+		else
+			setup_log(td, &td->ts.slat_log, "slat");
+		if (td->o.lat_log_file)
+			setup_log_named(&td->ts.clat_log, td->o.lat_log_file, "clat");
+		else
+			setup_log(td, &td->ts.clat_log, "clat");
+	}
+	if (td->o.write_bw_log) {
+		if (td->o.bw_log_file)
+			setup_log_named(&td->ts.bw_log, td->o.bw_log_file, "bw");
+		else
+			setup_log(td, &td->ts.bw_log, "bw");
 	}
-	if (td->o.write_bw_log)
-		setup_log(&td->ts.bw_log);
 
 	if (!td->o.name)
 		td->o.name = strdup(jobname);
diff --git a/iolog.h b/iolog.h
index c35ce1e..2b2aa66 100644
--- a/iolog.h
+++ b/iolog.h
@@ -30,6 +30,8 @@ struct io_log {
 	unsigned long nr_samples;
 	unsigned long max_samples;
 	struct io_sample *log;
+	char *log_name;
+	unsigned int max_log_mb;
 };
 
 enum {
@@ -95,10 +97,11 @@ extern void show_run_stats(void);
 extern void init_disk_util(struct thread_data *);
 extern void update_rusage_stat(struct thread_data *);
 extern void update_io_ticks(void);
-extern void setup_log(struct io_log **);
-extern void finish_log(struct thread_data *, struct io_log *, const char *);
-extern void finish_log_named(struct thread_data *, struct io_log *, const char *, const char *);
-extern void __finish_log(struct io_log *, const char *);
+extern void __setup_log(struct io_log **, const char *);
+extern void setup_log(struct thread_data *, struct io_log **, const char *);
+extern void setup_log_named(struct io_log **, const char *, const char *);
+extern void finish_log(struct io_log *);
+extern void flush_log(struct io_log *);
 extern struct io_log *agg_io_log[2];
 extern int write_bw_log;
 extern void add_agg_sample(unsigned long, enum fio_ddir, unsigned int);
diff --git a/log.c b/log.c
index 266dc06..22d2524 100644
--- a/log.c
+++ b/log.c
@@ -491,22 +491,39 @@ int init_iolog(struct thread_data *td)
 	return ret;
 }
 
-void setup_log(struct io_log **log)
+void __setup_log(struct io_log **log, const char *name)
 {
 	struct io_log *l = malloc(sizeof(*l));
 
 	l->nr_samples = 0;
 	l->max_samples = 1024;
 	l->log = malloc(l->max_samples * sizeof(struct io_sample));
+	l->log_name = strdup(name);
+	l->max_log_mb = 10;
 	*log = l;
 }
 
-void __finish_log(struct io_log *log, const char *name)
+void setup_log_named(struct io_log **log, const char *prefix,
+		     const char *postfix)
+{
+	char file_name[256], *p;
+
+	snprintf(file_name, 200, "%s_%s.log", prefix, postfix);
+	p = basename(file_name);
+	__setup_log(log, p);
+}
+
+void setup_log(struct thread_data *td, struct io_log **log, const char *name)
+{
+	setup_log_named(log, td->o.name, name);
+}
+
+void flush_log(struct io_log *log)
 {
 	unsigned int i;
 	FILE *f;
 
-	f = fopen(name, "a");
+	f = fopen(log->log_name, "a");
 	if (!f) {
 		perror("fopen log");
 		return;
@@ -520,21 +537,13 @@ void __finish_log(struct io_log *log, const char *name)
 	}
 
 	fclose(f);
-	free(log->log);
-	free(log);
-}
-
-void finish_log_named(struct thread_data *td, struct io_log *log,
-		       const char *prefix, const char *postfix)
-{
-	char file_name[256], *p;
-
-	snprintf(file_name, 200, "%s_%s.log", prefix, postfix);
-	p = basename(file_name);
-	__finish_log(log, p);
+	log->nr_samples = 0;
 }
 
-void finish_log(struct thread_data *td, struct io_log *log, const char *name)
+void finish_log(struct io_log *log)
 {
-	finish_log_named(td, log, td->o.name, name);
+	flush_log(log);
+	free(log->log);
+	free(log->log_name);
+	free(log);
 }
diff --git a/stat.c b/stat.c
index b5ff010..02a8ad9 100644
--- a/stat.c
+++ b/stat.c
@@ -730,13 +730,24 @@ static void __add_log_sample(struct io_log *iolog, unsigned long val,
 			     enum fio_ddir ddir, unsigned int bs,
 			     unsigned long time)
 {
-	const int nr_samples = iolog->nr_samples;
+	int nr_samples = iolog->nr_samples;
 
 	if (iolog->nr_samples == iolog->max_samples) {
-		int new_size = sizeof(struct io_sample) * iolog->max_samples*2;
-
-		iolog->log = realloc(iolog->log, new_size);
-		iolog->max_samples <<= 1;
+		int new_size;
+
+		new_size = sizeof(struct io_sample) * iolog->max_samples * 2;
+
+		/*
+		 * If it fits, increase log size and add entry. If not, flush
+		 * log
+		 */
+		if (new_size <= (iolog->max_log_mb * 1024 * 1024UL)) {
+			iolog->log = realloc(iolog->log, new_size);
+			iolog->max_samples <<= 1;
+		} else {
+			flush_log(iolog);
+			nr_samples = iolog->nr_samples;
+		}
 	}
 
 	iolog->log[nr_samples].val = val;

-- 
Jens Axboe

