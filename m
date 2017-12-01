Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:60380 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752166AbdLANAN (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 1 Dec 2017 08:00:13 -0500
Received: from [216.160.245.99] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1eKkvM-00040l-Mr
        for fio@vger.kernel.org; Fri, 01 Dec 2017 13:00:13 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20171201130002.642882C0137@kernel.dk>
Date: Fri,  1 Dec 2017 06:00:02 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 6c3fb04c80c3c241162e743a54761e5e896d4ba2:

  options: correct parser type for max_latency (2017-11-29 22:27:05 -0700)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to e1c325d25dd977c28c9489c542a51ee05dfc620e:

  io_u: don't account io issue blocks for verify backlog (2017-11-30 21:48:12 -0700)

----------------------------------------------------------------
Jens Axboe (20):
      io_u: use nsec value for buffer scramble
      io_u: tweak small content buffer scramble
      io_u: cleanup check_get_trim()
      io_u: speed up small_content_scramble()
      fio: add check rate flag
      client: ignore a client timeout, if the last thing we saw as a trigger
      server: process connection list before executing trigger
      steadystate: make flags conform to usual fio standard
      Bump support of zones to 256 max
      options: don't overrun bssplit array
      Documentation cleanup
      gettime-thread: fix failure to check setaffinity return value
      backend: make it clear that we passed 'fd' to the new thread
      t/verify-state: fix leak in error case
      engines/dev-dax: fix leak of 'sfile' in error case
      client: fix use-after-free for client timeout
      ioengine: don't account verify bytes
      Documentation: add note about how many bssplit and zones fio supports
      options: warn if we exceed the supported number of split entries
      io_u: don't account io issue blocks for verify backlog

 HOWTO             | 54 ++++++++++++++++++++++++------------------
 backend.c         |  1 +
 client.c          | 16 +++++++++----
 client.h          |  1 +
 engines/dev-dax.c |  1 +
 fio.1             | 11 ++++++---
 fio.h             | 21 ++++++++++------
 gettime-thread.c  |  9 ++++++-
 init.c            |  8 +++++++
 io_u.c            | 71 +++++++++++++++++++++++++++++--------------------------
 ioengines.c       |  6 +++--
 libfio.c          |  2 +-
 options.c         | 15 +++++++-----
 server.c          | 11 +++++----
 stat.c            | 20 ++++++++--------
 steadystate.c     | 52 ++++++++++++++++++++--------------------
 steadystate.h     | 35 +++++++++++++++++----------
 t/verify-state.c  |  2 ++
 thread_options.h  |  2 +-
 19 files changed, 202 insertions(+), 136 deletions(-)

---

Diff of recent changes:

diff --git a/HOWTO b/HOWTO
index dc99e99..4caaf54 100644
--- a/HOWTO
+++ b/HOWTO
@@ -1293,6 +1293,9 @@ I/O type
 
 		random_distribution=zoned_abs=60/20G:30/100G:10/500g
 
+	For both **zoned** and **zoned_abs**, fio supports defining up to
+	256 separate zones.
+
 	Similarly to how :option:`bssplit` works for setting ranges and
 	percentages of block sizes. Like :option:`bssplit`, it's possible to
 	specify separate zones for reads, writes, and trims. If just one set
@@ -1388,34 +1391,39 @@ Block size
 
 .. option:: bssplit=str[,str][,str]
 
-	Sometimes you want even finer grained control of the block sizes issued, not
-	just an even split between them.  This option allows you to weight various
-	block sizes, so that you are able to define a specific amount of block sizes
-	issued. The format for this option is::
+	Sometimes you want even finer grained control of the block sizes
+	issued, not just an even split between them.  This option allows you to
+	weight various block sizes, so that you are able to define a specific
+	amount of block sizes issued. The format for this option is::
 
 		bssplit=blocksize/percentage:blocksize/percentage
 
-	for as many block sizes as needed. So if you want to define a workload that
-	has 50% 64k blocks, 10% 4k blocks, and 40% 32k blocks, you would write::
+	for as many block sizes as needed. So if you want to define a workload
+	that has 50% 64k blocks, 10% 4k blocks, and 40% 32k blocks, you would
+	write::
 
 		bssplit=4k/10:64k/50:32k/40
 
-	Ordering does not matter. If the percentage is left blank, fio will fill in
-	the remaining values evenly. So a bssplit option like this one::
+	Ordering does not matter. If the percentage is left blank, fio will
+	fill in the remaining values evenly. So a bssplit option like this one::
 
 		bssplit=4k/50:1k/:32k/
 
-	would have 50% 4k ios, and 25% 1k and 32k ios. The percentages always add up
-	to 100, if bssplit is given a range that adds up to more, it will error out.
+	would have 50% 4k ios, and 25% 1k and 32k ios. The percentages always
+	add up to 100, if bssplit is given a range that adds up to more, it
+	will error out.
 
 	Comma-separated values may be specified for reads, writes, and trims as
 	described in :option:`blocksize`.
 
-	If you want a workload that has 50% 2k reads and 50% 4k reads, while having
-	90% 4k writes and 10% 8k writes, you would specify::
+	If you want a workload that has 50% 2k reads and 50% 4k reads, while
+	having 90% 4k writes and 10% 8k writes, you would specify::
 
 		bssplit=2k/50:4k/50,4k/90,8k/10
 
+	Fio supports defining up to 64 different weights for each data
+	direction.
+
 .. option:: blocksize_unaligned, bs_unaligned
 
 	If set, fio will issue I/O units with any size within
@@ -2950,20 +2958,20 @@ Measurements and reporting
 
 .. option:: percentile_list=float_list
 
-	Overwrite the default list of percentiles for completion latencies and the
-	block error histogram.  Each number is a floating number in the range
-	(0,100], and the maximum length of the list is 20. Use ``:`` to separate the
-	numbers, and list the numbers in ascending order. For example,
-	``--percentile_list=99.5:99.9`` will cause fio to report the values of
-	completion latency below which 99.5% and 99.9% of the observed latencies
-	fell, respectively.
+	Overwrite the default list of percentiles for completion latencies and
+	the block error histogram.  Each number is a floating number in the
+	range (0,100], and the maximum length of the list is 20. Use ``:`` to
+	separate the numbers, and list the numbers in ascending order. For
+	example, ``--percentile_list=99.5:99.9`` will cause fio to report the
+	values of completion latency below which 99.5% and 99.9% of the observed
+	latencies fell, respectively.
 
 .. option:: significant_figures=int
 
-	If using :option:`--output-format` of `normal`, set the significant figures 
-	to this	value. Higher values will yield more precise IOPS and throughput 
-	units, while lower values will round. Requires a minimum value of 1 and a 
-	maximum value of 10. Defaults to 4.
+	If using :option:`--output-format` of `normal`, set the significant
+	figures to this	value. Higher values will yield more precise IOPS and
+	throughput units, while lower values will round. Requires a minimum
+	value of 1 and a maximum value of 10. Defaults to 4.
 
 
 Error handling
diff --git a/backend.c b/backend.c
index 7cf9b38..10eb90e 100644
--- a/backend.c
+++ b/backend.c
@@ -2318,6 +2318,7 @@ reap:
 					nr_started--;
 					break;
 				}
