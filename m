Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:48096 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932192AbaBFNAG (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 6 Feb 2014 08:00:06 -0500
Received: from kernel.dk ([54.225.238.116] helo=strynoevaenget.dk)
	by merlin.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1WBOYn-0006QE-7I
	for fio@vger.kernel.org; Thu, 06 Feb 2014 13:00:05 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20140206130003.3F0B045922@strynoevaenget.dk>
Date: Thu,  6 Feb 2014 06:00:03 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit bfca2c74b53e499acd8e97e9e56d3c40a5dd8b4f:

  init: update email address (2014-01-29 16:39:04 -0700)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 78a6469cfc9094763320e61c60f9aaef0ece9689:

  More precise fix for verify_backlog verification failure (2014-02-05 13:15:22 -0700)

----------------------------------------------------------------
Jens Axboe (2):
      Fix for prematurely stopping on verify
      More precise fix for verify_backlog verification failure

Puthikorn Voravootivat (2):
      Fix rand_seed mismatches in verify phase
      Fix verify_backlog start verification before finish writing

Stefan Hajnoczi (2):
      init: --minimal does not take an optional argument
      init: log error on missing --output-format argument

 backend.c |   32 ++++++++++++++++++++++++++++++--
 init.c    |    8 +++++++-
 io_u.c    |    7 ++++++-
 iolog.c   |    2 +-
 verify.c  |   17 +++++++++++++++--
 5 files changed, 59 insertions(+), 7 deletions(-)

---

Diff of recent changes:

diff --git a/backend.c b/backend.c
index 93e6632..62fa17c 100644
--- a/backend.c
+++ b/backend.c
@@ -642,7 +642,7 @@ static uint64_t do_io(struct thread_data *td)
 	uint64_t bytes_done[DDIR_RWDIR_CNT] = { 0, 0, 0 };
 	unsigned int i;
 	int ret = 0;
-	uint64_t bytes_issued = 0;
+	uint64_t total_bytes, bytes_issued = 0;
 
 	if (in_ramp_time(td))
 		td_set_runstate(td, TD_RAMP);
@@ -651,6 +651,16 @@ static uint64_t do_io(struct thread_data *td)
 
 	lat_target_init(td);
 
+	/*
+	 * If verify_backlog is enabled, we'll run the verify in this
+	 * handler as well. For that case, we may need up to twice the
+	 * amount of bytes.
+	 */
+	total_bytes = td->o.size;
+	if (td->o.verify != VERIFY_NONE &&
+	   (td_write(td) && td->o.verify_backlog))
+		total_bytes += td->o.size;
+
 	while ((td->o.read_iolog_file && !flist_empty(&td->io_log_list)) ||
 		(!flist_empty(&td->trim_list)) || !io_bytes_exceeded(td) ||
 		td->o.time_based) {
@@ -678,7 +688,7 @@ static uint64_t do_io(struct thread_data *td)
 		if (flow_threshold_exceeded(td))
 			continue;
 
-		if (bytes_issued >= (uint64_t) td->o.size)
+		if (bytes_issued >= total_bytes)
 			break;
 
 		io_u = get_io_u(td);
@@ -697,6 +707,13 @@ static uint64_t do_io(struct thread_data *td)
 		 */
 		if (td->o.verify != VERIFY_NONE && io_u->ddir == DDIR_READ &&
 		    ((io_u->flags & IO_U_F_VER_LIST) || !td_rw(td))) {
+
+			if (!td->o.verify_pattern_bytes) {
+				io_u->rand_seed = __rand(&td->__verify_state);
+				if (sizeof(int) != sizeof(long *))
+					io_u->rand_seed *= __rand(&td->__verify_state);
+			}
+
 			if (td->o.verify_async)
 				io_u->end_io = verify_io_u_async;
 			else
@@ -707,6 +724,17 @@ static uint64_t do_io(struct thread_data *td)
 		else
 			td_set_runstate(td, TD_RUNNING);
 
+		/*
+		 * Verify_backlog disabled: We need to log rand seed before the
+		 * actual IO to be able to replay it correctly in the verify phase.
+		 */
+		if (td_write(td) && io_u->ddir == DDIR_WRITE &&
+		    td->o.do_verify &&
+		    td->o.verify != VERIFY_NONE &&
+		    !td->o.experimental_verify &&
+		    !(td->flags & TD_F_VER_BACKLOG))
+			log_io_piece(td, io_u);
+
 		ret = td_io_queue(td, io_u);
 		switch (ret) {
 		case FIO_Q_COMPLETED:
diff --git a/init.c b/init.c
index cc35e2b..6c48d3a 100644
--- a/init.c
+++ b/init.c
@@ -100,7 +100,7 @@ static struct option l_opts[FIO_NR_OPTIONS] = {
 	},
 	{
 		.name		= (char *) "minimal",
-		.has_arg	= optional_argument,
+		.has_arg	= no_argument,
 		.val		= 'm' | FIO_CLIENT_FLAG,
 	},
 	{
@@ -1652,6 +1652,12 @@ int parse_cmd_line(int argc, char *argv[], int client_type)
 			output_format = FIO_OUTPUT_TERSE;
 			break;
 		case 'F':
+			if (!optarg) {
+				log_err("fio: missing --output-format argument\n");
+				exit_val = 1;
+				do_exit++;
+				break;
+			}
 			if (!strcmp(optarg, "minimal") ||
 			    !strcmp(optarg, "terse") ||
 			    !strcmp(optarg, "csv"))
diff --git a/io_u.c b/io_u.c
index 518d884..4264cd5 100644
--- a/io_u.c
+++ b/io_u.c
@@ -1623,10 +1623,15 @@ static void io_completed(struct thread_data *td, struct io_u *io_u,
 					 utime_since_now(&td->start));
 		}
 
+		/*
+		 * Verify_backlog enable: We need to log the write job after
+		 * finishing it to prevent verifying before finish writing.
+		 */
 		if (td_write(td) && idx == DDIR_WRITE &&
 		    td->o.do_verify &&
 		    td->o.verify != VERIFY_NONE &&
-		    !td->o.experimental_verify)
+		    !td->o.experimental_verify &&
+		    (td->flags & TD_F_VER_BACKLOG))
 			log_io_piece(td, io_u);
 
 		icd->bytes_done[idx] += bytes;
diff --git a/iolog.c b/iolog.c
index ec29971..017b235 100644
--- a/iolog.c
+++ b/iolog.c
@@ -209,7 +209,7 @@ void log_io_piece(struct thread_data *td, struct io_u *io_u)
 	 * drop the old one, which we rely on the rb insert/lookup for
 	 * handling.
 	 */
-	if ((!td_random(td) || !td->o.overwrite) &&
+	if (((!td->o.verifysort) || !td_random(td) || !td->o.overwrite) &&
 	      (file_randommap(td, ipo->file) || td->o.verify == VERIFY_NONE)) {
 		INIT_FLIST_HEAD(&ipo->list);
 		flist_add_tail(&ipo->list, &td->io_hist_list);
diff --git a/verify.c b/verify.c
index 568bae8..90cd093 100644
--- a/verify.c
+++ b/verify.c
@@ -72,10 +72,10 @@ void fill_verify_pattern(struct thread_data *td, void *p, unsigned int len,
 		if (use_seed)
 			__fill_random_buf(p, len, seed);
 		else
-			io_u->rand_seed = fill_random_buf(&td->buf_state, p, len);
+			io_u->rand_seed = fill_random_buf(&td->__verify_state, p, len);
 		return;
 	}
-	
+
 	if (io_u->buf_filled_len >= len) {
 		dprint(FD_VERIFY, "using already filled verify pattern b=%d len=%u\n",
 			td->o.verify_pattern_bytes, len);
@@ -718,6 +718,13 @@ int verify_io_u(struct thread_data *td, struct io_u *io_u)
 			memswp(p, p + td->o.verify_offset, header_size);
 		hdr = p;
 
+		/*
+		 * Make rand_seed check pass when have verifysort or
+		 * verify_backlog.
+		 */
+		if (td->o.verifysort || (td->flags & TD_F_VER_BACKLOG))
+			io_u->rand_seed = hdr->rand_seed;
+
 		ret = verify_header(io_u, hdr);
 		switch (ret) {
 		case 0:
@@ -1056,6 +1063,12 @@ int get_next_verify(struct thread_data *td, struct io_u *io_u)
 		remove_trim_entry(td, ipo);
 		free(ipo);
 		dprint(FD_VERIFY, "get_next_verify: ret io_u %p\n", io_u);
+
+		if (!td->o.verify_pattern_bytes) {
+			io_u->rand_seed = __rand(&td->__verify_state);
+			if (sizeof(int) != sizeof(long *))
+				io_u->rand_seed *= __rand(&td->__verify_state);
+		}
 		return 0;
 	}
 
