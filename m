Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:40250 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030744Ab2CPKI3 (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 16 Mar 2012 06:08:29 -0400
Message-ID: <4F6310F4.8000000@kernel.dk>
Date: Fri, 16 Mar 2012 11:07:48 +0100
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: [PATCH] time_based: Avoid restarting main I/O loop
References: <1331867567-25371-1-git-send-email-dehrenberg@google.com>
In-Reply-To: <1331867567-25371-1-git-send-email-dehrenberg@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Dan Ehrenberg <dehrenberg@google.com>
Cc: fio@vger.kernel.org, nauman@google.com, egouriou@google.com, tirea@google.com

On 03/16/2012 04:12 AM, Dan Ehrenberg wrote:
> Previously, when fio had written a volume of I/O equal to the size
> argument, it restarted the main do_io loop.
> 
> This patch allows time_based tests to be run for longer than one
> cycle in the do_io main loop. This has a couple of advantages:
>  * The random number generator is not reset on each iteration
>    of the loop, so running longer will reach different locations.
>  * There is not a throughput-reducing point where all operations
>    must be reaped before new operations are submitted.
> 
> The implementation consists of two minor changes:
>  * In the do_io loop, a time_based test will not exit the loop for
>    reading or writing too much data.
>  * When reading or writing sequentially, the operations wrap around
>    to the beginning after reading the end within the
>    get_next_seq_block function.

This looks good, but one question - does it really behave with random
IO, when the random map is enabled? I set write_iolog and looked at the
patterns. From the beginning:

foo.1.0 add
foo.1.0 open 
foo.1.0 read 8093696 4096
foo.1.0 read 99356672 4096
foo.1.0 read 113164288 4096
[...]
foo.1.0 close
foo.1.0 open 
foo.1.0 read 8093696 4096
foo.1.0 read 99356672 4096
foo.1.0 read 113164288 4096
[...]

etc. So it's definitely repeating the same sequence there. We don't want
to close/open the file for this case either, how does the below
look/work for you? It's your patch, and an update in
get_next_rand_block() to handle this case too.

diff --git a/backend.c b/backend.c
index 7343286..1d9b0a2 100644
--- a/backend.c
+++ b/backend.c
@@ -555,7 +555,8 @@ static void do_io(struct thread_data *td)
 		td_set_runstate(td, TD_RUNNING);
 
 	while ((td->o.read_iolog_file && !flist_empty(&td->io_log_list)) ||
-		(!flist_empty(&td->trim_list)) || !io_bytes_exceeded(td)) {
+		(!flist_empty(&td->trim_list)) || !io_bytes_exceeded(td) ||
+		td->o.time_based) {
 		struct timeval comp_time;
 		unsigned long bytes_done[2] = { 0, 0 };
 		int min_evts = 0;
diff --git a/io_u.c b/io_u.c
index 20794c3..3bda0e6 100644
--- a/io_u.c
+++ b/io_u.c
@@ -238,13 +238,18 @@ ret:
 static int get_next_rand_block(struct thread_data *td, struct fio_file *f,
 			       enum fio_ddir ddir, unsigned long long *b)
 {
-	if (get_next_rand_offset(td, f, ddir, b)) {
-		dprint(FD_IO, "%s: rand offset failed, last=%llu, size=%llu\n",
-				f->file_name, f->last_pos, f->real_file_size);
-		return 1;
+	if (!get_next_rand_offset(td, f, ddir, b))
+		return 0;
+
+	if (td->o.time_based) {
+		fio_file_reset(f);
+		if (!get_next_rand_offset(td, f, ddir, b))
+			return 0;
 	}
 
-	return 0;
+	dprint(FD_IO, "%s: rand offset failed, last=%llu, size=%llu\n",
+			f->file_name, f->last_pos, f->real_file_size);
+	return 1;
 }
 
 static int get_next_seq_block(struct thread_data *td, struct fio_file *f,
@@ -252,6 +257,9 @@ static int get_next_seq_block(struct thread_data *td, struct fio_file *f,
 {
 	assert(ddir_rw(ddir));
 
+	if (f->last_pos >= f->io_size && td->o.time_based)
+		f->last_pos = f->last_pos - f->io_size;
+
 	if (f->last_pos < f->real_file_size) {
 		unsigned long long pos;
 


-- 
Jens Axboe