+				fd = NULL;
 				ret = pthread_detach(td->thread);
 				if (ret)
 					log_err("pthread_detach: %s",
diff --git a/client.c b/client.c
index 11fa262..2b136a0 100644
--- a/client.c
+++ b/client.c
@@ -961,7 +961,7 @@ static void convert_ts(struct thread_stat *dst, struct thread_stat *src)
 	dst->ss_deviation.u.f 	= fio_uint64_to_double(le64_to_cpu(src->ss_deviation.u.i));
 	dst->ss_criterion.u.f 	= fio_uint64_to_double(le64_to_cpu(src->ss_criterion.u.i));
 
-	if (dst->ss_state & __FIO_SS_DATA) {
+	if (dst->ss_state & FIO_SS_DATA) {
 		for (i = 0; i < dst->ss_dur; i++ ) {
 			dst->ss_iops_data[i] = le64_to_cpu(src->ss_iops_data[i]);
 			dst->ss_bw_data[i] = le64_to_cpu(src->ss_bw_data[i]);
@@ -1666,6 +1666,8 @@ int fio_handle_client(struct fio_client *client)
 	dprint(FD_NET, "client: got cmd op %s from %s (pdu=%u)\n",
 		fio_server_op(cmd->opcode), client->hostname, cmd->pdu_len);
 
+	client->last_cmd = cmd->opcode;
+
 	switch (cmd->opcode) {
 	case FIO_NET_CMD_QUIT:
 		if (ops->quit)
@@ -1689,7 +1691,7 @@ int fio_handle_client(struct fio_client *client)
 		struct cmd_ts_pdu *p = (struct cmd_ts_pdu *) cmd->payload;
 
 		dprint(FD_NET, "client: ts->ss_state = %u\n", (unsigned int) le32_to_cpu(p->ts.ss_state));
-		if (le32_to_cpu(p->ts.ss_state) & __FIO_SS_DATA) {
+		if (le32_to_cpu(p->ts.ss_state) & FIO_SS_DATA) {
 			dprint(FD_NET, "client: received steadystate ring buffers\n");
 
 			size = le64_to_cpu(p->ts.ss_dur);
@@ -1901,16 +1903,19 @@ static int client_check_cmd_timeout(struct fio_client *client,
 	int ret = 0;
 
 	flist_for_each_safe(entry, tmp, &client->cmd_list) {
+		unsigned int op;
+
 		reply = flist_entry(entry, struct fio_net_cmd_reply, list);
 
 		if (mtime_since(&reply->ts, now) < FIO_NET_CLIENT_TIMEOUT)
 			continue;
 
+		op = reply->opcode;
 		if (!handle_cmd_timeout(client, reply))
 			continue;
 
 		log_err("fio: client %s, timeout on cmd %s\n", client->hostname,
-						fio_server_op(reply->opcode));
+						fio_server_op(op));
 		ret = 1;
 	}
 
@@ -1940,7 +1945,10 @@ static int fio_check_clients_timed_out(void)
 		else
 			log_err("fio: client %s timed out\n", client->hostname);
 
-		client->error = ETIMEDOUT;
+		if (client->last_cmd != FIO_NET_CMD_VTRIGGER)
+			client->error = ETIMEDOUT;
+		else
+			log_info("fio: ignoring timeout due to vtrigger\n");
 		remove_client(client);
 		ret = 1;
 	}
diff --git a/client.h b/client.h
index 394b685..90082a3 100644
--- a/client.h
+++ b/client.h
@@ -39,6 +39,7 @@ struct fio_client {
 	int port;
 	int fd;
 	unsigned int refs;
+	unsigned int last_cmd;
 
 	char *name;
 
diff --git a/engines/dev-dax.c b/engines/dev-dax.c
index 235a31e..b1f91a4 100644
--- a/engines/dev-dax.c
+++ b/engines/dev-dax.c
@@ -307,6 +307,7 @@ fio_devdax_get_file_size(struct thread_data *td, struct fio_file *f)
 	if (rc < 0) {
 		log_err("%s: fscanf on %s failed (%s)\n",
 			td->o.name, spath, strerror(errno));
+		fclose(sfile);
 		return 1;
 	}
 
diff --git a/fio.1 b/fio.1
index 01b4db6..54d1b0f 100644
--- a/fio.1
+++ b/fio.1
@@ -1090,6 +1090,9 @@ we can define an absolute zoning distribution with:
 random_distribution=zoned:60/10:30/20:8/30:2/40
 .RE
 .P
+For both \fBzoned\fR and \fBzoned_abs\fR, fio supports defining up to 256
+separate zones.
+.P
 Similarly to how \fBbssplit\fR works for setting ranges and percentages
 of block sizes. Like \fBbssplit\fR, it's possible to specify separate
 zones for reads, writes, and trims. If just one set is given, it'll apply to
@@ -1219,6 +1222,8 @@ If you want a workload that has 50% 2k reads and 50% 4k reads, while having
 .P
 bssplit=2k/50:4k/50,4k/90,8k/10
 .RE
+.P
+Fio supports defining up to 64 different weights for each data direction.
 .RE
 .TP
 .BI blocksize_unaligned "\fR,\fB bs_unaligned"
@@ -2639,9 +2644,9 @@ completion latency below which 99.5% and 99.9% of the observed latencies
 fell, respectively.
 .TP
 .BI significant_figures \fR=\fPint
-If using \fB\-\-output\-format\fR of `normal', set the significant figures 
-to this value. Higher values will yield more precise IOPS and throughput 
-units, while lower values will round. Requires a minimum value of 1 and a 
+If using \fB\-\-output\-format\fR of `normal', set the significant figures
+to this value. Higher values will yield more precise IOPS and throughput
+units, while lower values will round. Requires a minimum value of 1 and a
 maximum value of 10. Defaults to 4.
 .SS "Error handling"
 .TP
diff --git a/fio.h b/fio.h
index a44f1aa..6b184c2 100644
--- a/fio.h
+++ b/fio.h
@@ -88,6 +88,7 @@ enum {
 	__TD_F_REGROW_LOGS,
 	__TD_F_MMAP_KEEP,
 	__TD_F_DIRS_CREATED,
+	__TD_F_CHECK_RATE,
 	__TD_F_LAST,		/* not a real bit, keep last */
 };
 
@@ -108,6 +109,7 @@ enum {
 	TD_F_REGROW_LOGS	= 1U << __TD_F_REGROW_LOGS,
 	TD_F_MMAP_KEEP		= 1U << __TD_F_MMAP_KEEP,
 	TD_F_DIRS_CREATED	= 1U << __TD_F_DIRS_CREATED,
+	TD_F_CHECK_RATE		= 1U << __TD_F_CHECK_RATE,
 };
 
 enum {
@@ -610,8 +612,8 @@ enum {
 	TD_NR,
 };
 
-#define TD_ENG_FLAG_SHIFT	16
-#define TD_ENG_FLAG_MASK	((1U << 16) - 1)
+#define TD_ENG_FLAG_SHIFT	17
+#define TD_ENG_FLAG_MASK	((1U << 17) - 1)
 
 static inline void td_set_ioengine_flags(struct thread_data *td)
 {
@@ -700,8 +702,7 @@ static inline bool fio_fill_issue_time(struct thread_data *td)
 	return false;
 }
 
-static inline bool __should_check_rate(struct thread_data *td,
-				       enum fio_ddir ddir)
+static inline bool option_check_rate(struct thread_data *td, enum fio_ddir ddir)
 {
 	struct thread_options *o = &td->o;
 
@@ -715,13 +716,19 @@ static inline bool __should_check_rate(struct thread_data *td,
 	return false;
 }
 
+static inline bool __should_check_rate(struct thread_data *td,
+				       enum fio_ddir ddir)
+{
+	return (td->flags & TD_F_CHECK_RATE) != 0;
+}
+
 static inline bool should_check_rate(struct thread_data *td)
 {
-	if (td->bytes_done[DDIR_READ] && __should_check_rate(td, DDIR_READ))
+	if (__should_check_rate(td, DDIR_READ) && td->bytes_done[DDIR_READ])
 		return true;
-	if (td->bytes_done[DDIR_WRITE] && __should_check_rate(td, DDIR_WRITE))
+	if (__should_check_rate(td, DDIR_WRITE) && td->bytes_done[DDIR_WRITE])
 		return true;
-	if (td->bytes_done[DDIR_TRIM] && __should_check_rate(td, DDIR_TRIM))
+	if (__should_check_rate(td, DDIR_TRIM) && td->bytes_done[DDIR_TRIM])
 		return true;
 
 	return false;
diff --git a/gettime-thread.c b/gettime-thread.c
index cbb81dc..fc52236 100644
--- a/gettime-thread.c
+++ b/gettime-thread.c
@@ -42,10 +42,17 @@ struct gtod_cpu_data {
 static void *gtod_thread_main(void *data)
 {
 	struct fio_mutex *mutex = data;
+	int ret;
+
+	ret = fio_setaffinity(gettid(), fio_gtod_cpumask);
 
-	fio_setaffinity(gettid(), fio_gtod_cpumask);
 	fio_mutex_up(mutex);
 
+	if (ret == -1) {
+		log_err("gtod: setaffinity failed\n");
+		return NULL;
+	}
+
 	/*
 	 * As long as we have jobs around, update the clock. It would be nice
 	 * to have some way of NOT hammering that CPU with gettimeofday(),
diff --git a/init.c b/init.c
index 7c16b06..607f7e0 100644
--- a/init.c
+++ b/init.c
@@ -1112,6 +1112,7 @@ int ioengine_load(struct thread_data *td)
 static void init_flags(struct thread_data *td)
 {
 	struct thread_options *o = &td->o;
+	int i;
 
 	if (o->verify_backlog)
 		td->flags |= TD_F_VER_BACKLOG;
@@ -1141,6 +1142,13 @@ static void init_flags(struct thread_data *td)
 
 	if (o->mem_type == MEM_CUDA_MALLOC)
 		td->flags &= ~TD_F_SCRAMBLE_BUFFERS;
+
+	for (i = 0; i < DDIR_RWDIR_CNT; i++) {
+		if (option_check_rate(td, i)) {
+			td->flags |= TD_F_CHECK_RATE;
+			break;
+		}
+	}
 }
 
 static int setup_random_seeds(struct thread_data *td)
diff --git a/io_u.c b/io_u.c
index ebe82e1..44933a1 100644
--- a/io_u.c
+++ b/io_u.c
@@ -1615,22 +1615,19 @@ static bool check_get_trim(struct thread_data *td, struct io_u *io_u)
 {
 	if (!(td->flags & TD_F_TRIM_BACKLOG))
 		return false;
+	if (!td->trim_entries)
+		return false;
 
-	if (td->trim_entries) {
-		int get_trim = 0;
-
-		if (td->trim_batch) {
-			td->trim_batch--;
-			get_trim = 1;
-		} else if (!(td->io_hist_len % td->o.trim_backlog) &&
-			 td->last_ddir != DDIR_READ) {
-			td->trim_batch = td->o.trim_batch;
-			if (!td->trim_batch)
-				td->trim_batch = td->o.trim_backlog;
-			get_trim = 1;
-		}
-
-		if (get_trim && get_next_trim(td, io_u))
+	if (td->trim_batch) {
+		td->trim_batch--;
+		if (get_next_trim(td, io_u))
+			return true;
+	} else if (!(td->io_hist_len % td->o.trim_backlog) &&
+		     td->last_ddir != DDIR_READ) {
+		td->trim_batch = td->o.trim_batch;
+		if (!td->trim_batch)
+			td->trim_batch = td->o.trim_backlog;
+		if (get_next_trim(td, io_u))
 			return true;
 	}
 
@@ -1672,35 +1669,40 @@ static bool check_get_verify(struct thread_data *td, struct io_u *io_u)
  */
 static void small_content_scramble(struct io_u *io_u)
 {
-	unsigned int i, nr_blocks = io_u->buflen / 512;
-	uint64_t boffset, usec;
+	unsigned int i, nr_blocks = io_u->buflen >> 9;
 	unsigned int offset;
-	char *p, *end;
+	uint64_t boffset, *iptr;
+	char *p;
 
 	if (!nr_blocks)
 		return;
 
 	p = io_u->xfer_buf;
 	boffset = io_u->offset;
-	io_u->buf_filled_len = 0;
 
-	/* close enough for this purpose */
-	usec = io_u->start_time.tv_nsec >> 10;
+	if (io_u->buf_filled_len)
+		io_u->buf_filled_len = 0;
+
+	/*
+	 * Generate random index between 0..7. We do chunks of 512b, if
+	 * we assume a cacheline is 64 bytes, then we have 8 of those.
+	 * Scramble content within the blocks in the same cacheline to
+	 * speed things up.
+	 */
+	offset = (io_u->start_time.tv_nsec ^ boffset) & 7;
 
 	for (i = 0; i < nr_blocks; i++) {
 		/*
-		 * Fill the byte offset into a "random" start offset of
-		 * the buffer, given by the product of the usec time
-		 * and the actual offset.
+		 * Fill offset into start of cacheline, time into end
+		 * of cacheline
 		 */
-		offset = (usec ^ boffset) & 511;
-		offset &= ~(sizeof(uint64_t) - 1);
-		if (offset >= 512 - sizeof(uint64_t))
-			offset -= sizeof(uint64_t);
-		memcpy(p + offset, &boffset, sizeof(boffset));
-
-		end = p + 512 - sizeof(io_u->start_time);
-		memcpy(end, &io_u->start_time, sizeof(io_u->start_time));
+		iptr = (void *) p + (offset << 6);
+		*iptr = boffset;
+
+		iptr = (void *) p + 64 - 2 * sizeof(uint64_t);
+		iptr[0] = io_u->start_time.tv_sec;
+		iptr[1] = io_u->start_time.tv_nsec;
+
 		p += 512;
 		boffset += 512;
 	}
@@ -1975,11 +1977,12 @@ static void io_completed(struct thread_data *td, struct io_u **io_u_ptr,
 		int ret;
 
 		td->io_blocks[ddir]++;
-		td->this_io_blocks[ddir]++;
 		td->io_bytes[ddir] += bytes;
 
-		if (!(io_u->flags & IO_U_F_VER_LIST))
+		if (!(io_u->flags & IO_U_F_VER_LIST)) {
+			td->this_io_blocks[ddir]++;
 			td->this_io_bytes[ddir] += bytes;
+		}
 
 		if (ddir == DDIR_WRITE)
 			file_log_write_comp(td, f, io_u->offset, bytes);
diff --git a/ioengines.c b/ioengines.c
index 02eaee8..7951ff3 100644
--- a/ioengines.c
+++ b/ioengines.c
@@ -309,8 +309,10 @@ int td_io_queue(struct thread_data *td, struct io_u *io_u)
 	}
 
 	if (ddir_rw(ddir)) {
-		td->io_issues[ddir]++;
-		td->io_issue_bytes[ddir] += buflen;
+		if (!(io_u->flags & IO_U_F_VER_LIST)) {
+			td->io_issues[ddir]++;
+			td->io_issue_bytes[ddir] += buflen;
+		}
 		td->rate_io_issue_bytes[ddir] += buflen;
 	}
 
diff --git a/libfio.c b/libfio.c
index c9bb8f3..74de735 100644
--- a/libfio.c
+++ b/libfio.c
@@ -366,7 +366,7 @@ int initialize_fio(char *envp[])
 	compiletime_assert((offsetof(struct jobs_eta, m_rate) % 8) == 0, "m_rate");
 
 	compiletime_assert(__TD_F_LAST <= TD_ENG_FLAG_SHIFT, "TD_ENG_FLAG_SHIFT");
-	compiletime_assert(BSSPLIT_MAX == ZONESPLIT_MAX, "bsssplit/zone max");
+	compiletime_assert(BSSPLIT_MAX <= ZONESPLIT_MAX, "bsssplit/zone max");
 
 	err = endian_check();
 	if (err) {
diff --git a/options.c b/options.c
index a224e7b..3fa646c 100644
--- a/options.c
+++ b/options.c
@@ -61,7 +61,8 @@ struct split {
 };
 
 static int split_parse_ddir(struct thread_options *o, struct split *split,
-			    enum fio_ddir ddir, char *str, bool absolute)
+			    enum fio_ddir ddir, char *str, bool absolute,
+			    unsigned int max_splits)
 {
 	unsigned long long perc;
 	unsigned int i;
@@ -109,8 +110,10 @@ static int split_parse_ddir(struct thread_options *o, struct split *split,
 		split->val1[i] = val;
 		split->val2[i] = perc;
 		i++;
-		if (i == ZONESPLIT_MAX)
+		if (i == max_splits) {
+			log_err("fio: hit max of %d split entries\n", i);
 			break;
+		}
 	}
 
 	split->nr = i;
@@ -126,7 +129,7 @@ static int bssplit_ddir(struct thread_options *o, enum fio_ddir ddir, char *str,
 
 	memset(&split, 0, sizeof(split));
 
-	if (split_parse_ddir(o, &split, ddir, str, data))
+	if (split_parse_ddir(o, &split, ddir, str, data, BSSPLIT_MAX))
 		return 1;
 	if (!split.nr)
 		return 0;
@@ -846,7 +849,7 @@ static int zone_split_ddir(struct thread_options *o, enum fio_ddir ddir,
 
 	memset(&split, 0, sizeof(split));
 
-	if (split_parse_ddir(o, &split, ddir, str, absolute))
+	if (split_parse_ddir(o, &split, ddir, str, absolute, ZONESPLIT_MAX))
 		return 1;
 	if (!split.nr)
 		return 0;
@@ -1127,9 +1130,9 @@ static int str_steadystate_cb(void *data, const char *str)
 		if (parse_dryrun())
 			return 0;
 
-		td->o.ss_state |= __FIO_SS_PCT;
+		td->o.ss_state |= FIO_SS_PCT;
 		td->o.ss_limit.u.f = val;
-	} else if (td->o.ss_state & __FIO_SS_IOPS) {
+	} else if (td->o.ss_state & FIO_SS_IOPS) {
 		if (!str_to_float(nr, &val, 0)) {
 			log_err("fio: steadystate IOPS threshold postfix parsing failed\n");
 			free(nr);
diff --git a/server.c b/server.c
index 967cebe..76d662d 100644
--- a/server.c
+++ b/server.c
@@ -616,7 +616,7 @@ static int fio_net_queue_quit(void)
 {
 	dprint(FD_NET, "server: sending quit\n");
 
-	return fio_net_queue_cmd(FIO_NET_CMD_QUIT, NULL, 0, NULL, SK_F_SIMPLE);
+	return fio_net_queue_cmd(FIO_NET_CMD_QUIT, NULL, 0, NULL, SK_F_SIMPLE | SK_F_INLINE);
 }
 
 int fio_net_send_quit(int sk)
@@ -636,7 +636,7 @@ static int fio_net_send_ack(struct fio_net_cmd *cmd, int error, int signal)
 
 	epdu.error = __cpu_to_le32(error);
 	epdu.signal = __cpu_to_le32(signal);
-	return fio_net_queue_cmd(FIO_NET_CMD_STOP, &epdu, sizeof(epdu), &tag, SK_F_COPY);
+	return fio_net_queue_cmd(FIO_NET_CMD_STOP, &epdu, sizeof(epdu), &tag, SK_F_COPY | SK_F_INLINE);
 }
 
 static int fio_net_queue_stop(int error, int signal)
@@ -951,7 +951,7 @@ static int handle_update_job_cmd(struct fio_net_cmd *cmd)
 	return 0;
 }
 
-static int handle_trigger_cmd(struct fio_net_cmd *cmd)
+static int handle_trigger_cmd(struct fio_net_cmd *cmd, struct flist_head *job_list)
 {
 	struct cmd_vtrigger_pdu *pdu = (struct cmd_vtrigger_pdu *) cmd->payload;
 	char *buf = (char *) pdu->cmd;
@@ -971,6 +971,7 @@ static int handle_trigger_cmd(struct fio_net_cmd *cmd)
 		fio_net_queue_cmd(FIO_NET_CMD_VTRIGGER, rep, sz, NULL, SK_F_FREE | SK_F_INLINE);
 
 	fio_terminate_threads(TERMINATE_ALL);
+	fio_server_check_jobs(job_list);
 	exec_trigger(buf);
 	return 0;
 }
@@ -1014,7 +1015,7 @@ static int handle_command(struct sk_out *sk_out, struct flist_head *job_list,
 		ret = handle_update_job_cmd(cmd);
 		break;
 	case FIO_NET_CMD_VTRIGGER:
-		ret = handle_trigger_cmd(cmd);
+		ret = handle_trigger_cmd(cmd, job_list);
 		break;
 	case FIO_NET_CMD_SENDFILE: {
 		struct cmd_sendfile_reply *in;
@@ -1555,7 +1556,7 @@ void fio_server_send_ts(struct thread_stat *ts, struct group_run_stats *rs)
 	convert_gs(&p.rs, rs);
 
 	dprint(FD_NET, "ts->ss_state = %d\n", ts->ss_state);
-	if (ts->ss_state & __FIO_SS_DATA) {
+	if (ts->ss_state & FIO_SS_DATA) {
 		dprint(FD_NET, "server sending steadystate ring buffers\n");
 
 		ss_buf = malloc(sizeof(p) + 2*ts->ss_dur*sizeof(uint64_t));
diff --git a/stat.c b/stat.c
index 48d8e7d..863aa45 100644
--- a/stat.c
+++ b/stat.c
@@ -743,12 +743,12 @@ static void show_ss_normal(struct thread_stat *ts, struct buf_output *out)
 	p2 = num2str(iops_mean, ts->sig_figs, 1, 0, N2S_NONE);
 
 	log_buf(out, "  steadystate  : attained=%s, bw=%s (%s), iops=%s, %s%s=%.3f%s\n",
-		ts->ss_state & __FIO_SS_ATTAINED ? "yes" : "no",
+		ts->ss_state & FIO_SS_ATTAINED ? "yes" : "no",
 		p1, p1alt, p2,
-		ts->ss_state & __FIO_SS_IOPS ? "iops" : "bw",
-		ts->ss_state & __FIO_SS_SLOPE ? " slope": " mean dev",
+		ts->ss_state & FIO_SS_IOPS ? "iops" : "bw",
+		ts->ss_state & FIO_SS_SLOPE ? " slope": " mean dev",
 		ts->ss_criterion.u.f,
-		ts->ss_state & __FIO_SS_PCT ? "%" : "");
+		ts->ss_state & FIO_SS_PCT ? "%" : "");
 
 	free(p1);
 	free(p1alt);
@@ -1353,19 +1353,19 @@ static struct json_object *show_thread_status_json(struct thread_stat *ts,
 		char ss_buf[64];
 
 		snprintf(ss_buf, sizeof(ss_buf), "%s%s:%f%s",
-			ts->ss_state & __FIO_SS_IOPS ? "iops" : "bw",
-			ts->ss_state & __FIO_SS_SLOPE ? "_slope" : "",
+			ts->ss_state & FIO_SS_IOPS ? "iops" : "bw",
+			ts->ss_state & FIO_SS_SLOPE ? "_slope" : "",
 			(float) ts->ss_limit.u.f,
-			ts->ss_state & __FIO_SS_PCT ? "%" : "");
+			ts->ss_state & FIO_SS_PCT ? "%" : "");
 
 		tmp = json_create_object();
 		json_object_add_value_object(root, "steadystate", tmp);
 		json_object_add_value_string(tmp, "ss", ss_buf);
 		json_object_add_value_int(tmp, "duration", (int)ts->ss_dur);
-		json_object_add_value_int(tmp, "attained", (ts->ss_state & __FIO_SS_ATTAINED) > 0);
+		json_object_add_value_int(tmp, "attained", (ts->ss_state & FIO_SS_ATTAINED) > 0);
 
 		snprintf(ss_buf, sizeof(ss_buf), "%f%s", (float) ts->ss_criterion.u.f,
-			ts->ss_state & __FIO_SS_PCT ? "%" : "");
+			ts->ss_state & FIO_SS_PCT ? "%" : "");
 		json_object_add_value_string(tmp, "criterion", ss_buf);
 		json_object_add_value_float(tmp, "max_deviation", ts->ss_deviation.u.f);
 		json_object_add_value_float(tmp, "slope", ts->ss_slope.u.f);
@@ -1381,7 +1381,7 @@ static struct json_object *show_thread_status_json(struct thread_stat *ts,
 		** otherwise it actually points to the second element
 		** in the list
 		*/
-		if ((ts->ss_state & __FIO_SS_ATTAINED) || !(ts->ss_state & __FIO_SS_BUFFER_FULL))
+		if ((ts->ss_state & FIO_SS_ATTAINED) || !(ts->ss_state & FIO_SS_BUFFER_FULL))
 			j = ts->ss_head;
 		else
 			j = ts->ss_head == 0 ? ts->ss_dur - 1 : ts->ss_head - 1;
diff --git a/steadystate.c b/steadystate.c
index 45d4f5d..05ce029 100644
--- a/steadystate.c
+++ b/steadystate.c
@@ -11,7 +11,7 @@ static void steadystate_alloc(struct thread_data *td)
 	td->ss.bw_data = calloc(td->ss.dur, sizeof(uint64_t));
 	td->ss.iops_data = calloc(td->ss.dur, sizeof(uint64_t));
 
-	td->ss.state |= __FIO_SS_DATA;
+	td->ss.state |= FIO_SS_DATA;
 }
 
 void steadystate_setup(void)
@@ -63,33 +63,33 @@ static bool steadystate_slope(uint64_t iops, uint64_t bw,
 	ss->bw_data[ss->tail] = bw;
 	ss->iops_data[ss->tail] = iops;
 
-	if (ss->state & __FIO_SS_IOPS)
+	if (ss->state & FIO_SS_IOPS)
 		new_val = iops;
 	else
 		new_val = bw;
 
-	if (ss->state & __FIO_SS_BUFFER_FULL || ss->tail - ss->head == ss->dur - 1) {
-		if (!(ss->state & __FIO_SS_BUFFER_FULL)) {
+	if (ss->state & FIO_SS_BUFFER_FULL || ss->tail - ss->head == ss->dur - 1) {
+		if (!(ss->state & FIO_SS_BUFFER_FULL)) {
 			/* first time through */
 			for(i = 0, ss->sum_y = 0; i < ss->dur; i++) {
-				if (ss->state & __FIO_SS_IOPS)
+				if (ss->state & FIO_SS_IOPS)
 					ss->sum_y += ss->iops_data[i];
 				else
 					ss->sum_y += ss->bw_data[i];
 				j = (ss->head + i) % ss->dur;
-				if (ss->state & __FIO_SS_IOPS)
+				if (ss->state & FIO_SS_IOPS)
 					ss->sum_xy += i * ss->iops_data[j];
 				else
 					ss->sum_xy += i * ss->bw_data[j];
 			}
-			ss->state |= __FIO_SS_BUFFER_FULL;
+			ss->state |= FIO_SS_BUFFER_FULL;
 		} else {		/* easy to update the sums */
 			ss->sum_y -= ss->oldest_y;
 			ss->sum_y += new_val;
 			ss->sum_xy = ss->sum_xy - ss->sum_y + ss->dur * new_val;
 		}
 
-		if (ss->state & __FIO_SS_IOPS)
+		if (ss->state & FIO_SS_IOPS)
 			ss->oldest_y = ss->iops_data[ss->head];
 		else
 			ss->oldest_y = ss->bw_data[ss->head];
@@ -102,7 +102,7 @@ static bool steadystate_slope(uint64_t iops, uint64_t bw,
 		 */
 		ss->slope = (ss->sum_xy - (double) ss->sum_x * ss->sum_y / ss->dur) /
 				(ss->sum_x_sq - (double) ss->sum_x * ss->sum_x / ss->dur);
-		if (ss->state & __FIO_SS_PCT)
+		if (ss->state & FIO_SS_PCT)
 			ss->criterion = 100.0 * ss->slope / (ss->sum_y / ss->dur);
 		else
 			ss->criterion = ss->slope;
@@ -137,24 +137,24 @@ static bool steadystate_deviation(uint64_t iops, uint64_t bw,
 	ss->bw_data[ss->tail] = bw;
 	ss->iops_data[ss->tail] = iops;
 
-	if (ss->state & __FIO_SS_BUFFER_FULL || ss->tail - ss->head == ss->dur - 1) {
-		if (!(ss->state & __FIO_SS_BUFFER_FULL)) {
+	if (ss->state & FIO_SS_BUFFER_FULL || ss->tail - ss->head == ss->dur - 1) {
+		if (!(ss->state & FIO_SS_BUFFER_FULL)) {
 			/* first time through */
 			for(i = 0, ss->sum_y = 0; i < ss->dur; i++)
-				if (ss->state & __FIO_SS_IOPS)
+				if (ss->state & FIO_SS_IOPS)
 					ss->sum_y += ss->iops_data[i];
 				else
 					ss->sum_y += ss->bw_data[i];
-			ss->state |= __FIO_SS_BUFFER_FULL;
+			ss->state |= FIO_SS_BUFFER_FULL;
 		} else {		/* easy to update the sum */
 			ss->sum_y -= ss->oldest_y;
-			if (ss->state & __FIO_SS_IOPS)
+			if (ss->state & FIO_SS_IOPS)
 				ss->sum_y += ss->iops_data[ss->tail];
 			else
 				ss->sum_y += ss->bw_data[ss->tail];
 		}
 
-		if (ss->state & __FIO_SS_IOPS)
+		if (ss->state & FIO_SS_IOPS)
 			ss->oldest_y = ss->iops_data[ss->head];
 		else
 			ss->oldest_y = ss->bw_data[ss->head];
@@ -163,14 +163,14 @@ static bool steadystate_deviation(uint64_t iops, uint64_t bw,
 		ss->deviation = 0.0;
 
 		for (i = 0; i < ss->dur; i++) {
-			if (ss->state & __FIO_SS_IOPS)
+			if (ss->state & FIO_SS_IOPS)
 				diff = ss->iops_data[i] - mean;
 			else
 				diff = ss->bw_data[i] - mean;
 			ss->deviation = max(ss->deviation, diff * (diff < 0.0 ? -1.0 : 1.0));
 		}
 
-		if (ss->state & __FIO_SS_PCT)
+		if (ss->state & FIO_SS_PCT)
 			ss->criterion = 100.0 * ss->deviation / mean;
 		else
 			ss->criterion = ss->deviation;
@@ -207,7 +207,7 @@ void steadystate_check(void)
 
 		if (!ss->dur || td->runstate <= TD_SETTING_UP ||
 		    td->runstate >= TD_EXITED || !ss->state ||
-		    ss->state & __FIO_SS_ATTAINED)
+		    ss->state & FIO_SS_ATTAINED)
 			continue;
 
 		td_iops = 0;
@@ -221,13 +221,13 @@ void steadystate_check(void)
 		prev_groupid = td->groupid;
 
 		fio_gettime(&now, NULL);
-		if (ss->ramp_time && !(ss->state & __FIO_SS_RAMP_OVER)) {
+		if (ss->ramp_time && !(ss->state & FIO_SS_RAMP_OVER)) {
 			/*
 			 * Begin recording data one second after ss->ramp_time
 			 * has elapsed
 			 */
 			if (utime_since(&td->epoch, &now) >= (ss->ramp_time + 1000000L))
-				ss->state |= __FIO_SS_RAMP_OVER;
+				ss->state |= FIO_SS_RAMP_OVER;
 		}
 
 		td_io_u_lock(td);
@@ -247,7 +247,7 @@ void steadystate_check(void)
 		 * prev_iops/bw the first time through after ss->ramp_time
 		 * is done.
 		 */
-		if (ss->state & __FIO_SS_RAMP_OVER) {
+		if (ss->state & FIO_SS_RAMP_OVER) {
 			group_bw += 1000 * (td_bytes - ss->prev_bytes) / rate_time;
 			group_iops += 1000 * (td_iops - ss->prev_iops) / rate_time;
 			++group_ramp_time_over;
@@ -255,7 +255,7 @@ void steadystate_check(void)
 		ss->prev_iops = td_iops;
 		ss->prev_bytes = td_bytes;
 
-		if (td->o.group_reporting && !(ss->state & __FIO_SS_DATA))
+		if (td->o.group_reporting && !(ss->state & FIO_SS_DATA))
 			continue;
 
 		/*
@@ -273,7 +273,7 @@ void steadystate_check(void)
 					(unsigned long long) group_bw,
 					ss->head, ss->tail);
 
-		if (ss->state & __FIO_SS_SLOPE)
+		if (ss->state & FIO_SS_SLOPE)
 			ret = steadystate_slope(group_iops, group_bw, td);
 		else
 			ret = steadystate_deviation(group_iops, group_bw, td);
@@ -282,12 +282,12 @@ void steadystate_check(void)
 			if (td->o.group_reporting) {
 				for_each_td(td2, j) {
 					if (td2->groupid == td->groupid) {
-						td2->ss.state |= __FIO_SS_ATTAINED;
+						td2->ss.state |= FIO_SS_ATTAINED;
 						fio_mark_td_terminate(td2);
 					}
 				}
 			} else {
-				ss->state |= __FIO_SS_ATTAINED;
+				ss->state |= FIO_SS_ATTAINED;
 				fio_mark_td_terminate(td);
 			}
 		}
@@ -314,7 +314,7 @@ int td_steadystate_init(struct thread_data *td)
 
 		ss->state = o->ss_state;
 		if (!td->ss.ramp_time)
-			ss->state |= __FIO_SS_RAMP_OVER;
+			ss->state |= FIO_SS_RAMP_OVER;
 
 		ss->sum_x = o->ss_dur * (o->ss_dur - 1) / 2;
 		ss->sum_x_sq = (o->ss_dur - 1) * (o->ss_dur) * (2*o->ss_dur - 1) / 6;
diff --git a/steadystate.h b/steadystate.h
index bbc3945..eaba0d7 100644
--- a/steadystate.h
+++ b/steadystate.h
@@ -41,19 +41,28 @@ struct steadystate_data {
 };
 
 enum {
-	__FIO_SS_IOPS		= 1,
-	__FIO_SS_BW		= 2,
-	__FIO_SS_SLOPE		= 4,
-	__FIO_SS_ATTAINED	= 8,
-	__FIO_SS_RAMP_OVER	= 16,
-	__FIO_SS_DATA		= 32,
-	__FIO_SS_PCT		= 64,
-	__FIO_SS_BUFFER_FULL	= 128,
-
-	FIO_SS_IOPS		= __FIO_SS_IOPS,
-	FIO_SS_IOPS_SLOPE	= __FIO_SS_IOPS | __FIO_SS_SLOPE,
-	FIO_SS_BW		= __FIO_SS_BW,
-	FIO_SS_BW_SLOPE		= __FIO_SS_BW | __FIO_SS_SLOPE,
+	__FIO_SS_IOPS = 0,
+	__FIO_SS_BW,
+	__FIO_SS_SLOPE,
+	__FIO_SS_ATTAINED,
+	__FIO_SS_RAMP_OVER,
+	__FIO_SS_DATA,
+	__FIO_SS_PCT,
+	__FIO_SS_BUFFER_FULL,
+};
+
+enum {
+	FIO_SS_IOPS		= 1 << __FIO_SS_IOPS,
+	FIO_SS_BW		= 1 << __FIO_SS_BW,
+	FIO_SS_SLOPE		= 1 << __FIO_SS_SLOPE,
+	FIO_SS_ATTAINED		= 1 << __FIO_SS_ATTAINED,
+	FIO_SS_RAMP_OVER	= 1 << __FIO_SS_RAMP_OVER,
+	FIO_SS_DATA		= 1 << __FIO_SS_DATA,
+	FIO_SS_PCT		= 1 << __FIO_SS_PCT,
+	FIO_SS_BUFFER_FULL	= 1 << __FIO_SS_BUFFER_FULL,
+
+	FIO_SS_IOPS_SLOPE	= FIO_SS_IOPS | FIO_SS_SLOPE,
+	FIO_SS_BW_SLOPE		= FIO_SS_BW | FIO_SS_SLOPE,
 };
 
 #define STEADYSTATE_MSEC	1000
diff --git a/t/verify-state.c b/t/verify-state.c
index 78a56da..734c1e4 100644
--- a/t/verify-state.c
+++ b/t/verify-state.c
@@ -119,10 +119,12 @@ static int show_file(const char *file)
 	if (ret < 0) {
 		log_err("read: %s\n", strerror(errno));
 		close(fd);
+		free(buf);
 		return 1;
 	} else if (ret != sb.st_size) {
 		log_err("Short read\n");
 		close(fd);
+		free(buf);
 		return 1;
 	}
 
diff --git a/thread_options.h b/thread_options.h
index 3532300..a9c3bee 100644
--- a/thread_options.h
+++ b/thread_options.h
@@ -26,7 +26,7 @@ enum fio_memtype {
 #define ERROR_STR_MAX	128
 
 #define BSSPLIT_MAX	64
-#define ZONESPLIT_MAX	64
+#define ZONESPLIT_MAX	256
 
 struct bssplit {
 	uint32_t bs;
