Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B25E3C433EF
	for <fio@archiver.kernel.org>; Fri,  4 Feb 2022 13:00:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242378AbiBDNAJ (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 4 Feb 2022 08:00:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240522AbiBDNAJ (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 4 Feb 2022 08:00:09 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89458C061714
        for <fio@vger.kernel.org>; Fri,  4 Feb 2022 05:00:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Date:Message-Id:To:From:Subject:Sender:
        Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=MYkbacVLyCVdXdOVW3tz90AHzbpnHpNiz1GDhAHWGzE=; b=lKmacUPUm9hwkRDtvq3fuoypI8
        jwH8M4bV/rHJUPkENC1B1Q4nB1rlpI/OJJLJwfhtms1GTAOrfrBUQCPHRIccixg4/cqrLsGMNzhMD
        zwnGFCo2UpYko1bfOoCJ4Apd+5yn3s4XF5YP4wMN0gpoWXmPddTXGy9PthLPCIppxRKbeNmVLugBJ
        ie9MrtkJUfQOCEnZ2TXnHvuq3QCMH2Ax0qnFwllmzeGAVRrNDKvfF69TAU/xRp2HwCFMvA/m3pBoz
        aQPURAiJOSWrz+7gY97xYmQhg6lD1Wazn7IAl+y0SJgdMehpaoz1r1mA9hFwaJr/jsQ6wRcE7tsXj
        kjui9LQQ==;
Received: from [207.135.234.126] (helo=kernel.dk)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nFyC5-006HhQ-6J
        for fio@vger.kernel.org; Fri, 04 Feb 2022 13:00:06 +0000
Received: by kernel.dk (Postfix, from userid 1000)
        id 5B9571BC011B; Fri,  4 Feb 2022 06:00:02 -0700 (MST)
Subject: Recent changes (master)
From:   Jens Axboe <axboe@kernel.dk>
To:     <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20220204130002.5B9571BC011B@kernel.dk>
Date:   Fri,  4 Feb 2022 06:00:02 -0700 (MST)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The following changes since commit 52a0b9ed71c3e929461e64b39059281948107071:

  Merge branch 'patch-1' of https://github.com/Nikratio/fio (2022-01-28 14:50:51 -0700)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 62e9ece4d540ff2af865e4b43811f3150b8b846b:

  fio: use correct function declaration for set_epoch_time() (2022-02-03 16:06:59 -0700)

----------------------------------------------------------------
David Korczynski (1):
      ci/Github actions: add CIFuzz integration

Jens Axboe (6):
      Merge branch 'master' of https://github.com/blah325/fio
      server: fix formatting issue
      Merge branch 'freebsd-comment-update' of https://github.com/macdice/fio
      Merge branch 'cifuzz-integration' of https://github.com/DavidKorczynski/fio
      Merge branch 'fio_pr_alternate_epoch' of https://github.com/PCPartPicker/fio
      fio: use correct function declaration for set_epoch_time()

Niklas Cassel (18):
      init: verify option lat_percentiles consistency for all jobs in group
      backend: do ioprio_set() before calling the ioengine init callback
      stat: save the default ioprio in struct thread_stat
      client/server: convert ss_data to use an offset instead of fixed position
      stat: add a new function to allocate a clat_prio_stat array
      os: define min/max prio class and level for systems without ioprio
      options: add a parsing function for an additional cmdprio_bssplit format
      cmdprio: add support for a new cmdprio_bssplit entry format
      examples: add new cmdprio_bssplit format examples
      stat: use enum fio_ddir consistently
      stat: increment members counter after call to sum_thread_stats()
      stat: add helper for resetting the latency buckets
      stat: disable per prio stats where not needed
      stat: report clat stats on a per priority granularity
      stat: convert json output to a new per priority granularity format
      gfio: drop support for high/low priority latency results
      stat: remove unused high/low prio struct members
      t/latency_percentiles.py: add tests for the new cmdprio_bssplit format

Thomas Munro (1):
      Update comments about availability of fdatasync().

aggieNick02 (1):
      Support for alternate epochs in fio log files

james rizzo (3):
      Avoid client calls to recv() without prior poll()
      Add Windows support for --server.
      Added a new windows only IO engine option “no_completion_thread”.

 .github/workflows/cifuzz.yml |  24 ++
 HOWTO                        |  41 +++-
 backend.c                    |  27 ++-
 cconv.c                      |   4 +
 client.c                     |  48 ++--
 engines/cmdprio.c            | 440 +++++++++++++++++++++++++++++------
 engines/cmdprio.h            |  22 +-
 engines/filecreate.c         |   2 +-
 engines/filedelete.c         |   2 +-
 engines/filestat.c           |   2 +-
 engines/windowsaio.c         | 134 +++++++++--
 examples/cmdprio-bssplit.fio |  39 +++-
 fio.1                        |  45 +++-
 fio.h                        |   2 +-
 fio_time.h                   |   2 +-
 gclient.c                    |  55 +----
 init.c                       |  37 +++
 io_u.c                       |   7 +-
 io_u.h                       |   3 +-
 libfio.c                     |   2 +-
 optgroup.h                   |   2 +
 options.c                    | 140 ++++++++++++
 os/os-windows.h              |   2 +
 os/os.h                      |   4 +
 os/windows/posix.c           | 182 ++++++++++++++-
 rate-submit.c                |  11 +-
 server.c                     | 369 +++++++++++++++++++++++++++---
 server.h                     |   7 +-
 stat.c                       | 531 ++++++++++++++++++++++++++++++++++---------
 stat.h                       |  40 +++-
 t/latency_percentiles.py     | 211 ++++++++++-------
 thread_options.h             |  14 ++
 time.c                       |  12 +-
 33 files changed, 2019 insertions(+), 444 deletions(-)
 create mode 100644 .github/workflows/cifuzz.yml

---

Diff of recent changes:

diff --git a/.github/workflows/cifuzz.yml b/.github/workflows/cifuzz.yml
new file mode 100644
index 00000000..acc8d482
--- /dev/null
+++ b/.github/workflows/cifuzz.yml
@@ -0,0 +1,24 @@
+name: CIFuzz
+on: [pull_request]
+jobs:
+  Fuzzing:
+    runs-on: ubuntu-latest
+    steps:
+    - name: Build Fuzzers
+      id: build
+      uses: google/oss-fuzz/infra/cifuzz/actions/build_fuzzers@master
+      with:
+        oss-fuzz-project-name: 'fio'
+        dry-run: false
+    - name: Run Fuzzers
+      uses: google/oss-fuzz/infra/cifuzz/actions/run_fuzzers@master
+      with:
+        oss-fuzz-project-name: 'fio'
+        fuzz-seconds: 600
+        dry-run: false
+    - name: Upload Crash
+      uses: actions/upload-artifact@v1
+      if: failure() && steps.build.outcome == 'success'
+      with:
+        name: artifacts
+        path: ./out/artifacts
diff --git a/HOWTO b/HOWTO
index c72ec8cd..74ba7216 100644
--- a/HOWTO
+++ b/HOWTO
@@ -1344,7 +1344,7 @@ I/O type
 .. option:: fdatasync=int
 
 	Like :option:`fsync` but uses :manpage:`fdatasync(2)` to only sync data and
-	not metadata blocks. In Windows, FreeBSD, DragonFlyBSD or OSX there is no
+	not metadata blocks. In Windows, DragonFlyBSD or OSX there is no
 	:manpage:`fdatasync(2)` so this falls back to using :manpage:`fsync(2)`.
 	Defaults to 0, which means fio does not periodically issue and wait for a
 	data-only sync to complete.
@@ -2212,10 +2212,28 @@ with the caveat that when used on the command line, they must come after the
 	depending on the block size of the IO. This option is useful only
 	when used together with the :option:`bssplit` option, that is,
 	multiple different block sizes are used for reads and writes.
-	The format for this option is the same as the format of the
-	:option:`bssplit` option, with the exception that values for
-	trim IOs are ignored. This option is mutually exclusive with the
-	:option:`cmdprio_percentage` option.
+
+	The first accepted format for this option is the same as the format of
+	the :option:`bssplit` option:
+
+		cmdprio_bssplit=blocksize/percentage:blocksize/percentage
+
+	In this case, each entry will use the priority class and priority
+	level defined by the options :option:`cmdprio_class` and
+	:option:`cmdprio` respectively.
+
+	The second accepted format for this option is:
+
+		cmdprio_bssplit=blocksize/percentage/class/level:blocksize/percentage/class/level
+
+	In this case, the priority class and priority level is defined inside
+	each entry. In comparison with the first accepted format, the second
+	accepted format does not restrict all entries to have the same priority
+	class and priority level.
+
+	For both formats, only the read and write data directions are supported,
+	values for trim IOs are ignored. This option is mutually exclusive with
+	the :option:`cmdprio_percentage` option.
 
 .. option:: fixedbufs : [io_uring]
 
@@ -3663,6 +3681,19 @@ Measurements and reporting
 	write_type_log for each log type, instead of the default zero-based
 	timestamps.
 
+.. option:: log_alternate_epoch=bool
+
+	If set, fio will log timestamps based on the epoch used by the clock specified
+	in the log_alternate_epoch_clock_id option, to the log files produced by
+	enabling write_type_log for each log type, instead of the default zero-based
+	timestamps.
+
+.. option:: log_alternate_epoch_clock_id=int
+
+	Specifies the clock_id to be used by clock_gettime to obtain the alternate epoch
+	if either log_unix_epoch or log_alternate_epoch are true. Otherwise has no
+	effect. Default value is 0, or CLOCK_REALTIME.
+
 .. option:: block_error_percentiles=bool
 
 	If set, record errors in trim block-sized units from writes and trims and
diff --git a/backend.c b/backend.c
index c167f908..061e3b32 100644
--- a/backend.c
+++ b/backend.c
@@ -1777,6 +1777,18 @@ static void *thread_main(void *data)
 	if (!init_iolog(td))
 		goto err;
 
+	/* ioprio_set() has to be done before td_io_init() */
+	if (fio_option_is_set(o, ioprio) ||
+	    fio_option_is_set(o, ioprio_class)) {
+		ret = ioprio_set(IOPRIO_WHO_PROCESS, 0, o->ioprio_class, o->ioprio);
+		if (ret == -1) {
+			td_verror(td, errno, "ioprio_set");
+			goto err;
+		}
+		td->ioprio = ioprio_value(o->ioprio_class, o->ioprio);
+		td->ts.ioprio = td->ioprio;
+	}
+
 	if (td_io_init(td))
 		goto err;
 
@@ -1789,16 +1801,6 @@ static void *thread_main(void *data)
 	if (o->verify_async && verify_async_init(td))
 		goto err;
 
-	if (fio_option_is_set(o, ioprio) ||
-	    fio_option_is_set(o, ioprio_class)) {
-		ret = ioprio_set(IOPRIO_WHO_PROCESS, 0, o->ioprio_class, o->ioprio);
-		if (ret == -1) {
-			td_verror(td, errno, "ioprio_set");
-			goto err;
-		}
-		td->ioprio = ioprio_value(o->ioprio_class, o->ioprio);
-	}
-
 	if (o->cgroup && cgroup_setup(td, cgroup_list, &cgroup_mnt))
 		goto err;
 
@@ -1828,7 +1830,7 @@ static void *thread_main(void *data)
 	if (rate_submit_init(td, sk_out))
 		goto err;
 
-	set_epoch_time(td, o->log_unix_epoch);
+	set_epoch_time(td, o->log_unix_epoch | o->log_alternate_epoch, o->log_alternate_epoch_clock_id);
 	fio_getrusage(&td->ru_start);
 	memcpy(&td->bw_sample_time, &td->epoch, sizeof(td->epoch));
 	memcpy(&td->iops_sample_time, &td->epoch, sizeof(td->epoch));
@@ -2611,6 +2613,9 @@ int fio_backend(struct sk_out *sk_out)
 	}
 
 	for_each_td(td, i) {
+		struct thread_stat *ts = &td->ts;
+
+		free_clat_prio_stats(ts);
 		steadystate_free(td);
 		fio_options_free(td);
 		fio_dump_options_free(td);
diff --git a/cconv.c b/cconv.c
index 4f8d27eb..62d02e36 100644
--- a/cconv.c
+++ b/cconv.c
@@ -197,6 +197,8 @@ void convert_thread_options_to_cpu(struct thread_options *o,
 	o->log_gz = le32_to_cpu(top->log_gz);
 	o->log_gz_store = le32_to_cpu(top->log_gz_store);
 	o->log_unix_epoch = le32_to_cpu(top->log_unix_epoch);
+	o->log_alternate_epoch = le32_to_cpu(top->log_alternate_epoch);
+	o->log_alternate_epoch_clock_id = le32_to_cpu(top->log_alternate_epoch_clock_id);
 	o->norandommap = le32_to_cpu(top->norandommap);
 	o->softrandommap = le32_to_cpu(top->softrandommap);
 	o->bs_unaligned = le32_to_cpu(top->bs_unaligned);
@@ -425,6 +427,8 @@ void convert_thread_options_to_net(struct thread_options_pack *top,
 	top->log_gz = cpu_to_le32(o->log_gz);
 	top->log_gz_store = cpu_to_le32(o->log_gz_store);
 	top->log_unix_epoch = cpu_to_le32(o->log_unix_epoch);
+	top->log_alternate_epoch = cpu_to_le32(o->log_alternate_epoch);
+	top->log_alternate_epoch_clock_id = cpu_to_le32(o->log_alternate_epoch_clock_id);
 	top->norandommap = cpu_to_le32(o->norandommap);
 	top->softrandommap = cpu_to_le32(o->softrandommap);
 	top->bs_unaligned = cpu_to_le32(o->bs_unaligned);
diff --git a/client.c b/client.c
index be8411d8..605a3ce5 100644
--- a/client.c
+++ b/client.c
@@ -284,9 +284,10 @@ static int fio_client_dec_jobs_eta(struct client_eta *eta, client_eta_op eta_fn)
 static void fio_drain_client_text(struct fio_client *client)
 {
 	do {
-		struct fio_net_cmd *cmd;
+		struct fio_net_cmd *cmd = NULL;
 
-		cmd = fio_net_recv_cmd(client->fd, false);
+		if (fio_server_poll_fd(client->fd, POLLIN, 0))
+			cmd = fio_net_recv_cmd(client->fd, false);
 		if (!cmd)
 			break;
 
@@ -953,6 +954,8 @@ static void convert_ts(struct thread_stat *dst, struct thread_stat *src)
 	dst->pid		= le32_to_cpu(src->pid);
 	dst->members		= le32_to_cpu(src->members);
 	dst->unified_rw_rep	= le32_to_cpu(src->unified_rw_rep);
+	dst->ioprio		= le32_to_cpu(src->ioprio);
+	dst->disable_prio_stat	= le32_to_cpu(src->disable_prio_stat);
 
 	for (i = 0; i < DDIR_RWDIR_CNT; i++) {
 		convert_io_stat(&dst->clat_stat[i], &src->clat_stat[i]);
@@ -1035,14 +1038,6 @@ static void convert_ts(struct thread_stat *dst, struct thread_stat *src)
 	dst->nr_block_infos	= le64_to_cpu(src->nr_block_infos);
 	for (i = 0; i < dst->nr_block_infos; i++)
 		dst->block_infos[i] = le32_to_cpu(src->block_infos[i]);
-	for (i = 0; i < DDIR_RWDIR_CNT; i++) {
-		for (j = 0; j < FIO_IO_U_PLAT_NR; j++) {
-			dst->io_u_plat_high_prio[i][j] = le64_to_cpu(src->io_u_plat_high_prio[i][j]);
-			dst->io_u_plat_low_prio[i][j] = le64_to_cpu(src->io_u_plat_low_prio[i][j]);
-		}
-		convert_io_stat(&dst->clat_high_prio_stat[i], &src->clat_high_prio_stat[i]);
-		convert_io_stat(&dst->clat_low_prio_stat[i], &src->clat_low_prio_stat[i]);
-	}
 
 	dst->ss_dur		= le64_to_cpu(src->ss_dur);
 	dst->ss_state		= le32_to_cpu(src->ss_state);
@@ -1052,6 +1047,19 @@ static void convert_ts(struct thread_stat *dst, struct thread_stat *src)
 	dst->ss_deviation.u.f 	= fio_uint64_to_double(le64_to_cpu(src->ss_deviation.u.i));
 	dst->ss_criterion.u.f 	= fio_uint64_to_double(le64_to_cpu(src->ss_criterion.u.i));
 
+	for (i = 0; i < DDIR_RWDIR_CNT; i++) {
+		dst->nr_clat_prio[i] = le32_to_cpu(src->nr_clat_prio[i]);
+		for (j = 0; j < dst->nr_clat_prio[i]; j++) {
+			for (k = 0; k < FIO_IO_U_PLAT_NR; k++)
+				dst->clat_prio[i][j].io_u_plat[k] =
+					le64_to_cpu(src->clat_prio[i][j].io_u_plat[k]);
+			convert_io_stat(&dst->clat_prio[i][j].clat_stat,
+					&src->clat_prio[i][j].clat_stat);
+			dst->clat_prio[i][j].ioprio =
+				le32_to_cpu(dst->clat_prio[i][j].ioprio);
+		}
+	}
+
 	if (dst->ss_state & FIO_SS_DATA) {
 		for (i = 0; i < dst->ss_dur; i++ ) {
 			dst->ss_iops_data[i] = le64_to_cpu(src->ss_iops_data[i]);
@@ -1760,7 +1768,6 @@ int fio_handle_client(struct fio_client *client)
 {
 	struct client_ops *ops = client->ops;
 	struct fio_net_cmd *cmd;
-	int size;
 
 	dprint(FD_NET, "client: handle %s\n", client->hostname);
 
@@ -1794,14 +1801,26 @@ int fio_handle_client(struct fio_client *client)
 		}
 	case FIO_NET_CMD_TS: {
 		struct cmd_ts_pdu *p = (struct cmd_ts_pdu *) cmd->payload;
+		uint64_t offset;
+		int i;
+
+		for (i = 0; i < DDIR_RWDIR_CNT; i++) {
+			if (le32_to_cpu(p->ts.nr_clat_prio[i])) {
+				offset = le64_to_cpu(p->ts.clat_prio_offset[i]);
+				p->ts.clat_prio[i] =
+					(struct clat_prio_stat *)((char *)p + offset);
+			}
+		}
 
 		dprint(FD_NET, "client: ts->ss_state = %u\n", (unsigned int) le32_to_cpu(p->ts.ss_state));
 		if (le32_to_cpu(p->ts.ss_state) & FIO_SS_DATA) {
 			dprint(FD_NET, "client: received steadystate ring buffers\n");
 
-			size = le64_to_cpu(p->ts.ss_dur);
-			p->ts.ss_iops_data = (uint64_t *) ((struct cmd_ts_pdu *)cmd->payload + 1);
-			p->ts.ss_bw_data = p->ts.ss_iops_data + size;
+			offset = le64_to_cpu(p->ts.ss_iops_data_offset);
+			p->ts.ss_iops_data = (uint64_t *)((char *)p + offset);
+
+			offset = le64_to_cpu(p->ts.ss_bw_data_offset);
+			p->ts.ss_bw_data = (uint64_t *)((char *)p + offset);
 		}
 
 		convert_ts(&p->ts, &p->ts);
@@ -2152,6 +2171,7 @@ int fio_handle_clients(struct client_ops *ops)
 
 	fio_client_json_fini();
 
+	free_clat_prio_stats(&client_ts);
 	free(pfds);
 	return retval || error_clients;
 }
diff --git a/engines/cmdprio.c b/engines/cmdprio.c
index 92b752ae..dd358754 100644
--- a/engines/cmdprio.c
+++ b/engines/cmdprio.c
@@ -5,45 +5,201 @@
 
 #include "cmdprio.h"
 
-static int fio_cmdprio_bssplit_ddir(struct thread_options *to, void *cb_arg,
-				    enum fio_ddir ddir, char *str, bool data)
+/*
+ * Temporary array used during parsing. Will be freed after the corresponding
+ * struct bsprio_desc has been generated and saved in cmdprio->bsprio_desc.
+ */
+struct cmdprio_parse_result {
+	struct split_prio *entries;
+	int nr_entries;
+};
+
+/*
+ * Temporary array used during init. Will be freed after the corresponding
+ * struct clat_prio_stat array has been saved in td->ts.clat_prio and the
+ * matching clat_prio_indexes have been saved in each struct cmdprio_prio.
+ */
+struct cmdprio_values {
+	unsigned int *prios;
+	int nr_prios;
+};
+
+static int find_clat_prio_index(unsigned int *all_prios, int nr_prios,
+				int32_t prio)
 {
-	struct cmdprio *cmdprio = cb_arg;
-	struct split split;
-	unsigned int i;
+	int i;
 
-	if (ddir == DDIR_TRIM)
-		return 0;
+	for (i = 0; i < nr_prios; i++) {
+		if (all_prios[i] == prio)
+			return i;
+	}
 
-	memset(&split, 0, sizeof(split));
+	return -1;
+}
 
-	if (split_parse_ddir(to, &split, str, data, BSSPLIT_MAX))
+/**
+ * assign_clat_prio_index - In order to avoid stat.c the need to loop through
+ * all possible priorities each time add_clat_sample() / add_lat_sample() is
+ * called, save which index to use in each cmdprio_prio. This will later be
+ * propagated to the io_u, if the specific io_u was determined to use a cmdprio
+ * priority value.
+ */
+static void assign_clat_prio_index(struct cmdprio_prio *prio,
+				   struct cmdprio_values *values)
+{
+	int clat_prio_index = find_clat_prio_index(values->prios,
+						   values->nr_prios,
+						   prio->prio);
+	if (clat_prio_index == -1) {
+		clat_prio_index = values->nr_prios;
+		values->prios[clat_prio_index] = prio->prio;
+		values->nr_prios++;
+	}
+	prio->clat_prio_index = clat_prio_index;
+}
+
+/**
+ * init_cmdprio_values - Allocate a temporary array that can hold all unique
+ * priorities (per ddir), so that we can assign_clat_prio_index() for each
+ * cmdprio_prio during setup. This temporary array is freed after setup.
+ */
+static int init_cmdprio_values(struct cmdprio_values *values,
+			       int max_unique_prios, struct thread_stat *ts)
+{
+	values->prios = calloc(max_unique_prios + 1,
+			       sizeof(*values->prios));
+	if (!values->prios)
 		return 1;
-	if (!split.nr)
-		return 0;
 
-	cmdprio->bssplit_nr[ddir] = split.nr;
-	cmdprio->bssplit[ddir] = malloc(split.nr * sizeof(struct bssplit));
-	if (!cmdprio->bssplit[ddir])
+	/* td->ioprio/ts->ioprio is always stored at index 0. */
+	values->prios[0] = ts->ioprio;
+	values->nr_prios++;
+
+	return 0;
+}
+
+/**
+ * init_ts_clat_prio - Allocates and fills a clat_prio_stat array which holds
+ * all unique priorities (per ddir).
+ */
+static int init_ts_clat_prio(struct thread_stat *ts, enum fio_ddir ddir,
+			     struct cmdprio_values *values)
+{
+	int i;
+
+	if (alloc_clat_prio_stat_ddir(ts, ddir, values->nr_prios))
 		return 1;
 
-	for (i = 0; i < split.nr; i++) {
-		cmdprio->bssplit[ddir][i].bs = split.val1[i];
-		if (split.val2[i] == -1U) {
-			cmdprio->bssplit[ddir][i].perc = 0;
-		} else {
-			if (split.val2[i] > 100)
-				cmdprio->bssplit[ddir][i].perc = 100;
-			else
-				cmdprio->bssplit[ddir][i].perc = split.val2[i];
+	for (i = 0; i < values->nr_prios; i++)
+		ts->clat_prio[ddir][i].ioprio = values->prios[i];
+
+	return 0;
+}
+
+static int fio_cmdprio_fill_bsprio(struct cmdprio_bsprio *bsprio,
+				   struct split_prio *entries,
+				   struct cmdprio_values *values,
+				   int implicit_cmdprio, int start, int end)
+{
+	struct cmdprio_prio *prio;
+	int i = end - start + 1;
+
+	bsprio->prios = calloc(i, sizeof(*bsprio->prios));
+	if (!bsprio->prios)
+		return 1;
+
+	bsprio->bs = entries[start].bs;
+	bsprio->nr_prios = 0;
+	for (i = start; i <= end; i++) {
+		prio = &bsprio->prios[bsprio->nr_prios];
+		prio->perc = entries[i].perc;
+		if (entries[i].prio == -1)
+			prio->prio = implicit_cmdprio;
+		else
+			prio->prio = entries[i].prio;
+		assign_clat_prio_index(prio, values);
+		bsprio->tot_perc += entries[i].perc;
+		if (bsprio->tot_perc > 100) {
+			log_err("fio: cmdprio_bssplit total percentage "
+				"for bs: %"PRIu64" exceeds 100\n",
+				bsprio->bs);
+			free(bsprio->prios);
+			return 1;
 		}
+		bsprio->nr_prios++;
+	}
+
+	return 0;
+}
+
+static int
+fio_cmdprio_generate_bsprio_desc(struct cmdprio_bsprio_desc *bsprio_desc,
+				 struct cmdprio_parse_result *parse_res,
+				 struct cmdprio_values *values,
+				 int implicit_cmdprio)
+{
+	struct split_prio *entries = parse_res->entries;
+	int nr_entries = parse_res->nr_entries;
+	struct cmdprio_bsprio *bsprio;
+	int i, start, count = 0;
+
+	/*
+	 * The parsed result is sorted by blocksize, so count only the number
+	 * of different blocksizes, to know how many cmdprio_bsprio we need.
+	 */
+	for (i = 0; i < nr_entries; i++) {
+		while (i + 1 < nr_entries && entries[i].bs == entries[i + 1].bs)
+			i++;
+		count++;
+	}
+
+	/*
+	 * This allocation is not freed on error. Instead, the calling function
+	 * is responsible for calling fio_cmdprio_cleanup() on error.
+	 */
+	bsprio_desc->bsprios = calloc(count, sizeof(*bsprio_desc->bsprios));
+	if (!bsprio_desc->bsprios)
+		return 1;
+
+	start = 0;
+	bsprio_desc->nr_bsprios = 0;
+	for (i = 0; i < nr_entries; i++) {
+		while (i + 1 < nr_entries && entries[i].bs == entries[i + 1].bs)
+			i++;
+		bsprio = &bsprio_desc->bsprios[bsprio_desc->nr_bsprios];
+		/*
+		 * All parsed entries with the same blocksize get saved in the
+		 * same cmdprio_bsprio, to expedite the search in the hot path.
+		 */
+		if (fio_cmdprio_fill_bsprio(bsprio, entries, values,
+					    implicit_cmdprio, start, i))
+			return 1;
+
+		start = i + 1;
+		bsprio_desc->nr_bsprios++;
 	}
 
 	return 0;
 }
 
-int fio_cmdprio_bssplit_parse(struct thread_data *td, const char *input,
-			      struct cmdprio *cmdprio)
+static int fio_cmdprio_bssplit_ddir(struct thread_options *to, void *cb_arg,
+				    enum fio_ddir ddir, char *str, bool data)
+{
+	struct cmdprio_parse_result *parse_res_arr = cb_arg;
+	struct cmdprio_parse_result *parse_res = &parse_res_arr[ddir];
+
+	if (ddir == DDIR_TRIM)
+		return 0;
+
+	if (split_parse_prio_ddir(to, &parse_res->entries,
+				  &parse_res->nr_entries, str))
+		return 1;
+
+	return 0;
+}
+
+static int fio_cmdprio_bssplit_parse(struct thread_data *td, const char *input,
+				     struct cmdprio_parse_result *parse_res)
 {
 	char *str, *p;
 	int ret = 0;
@@ -53,26 +209,39 @@ int fio_cmdprio_bssplit_parse(struct thread_data *td, const char *input,
 	strip_blank_front(&str);
 	strip_blank_end(str);
 
-	ret = str_split_parse(td, str, fio_cmdprio_bssplit_ddir, cmdprio,
+	ret = str_split_parse(td, str, fio_cmdprio_bssplit_ddir, parse_res,
 			      false);
 
 	free(p);
 	return ret;
 }
 
-static int fio_cmdprio_percentage(struct cmdprio *cmdprio, struct io_u *io_u)
+/**
+ * fio_cmdprio_percentage - Returns the percentage of I/Os that should
+ * use a cmdprio priority value (rather than the default context priority).
+ *
+ * For CMDPRIO_MODE_BSSPLIT, if the percentage is non-zero, we will also
+ * return the matching bsprio, to avoid the same linear search elsewhere.
+ * For CMDPRIO_MODE_PERC, we will never return a bsprio.
+ */
+static int fio_cmdprio_percentage(struct cmdprio *cmdprio, struct io_u *io_u,
+				  struct cmdprio_bsprio **bsprio)
 {
+	struct cmdprio_bsprio *bsprio_entry;
 	enum fio_ddir ddir = io_u->ddir;
-	struct cmdprio_options *options = cmdprio->options;
 	int i;
 
 	switch (cmdprio->mode) {
 	case CMDPRIO_MODE_PERC:
-		return options->percentage[ddir];
+		*bsprio = NULL;
+		return cmdprio->perc_entry[ddir].perc;
 	case CMDPRIO_MODE_BSSPLIT:
-		for (i = 0; i < cmdprio->bssplit_nr[ddir]; i++) {
-			if (cmdprio->bssplit[ddir][i].bs == io_u->buflen)
-				return cmdprio->bssplit[ddir][i].perc;
+		for (i = 0; i < cmdprio->bsprio_desc[ddir].nr_bsprios; i++) {
+			bsprio_entry = &cmdprio->bsprio_desc[ddir].bsprios[i];
+			if (bsprio_entry->bs == io_u->buflen) {
+				*bsprio = bsprio_entry;
+				return bsprio_entry->tot_perc;
+			}
 		}
 		break;
 	default:
@@ -83,6 +252,11 @@ static int fio_cmdprio_percentage(struct cmdprio *cmdprio, struct io_u *io_u)
 		assert(0);
 	}
 
+	/*
+	 * This is totally fine, the given blocksize simply does not
+	 * have any (non-zero) cmdprio_bssplit entries defined.
+	 */
+	*bsprio = NULL;
 	return 0;
 }
 
@@ -100,52 +274,162 @@ static int fio_cmdprio_percentage(struct cmdprio *cmdprio, struct io_u *io_u)
 bool fio_cmdprio_set_ioprio(struct thread_data *td, struct cmdprio *cmdprio,
 			    struct io_u *io_u)
 {
-	enum fio_ddir ddir = io_u->ddir;
-	struct cmdprio_options *options = cmdprio->options;
-	unsigned int p;
-	unsigned int cmdprio_value =
-		ioprio_value(options->class[ddir], options->level[ddir]);
-
-	p = fio_cmdprio_percentage(cmdprio, io_u);
-	if (p && rand_between(&td->prio_state, 0, 99) < p) {
-		io_u->ioprio = cmdprio_value;
-		if (!td->ioprio || cmdprio_value < td->ioprio) {
-			/*
-			 * The async IO priority is higher (has a lower value)
-			 * than the default priority (which is either 0 or the
-			 * value set by "prio" and "prioclass" options).
-			 */
-			io_u->flags |= IO_U_F_HIGH_PRIO;
-		}
+	struct cmdprio_bsprio *bsprio;
+	unsigned int p, rand;
+	uint32_t perc = 0;
+	int i;
+
+	p = fio_cmdprio_percentage(cmdprio, io_u, &bsprio);
+	if (!p)
+		return false;
+
+	rand = rand_between(&td->prio_state, 0, 99);
+	if (rand >= p)
+		return false;
+
+	switch (cmdprio->mode) {
+	case CMDPRIO_MODE_PERC:
+		io_u->ioprio = cmdprio->perc_entry[io_u->ddir].prio;
+		io_u->clat_prio_index =
+			cmdprio->perc_entry[io_u->ddir].clat_prio_index;
 		return true;
+	case CMDPRIO_MODE_BSSPLIT:
+		assert(bsprio);
+		for (i = 0; i < bsprio->nr_prios; i++) {
+			struct cmdprio_prio *prio = &bsprio->prios[i];
+
+			perc += prio->perc;
+			if (rand < perc) {
+				io_u->ioprio = prio->prio;
+				io_u->clat_prio_index = prio->clat_prio_index;
+				return true;
+			}
+		}
+		break;
+	default:
+		assert(0);
 	}
 
-	if (td->ioprio && td->ioprio < cmdprio_value) {
+	/* When rand < p (total perc), we should always find a cmdprio_prio. */
+	assert(0);
+	return false;
+}
+
+static int fio_cmdprio_gen_perc(struct thread_data *td, struct cmdprio *cmdprio)
+{
+	struct cmdprio_options *options = cmdprio->options;
+	struct cmdprio_prio *prio;
+	struct cmdprio_values values[CMDPRIO_RWDIR_CNT] = {0};
+	struct thread_stat *ts = &td->ts;
+	enum fio_ddir ddir;
+	int ret;
+
+	for (ddir = 0; ddir < CMDPRIO_RWDIR_CNT; ddir++) {
 		/*
-		 * The IO will be executed with the default priority (which is
-		 * either 0 or the value set by "prio" and "prioclass options),
-		 * and this priority is higher (has a lower value) than the
-		 * async IO priority.
+		 * Do not allocate a clat_prio array nor set the cmdprio struct
+		 * if zero percent of the I/Os (for the ddir) should use a
+		 * cmdprio priority value, or when the ddir is not enabled.
 		 */
-		io_u->flags |= IO_U_F_HIGH_PRIO;
+		if (!options->percentage[ddir] ||
+		    (ddir == DDIR_READ && !td_read(td)) ||
+		    (ddir == DDIR_WRITE && !td_write(td)))
+			continue;
+
+		ret = init_cmdprio_values(&values[ddir], 1, ts);
+		if (ret)
+			goto err;
+
+		prio = &cmdprio->perc_entry[ddir];
+		prio->perc = options->percentage[ddir];
+		prio->prio = ioprio_value(options->class[ddir],
+					  options->level[ddir]);
+		assign_clat_prio_index(prio, &values[ddir]);
+
+		ret = init_ts_clat_prio(ts, ddir, &values[ddir]);
+		if (ret)
+			goto err;
+
+		free(values[ddir].prios);
+		values[ddir].prios = NULL;
+		values[ddir].nr_prios = 0;
 	}
 
-	return false;
+	return 0;
+
+err:
+	for (ddir = 0; ddir < CMDPRIO_RWDIR_CNT; ddir++)
+		free(values[ddir].prios);
+	free_clat_prio_stats(ts);
+
+	return ret;
 }
 
 static int fio_cmdprio_parse_and_gen_bssplit(struct thread_data *td,
 					     struct cmdprio *cmdprio)
 {
 	struct cmdprio_options *options = cmdprio->options;
-	int ret;
-
-	ret = fio_cmdprio_bssplit_parse(td, options->bssplit_str, cmdprio);
+	struct cmdprio_parse_result parse_res[CMDPRIO_RWDIR_CNT] = {0};
+	struct cmdprio_values values[CMDPRIO_RWDIR_CNT] = {0};
+	struct thread_stat *ts = &td->ts;
+	int ret, implicit_cmdprio;
+	enum fio_ddir ddir;
+
+	ret = fio_cmdprio_bssplit_parse(td, options->bssplit_str,
+					&parse_res[0]);
 	if (ret)
 		goto err;
 
+	for (ddir = 0; ddir < CMDPRIO_RWDIR_CNT; ddir++) {
+		/*
+		 * Do not allocate a clat_prio array nor set the cmdprio structs
+		 * if there are no non-zero entries (for the ddir), or when the
+		 * ddir is not enabled.
+		 */
+		if (!parse_res[ddir].nr_entries ||
+		    (ddir == DDIR_READ && !td_read(td)) ||
+		    (ddir == DDIR_WRITE && !td_write(td))) {
+			free(parse_res[ddir].entries);
+			parse_res[ddir].entries = NULL;
+			parse_res[ddir].nr_entries = 0;
+			continue;
+		}
+
+		ret = init_cmdprio_values(&values[ddir],
+					  parse_res[ddir].nr_entries, ts);
+		if (ret)
+			goto err;
+
+		implicit_cmdprio = ioprio_value(options->class[ddir],
+						options->level[ddir]);
+
+		ret = fio_cmdprio_generate_bsprio_desc(&cmdprio->bsprio_desc[ddir],
+						       &parse_res[ddir],
+						       &values[ddir],
+						       implicit_cmdprio);
+		if (ret)
+			goto err;
+
+		free(parse_res[ddir].entries);
+		parse_res[ddir].entries = NULL;
+		parse_res[ddir].nr_entries = 0;
+
+		ret = init_ts_clat_prio(ts, ddir, &values[ddir]);
+		if (ret)
+			goto err;
+
+		free(values[ddir].prios);
+		values[ddir].prios = NULL;
+		values[ddir].nr_prios = 0;
+	}
+
 	return 0;
 
 err:
+	for (ddir = 0; ddir < CMDPRIO_RWDIR_CNT; ddir++) {
+		free(parse_res[ddir].entries);
+		free(values[ddir].prios);
+	}
+	free_clat_prio_stats(ts);
 	fio_cmdprio_cleanup(cmdprio);
 
 	return ret;
@@ -157,40 +441,46 @@ static int fio_cmdprio_parse_and_gen(struct thread_data *td,
 	struct cmdprio_options *options = cmdprio->options;
 	int i, ret;
 
+	/*
+	 * If cmdprio_percentage/cmdprio_bssplit is set and cmdprio_class
+	 * is not set, default to RT priority class.
+	 */
+	for (i = 0; i < CMDPRIO_RWDIR_CNT; i++) {
+		/*
+		 * A cmdprio value is only used when fio_cmdprio_percentage()
+		 * returns non-zero, so it is safe to set a class even for a
+		 * DDIR that will never use it.
+		 */
+		if (!options->class[i])
+			options->class[i] = IOPRIO_CLASS_RT;
+	}
+
 	switch (cmdprio->mode) {
 	case CMDPRIO_MODE_BSSPLIT:
 		ret = fio_cmdprio_parse_and_gen_bssplit(td, cmdprio);
 		break;
 	case CMDPRIO_MODE_PERC:
-		ret = 0;
+		ret = fio_cmdprio_gen_perc(td, cmdprio);
 		break;
 	default:
 		assert(0);
 		return 1;
 	}
 
-	/*
-	 * If cmdprio_percentage/cmdprio_bssplit is set and cmdprio_class
-	 * is not set, default to RT priority class.
-	 */
-	for (i = 0; i < CMDPRIO_RWDIR_CNT; i++) {
-		if (options->percentage[i] || cmdprio->bssplit_nr[i]) {
-			if (!options->class[i])
-				options->class[i] = IOPRIO_CLASS_RT;
-		}
-	}
-
 	return ret;
 }
 
 void fio_cmdprio_cleanup(struct cmdprio *cmdprio)
 {
-	int ddir;
+	enum fio_ddir ddir;
+	int i;
 
 	for (ddir = 0; ddir < CMDPRIO_RWDIR_CNT; ddir++) {
-		free(cmdprio->bssplit[ddir]);
-		cmdprio->bssplit[ddir] = NULL;
-		cmdprio->bssplit_nr[ddir] = 0;
+		for (i = 0; i < cmdprio->bsprio_desc[ddir].nr_bsprios; i++)
+			free(cmdprio->bsprio_desc[ddir].bsprios[i].prios);
+		free(cmdprio->bsprio_desc[ddir].bsprios);
+		cmdprio->bsprio_desc[ddir].bsprios = NULL;
+		cmdprio->bsprio_desc[ddir].nr_bsprios = 0;
 	}
 
 	/*
diff --git a/engines/cmdprio.h b/engines/cmdprio.h
index 0c7bd6cf..755da8d0 100644
--- a/engines/cmdprio.h
+++ b/engines/cmdprio.h
@@ -17,6 +17,24 @@ enum {
 	CMDPRIO_MODE_BSSPLIT,
 };
 
+struct cmdprio_prio {
+	int32_t prio;
+	uint32_t perc;
+	uint16_t clat_prio_index;
+};
+
+struct cmdprio_bsprio {
+	uint64_t bs;
+	uint32_t tot_perc;
+	unsigned int nr_prios;
+	struct cmdprio_prio *prios;
+};
+
+struct cmdprio_bsprio_desc {
+	struct cmdprio_bsprio *bsprios;
+	unsigned int nr_bsprios;
+};
+
 struct cmdprio_options {
 	unsigned int percentage[CMDPRIO_RWDIR_CNT];
 	unsigned int class[CMDPRIO_RWDIR_CNT];
@@ -26,8 +44,8 @@ struct cmdprio_options {
 
 struct cmdprio {
 	struct cmdprio_options *options;
-	unsigned int bssplit_nr[CMDPRIO_RWDIR_CNT];
-	struct bssplit *bssplit[CMDPRIO_RWDIR_CNT];
+	struct cmdprio_prio perc_entry[CMDPRIO_RWDIR_CNT];
+	struct cmdprio_bsprio_desc bsprio_desc[CMDPRIO_RWDIR_CNT];
 	unsigned int mode;
 };
 
diff --git a/engines/filecreate.c b/engines/filecreate.c
index 4bb13c34..7884752d 100644
--- a/engines/filecreate.c
+++ b/engines/filecreate.c
@@ -49,7 +49,7 @@ static int open_file(struct thread_data *td, struct fio_file *f)
 		uint64_t nsec;
 
 		nsec = ntime_since_now(&start);
-		add_clat_sample(td, data->stat_ddir, nsec, 0, 0, 0, false);
+		add_clat_sample(td, data->stat_ddir, nsec, 0, 0, 0, 0);
 	}
 
 	return 0;
diff --git a/engines/filedelete.c b/engines/filedelete.c
index e882ccf0..df388ac9 100644
--- a/engines/filedelete.c
+++ b/engines/filedelete.c
@@ -51,7 +51,7 @@ static int delete_file(struct thread_data *td, struct fio_file *f)
 		uint64_t nsec;
 
 		nsec = ntime_since_now(&start);
-		add_clat_sample(td, data->stat_ddir, nsec, 0, 0, 0, false);
+		add_clat_sample(td, data->stat_ddir, nsec, 0, 0, 0, 0);
 	}
 
 	return 0;
diff --git a/engines/filestat.c b/engines/filestat.c
index 00311247..e587eb54 100644
--- a/engines/filestat.c
+++ b/engines/filestat.c
@@ -125,7 +125,7 @@ static int stat_file(struct thread_data *td, struct fio_file *f)
 		uint64_t nsec;
 
 		nsec = ntime_since_now(&start);
-		add_clat_sample(td, data->stat_ddir, nsec, 0, 0, 0, false);
+		add_clat_sample(td, data->stat_ddir, nsec, 0, 0, 0, 0);
 	}
 
 	return 0;
diff --git a/engines/windowsaio.c b/engines/windowsaio.c
index 9868e816..d82c8053 100644
--- a/engines/windowsaio.c
+++ b/engines/windowsaio.c
@@ -11,6 +11,7 @@
 #include <errno.h>
 
 #include "../fio.h"
+#include "../optgroup.h"
 
 typedef BOOL (WINAPI *CANCELIOEX)(HANDLE hFile, LPOVERLAPPED lpOverlapped);
 
@@ -35,6 +36,26 @@ struct thread_ctx {
 	struct windowsaio_data *wd;
 };
 
+struct windowsaio_options {
+	struct thread_data *td;
+	unsigned int no_completion_thread;
+};
+
+static struct fio_option options[] = {
+	{
+		.name	= "no_completion_thread",
+		.lname	= "No completion polling thread",
+		.type	= FIO_OPT_STR_SET,
+		.off1	= offsetof(struct windowsaio_options, no_completion_thread),
+		.help	= "Use to avoid separate completion polling thread",
+		.category = FIO_OPT_C_ENGINE,
+		.group	= FIO_OPT_G_WINDOWSAIO,
+	},
+	{
+		.name	= NULL,
+	},
+};
+
 static DWORD WINAPI IoCompletionRoutine(LPVOID lpParameter);
 
 static int fio_windowsaio_init(struct thread_data *td)
@@ -80,6 +101,7 @@ static int fio_windowsaio_init(struct thread_data *td)
 		struct thread_ctx *ctx;
 		struct windowsaio_data *wd;
 		HANDLE hFile;
+		struct windowsaio_options *o = td->eo;
 
 		hFile = CreateIoCompletionPort(INVALID_HANDLE_VALUE, NULL, 0, 0);
 		if (hFile == INVALID_HANDLE_VALUE) {
@@ -91,29 +113,30 @@ static int fio_windowsaio_init(struct thread_data *td)
 		wd->iothread_running = TRUE;
 		wd->iocp = hFile;
 
-		if (!rc)
-			ctx = malloc(sizeof(struct thread_ctx));
+		if (o->no_completion_thread == 0) {
+			if (!rc)
+				ctx = malloc(sizeof(struct thread_ctx));
 
-		if (!rc && ctx == NULL) {
-			log_err("windowsaio: failed to allocate memory for thread context structure\n");
-			CloseHandle(hFile);
-			rc = 1;
-		}
+			if (!rc && ctx == NULL) {
+				log_err("windowsaio: failed to allocate memory for thread context structure\n");
+				CloseHandle(hFile);
+				rc = 1;
+			}
 
-		if (!rc) {
-			DWORD threadid;
+			if (!rc) {
+				DWORD threadid;
 
-			ctx->iocp = hFile;
-			ctx->wd = wd;
-			wd->iothread = CreateThread(NULL, 0, IoCompletionRoutine, ctx, 0, &threadid);
-			if (!wd->iothread)
-				log_err("windowsaio: failed to create io completion thread\n");
-			else if (fio_option_is_set(&td->o, cpumask))
-				fio_setaffinity(threadid, td->o.cpumask);
+				ctx->iocp = hFile;
+				ctx->wd = wd;
+				wd->iothread = CreateThread(NULL, 0, IoCompletionRoutine, ctx, 0, &threadid);
+				if (!wd->iothread)
+					log_err("windowsaio: failed to create io completion thread\n");
+				else if (fio_option_is_set(&td->o, cpumask))
+					fio_setaffinity(threadid, td->o.cpumask);
+			}
+			if (rc || wd->iothread == NULL)
+				rc = 1;
 		}
-
-		if (rc || wd->iothread == NULL)
-			rc = 1;
 	}
 
 	return rc;
@@ -302,9 +325,63 @@ static struct io_u* fio_windowsaio_event(struct thread_data *td, int event)
 	return wd->aio_events[event];
 }
 
-static int fio_windowsaio_getevents(struct thread_data *td, unsigned int min,
-				    unsigned int max,
-				    const struct timespec *t)
+/* dequeue completion entrees directly (no separate completion thread) */
+static int fio_windowsaio_getevents_nothread(struct thread_data *td, unsigned int min,
+				    unsigned int max, const struct timespec *t)
+{
+	struct windowsaio_data *wd = td->io_ops_data;
+	unsigned int dequeued = 0;
+	struct io_u *io_u;
+	DWORD start_count = 0;
+	DWORD end_count = 0;
+	DWORD mswait = 250;
+	struct fio_overlapped *fov;
+
+	if (t != NULL) {
+		mswait = (t->tv_sec * 1000) + (t->tv_nsec / 1000000);
+		start_count = GetTickCount();
+		end_count = start_count + (t->tv_sec * 1000) + (t->tv_nsec / 1000000);
+	}
+
+	do {
+		BOOL ret;
+		OVERLAPPED *ovl;
+
+		ULONG entries = min(16, max-dequeued);
+		OVERLAPPED_ENTRY oe[16];
+		ret = GetQueuedCompletionStatusEx(wd->iocp, oe, 16, &entries, mswait, 0);
+		if (ret && entries) {
+			int entry_num;
+
+			for (entry_num=0; entry_num<entries; entry_num++) {
+				ovl = oe[entry_num].lpOverlapped;
+				fov = CONTAINING_RECORD(ovl, struct fio_overlapped, o);
+				io_u = fov->io_u;
+
+				if (ovl->Internal == ERROR_SUCCESS) {
+					io_u->resid = io_u->xfer_buflen - ovl->InternalHigh;
+					io_u->error = 0;
+				} else {
+					io_u->resid = io_u->xfer_buflen;
+					io_u->error = win_to_posix_error(GetLastError());
+				}
+
+				fov->io_complete = FALSE;
+				wd->aio_events[dequeued] = io_u;
+				dequeued++;
+			}
+		}
+
+		if (dequeued >= min ||
+			(t != NULL && timeout_expired(start_count, end_count)))
+			break;
+	} while (1);
+	return dequeued;
+}
+
+/* dequeue completion entrees creates by separate IoCompletionRoutine thread */
+static int fio_windowaio_getevents_thread(struct thread_data *td, unsigned int min,
+				    unsigned int max, const struct timespec *t)
 {
 	struct windowsaio_data *wd = td->io_ops_data;
 	unsigned int dequeued = 0;
@@ -334,7 +411,6 @@ static int fio_windowsaio_getevents(struct thread_data *td, unsigned int min,
 				wd->aio_events[dequeued] = io_u;
 				dequeued++;
 			}
-
 		}
 		if (dequeued >= min)
 			break;
@@ -353,6 +429,16 @@ static int fio_windowsaio_getevents(struct thread_data *td, unsigned int min,
 	return dequeued;
 }
 
+static int fio_windowsaio_getevents(struct thread_data *td, unsigned int min,
+				    unsigned int max, const struct timespec *t)
+{
+	struct windowsaio_options *o = td->eo;
+
+	if (o->no_completion_thread)
+		return fio_windowsaio_getevents_nothread(td, min, max, t);
+	return fio_windowaio_getevents_thread(td, min, max, t);
+}
+
 static enum fio_q_status fio_windowsaio_queue(struct thread_data *td,
 					      struct io_u *io_u)
 {
@@ -484,6 +570,8 @@ static struct ioengine_ops ioengine = {
 	.get_file_size	= generic_get_file_size,
 	.io_u_init	= fio_windowsaio_io_u_init,
 	.io_u_free	= fio_windowsaio_io_u_free,
+	.options	= options,
+	.option_struct_size	= sizeof(struct windowsaio_options),
 };
 
 static void fio_init fio_windowsaio_register(void)
diff --git a/examples/cmdprio-bssplit.fio b/examples/cmdprio-bssplit.fio
index 47e9a790..f3b2fac0 100644
--- a/examples/cmdprio-bssplit.fio
+++ b/examples/cmdprio-bssplit.fio
@@ -1,17 +1,44 @@
 ; Randomly read/write a block device file at queue depth 16.
-; 40 % of read IOs are 64kB and 60% are 1MB. 100% of writes are 1MB.
-; 100% of the 64kB reads are executed at the highest priority and
-; all other IOs executed without a priority set.
 [global]
 filename=/dev/sda
 direct=1
 write_lat_log=prio-run.log
 log_prio=1
-
-[randrw]
 rw=randrw
-bssplit=64k/40:1024k/60,1024k/100
 ioengine=libaio
 iodepth=16
+
+; Simple cmdprio_bssplit format. All non-zero percentage entries will
+; use the same prio class and prio level defined by the cmdprio_class
+; and cmdprio options.
+[cmdprio]
+; 40% of read IOs are 64kB and 60% are 1MB. 100% of writes are 1MB.
+; 100% of the 64kB reads are executed with prio class 1 and prio level 0.
+; All other IOs are executed without a priority set.
+bssplit=64k/40:1024k/60,1024k/100
 cmdprio_bssplit=64k/100:1024k/0,1024k/0
 cmdprio_class=1
+cmdprio=0
+
+; Advanced cmdprio_bssplit format. Each non-zero percentage entry can
+; use a different prio class and prio level (appended to each entry).
+[cmdprio-adv]
+; 40% of read IOs are 64kB and 60% are 1MB. 100% of writes are 1MB.
+; 25% of the 64kB reads are executed with prio class 1 and prio level 1,
+; 75% of the 64kB reads are executed with prio class 3 and prio level 2.
+; All other IOs are executed without a priority set.
+stonewall
+bssplit=64k/40:1024k/60,1024k/100
+cmdprio_bssplit=64k/25/1/1:64k/75/3/2:1024k/0,1024k/0
+
+; Identical to the previous example, but with a default priority defined.
+[cmdprio-adv-def]
+; 40% of read IOs are 64kB and 60% are 1MB. 100% of writes are 1MB.
+; 25% of the 64kB reads are executed with prio class 1 and prio level 1,
+; 75% of the 64kB reads are executed with prio class 3 and prio level 2.
+; All other IOs are executed with prio class 2 and prio level 7.
+stonewall
+prioclass=2
+prio=7
+bssplit=64k/40:1024k/60,1024k/100
+cmdprio_bssplit=64k/25/1/1:64k/75/3/2:1024k/0,1024k/0
diff --git a/fio.1 b/fio.1
index b87d2309..f32d7915 100644
--- a/fio.1
+++ b/fio.1
@@ -1122,7 +1122,7 @@ see \fBend_fsync\fR and \fBfsync_on_close\fR.
 .TP
 .BI fdatasync \fR=\fPint
 Like \fBfsync\fR but uses \fBfdatasync\fR\|(2) to only sync data and
-not metadata blocks. In Windows, FreeBSD, DragonFlyBSD or OSX there is no
+not metadata blocks. In Windows, DragonFlyBSD or OSX there is no
 \fBfdatasync\fR\|(2) so this falls back to using \fBfsync\fR\|(2).
 Defaults to 0, which means fio does not periodically issue and wait for a
 data-only sync to complete.
@@ -1995,10 +1995,34 @@ To get a finer control over I/O priority, this option allows specifying
 the percentage of IOs that must have a priority set depending on the block
 size of the IO. This option is useful only when used together with the option
 \fBbssplit\fR, that is, multiple different block sizes are used for reads and
-writes. The format for this option is the same as the format of the
-\fBbssplit\fR option, with the exception that values for trim IOs are
-ignored. This option is mutually exclusive with the \fBcmdprio_percentage\fR
-option.
+writes.
+.RS
+.P
+The first accepted format for this option is the same as the format of the
+\fBbssplit\fR option:
+.RS
+.P
+cmdprio_bssplit=blocksize/percentage:blocksize/percentage
+.RE
+.P
+In this case, each entry will use the priority class and priority level defined
+by the options \fBcmdprio_class\fR and \fBcmdprio\fR respectively.
+.P
+The second accepted format for this option is:
+.RS
+.P
+cmdprio_bssplit=blocksize/percentage/class/level:blocksize/percentage/class/level
+.RE
+.P
+In this case, the priority class and priority level is defined inside each
+entry. In comparison with the first accepted format, the second accepted format
+does not restrict all entries to have the same priority class and priority
+level.
+.P
+For both formats, only the read and write data directions are supported, values
+for trim IOs are ignored. This option is mutually exclusive with the
+\fBcmdprio_percentage\fR option.
+.RE
 .TP
 .BI (io_uring)fixedbufs
 If fio is asked to do direct IO, then Linux will map pages for each IO call, and
@@ -3360,6 +3384,17 @@ If set, fio will log Unix timestamps to the log files produced by enabling
 write_type_log for each log type, instead of the default zero-based
 timestamps.
 .TP
+.BI log_alternate_epoch \fR=\fPbool
+If set, fio will log timestamps based on the epoch used by the clock specified
+in the \fBlog_alternate_epoch_clock_id\fR option, to the log files produced by
+enabling write_type_log for each log type, instead of the default zero-based
+timestamps.
+.TP
+.BI log_alternate_epoch_clock_id \fR=\fPint
+Specifies the clock_id to be used by clock_gettime to obtain the alternate epoch
+if either \fBBlog_unix_epoch\fR or \fBlog_alternate_epoch\fR are true. Otherwise has no
+effect. Default value is 0, or CLOCK_REALTIME.
+.TP
 .BI block_error_percentiles \fR=\fPbool
 If set, record errors in trim block-sized units from writes and trims and
 output a histogram of how many trims it took to get to errors, and what kind
diff --git a/fio.h b/fio.h
index 1ea3d064..7b0ca843 100644
--- a/fio.h
+++ b/fio.h
@@ -380,7 +380,7 @@ struct thread_data {
 
 	struct timespec start;	/* start of this loop */
 	struct timespec epoch;	/* time job was started */
-	unsigned long long unix_epoch; /* Time job was started, unix epoch based. */
+	unsigned long long alternate_epoch; /* Time job was started, clock_gettime's clock_id epoch based. */
 	struct timespec last_issue;
 	long time_offset;
 	struct timespec ts_cache;
diff --git a/fio_time.h b/fio_time.h
index b3bbd4c0..62d92120 100644
--- a/fio_time.h
+++ b/fio_time.h
@@ -30,6 +30,6 @@ extern bool ramp_time_over(struct thread_data *);
 extern bool in_ramp_time(struct thread_data *);
 extern void fio_time_init(void);
 extern void timespec_add_msec(struct timespec *, unsigned int);
-extern void set_epoch_time(struct thread_data *, int);
+extern void set_epoch_time(struct thread_data *, int, clockid_t);
 
 #endif
diff --git a/gclient.c b/gclient.c
index ac063536..c59bcfe2 100644
--- a/gclient.c
+++ b/gclient.c
@@ -1155,21 +1155,18 @@ out:
 #define GFIO_CLAT	1
 #define GFIO_SLAT	2
 #define GFIO_LAT	4
-#define GFIO_HILAT	8
-#define GFIO_LOLAT	16
 
 static void gfio_show_ddir_status(struct gfio_client *gc, GtkWidget *mbox,
 				  struct group_run_stats *rs,
 				  struct thread_stat *ts, int ddir)
 {
 	const char *ddir_label[3] = { "Read", "Write", "Trim" };
-	const char *hilat, *lolat;
 	GtkWidget *frame, *label, *box, *vbox, *main_vbox;
-	unsigned long long min[5], max[5];
+	unsigned long long min[3], max[3];
 	unsigned long runt;
 	unsigned long long bw, iops;
 	unsigned int flags = 0;
-	double mean[5], dev[5];
+	double mean[3], dev[3];
 	char *io_p, *io_palt, *bw_p, *bw_palt, *iops_p;
 	char tmp[128];
 	int i2p;
@@ -1268,14 +1265,6 @@ static void gfio_show_ddir_status(struct gfio_client *gc, GtkWidget *mbox,
 		flags |= GFIO_CLAT;
 	if (calc_lat(&ts->lat_stat[ddir], &min[2], &max[2], &mean[2], &dev[2]))
 		flags |= GFIO_LAT;
-	if (calc_lat(&ts->clat_high_prio_stat[ddir], &min[3], &max[3], &mean[3], &dev[3])) {
-		flags |= GFIO_HILAT;
-		if (calc_lat(&ts->clat_low_prio_stat[ddir], &min[4], &max[4], &mean[4], &dev[4]))
-			flags |= GFIO_LOLAT;
-		/* we only want to print low priority statistics if other IOs were
-		 * submitted with the priority bit set
-		 */
-	}
 
 	if (flags) {
 		frame = gtk_frame_new("Latency");
@@ -1284,24 +1273,12 @@ static void gfio_show_ddir_status(struct gfio_client *gc, GtkWidget *mbox,
 		vbox = gtk_vbox_new(FALSE, 3);
 		gtk_container_add(GTK_CONTAINER(frame), vbox);
 
-		if (ts->lat_percentiles) {
-			hilat = "High priority total latency";
-			lolat = "Low priority total latency";
-		} else {
-			hilat = "High priority completion latency";
-			lolat = "Low priority completion latency";
-		}
-
 		if (flags & GFIO_SLAT)
 			gfio_show_lat(vbox, "Submission latency", min[0], max[0], mean[0], dev[0]);
 		if (flags & GFIO_CLAT)
 			gfio_show_lat(vbox, "Completion latency", min[1], max[1], mean[1], dev[1]);
 		if (flags & GFIO_LAT)
 			gfio_show_lat(vbox, "Total latency", min[2], max[2], mean[2], dev[2]);
-		if (flags & GFIO_HILAT)
-			gfio_show_lat(vbox, hilat, min[3], max[3], mean[3], dev[3]);
-		if (flags & GFIO_LOLAT)
-			gfio_show_lat(vbox, lolat, min[4], max[4], mean[4], dev[4]);
 	}
 
 	if (ts->slat_percentiles && flags & GFIO_SLAT)
@@ -1309,40 +1286,16 @@ static void gfio_show_ddir_status(struct gfio_client *gc, GtkWidget *mbox,
 				ts->io_u_plat[FIO_SLAT][ddir],
 				ts->slat_stat[ddir].samples,
 				"Submission");
-	if (ts->clat_percentiles && flags & GFIO_CLAT) {
+	if (ts->clat_percentiles && flags & GFIO_CLAT)
 		gfio_show_clat_percentiles(gc, main_vbox, ts, ddir,
 				ts->io_u_plat[FIO_CLAT][ddir],
 				ts->clat_stat[ddir].samples,
 				"Completion");
-		if (!ts->lat_percentiles) {
-			if (flags & GFIO_HILAT)
-				gfio_show_clat_percentiles(gc, main_vbox, ts, ddir,
-						ts->io_u_plat_high_prio[ddir],
-						ts->clat_high_prio_stat[ddir].samples,
-						"High priority completion");
-			if (flags & GFIO_LOLAT)
-				gfio_show_clat_percentiles(gc, main_vbox, ts, ddir,
-						ts->io_u_plat_low_prio[ddir],
-						ts->clat_low_prio_stat[ddir].samples,
-						"Low priority completion");
-		}
-	}
-	if (ts->lat_percentiles && flags & GFIO_LAT) {
+	if (ts->lat_percentiles && flags & GFIO_LAT)
 		gfio_show_clat_percentiles(gc, main_vbox, ts, ddir,
 				ts->io_u_plat[FIO_LAT][ddir],
 				ts->lat_stat[ddir].samples,
 				"Total");
-		if (flags & GFIO_HILAT)
-			gfio_show_clat_percentiles(gc, main_vbox, ts, ddir,
-					ts->io_u_plat_high_prio[ddir],
-					ts->clat_high_prio_stat[ddir].samples,
-					"High priority total");
-		if (flags & GFIO_LOLAT)
-			gfio_show_clat_percentiles(gc, main_vbox, ts, ddir,
-					ts->io_u_plat_low_prio[ddir],
-					ts->clat_low_prio_stat[ddir].samples,
-					"Low priority total");
-	}
 
 	free(io_p);
 	free(bw_p);
diff --git a/init.c b/init.c
index 07daaa84..13935152 100644
--- a/init.c
+++ b/init.c
@@ -224,6 +224,13 @@ static struct option l_opts[FIO_NR_OPTIONS] = {
 		.has_arg	= optional_argument,
 		.val		= 'S',
 	},
+#ifdef WIN32
+	{
+		.name		= (char *) "server-internal",
+		.has_arg	= required_argument,
+		.val		= 'N',
+	},
+#endif
 	{	.name		= (char *) "daemonize",
 		.has_arg	= required_argument,
 		.val		= 'D',
@@ -1445,6 +1452,26 @@ static bool wait_for_ok(const char *jobname, struct thread_options *o)
 	return true;
 }
 
+static int verify_per_group_options(struct thread_data *td, const char *jobname)
+{
+	struct thread_data *td2;
+	int i;
+
+	for_each_td(td2, i) {
+		if (td->groupid != td2->groupid)
+			continue;
+
+		if (td->o.stats &&
+		    td->o.lat_percentiles != td2->o.lat_percentiles) {
+			log_err("fio: lat_percentiles in job: %s differs from group\n",
+				jobname);
+			return 1;
+		}
+	}
+
+	return 0;
+}
+
 /*
  * Treat an empty log file name the same as a one not given
  */
@@ -1563,6 +1590,10 @@ static int add_job(struct thread_data *td, const char *jobname, int job_add_num,
 	td->groupid = groupid;
 	prev_group_jobs++;
 
+	if (td->o.group_reporting && prev_group_jobs > 1 &&
+	    verify_per_group_options(td, jobname))
+		goto err;
+
 	if (setup_rate(td))
 		goto err;
 
@@ -2795,6 +2826,12 @@ int parse_cmd_line(int argc, char *argv[], int client_type)
 			exit_val = 1;
 #endif
 			break;
+#ifdef WIN32
+		case 'N':
+			did_arg = true;
+			fio_server_internal_set(optarg);
+			break;
+#endif
 		case 'D':
 			if (pid_file)
 				free(pid_file);
diff --git a/io_u.c b/io_u.c
index 3c72d63d..059637e5 100644
--- a/io_u.c
+++ b/io_u.c
@@ -1595,7 +1595,7 @@ again:
 		assert(io_u->flags & IO_U_F_FREE);
 		io_u_clear(td, io_u, IO_U_F_FREE | IO_U_F_NO_FILE_PUT |
 				 IO_U_F_TRIMMED | IO_U_F_BARRIER |
-				 IO_U_F_VER_LIST | IO_U_F_HIGH_PRIO);
+				 IO_U_F_VER_LIST);
 
 		io_u->error = 0;
 		io_u->acct_ddir = -1;
@@ -1803,6 +1803,7 @@ struct io_u *get_io_u(struct thread_data *td)
 	 * Remember the issuing context priority. The IO engine may change this.
 	 */
 	io_u->ioprio = td->ioprio;
+	io_u->clat_prio_index = 0;
 out:
 	assert(io_u->file);
 	if (!td_io_prep(td, io_u)) {
@@ -1889,7 +1890,7 @@ static void account_io_completion(struct thread_data *td, struct io_u *io_u,
 
 		tnsec = ntime_since(&io_u->start_time, &icd->time);
 		add_lat_sample(td, idx, tnsec, bytes, io_u->offset,
-			       io_u->ioprio, io_u_is_high_prio(io_u));
+			       io_u->ioprio, io_u->clat_prio_index);
 
 		if (td->flags & TD_F_PROFILE_OPS) {
 			struct prof_io_ops *ops = &td->prof_io_ops;
@@ -1911,7 +1912,7 @@ static void account_io_completion(struct thread_data *td, struct io_u *io_u,
 	if (ddir_rw(idx)) {
 		if (!td->o.disable_clat) {
 			add_clat_sample(td, idx, llnsec, bytes, io_u->offset,
-					io_u->ioprio, io_u_is_high_prio(io_u));
+					io_u->ioprio, io_u->clat_prio_index);
 			io_u_mark_latency(td, llnsec);
 		}
 
diff --git a/io_u.h b/io_u.h
index bdbac525..206e24fe 100644
--- a/io_u.h
+++ b/io_u.h
@@ -21,7 +21,6 @@ enum {
 	IO_U_F_TRIMMED		= 1 << 5,
 	IO_U_F_BARRIER		= 1 << 6,
 	IO_U_F_VER_LIST		= 1 << 7,
-	IO_U_F_HIGH_PRIO	= 1 << 8,
 };
 
 /*
@@ -50,6 +49,7 @@ struct io_u {
 	 * IO priority.
 	 */
 	unsigned short ioprio;
+	unsigned short clat_prio_index;
 
 	/*
 	 * Allocated/set buffer and length
@@ -193,6 +193,5 @@ static inline enum fio_ddir acct_ddir(struct io_u *io_u)
 	td_flags_clear((td), &(io_u->flags), (val))
 #define io_u_set(td, io_u, val)		\
 	td_flags_set((td), &(io_u)->flags, (val))
-#define io_u_is_high_prio(io_u)	(io_u->flags & IO_U_F_HIGH_PRIO)
 
 #endif
diff --git a/libfio.c b/libfio.c
index 198eaf2e..01fa7452 100644
--- a/libfio.c
+++ b/libfio.c
@@ -142,7 +142,7 @@ void reset_all_stats(struct thread_data *td)
 		td->ts.runtime[i] = 0;
 	}
 
-	set_epoch_time(td, td->o.log_unix_epoch);
+	set_epoch_time(td, td->o.log_unix_epoch | td->o.log_alternate_epoch, td->o.log_alternate_epoch_clock_id);
 	memcpy(&td->start, &td->epoch, sizeof(td->epoch));
 	memcpy(&td->iops_sample_time, &td->epoch, sizeof(td->epoch));
 	memcpy(&td->bw_sample_time, &td->epoch, sizeof(td->epoch));
diff --git a/optgroup.h b/optgroup.h
index 1fb84a29..3ac8f62a 100644
--- a/optgroup.h
+++ b/optgroup.h
@@ -71,6 +71,7 @@ enum opt_category_group {
 	__FIO_OPT_G_LIBCUFILE,
 	__FIO_OPT_G_DFS,
 	__FIO_OPT_G_NFS,
+	__FIO_OPT_G_WINDOWSAIO,
 
 	FIO_OPT_G_RATE		= (1ULL << __FIO_OPT_G_RATE),
 	FIO_OPT_G_ZONE		= (1ULL << __FIO_OPT_G_ZONE),
@@ -116,6 +117,7 @@ enum opt_category_group {
 	FIO_OPT_G_FILESTAT	= (1ULL << __FIO_OPT_G_FILESTAT),
 	FIO_OPT_G_LIBCUFILE	= (1ULL << __FIO_OPT_G_LIBCUFILE),
 	FIO_OPT_G_DFS		= (1ULL << __FIO_OPT_G_DFS),
+	FIO_OPT_G_WINDOWSAIO	= (1ULL << __FIO_OPT_G_WINDOWSAIO),
 };
 
 extern const struct opt_group *opt_group_from_mask(uint64_t *mask);
diff --git a/options.c b/options.c
index 102bcf56..6cdbd268 100644
--- a/options.c
+++ b/options.c
@@ -278,6 +278,128 @@ static int str_bssplit_cb(void *data, const char *input)
 	return ret;
 }
 
+static int parse_cmdprio_bssplit_entry(struct thread_options *o,
+				       struct split_prio *entry, char *str)
+{
+	int matches = 0;
+	char *bs_str = NULL;
+	long long bs_val;
+	unsigned int perc = 0, class, level;
+
+	/*
+	 * valid entry formats:
+	 * bs/ - %s/ - set perc to 0, prio to -1.
+	 * bs/perc - %s/%u - set prio to -1.
+	 * bs/perc/class/level - %s/%u/%u/%u
+	 */
+	matches = sscanf(str, "%m[^/]/%u/%u/%u", &bs_str, &perc, &class, &level);
+	if (matches < 1) {
+		log_err("fio: invalid cmdprio_bssplit format\n");
+		return 1;
+	}
+
+	if (str_to_decimal(bs_str, &bs_val, 1, o, 0, 0)) {
+		log_err("fio: split conversion failed\n");
+		free(bs_str);
+		return 1;
+	}
+	free(bs_str);
+
+	entry->bs = bs_val;
+	entry->perc = min(perc, 100u);
+	entry->prio = -1;
+	switch (matches) {
+	case 1: /* bs/ case */
+	case 2: /* bs/perc case */
+		break;
+	case 4: /* bs/perc/class/level case */
+		class = min(class, (unsigned int) IOPRIO_MAX_PRIO_CLASS);
+		level = min(level, (unsigned int) IOPRIO_MAX_PRIO);
+		entry->prio = ioprio_value(class, level);
+		break;
+	default:
+		log_err("fio: invalid cmdprio_bssplit format\n");
+		return 1;
+	}
+
+	return 0;
+}
+
+/*
+ * Returns a negative integer if the first argument should be before the second
+ * argument in the sorted list. A positive integer if the first argument should
+ * be after the second argument in the sorted list. A zero if they are equal.
+ */
+static int fio_split_prio_cmp(const void *p1, const void *p2)
+{
+	const struct split_prio *tmp1 = p1;
+	const struct split_prio *tmp2 = p2;
+
+	if (tmp1->bs > tmp2->bs)
+		return 1;
+	if (tmp1->bs < tmp2->bs)
+		return -1;
+	return 0;
+}
+
+int split_parse_prio_ddir(struct thread_options *o, struct split_prio **entries,
+			  int *nr_entries, char *str)
+{
+	struct split_prio *tmp_entries;
+	unsigned int nr_bssplits;
+	char *str_cpy, *p, *fname;
+
+	/* strsep modifies the string, dup it so that we can use strsep twice */
+	p = str_cpy = strdup(str);
+	if (!p)
+		return 1;
+
+	nr_bssplits = 0;
+	while ((fname = strsep(&str_cpy, ":")) != NULL) {
+		if (!strlen(fname))
+			break;
+		nr_bssplits++;
+	}
+	free(p);
+
+	if (nr_bssplits > BSSPLIT_MAX) {
+		log_err("fio: too many cmdprio_bssplit entries\n");
+		return 1;
+	}
+
+	tmp_entries = calloc(nr_bssplits, sizeof(*tmp_entries));
+	if (!tmp_entries)
+		return 1;
+
+	nr_bssplits = 0;
+	while ((fname = strsep(&str, ":")) != NULL) {
+		struct split_prio *entry;
+
+		if (!strlen(fname))
+			break;
+
+		entry = &tmp_entries[nr_bssplits];
+
+		if (parse_cmdprio_bssplit_entry(o, entry, fname)) {
+			log_err("fio: failed to parse cmdprio_bssplit entry\n");
+			free(tmp_entries);
+			return 1;
+		}
+
+		/* skip zero perc entries, they provide no useful information */
+		if (entry->perc)
+			nr_bssplits++;
+	}
+
+	qsort(tmp_entries, nr_bssplits, sizeof(*tmp_entries),
+	      fio_split_prio_cmp);
+
+	*entries = tmp_entries;
+	*nr_entries = nr_bssplits;
+
+	return 0;
+}
+
 static int str2error(char *str)
 {
 	const char *err[] = { "EPERM", "ENOENT", "ESRCH", "EINTR", "EIO",
@@ -4392,6 +4514,24 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.category = FIO_OPT_C_LOG,
 		.group = FIO_OPT_G_INVALID,
 	},
+	{
+		.name = "log_alternate_epoch",
+		.lname = "Log epoch alternate",
+		.type = FIO_OPT_BOOL,
+		.off1 = offsetof(struct thread_options, log_alternate_epoch),
+		.help = "Use alternate epoch time in log files. Uses the same epoch as that is used by clock_gettime with specified log_alternate_epoch_clock_id.",
+		.category = FIO_OPT_C_LOG,
+		.group = FIO_OPT_G_INVALID,
+	},
+	{
+		.name = "log_alternate_epoch_clock_id",
+		.lname = "Log alternate epoch clock_id",
+		.type = FIO_OPT_INT,
+		.off1 = offsetof(struct thread_options, log_alternate_epoch_clock_id),
+		.help = "If log_alternate_epoch or log_unix_epoch is true, this option specifies the clock_id from clock_gettime whose epoch should be used. If neither of those is true, this option has no effect. Default value is 0, or CLOCK_REALTIME",
+		.category = FIO_OPT_C_LOG,
+		.group = FIO_OPT_G_INVALID,
+	},
 	{
 		.name	= "block_error_percentiles",
 		.lname	= "Block error percentiles",
diff --git a/os/os-windows.h b/os/os-windows.h
index 59da9dba..510b8143 100644
--- a/os/os-windows.h
+++ b/os/os-windows.h
@@ -110,6 +110,8 @@ int nanosleep(const struct timespec *rqtp, struct timespec *rmtp);
 ssize_t pread(int fildes, void *buf, size_t nbyte, off_t offset);
 ssize_t pwrite(int fildes, const void *buf, size_t nbyte,
 		off_t offset);
+HANDLE windows_handle_connection(HANDLE hjob, int sk);
+HANDLE windows_create_job(void);
 
 static inline int blockdev_size(struct fio_file *f, unsigned long long *bytes)
 {
diff --git a/os/os.h b/os/os.h
index 5965d7b8..810e6166 100644
--- a/os/os.h
+++ b/os/os.h
@@ -119,10 +119,14 @@ extern int fio_cpus_split(os_cpu_mask_t *mask, unsigned int cpu);
 
 #ifndef FIO_HAVE_IOPRIO_CLASS
 #define ioprio_value_is_class_rt(prio)	(false)
+#define IOPRIO_MIN_PRIO_CLASS		0
+#define IOPRIO_MAX_PRIO_CLASS		0
 #endif
 #ifndef FIO_HAVE_IOPRIO
 #define ioprio_value(prioclass, prio)	(0)
 #define ioprio_set(which, who, prioclass, prio)	(0)
+#define IOPRIO_MIN_PRIO			0
+#define IOPRIO_MAX_PRIO			0
 #endif
 
 #ifndef FIO_HAVE_ODIRECT
diff --git a/os/windows/posix.c b/os/windows/posix.c
index 09c2e4a7..0d415e1e 100644
--- a/os/windows/posix.c
+++ b/os/windows/posix.c
@@ -537,16 +537,21 @@ int fcntl(int fildes, int cmd, ...)
 return 0;
 }
 
+#ifndef CLOCK_MONOTONIC_RAW
+#define CLOCK_MONOTONIC_RAW 4
+#endif
+
 /*
  * Get the value of a local clock source.
- * This implementation supports 2 clocks: CLOCK_MONOTONIC provides high-accuracy
- * relative time, while CLOCK_REALTIME provides a low-accuracy wall time.
+ * This implementation supports 3 clocks: CLOCK_MONOTONIC/CLOCK_MONOTONIC_RAW
+ * provide high-accuracy relative time, while CLOCK_REALTIME provides a
+ * low-accuracy wall time.
  */
 int clock_gettime(clockid_t clock_id, struct timespec *tp)
 {
 	int rc = 0;
 
-	if (clock_id == CLOCK_MONOTONIC) {
+	if (clock_id == CLOCK_MONOTONIC || clock_id == CLOCK_MONOTONIC_RAW) {
 		static LARGE_INTEGER freq = {{0,0}};
 		LARGE_INTEGER counts;
 		uint64_t t;
@@ -1026,3 +1031,174 @@ in_addr_t inet_network(const char *cp)
 	hbo = ((nbo & 0xFF) << 24) + ((nbo & 0xFF00) << 8) + ((nbo & 0xFF0000) >> 8) + ((nbo & 0xFF000000) >> 24);
 	return hbo;
 }
+
+static HANDLE create_named_pipe(char *pipe_name, int wait_connect_time)
+{
+	HANDLE hpipe;
+
+	hpipe = CreateNamedPipe (
+			pipe_name,
+			PIPE_ACCESS_DUPLEX,
+			PIPE_WAIT | PIPE_TYPE_BYTE,
+			1, 0, 0, wait_connect_time, NULL);
+
+	if (hpipe == INVALID_HANDLE_VALUE) {
+		log_err("ConnectNamedPipe failed (%lu).\n", GetLastError());
+		return INVALID_HANDLE_VALUE;
+	}
+
+	if (!ConnectNamedPipe(hpipe, NULL)) {
+		log_err("ConnectNamedPipe failed (%lu).\n", GetLastError());
+		CloseHandle(hpipe);
+		return INVALID_HANDLE_VALUE;
+	}
+
+	return hpipe;
+}
+
+static BOOL windows_create_process(PROCESS_INFORMATION *pi, const char *args, HANDLE *hjob)
+{
+	LPSTR this_cmd_line = GetCommandLine();
+	LPSTR new_process_cmd_line = malloc((strlen(this_cmd_line)+strlen(args)) * sizeof(char *));
+	STARTUPINFO si = {0};
+	DWORD flags = 0;
+
+	strcpy(new_process_cmd_line, this_cmd_line);
+	strcat(new_process_cmd_line, args);
+
+	si.cb = sizeof(si);
+	memset(pi, 0, sizeof(*pi));
+
+	if ((hjob != NULL) && (*hjob != INVALID_HANDLE_VALUE))
+		flags = CREATE_SUSPENDED | CREATE_BREAKAWAY_FROM_JOB;
+
+	flags |= CREATE_NEW_CONSOLE;
+
+	if( !CreateProcess( NULL,
+		new_process_cmd_line,
+		NULL,    /* Process handle not inherited */
+		NULL,    /* Thread handle not inherited */
+		TRUE,    /* no handle inheritance */
+		flags,
+		NULL,    /* Use parent's environment block */
+		NULL,    /* Use parent's starting directory */
+		&si,
+		pi )
+	)
+	{
+		log_err("CreateProcess failed (%lu).\n", GetLastError() );
+		free(new_process_cmd_line);
+		return 1;
+	}
+	if ((hjob != NULL) && (*hjob != INVALID_HANDLE_VALUE)) {
+		BOOL ret = AssignProcessToJobObject(*hjob, pi->hProcess);
+		if (!ret) {
+			log_err("AssignProcessToJobObject failed (%lu).\n", GetLastError() );
+			return 1;
+		}
+
+ 		ResumeThread(pi->hThread);
+	}
+
+	free(new_process_cmd_line);
+	return 0;
+}
+
+HANDLE windows_create_job(void)
+{
+	JOBOBJECT_EXTENDED_LIMIT_INFORMATION jeli = { 0 };
+	BOOL success;
+	HANDLE hjob = CreateJobObject(NULL, NULL);
+
+	jeli.BasicLimitInformation.LimitFlags = JOB_OBJECT_LIMIT_KILL_ON_JOB_CLOSE;
+	success = SetInformationJobObject(hjob, JobObjectExtendedLimitInformation, &jeli, sizeof(jeli));
+	if ( success == 0 ) {
+        log_err( "SetInformationJobObject failed: error %lu\n", GetLastError() );
+        return INVALID_HANDLE_VALUE;
+    }
+	return hjob;
+}
+
+/* wait for a child process to either exit or connect to a child */
+static bool monitor_process_till_connect(PROCESS_INFORMATION *pi, HANDLE *hpipe)
+{
+	bool connected = FALSE;
+	bool process_alive = TRUE;
+	char buffer[32] = {0};
+	DWORD bytes_read;
+
+	do {
+		DWORD exit_code;
+		GetExitCodeProcess(pi->hProcess, &exit_code);
+		if (exit_code != STILL_ACTIVE) {
+			dprint(FD_PROCESS, "process %u exited %d\n", GetProcessId(pi->hProcess), exit_code);
+			break;
+		}
+
+		memset(buffer, 0, sizeof(buffer));
+		ReadFile(*hpipe, &buffer, sizeof(buffer) - 1, &bytes_read, NULL);
+		if (bytes_read && strstr(buffer, "connected")) {
+			dprint(FD_PROCESS, "process %u connected to client\n", GetProcessId(pi->hProcess));
+			connected = TRUE;
+		}
+		usleep(10*1000);
+	} while (process_alive && !connected);
+	return connected;
+}
+
+/*create a process with --server-internal to emulate fork() */
+HANDLE windows_handle_connection(HANDLE hjob, int sk)
+{
+	char pipe_name[64] =  "\\\\.\\pipe\\fiointernal-";
+	char args[128] = " --server-internal=";
+	PROCESS_INFORMATION pi;
+	HANDLE hpipe = INVALID_HANDLE_VALUE;
+	WSAPROTOCOL_INFO protocol_info;
+	HANDLE ret;
+
+	sprintf(pipe_name+strlen(pipe_name), "%d", GetCurrentProcessId());
+	sprintf(args+strlen(args), "%s", pipe_name);
+
+	if (windows_create_process(&pi, args, &hjob) != 0)
+		return INVALID_HANDLE_VALUE;
+	else
+		ret = pi.hProcess;
+
+	/* duplicate socket and write the protocol_info to pipe so child can
+	 * duplicate the communciation socket */
+	if (WSADuplicateSocket(sk, GetProcessId(pi.hProcess), &protocol_info)) {
+		log_err("WSADuplicateSocket failed (%lu).\n", GetLastError());
+		ret = INVALID_HANDLE_VALUE;
+		goto cleanup;
+	}
+
+	/* make a pipe with a unique name based upon processid */
+	hpipe = create_named_pipe(pipe_name, 1000);
+	if (hpipe == INVALID_HANDLE_VALUE) {
+		ret = INVALID_HANDLE_VALUE;
+		goto cleanup;
+	}
+
+	if (!WriteFile(hpipe, &protocol_info, sizeof(protocol_info), NULL, NULL)) {
+		log_err("WriteFile failed (%lu).\n", GetLastError());
+		ret = INVALID_HANDLE_VALUE;
+		goto cleanup;
+	}
+
+	dprint(FD_PROCESS, "process %d created child process %u\n", GetCurrentProcessId(), GetProcessId(pi.hProcess));
+
+	/* monitor the process until it either exits or connects. This level
+	 * doesnt care which of those occurs because the result is that it
+	 * needs to loop around and create another child process to monitor */
+	if (!monitor_process_till_connect(&pi, &hpipe))
+		ret = INVALID_HANDLE_VALUE;
+
+cleanup:
+	/* close the handles and pipes because this thread is done monitoring them */
+	if (ret == INVALID_HANDLE_VALUE)
+		CloseHandle(pi.hProcess);
+	CloseHandle(pi.hThread);
+	DisconnectNamedPipe(hpipe);
+	CloseHandle(hpipe);
+	return ret;
+}
\ No newline at end of file
diff --git a/rate-submit.c b/rate-submit.c
index 752c30a5..268356d1 100644
--- a/rate-submit.c
+++ b/rate-submit.c
@@ -173,7 +173,7 @@ static int io_workqueue_init_worker_fn(struct submit_worker *sw)
 	if (td->io_ops->post_init && td->io_ops->post_init(td))
 		goto err_io_init;
 
-	set_epoch_time(td, td->o.log_unix_epoch);
+	set_epoch_time(td, td->o.log_unix_epoch | td->o.log_alternate_epoch, td->o.log_alternate_epoch_clock_id);
 	fio_getrusage(&td->ru_start);
 	clear_io_state(td, 1);
 
@@ -195,6 +195,15 @@ static void io_workqueue_exit_worker_fn(struct submit_worker *sw,
 	struct thread_data *td = sw->priv;
 
 	(*sum_cnt)++;
+
+	/*
+	 * io_workqueue_update_acct_fn() doesn't support per prio stats, and
+	 * even if it did, offload can't be used with all async IO engines.
+	 * If group reporting is set in the parent td, the group result
+	 * generated by __show_run_stats() can still contain multiple prios
+	 * from different offloaded jobs.
+	 */
+	sw->wq->td->ts.disable_prio_stat = 1;
 	sum_thread_stats(&sw->wq->td->ts, &td->ts);
 
 	fio_options_free(td);
diff --git a/server.c b/server.c
index 90c52e01..914a8c74 100644
--- a/server.c
+++ b/server.c
@@ -63,12 +63,28 @@ static char me[128];
 
 static pthread_key_t sk_out_key;
 
+#ifdef WIN32
+static char *fio_server_pipe_name  = NULL;
+static HANDLE hjob = INVALID_HANDLE_VALUE;
+struct ffi_element {
+	union {
+		pthread_t thread;
+		HANDLE hProcess;
+	};
+	bool is_thread;
+};
+#endif
+
 struct fio_fork_item {
 	struct flist_head list;
 	int exitval;
 	int signal;
 	int exited;
+#ifdef WIN32
+	struct ffi_element element;
+#else
 	pid_t pid;
+#endif
 };
 
 struct cmd_reply {
@@ -250,6 +266,28 @@ static int fio_send_data(int sk, const void *p, unsigned int len)
 	return fio_sendv_data(sk, &iov, 1);
 }
 
+bool fio_server_poll_fd(int fd, short events, int timeout)
+{
+	struct pollfd pfd = {
+		.fd	= fd,
+		.events	= events,
+	};
+	int ret;
+
+	ret = poll(&pfd, 1, timeout);
+	if (ret < 0) {
+		if (errno == EINTR)
+			return false;
+		log_err("fio: poll: %s\n", strerror(errno));
+		return false;
+	} else if (!ret) {
+		return false;
+	}
+	if (pfd.revents & events)
+		return true;
+	return false;
+}
+
 static int fio_recv_data(int sk, void *buf, unsigned int len, bool wait)
 {
 	int flags;
@@ -651,6 +689,63 @@ static int fio_net_queue_stop(int error, int signal)
 	return fio_net_send_ack(NULL, error, signal);
 }
 
+#ifdef WIN32
+static void fio_server_add_fork_item(struct ffi_element *element, struct flist_head *list)
+{
+	struct fio_fork_item *ffi;
+
+	ffi = malloc(sizeof(*ffi));
+	ffi->exitval = 0;
+	ffi->signal = 0;
+	ffi->exited = 0;
+	ffi->element = *element;
+	flist_add_tail(&ffi->list, list);
+}
+
+static void fio_server_add_conn_pid(struct flist_head *conn_list, HANDLE hProcess)
+{
+	struct ffi_element element = {.hProcess = hProcess, .is_thread=FALSE};
+	dprint(FD_NET, "server: forked off connection job (tid=%u)\n", (int) element.thread);
+
+	fio_server_add_fork_item(&element, conn_list);
+}
+
+static void fio_server_add_job_pid(struct flist_head *job_list, pthread_t thread)
+{
+	struct ffi_element element = {.thread = thread, .is_thread=TRUE};
+	dprint(FD_NET, "server: forked off job job (tid=%u)\n", (int) element.thread);
+	fio_server_add_fork_item(&element, job_list);
+}
+
+static void fio_server_check_fork_item(struct fio_fork_item *ffi)
+{
+	int ret;
+
+	if (ffi->element.is_thread) {
+
+		ret = pthread_kill(ffi->element.thread, 0);
+		if (ret) {
+			int rev_val;
+			pthread_join(ffi->element.thread, (void**) &rev_val); /*if the thread is dead, then join it to get status*/
+
+			ffi->exitval = rev_val;
+			if (ffi->exitval)
+				log_err("thread (tid=%u) exited with %x\n", (int) ffi->element.thread, (int) ffi->exitval);
+			dprint(FD_PROCESS, "thread (tid=%u) exited with %x\n", (int) ffi->element.thread, (int) ffi->exitval);
+			ffi->exited = 1;
+		}
+	} else {
+		DWORD exit_val;
+		GetExitCodeProcess(ffi->element.hProcess, &exit_val);
+
+		if (exit_val != STILL_ACTIVE) {
+			dprint(FD_PROCESS, "process %u exited with %d\n", GetProcessId(ffi->element.hProcess), exit_val);
+			ffi->exited = 1;
+			ffi->exitval = exit_val;
+		}
+	}
+}
+#else
 static void fio_server_add_fork_item(pid_t pid, struct flist_head *list)
 {
 	struct fio_fork_item *ffi;
@@ -698,10 +793,21 @@ static void fio_server_check_fork_item(struct fio_fork_item *ffi)
 		}
 	}
 }
+#endif
 
 static void fio_server_fork_item_done(struct fio_fork_item *ffi, bool stop)
 {
+#ifdef WIN32
+	if (ffi->element.is_thread)
+		dprint(FD_NET, "tid %u exited, sig=%u, exitval=%d\n", (int) ffi->element.thread, ffi->signal, ffi->exitval);
+	else {
+		dprint(FD_NET, "pid %u exited, sig=%u, exitval=%d\n", (int)  GetProcessId(ffi->element.hProcess), ffi->signal, ffi->exitval);
+		CloseHandle(ffi->element.hProcess);
+		ffi->element.hProcess = INVALID_HANDLE_VALUE;
+	}
+#else
 	dprint(FD_NET, "pid %u exited, sig=%u, exitval=%d\n", (int) ffi->pid, ffi->signal, ffi->exitval);
+#endif
 
 	/*
 	 * Fold STOP and QUIT...
@@ -762,27 +868,62 @@ static int handle_load_file_cmd(struct fio_net_cmd *cmd)
 	return 0;
 }
 
-static int handle_run_cmd(struct sk_out *sk_out, struct flist_head *job_list,
-			  struct fio_net_cmd *cmd)
+#ifdef WIN32
+static void *fio_backend_thread(void *data)
 {
-	pid_t pid;
 	int ret;
+	struct sk_out *sk_out = (struct sk_out *) data;
 
 	sk_out_assign(sk_out);
 
+	ret = fio_backend(sk_out);
+	sk_out_drop();
+
+	pthread_exit((void*) (intptr_t) ret);
+	return NULL;
+}
+#endif
+
+static int handle_run_cmd(struct sk_out *sk_out, struct flist_head *job_list,
+			  struct fio_net_cmd *cmd)
+{
+	int ret;
+
 	fio_time_init();
 	set_genesis_time();
 
-	pid = fork();
-	if (pid) {
-		fio_server_add_job_pid(job_list, pid);
-		return 0;
+#ifdef WIN32
+	{
+		pthread_t thread;
+		/* both this thread and backend_thread call sk_out_assign() to double increment
+		 * the ref count.  This ensures struct is valid until both threads are done with it
+		 */
+		sk_out_assign(sk_out);
+		ret = pthread_create(&thread, NULL,	fio_backend_thread, sk_out);
+		if (ret) {
+			log_err("pthread_create: %s\n", strerror(ret));
+			return ret;
+		}
+
+		fio_server_add_job_pid(job_list, thread);
+		return ret;
 	}
+#else
+    {
+		pid_t pid;
+		sk_out_assign(sk_out);
+		pid = fork();
+		if (pid) {
+			fio_server_add_job_pid(job_list, pid);
+			return 0;
+		}
 
-	ret = fio_backend(sk_out);
-	free_threads_shm();
-	sk_out_drop();
-	_exit(ret);
+		ret = fio_backend(sk_out);
+		free_threads_shm();
+		sk_out_drop();
+		_exit(ret);
+	}
+#endif
 }
 
 static int handle_job_cmd(struct fio_net_cmd *cmd)
@@ -1238,7 +1379,8 @@ static int handle_connection(struct sk_out *sk_out)
 		if (ret < 0)
 			break;
 
-		cmd = fio_net_recv_cmd(sk_out->sk, true);
+		if (pfd.revents & POLLIN)
+			cmd = fio_net_recv_cmd(sk_out->sk, true);
 		if (!cmd) {
 			ret = -1;
 			break;
@@ -1300,6 +1442,73 @@ static int get_my_addr_str(int sk)
 	return 0;
 }
 
+#ifdef WIN32
+static int handle_connection_process(void)
+{
+	WSAPROTOCOL_INFO protocol_info;
+	DWORD bytes_read;
+	HANDLE hpipe;
+	int sk;
+	struct sk_out *sk_out;
+	int ret;
+	char *msg = (char *) "connected";
+
+	log_info("server enter accept loop.  ProcessID %d\n", GetCurrentProcessId());
+
+	hpipe = CreateFile(
+					fio_server_pipe_name,
+					GENERIC_READ | GENERIC_WRITE,
+					0, NULL,
+					OPEN_EXISTING,
+					0, NULL);
+
+	if (hpipe == INVALID_HANDLE_VALUE) {
+		log_err("couldnt open pipe %s error %lu\n",
+				fio_server_pipe_name, GetLastError());
+		return -1;
+	}
+
+	if (!ReadFile(hpipe, &protocol_info, sizeof(protocol_info), &bytes_read, NULL)) {
+		log_err("couldnt read pi from pipe %s error %lu\n", fio_server_pipe_name,
+				GetLastError());
+	}
+
+	if (use_ipv6) /* use protocol_info to create a duplicate of parents socket */
+		sk = WSASocket(AF_INET6, SOCK_STREAM, 0, &protocol_info, 0, 0);
+	else
+		sk = WSASocket(AF_INET,  SOCK_STREAM, 0, &protocol_info, 0, 0);
+
+	sk_out = scalloc(1, sizeof(*sk_out));
+	if (!sk_out) {
+		CloseHandle(hpipe);
+		close(sk);
+		return -1;
+	}
+
+	sk_out->sk = sk;
+	sk_out->hProcess = INVALID_HANDLE_VALUE;
+	INIT_FLIST_HEAD(&sk_out->list);
+	__fio_sem_init(&sk_out->lock, FIO_SEM_UNLOCKED);
+	__fio_sem_init(&sk_out->wait, FIO_SEM_LOCKED);
+	__fio_sem_init(&sk_out->xmit, FIO_SEM_UNLOCKED);
+
+	get_my_addr_str(sk);
+
+	if (!WriteFile(hpipe, msg, strlen(msg), NULL, NULL)) {
+		log_err("couldnt write pipe\n");
+		close(sk);
+		return -1;
+	}
+	CloseHandle(hpipe);
+
+	sk_out_assign(sk_out);
+
+	ret = handle_connection(sk_out);
+	__sk_out_drop(sk_out);
+	return ret;
+}
+#endif
+
 static int accept_loop(int listen_sk)
 {
 	struct sockaddr_in addr;
@@ -1317,8 +1526,11 @@ static int accept_loop(int listen_sk)
 		struct sk_out *sk_out;
 		const char *from;
 		char buf[64];
+#ifdef WIN32
+		HANDLE hProcess;
+#else
 		pid_t pid;
-
+#endif
 		pfd.fd = listen_sk;
 		pfd.events = POLLIN;
 		do {
@@ -1376,6 +1588,13 @@ static int accept_loop(int listen_sk)
 		__fio_sem_init(&sk_out->wait, FIO_SEM_LOCKED);
 		__fio_sem_init(&sk_out->xmit, FIO_SEM_UNLOCKED);
 
+#ifdef WIN32
+		hProcess = windows_handle_connection(hjob, sk);
+		if (hProcess == INVALID_HANDLE_VALUE)
+			return -1;
+		sk_out->hProcess = hProcess;
+		fio_server_add_conn_pid(&conn_list, hProcess);
+#else
 		pid = fork();
 		if (pid) {
 			close(sk);
@@ -1392,6 +1611,7 @@ static int accept_loop(int listen_sk)
 		 */
 		sk_out_assign(sk_out);
 		handle_connection(sk_out);
+#endif
 	}
 
 	return exitval;
@@ -1465,8 +1685,11 @@ void fio_server_send_ts(struct thread_stat *ts, struct group_run_stats *rs)
 {
 	struct cmd_ts_pdu p;
 	int i, j, k;
-	void *ss_buf;
-	uint64_t *ss_iops, *ss_bw;
+	size_t clat_prio_stats_extra_size = 0;
+	size_t ss_extra_size = 0;
+	size_t extended_buf_size = 0;
+	void *extended_buf;
+	void *extended_buf_wp;
 
 	dprint(FD_NET, "server sending end stats\n");
 
@@ -1483,6 +1706,8 @@ void fio_server_send_ts(struct thread_stat *ts, struct group_run_stats *rs)
 	p.ts.pid		= cpu_to_le32(ts->pid);
 	p.ts.members		= cpu_to_le32(ts->members);
 	p.ts.unified_rw_rep	= cpu_to_le32(ts->unified_rw_rep);
+	p.ts.ioprio		= cpu_to_le32(ts->ioprio);
+	p.ts.disable_prio_stat	= cpu_to_le32(ts->disable_prio_stat);
 
 	for (i = 0; i < DDIR_RWDIR_CNT; i++) {
 		convert_io_stat(&p.ts.clat_stat[i], &ts->clat_stat[i]);
@@ -1577,38 +1802,88 @@ void fio_server_send_ts(struct thread_stat *ts, struct group_run_stats *rs)
 	p.ts.cachehit		= cpu_to_le64(ts->cachehit);
 	p.ts.cachemiss		= cpu_to_le64(ts->cachemiss);
 
+	convert_gs(&p.rs, rs);
+
 	for (i = 0; i < DDIR_RWDIR_CNT; i++) {
-		for (j = 0; j < FIO_IO_U_PLAT_NR; j++) {
-			p.ts.io_u_plat_high_prio[i][j] = cpu_to_le64(ts->io_u_plat_high_prio[i][j]);
-			p.ts.io_u_plat_low_prio[i][j] = cpu_to_le64(ts->io_u_plat_low_prio[i][j]);
+		if (ts->nr_clat_prio[i])
+			clat_prio_stats_extra_size += ts->nr_clat_prio[i] * sizeof(*ts->clat_prio[i]);
+	}
+	extended_buf_size += clat_prio_stats_extra_size;
+
+	dprint(FD_NET, "ts->ss_state = %d\n", ts->ss_state);
+	if (ts->ss_state & FIO_SS_DATA)
+		ss_extra_size = 2 * ts->ss_dur * sizeof(uint64_t);
+
+	extended_buf_size += ss_extra_size;
+	if (!extended_buf_size) {
+		fio_net_queue_cmd(FIO_NET_CMD_TS, &p, sizeof(p), NULL, SK_F_COPY);
+		return;
+	}
+
+	extended_buf_size += sizeof(p);
+	extended_buf = calloc(1, extended_buf_size);
+	if (!extended_buf) {
+		log_err("fio: failed to allocate FIO_NET_CMD_TS buffer\n");
+		return;
+	}
+
+	memcpy(extended_buf, &p, sizeof(p));
+	extended_buf_wp = (struct cmd_ts_pdu *)extended_buf + 1;
+
+	if (clat_prio_stats_extra_size) {
+		for (i = 0; i < DDIR_RWDIR_CNT; i++) {
+			struct clat_prio_stat *prio = (struct clat_prio_stat *) extended_buf_wp;
+
+			for (j = 0; j < ts->nr_clat_prio[i]; j++) {
+				for (k = 0; k < FIO_IO_U_PLAT_NR; k++)
+					prio->io_u_plat[k] =
+						cpu_to_le64(ts->clat_prio[i][j].io_u_plat[k]);
+				convert_io_stat(&prio->clat_stat,
+						&ts->clat_prio[i][j].clat_stat);
+				prio->ioprio = cpu_to_le32(ts->clat_prio[i][j].ioprio);
+				prio++;
+			}
+
+			if (ts->nr_clat_prio[i]) {
+				uint64_t offset = (char *)extended_buf_wp - (char *)extended_buf;
+				struct cmd_ts_pdu *ptr = extended_buf;
+
+				ptr->ts.clat_prio_offset[i] = cpu_to_le64(offset);
+				ptr->ts.nr_clat_prio[i] = cpu_to_le32(ts->nr_clat_prio[i]);
+			}
+
+			extended_buf_wp = prio;
 		}
-		convert_io_stat(&p.ts.clat_high_prio_stat[i], &ts->clat_high_prio_stat[i]);
-		convert_io_stat(&p.ts.clat_low_prio_stat[i], &ts->clat_low_prio_stat[i]);
 	}
 
-	convert_gs(&p.rs, rs);
+	if (ss_extra_size) {
+		uint64_t *ss_iops, *ss_bw;
+		uint64_t offset;
+		struct cmd_ts_pdu *ptr = extended_buf;
 
-	dprint(FD_NET, "ts->ss_state = %d\n", ts->ss_state);
-	if (ts->ss_state & FIO_SS_DATA) {
 		dprint(FD_NET, "server sending steadystate ring buffers\n");
 
-		ss_buf = malloc(sizeof(p) + 2*ts->ss_dur*sizeof(uint64_t));
+		/* ss iops */
+		ss_iops = (uint64_t *) extended_buf_wp;
+		for (i = 0; i < ts->ss_dur; i++)
+			ss_iops[i] = cpu_to_le64(ts->ss_iops_data[i]);
 
-		memcpy(ss_buf, &p, sizeof(p));
+		offset = (char *)extended_buf_wp - (char *)extended_buf;
+		ptr->ts.ss_iops_data_offset = cpu_to_le64(offset);
+		extended_buf_wp = ss_iops + (int) ts->ss_dur;
 
-		ss_iops = (uint64_t *) ((struct cmd_ts_pdu *)ss_buf + 1);
-		ss_bw = ss_iops + (int) ts->ss_dur;
-		for (i = 0; i < ts->ss_dur; i++) {
-			ss_iops[i] = cpu_to_le64(ts->ss_iops_data[i]);
+		/* ss bw */
+		ss_bw = extended_buf_wp;
+		for (i = 0; i < ts->ss_dur; i++)
 			ss_bw[i] = cpu_to_le64(ts->ss_bw_data[i]);
-		}
-
-		fio_net_queue_cmd(FIO_NET_CMD_TS, ss_buf, sizeof(p) + 2*ts->ss_dur*sizeof(uint64_t), NULL, SK_F_COPY);
 
-		free(ss_buf);
+		offset = (char *)extended_buf_wp - (char *)extended_buf;
+		ptr->ts.ss_bw_data_offset = cpu_to_le64(offset);
+		extended_buf_wp = ss_bw + (int) ts->ss_dur;
 	}
-	else
-		fio_net_queue_cmd(FIO_NET_CMD_TS, &p, sizeof(p), NULL, SK_F_COPY);
+
+	fio_net_queue_cmd(FIO_NET_CMD_TS, extended_buf, extended_buf_size, NULL, SK_F_COPY);
+	free(extended_buf);
 }
 
 void fio_server_send_gs(struct group_run_stats *rs)
@@ -2489,12 +2764,25 @@ static int fio_server(void)
 	if (fio_handle_server_arg())
 		return -1;
 
+	set_sig_handlers();
+
+#ifdef WIN32
+	/* if this is a child process, go handle the connection */
+	if (fio_server_pipe_name != NULL) {
+		ret = handle_connection_process();
+		return ret;
+	}
+
+	/* job to link child processes so they terminate together */
+	hjob = windows_create_job();
+	if (hjob == INVALID_HANDLE_VALUE)
+		return -1;
+#endif
+
 	sk = fio_init_server_connection();
 	if (sk < 0)
 		return -1;
 
-	set_sig_handlers();
-
 	ret = accept_loop(sk);
 
 	close(sk);
@@ -2635,3 +2923,10 @@ void fio_server_set_arg(const char *arg)
 {
 	fio_server_arg = strdup(arg);
 }
+
+#ifdef WIN32
+void fio_server_internal_set(const char *arg)
+{
+	fio_server_pipe_name = strdup(arg);
+}
+#endif
diff --git a/server.h b/server.h
index 25b6bbdc..0e62b6df 100644
--- a/server.h
+++ b/server.h
@@ -15,6 +15,9 @@ struct sk_out {
 	unsigned int refs;	/* frees sk_out when it drops to zero.
 				 * protected by below ->lock */
 
+#ifdef WIN32
+	HANDLE hProcess;		/* process handle of handle_connection_process*/
+#endif
 	int sk;			/* socket fd to talk to client */
 	struct fio_sem lock;	/* protects ref and below list */
 	struct flist_head list;	/* list of pending transmit work */
@@ -48,7 +51,7 @@ struct fio_net_cmd_reply {
 };
 
 enum {
-	FIO_SERVER_VER			= 95,
+	FIO_SERVER_VER			= 96,
 
 	FIO_SERVER_MAX_FRAGMENT_PDU	= 1024,
 	FIO_SERVER_MAX_CMD_MB		= 2048,
@@ -212,6 +215,7 @@ extern int fio_server_text_output(int, const char *, size_t);
 extern int fio_net_send_cmd(int, uint16_t, const void *, off_t, uint64_t *, struct flist_head *);
 extern int fio_net_send_simple_cmd(int, uint16_t, uint64_t, struct flist_head *);
 extern void fio_server_set_arg(const char *);
+extern void fio_server_internal_set(const char *);
 extern int fio_server_parse_string(const char *, char **, bool *, int *, struct in_addr *, struct in6_addr *, int *);
 extern int fio_server_parse_host(const char *, int, struct in_addr *, struct in6_addr *);
 extern const char *fio_server_op(unsigned int);
@@ -222,6 +226,7 @@ extern void fio_server_send_gs(struct group_run_stats *);
 extern void fio_server_send_du(void);
 extern void fio_server_send_job_options(struct flist_head *, unsigned int);
 extern int fio_server_get_verify_state(const char *, int, void **);
+extern bool fio_server_poll_fd(int fd, short events, int timeout);
 
 extern struct fio_net_cmd *fio_net_recv_cmd(int sk, bool wait);
 
diff --git a/stat.c b/stat.c
index b08d2f25..0876222a 100644
--- a/stat.c
+++ b/stat.c
@@ -265,6 +265,18 @@ static void show_clat_percentiles(uint64_t *io_u_plat, unsigned long long nr,
 	free(ovals);
 }
 
+static int get_nr_prios_with_samples(struct thread_stat *ts, enum fio_ddir ddir)
+{
+	int i, nr_prios_with_samples = 0;
+
+	for (i = 0; i < ts->nr_clat_prio[ddir]; i++) {
+		if (ts->clat_prio[ddir][i].clat_stat.samples)
+			nr_prios_with_samples++;
+	}
+
+	return nr_prios_with_samples;
+}
+
 bool calc_lat(struct io_stat *is, unsigned long long *min,
 	      unsigned long long *max, double *mean, double *dev)
 {
@@ -491,7 +503,8 @@ static struct thread_stat *gen_mixed_ddir_stats_from_ts(struct thread_stat *ts)
 	return ts_lcl;
 }
 
-static double convert_agg_kbytes_percent(struct group_run_stats *rs, int ddir, int mean)
+static double convert_agg_kbytes_percent(struct group_run_stats *rs,
+					 enum fio_ddir ddir, int mean)
 {
 	double p_of_agg = 100.0;
 	if (rs && rs->agg[ddir] > 1024) {
@@ -504,13 +517,14 @@ static double convert_agg_kbytes_percent(struct group_run_stats *rs, int ddir, i
 }
 
 static void show_ddir_status(struct group_run_stats *rs, struct thread_stat *ts,
-			     int ddir, struct buf_output *out)
+			     enum fio_ddir ddir, struct buf_output *out)
 {
 	unsigned long runt;
 	unsigned long long min, max, bw, iops;
 	double mean, dev;
 	char *io_p, *bw_p, *bw_p_alt, *iops_p, *post_st = NULL;
-	int i2p;
+	int i2p, i;
+	const char *clat_type = ts->lat_percentiles ? "lat" : "clat";
 
 	if (ddir_sync(ddir)) {
 		if (calc_lat(&ts->sync_stat, &min, &max, &mean, &dev)) {
@@ -571,12 +585,22 @@ static void show_ddir_status(struct group_run_stats *rs, struct thread_stat *ts,
 		display_lat("clat", min, max, mean, dev, out);
 	if (calc_lat(&ts->lat_stat[ddir], &min, &max, &mean, &dev))
 		display_lat(" lat", min, max, mean, dev, out);
-	if (calc_lat(&ts->clat_high_prio_stat[ddir], &min, &max, &mean, &dev)) {
-		display_lat(ts->lat_percentiles ? "high prio_lat" : "high prio_clat",
-				min, max, mean, dev, out);
-		if (calc_lat(&ts->clat_low_prio_stat[ddir], &min, &max, &mean, &dev))
-			display_lat(ts->lat_percentiles ? "low prio_lat" : "low prio_clat",
-					min, max, mean, dev, out);
+
+	/* Only print per prio stats if there are >= 2 prios with samples */
+	if (get_nr_prios_with_samples(ts, ddir) >= 2) {
+		for (i = 0; i < ts->nr_clat_prio[ddir]; i++) {
+			if (calc_lat(&ts->clat_prio[ddir][i].clat_stat, &min,
+				     &max, &mean, &dev)) {
+				char buf[64];
+
+				snprintf(buf, sizeof(buf),
+					 "%s prio %u/%u",
+					 clat_type,
+					 ts->clat_prio[ddir][i].ioprio >> 13,
+					 ts->clat_prio[ddir][i].ioprio & 7);
+				display_lat(buf, min, max, mean, dev, out);
+			}
+		}
 	}
 
 	if (ts->slat_percentiles && ts->slat_stat[ddir].samples > 0)
@@ -596,8 +620,7 @@ static void show_ddir_status(struct group_run_stats *rs, struct thread_stat *ts,
 					ts->percentile_precision, "lat", out);
 
 	if (ts->clat_percentiles || ts->lat_percentiles) {
-		const char *name = ts->lat_percentiles ? "lat" : "clat";
-		char prio_name[32];
+		char prio_name[64];
 		uint64_t samples;
 
 		if (ts->lat_percentiles)
@@ -605,25 +628,24 @@ static void show_ddir_status(struct group_run_stats *rs, struct thread_stat *ts,
 		else
 			samples = ts->clat_stat[ddir].samples;
 
-		/* Only print this if some high and low priority stats were collected */
-		if (ts->clat_high_prio_stat[ddir].samples > 0 &&
-			ts->clat_low_prio_stat[ddir].samples > 0)
-		{
-			sprintf(prio_name, "high prio (%.2f%%) %s",
-					100. * (double) ts->clat_high_prio_stat[ddir].samples / (double) samples,
-					name);
-			show_clat_percentiles(ts->io_u_plat_high_prio[ddir],
-						ts->clat_high_prio_stat[ddir].samples,
-						ts->percentile_list,
-						ts->percentile_precision, prio_name, out);
-
-			sprintf(prio_name, "low prio (%.2f%%) %s",
-					100. * (double) ts->clat_low_prio_stat[ddir].samples / (double) samples,
-					name);
-			show_clat_percentiles(ts->io_u_plat_low_prio[ddir],
-						ts->clat_low_prio_stat[ddir].samples,
-						ts->percentile_list,
-						ts->percentile_precision, prio_name, out);
+		/* Only print per prio stats if there are >= 2 prios with samples */
+		if (get_nr_prios_with_samples(ts, ddir) >= 2) {
+			for (i = 0; i < ts->nr_clat_prio[ddir]; i++) {
+				uint64_t prio_samples = ts->clat_prio[ddir][i].clat_stat.samples;
+
+				if (prio_samples > 0) {
+					snprintf(prio_name, sizeof(prio_name),
+						 "%s prio %u/%u (%.2f%% of IOs)",
+						 clat_type,
+						 ts->clat_prio[ddir][i].ioprio >> 13,
+						 ts->clat_prio[ddir][i].ioprio & 7,
+						 100. * (double) prio_samples / (double) samples);
+					show_clat_percentiles(ts->clat_prio[ddir][i].io_u_plat,
+							      prio_samples, ts->percentile_list,
+							      ts->percentile_precision,
+							      prio_name, out);
+				}
+			}
 		}
 	}
 
@@ -678,6 +700,7 @@ static void show_mixed_ddir_status(struct group_run_stats *rs,
 	if (ts_lcl)
 		show_ddir_status(rs, ts_lcl, DDIR_READ, out);
 
+	free_clat_prio_stats(ts_lcl);
 	free(ts_lcl);
 }
 
@@ -1251,8 +1274,9 @@ static void show_thread_status_normal(struct thread_stat *ts,
 }
 
 static void show_ddir_status_terse(struct thread_stat *ts,
-				   struct group_run_stats *rs, int ddir,
-				   int ver, struct buf_output *out)
+				   struct group_run_stats *rs,
+				   enum fio_ddir ddir, int ver,
+				   struct buf_output *out)
 {
 	unsigned long long min, max, minv, maxv, bw, iops;
 	unsigned long long *ovals = NULL;
@@ -1351,6 +1375,7 @@ static void show_mixed_ddir_status_terse(struct thread_stat *ts,
 	if (ts_lcl)
 		show_ddir_status_terse(ts_lcl, rs, DDIR_READ, ver, out);
 
+	free_clat_prio_stats(ts_lcl);
 	free(ts_lcl);
 }
 
@@ -1407,7 +1432,8 @@ static struct json_object *add_ddir_lat_json(struct thread_stat *ts,
 }
 
 static void add_ddir_status_json(struct thread_stat *ts,
-		struct group_run_stats *rs, int ddir, struct json_object *parent)
+				 struct group_run_stats *rs, enum fio_ddir ddir,
+				 struct json_object *parent)
 {
 	unsigned long long min, max;
 	unsigned long long bw_bytes, bw;
@@ -1467,25 +1493,37 @@ static void add_ddir_status_json(struct thread_stat *ts,
 	if (!ddir_rw(ddir))
 		return;
 
-	/* Only print PRIO latencies if some high priority samples were gathered */
-	if (ts->clat_high_prio_stat[ddir].samples > 0) {
-		const char *high, *low;
+	/* Only include per prio stats if there are >= 2 prios with samples */
+	if (get_nr_prios_with_samples(ts, ddir) >= 2) {
+		struct json_array *array = json_create_array();
+		const char *obj_name;
+		int i;
 
-		if (ts->lat_percentiles) {
-			high = "lat_high_prio";
-			low = "lat_low_prio";
-		} else {
-			high = "clat_high_prio";
-			low = "clat_low_prio";
+		if (ts->lat_percentiles)
+			obj_name = "lat_ns";
+		else
+			obj_name = "clat_ns";
+
+		json_object_add_value_array(dir_object, "prios", array);
+
+		for (i = 0; i < ts->nr_clat_prio[ddir]; i++) {
+			if (ts->clat_prio[ddir][i].clat_stat.samples > 0) {
+				struct json_object *obj = json_create_object();
+				unsigned long long class, level;
+
+				class = ts->clat_prio[ddir][i].ioprio >> 13;
+				json_object_add_value_int(obj, "prioclass", class);
+				level = ts->clat_prio[ddir][i].ioprio & 7;
+				json_object_add_value_int(obj, "prio", level);
+
+				tmp_object = add_ddir_lat_json(ts,
+							       ts->clat_percentiles | ts->lat_percentiles,
+							       &ts->clat_prio[ddir][i].clat_stat,
+							       ts->clat_prio[ddir][i].io_u_plat);
+				json_object_add_value_object(obj, obj_name, tmp_object);
+				json_array_add_value_object(array, obj);
+			}
 		}
-
-		tmp_object = add_ddir_lat_json(ts, ts->clat_percentiles | ts->lat_percentiles,
-				&ts->clat_high_prio_stat[ddir], ts->io_u_plat_high_prio[ddir]);
-		json_object_add_value_object(dir_object, high, tmp_object);
-
-		tmp_object = add_ddir_lat_json(ts, ts->clat_percentiles | ts->lat_percentiles,
-				&ts->clat_low_prio_stat[ddir], ts->io_u_plat_low_prio[ddir]);
-		json_object_add_value_object(dir_object, low, tmp_object);
 	}
 
 	if (calc_lat(&ts->bw_stat[ddir], &min, &max, &mean, &dev)) {
@@ -1534,6 +1572,7 @@ static void add_mixed_ddir_status_json(struct thread_stat *ts,
 	if (ts_lcl)
 		add_ddir_status_json(ts_lcl, rs, DDIR_READ, parent);
 
+	free_clat_prio_stats(ts_lcl);
 	free(ts_lcl);
 }
 
@@ -1995,6 +2034,215 @@ void sum_group_stats(struct group_run_stats *dst, struct group_run_stats *src)
 		dst->sig_figs = src->sig_figs;
 }
 
+/*
+ * Free the clat_prio_stat arrays allocated by alloc_clat_prio_stat_ddir().
+ */
+void free_clat_prio_stats(struct thread_stat *ts)
+{
+	enum fio_ddir ddir;
+
+	for (ddir = 0; ddir < DDIR_RWDIR_CNT; ddir++) {
+		sfree(ts->clat_prio[ddir]);
+		ts->clat_prio[ddir] = NULL;
+		ts->nr_clat_prio[ddir] = 0;
+	}
+}
+
+/*
+ * Allocate a clat_prio_stat array. The array has to be allocated/freed using
+ * smalloc/sfree, so that it is accessible by the process/thread summing the
+ * thread_stats.
+ */
+int alloc_clat_prio_stat_ddir(struct thread_stat *ts, enum fio_ddir ddir,
+			      int nr_prios)
+{
+	struct clat_prio_stat *clat_prio;
+	int i;
+
+	clat_prio = scalloc(nr_prios, sizeof(*ts->clat_prio[ddir]));
+	if (!clat_prio) {
+		log_err("fio: failed to allocate ts clat data\n");
+		return 1;
+	}
+
+	for (i = 0; i < nr_prios; i++)
+		clat_prio[i].clat_stat.min_val = ULONG_MAX;
+
+	ts->clat_prio[ddir] = clat_prio;
+	ts->nr_clat_prio[ddir] = nr_prios;
+
+	return 0;
+}
+
+static int grow_clat_prio_stat(struct thread_stat *dst, enum fio_ddir ddir)
+{
+	int curr_len = dst->nr_clat_prio[ddir];
+	void *new_arr;
+
+	new_arr = scalloc(curr_len + 1, sizeof(*dst->clat_prio[ddir]));
+	if (!new_arr) {
+		log_err("fio: failed to grow clat prio array\n");
+		return 1;
+	}
+
+	memcpy(new_arr, dst->clat_prio[ddir],
+	       curr_len * sizeof(*dst->clat_prio[ddir]));
+	sfree(dst->clat_prio[ddir]);
+
+	dst->clat_prio[ddir] = new_arr;
+	dst->clat_prio[ddir][curr_len].clat_stat.min_val = ULONG_MAX;
+	dst->nr_clat_prio[ddir]++;
+
+	return 0;
+}
+
+static int find_clat_prio_index(struct thread_stat *dst, enum fio_ddir ddir,
+				uint32_t ioprio)
+{
+	int i, nr_prios = dst->nr_clat_prio[ddir];
+
+	for (i = 0; i < nr_prios; i++) {
+		if (dst->clat_prio[ddir][i].ioprio == ioprio)
+			return i;
+	}
+
+	return -1;
+}
+
+static int alloc_or_get_clat_prio_index(struct thread_stat *dst,
+					enum fio_ddir ddir, uint32_t ioprio,
+					int *idx)
+{
+	int index = find_clat_prio_index(dst, ddir, ioprio);
+
+	if (index == -1) {
+		index = dst->nr_clat_prio[ddir];
+
+		if (grow_clat_prio_stat(dst, ddir))
+			return 1;
+
+		dst->clat_prio[ddir][index].ioprio = ioprio;
+	}
+
+	*idx = index;
+
+	return 0;
+}
+
+static int clat_prio_stats_copy(struct thread_stat *dst, struct thread_stat *src,
+				enum fio_ddir dst_ddir, enum fio_ddir src_ddir)
+{
+	size_t sz = sizeof(*src->clat_prio[src_ddir]) *
+		src->nr_clat_prio[src_ddir];
+
+	dst->clat_prio[dst_ddir] = smalloc(sz);
+	if (!dst->clat_prio[dst_ddir]) {
+		log_err("fio: failed to alloc clat prio array\n");
+		return 1;
+	}
+
+	memcpy(dst->clat_prio[dst_ddir], src->clat_prio[src_ddir], sz);
+	dst->nr_clat_prio[dst_ddir] = src->nr_clat_prio[src_ddir];
+
+	return 0;
+}
+
+static int clat_prio_stat_add_samples(struct thread_stat *dst,
+				      enum fio_ddir dst_ddir, uint32_t ioprio,
+				      struct io_stat *io_stat,
+				      uint64_t *io_u_plat)
+{
+	int i, dst_index;
+
+	if (!io_stat->samples)
+		return 0;
+
+	if (alloc_or_get_clat_prio_index(dst, dst_ddir, ioprio, &dst_index))
+		return 1;
+
+	sum_stat(&dst->clat_prio[dst_ddir][dst_index].clat_stat, io_stat,
+		 false);
+
+	for (i = 0; i < FIO_IO_U_PLAT_NR; i++)
+		dst->clat_prio[dst_ddir][dst_index].io_u_plat[i] += io_u_plat[i];
+
+	return 0;
+}
+
+static int sum_clat_prio_stats_src_single_prio(struct thread_stat *dst,
+					       struct thread_stat *src,
+					       enum fio_ddir dst_ddir,
+					       enum fio_ddir src_ddir)
+{
+	struct io_stat *io_stat;
+	uint64_t *io_u_plat;
+
+	/*
+	 * If src ts has no clat_prio_stat array, then all I/Os were submitted
+	 * using src->ioprio. Thus, the global samples in src->clat_stat (or
+	 * src->lat_stat) can be used as the 'per prio' samples for src->ioprio.
+	 */
+	assert(!src->clat_prio[src_ddir]);
+	assert(src->nr_clat_prio[src_ddir] == 0);
+
+	if (src->lat_percentiles) {
+		io_u_plat = src->io_u_plat[FIO_LAT][src_ddir];
+		io_stat = &src->lat_stat[src_ddir];
+	} else {
+		io_u_plat = src->io_u_plat[FIO_CLAT][src_ddir];
+		io_stat = &src->clat_stat[src_ddir];
+	}
+
+	return clat_prio_stat_add_samples(dst, dst_ddir, src->ioprio, io_stat,
+					  io_u_plat);
+}
+
+static int sum_clat_prio_stats_src_multi_prio(struct thread_stat *dst,
+					      struct thread_stat *src,
+					      enum fio_ddir dst_ddir,
+					      enum fio_ddir src_ddir)
+{
+	int i;
+
+	/*
+	 * If src ts has a clat_prio_stat array, then there are multiple prios
+	 * in use (i.e. src ts had cmdprio_percentage or cmdprio_bssplit set).
+	 * The samples for the default prio will exist in the src->clat_prio
+	 * array, just like the samples for any other prio.
+	 */
+	assert(src->clat_prio[src_ddir]);
+	assert(src->nr_clat_prio[src_ddir]);
+
+	/* If the dst ts doesn't yet have a clat_prio array, simply memcpy. */
+	if (!dst->clat_prio[dst_ddir])
+		return clat_prio_stats_copy(dst, src, dst_ddir, src_ddir);
+
+	/* The dst ts already has a clat_prio_array, add src stats into it. */
+	for (i = 0; i < src->nr_clat_prio[src_ddir]; i++) {
+		struct io_stat *io_stat = &src->clat_prio[src_ddir][i].clat_stat;
+		uint64_t *io_u_plat = src->clat_prio[src_ddir][i].io_u_plat;
+		uint32_t ioprio = src->clat_prio[src_ddir][i].ioprio;
+
+		if (clat_prio_stat_add_samples(dst, dst_ddir, ioprio, io_stat, io_u_plat))
+			return 1;
+	}
+
+	return 0;
+}
+
+static int sum_clat_prio_stats(struct thread_stat *dst, struct thread_stat *src,
+			       enum fio_ddir dst_ddir, enum fio_ddir src_ddir)
+{
+	if (dst->disable_prio_stat)
+		return 0;
+
+	if (!src->clat_prio[src_ddir])
+		return sum_clat_prio_stats_src_single_prio(dst, src, dst_ddir,
+							   src_ddir);
+
+	return sum_clat_prio_stats_src_multi_prio(dst, src, dst_ddir, src_ddir);
+}
+
 void sum_thread_stats(struct thread_stat *dst, struct thread_stat *src)
 {
 	int k, l, m;
@@ -2002,12 +2250,11 @@ void sum_thread_stats(struct thread_stat *dst, struct thread_stat *src)
 	for (l = 0; l < DDIR_RWDIR_CNT; l++) {
 		if (dst->unified_rw_rep != UNIFIED_MIXED) {
 			sum_stat(&dst->clat_stat[l], &src->clat_stat[l], false);
-			sum_stat(&dst->clat_high_prio_stat[l], &src->clat_high_prio_stat[l], false);
-			sum_stat(&dst->clat_low_prio_stat[l], &src->clat_low_prio_stat[l], false);
 			sum_stat(&dst->slat_stat[l], &src->slat_stat[l], false);
 			sum_stat(&dst->lat_stat[l], &src->lat_stat[l], false);
 			sum_stat(&dst->bw_stat[l], &src->bw_stat[l], true);
 			sum_stat(&dst->iops_stat[l], &src->iops_stat[l], true);
+			sum_clat_prio_stats(dst, src, l, l);
 
 			dst->io_bytes[l] += src->io_bytes[l];
 
@@ -2015,12 +2262,11 @@ void sum_thread_stats(struct thread_stat *dst, struct thread_stat *src)
 				dst->runtime[l] = src->runtime[l];
 		} else {
 			sum_stat(&dst->clat_stat[0], &src->clat_stat[l], false);
-			sum_stat(&dst->clat_high_prio_stat[0], &src->clat_high_prio_stat[l], false);
-			sum_stat(&dst->clat_low_prio_stat[0], &src->clat_low_prio_stat[l], false);
 			sum_stat(&dst->slat_stat[0], &src->slat_stat[l], false);
 			sum_stat(&dst->lat_stat[0], &src->lat_stat[l], false);
 			sum_stat(&dst->bw_stat[0], &src->bw_stat[l], true);
 			sum_stat(&dst->iops_stat[0], &src->iops_stat[l], true);
+			sum_clat_prio_stats(dst, src, 0, l);
 
 			dst->io_bytes[0] += src->io_bytes[l];
 
@@ -2074,19 +2320,6 @@ void sum_thread_stats(struct thread_stat *dst, struct thread_stat *src)
 	for (k = 0; k < FIO_IO_U_PLAT_NR; k++)
 		dst->io_u_sync_plat[k] += src->io_u_sync_plat[k];
 
-	for (k = 0; k < DDIR_RWDIR_CNT; k++) {
-		for (m = 0; m < FIO_IO_U_PLAT_NR; m++) {
-			if (dst->unified_rw_rep != UNIFIED_MIXED) {
-				dst->io_u_plat_high_prio[k][m] += src->io_u_plat_high_prio[k][m];
-				dst->io_u_plat_low_prio[k][m] += src->io_u_plat_low_prio[k][m];
-			} else {
-				dst->io_u_plat_high_prio[0][m] += src->io_u_plat_high_prio[k][m];
-				dst->io_u_plat_low_prio[0][m] += src->io_u_plat_low_prio[k][m];
-			}
-
-		}
-	}
-
 	dst->total_run_time += src->total_run_time;
 	dst->total_submit += src->total_submit;
 	dst->total_complete += src->total_complete;
@@ -2114,8 +2347,6 @@ void init_thread_stat_min_vals(struct thread_stat *ts)
 		ts->lat_stat[i].min_val = ULONG_MAX;
 		ts->bw_stat[i].min_val = ULONG_MAX;
 		ts->iops_stat[i].min_val = ULONG_MAX;
-		ts->clat_high_prio_stat[i].min_val = ULONG_MAX;
-		ts->clat_low_prio_stat[i].min_val = ULONG_MAX;
 	}
 	ts->sync_stat.min_val = ULONG_MAX;
 }
@@ -2128,6 +2359,58 @@ void init_thread_stat(struct thread_stat *ts)
 	ts->groupid = -1;
 }
 
+static void init_per_prio_stats(struct thread_stat *threadstats, int nr_ts)
+{
+	struct thread_data *td;
+	struct thread_stat *ts;
+	int i, j, last_ts, idx;
+	enum fio_ddir ddir;
+
+	j = 0;
+	last_ts = -1;
+	idx = 0;
+
+	/*
+	 * Loop through all tds, if a td requires per prio stats, temporarily
+	 * store a 1 in ts->disable_prio_stat, and then do an additional
+	 * loop at the end where we invert the ts->disable_prio_stat values.
+	 */
+	for_each_td(td, i) {
+		if (!td->o.stats)
+			continue;
+		if (idx &&
+		    (!td->o.group_reporting ||
+		     (td->o.group_reporting && last_ts != td->groupid))) {
+			idx = 0;
+			j++;
+		}
+
+		last_ts = td->groupid;
+		ts = &threadstats[j];
+
+		/* idx == 0 means first td in group, or td is not in a group. */
+		if (idx == 0)
+			ts->ioprio = td->ioprio;
+		else if (td->ioprio != ts->ioprio)
+			ts->disable_prio_stat = 1;
+
+		for (ddir = 0; ddir < DDIR_RWDIR_CNT; ddir++) {
+			if (td->ts.clat_prio[ddir]) {
+				ts->disable_prio_stat = 1;
+				break;
+			}
+		}
+
+		idx++;
+	}
+
+	/* Loop through all dst threadstats and fixup the values. */
+	for (i = 0; i < nr_ts; i++) {
+		ts = &threadstats[i];
+		ts->disable_prio_stat = !ts->disable_prio_stat;
+	}
+}
+
 void __show_run_stats(void)
 {
 	struct group_run_stats *runstats, *rs;
@@ -2174,6 +2457,8 @@ void __show_run_stats(void)
 		opt_lists[i] = NULL;
 	}
 
+	init_per_prio_stats(threadstats, nr_ts);
+
 	j = 0;
 	last_ts = -1;
 	idx = 0;
@@ -2198,7 +2483,6 @@ void __show_run_stats(void)
 		opt_lists[j] = &td->opt_list;
 
 		idx++;
-		ts->members++;
 
 		if (ts->groupid == -1) {
 			/*
@@ -2265,6 +2549,8 @@ void __show_run_stats(void)
 
 		sum_thread_stats(ts, &td->ts);
 
+		ts->members++;
+
 		if (td->o.ss_dur) {
 			ts->ss_state = td->ss.state;
 			ts->ss_dur = td->ss.dur;
@@ -2313,7 +2599,7 @@ void __show_run_stats(void)
 	}
 
 	for (i = 0; i < groupid + 1; i++) {
-		int ddir;
+		enum fio_ddir ddir;
 
 		rs = &runstats[i];
 
@@ -2419,6 +2705,12 @@ void __show_run_stats(void)
 
 	log_info_flush();
 	free(runstats);
+
+	/* free arrays allocated by sum_thread_stats(), if any */
+	for (i = 0; i < nr_ts; i++) {
+		ts = &threadstats[i];
+		free_clat_prio_stats(ts);
+	}
 	free(threadstats);
 	free(opt_lists);
 }
@@ -2545,6 +2837,14 @@ static inline void add_stat_sample(struct io_stat *is, unsigned long long data)
 	is->samples++;
 }
 
+static inline void add_stat_prio_sample(struct clat_prio_stat *clat_prio,
+					unsigned short clat_prio_index,
+					unsigned long long nsec)
+{
+	if (clat_prio)
+		add_stat_sample(&clat_prio[clat_prio_index].clat_stat, nsec);
+}
+
 /*
  * Return a struct io_logs, which is added to the tail of the log
  * list for 'iolog'.
@@ -2717,7 +3017,7 @@ static void __add_log_sample(struct io_log *iolog, union io_sample_data data,
 		s = get_sample(iolog, cur_log, cur_log->nr_samples);
 
 		s->data = data;
-		s->time = t + (iolog->td ? iolog->td->unix_epoch : 0);
+		s->time = t + (iolog->td ? iolog->td->alternate_epoch : 0);
 		io_sample_set_ddir(iolog, s, ddir);
 		s->bs = bs;
 		s->priority = priority;
@@ -2742,14 +3042,36 @@ static inline void reset_io_stat(struct io_stat *ios)
 	ios->mean.u.f = ios->S.u.f = 0;
 }
 
+static inline void reset_io_u_plat(uint64_t *io_u_plat)
+{
+	int i;
+
+	for (i = 0; i < FIO_IO_U_PLAT_NR; i++)
+		io_u_plat[i] = 0;
+}
+
+static inline void reset_clat_prio_stats(struct thread_stat *ts)
+{
+	enum fio_ddir ddir;
+	int i;
+
+	for (ddir = 0; ddir < DDIR_RWDIR_CNT; ddir++) {
+		if (!ts->clat_prio[ddir])
+			continue;
+
+		for (i = 0; i < ts->nr_clat_prio[ddir]; i++) {
+			reset_io_stat(&ts->clat_prio[ddir][i].clat_stat);
+			reset_io_u_plat(ts->clat_prio[ddir][i].io_u_plat);
+		}
+	}
+}
+
 void reset_io_stats(struct thread_data *td)
 {
 	struct thread_stat *ts = &td->ts;
-	int i, j, k;
+	int i, j;
 
 	for (i = 0; i < DDIR_RWDIR_CNT; i++) {
-		reset_io_stat(&ts->clat_high_prio_stat[i]);
-		reset_io_stat(&ts->clat_low_prio_stat[i]);
 		reset_io_stat(&ts->clat_stat[i]);
 		reset_io_stat(&ts->slat_stat[i]);
 		reset_io_stat(&ts->lat_stat[i]);
@@ -2761,21 +3083,16 @@ void reset_io_stats(struct thread_data *td)
 		ts->total_io_u[i] = 0;
 		ts->short_io_u[i] = 0;
 		ts->drop_io_u[i] = 0;
-
-		for (j = 0; j < FIO_IO_U_PLAT_NR; j++) {
-			ts->io_u_plat_high_prio[i][j] = 0;
-			ts->io_u_plat_low_prio[i][j] = 0;
-			if (!i)
-				ts->io_u_sync_plat[j] = 0;
-		}
 	}
 
 	for (i = 0; i < FIO_LAT_CNT; i++)
 		for (j = 0; j < DDIR_RWDIR_CNT; j++)
-			for (k = 0; k < FIO_IO_U_PLAT_NR; k++)
-				ts->io_u_plat[i][j][k] = 0;
+			reset_io_u_plat(ts->io_u_plat[i][j]);
+
+	reset_clat_prio_stats(ts);
 
 	ts->total_io_u[DDIR_SYNC] = 0;
+	reset_io_u_plat(ts->io_u_sync_plat);
 
 	for (i = 0; i < FIO_IO_U_MAP_NR; i++) {
 		ts->io_u_map[i] = 0;
@@ -2821,7 +3138,7 @@ static void __add_stat_to_log(struct io_log *iolog, enum fio_ddir ddir,
 static void _add_stat_to_log(struct io_log *iolog, unsigned long elapsed,
 			     bool log_max)
 {
-	int ddir;
+	enum fio_ddir ddir;
 
 	for (ddir = 0; ddir < DDIR_RWDIR_CNT; ddir++)
 		__add_stat_to_log(iolog, ddir, elapsed, log_max);
@@ -2926,22 +3243,21 @@ static inline void add_lat_percentile_sample(struct thread_stat *ts,
 	ts->io_u_plat[lat][ddir][idx]++;
 }
 
-static inline void add_lat_percentile_prio_sample(struct thread_stat *ts,
-						  unsigned long long nsec,
-						  enum fio_ddir ddir,
-						  bool high_prio)
+static inline void
+add_lat_percentile_prio_sample(struct thread_stat *ts, unsigned long long nsec,
+			       enum fio_ddir ddir,
+			       unsigned short clat_prio_index)
 {
 	unsigned int idx = plat_val_to_idx(nsec);
 
-	if (!high_prio)
-		ts->io_u_plat_low_prio[ddir][idx]++;
-	else
-		ts->io_u_plat_high_prio[ddir][idx]++;
+	if (ts->clat_prio[ddir])
+		ts->clat_prio[ddir][clat_prio_index].io_u_plat[idx]++;
 }
 
 void add_clat_sample(struct thread_data *td, enum fio_ddir ddir,
 		     unsigned long long nsec, unsigned long long bs,
-		     uint64_t offset, unsigned int ioprio, bool high_prio)
+		     uint64_t offset, unsigned int ioprio,
+		     unsigned short clat_prio_index)
 {
 	const bool needs_lock = td_async_processing(td);
 	unsigned long elapsed, this_window;
@@ -2954,7 +3270,7 @@ void add_clat_sample(struct thread_data *td, enum fio_ddir ddir,
 	add_stat_sample(&ts->clat_stat[ddir], nsec);
 
 	/*
-	 * When lat_percentiles=1 (default 0), the reported high/low priority
+	 * When lat_percentiles=1 (default 0), the reported per priority
 	 * percentiles and stats are used for describing total latency values,
 	 * even though the variable names themselves start with clat_.
 	 *
@@ -2962,12 +3278,9 @@ void add_clat_sample(struct thread_data *td, enum fio_ddir ddir,
 	 * lat_percentiles=0. add_lat_sample() will add the prio stat sample
 	 * when lat_percentiles=1.
 	 */
-	if (!ts->lat_percentiles) {
-		if (high_prio)
-			add_stat_sample(&ts->clat_high_prio_stat[ddir], nsec);
-		else
-			add_stat_sample(&ts->clat_low_prio_stat[ddir], nsec);
-	}
+	if (!ts->lat_percentiles)
+		add_stat_prio_sample(ts->clat_prio[ddir], clat_prio_index,
+				     nsec);
 
 	if (td->clat_log)
 		add_log_sample(td, td->clat_log, sample_val(nsec), ddir, bs,
@@ -2982,7 +3295,7 @@ void add_clat_sample(struct thread_data *td, enum fio_ddir ddir,
 		add_lat_percentile_sample(ts, nsec, ddir, FIO_CLAT);
 		if (!ts->lat_percentiles)
 			add_lat_percentile_prio_sample(ts, nsec, ddir,
-						       high_prio);
+						       clat_prio_index);
 	}
 
 	if (iolog && iolog->hist_msec) {
@@ -3055,7 +3368,8 @@ void add_slat_sample(struct thread_data *td, enum fio_ddir ddir,
 
 void add_lat_sample(struct thread_data *td, enum fio_ddir ddir,
 		    unsigned long long nsec, unsigned long long bs,
-		    uint64_t offset, unsigned int ioprio, bool high_prio)
+		    uint64_t offset, unsigned int ioprio,
+		    unsigned short clat_prio_index)
 {
 	const bool needs_lock = td_async_processing(td);
 	struct thread_stat *ts = &td->ts;
@@ -3073,7 +3387,7 @@ void add_lat_sample(struct thread_data *td, enum fio_ddir ddir,
 			       offset, ioprio);
 
 	/*
-	 * When lat_percentiles=1 (default 0), the reported high/low priority
+	 * When lat_percentiles=1 (default 0), the reported per priority
 	 * percentiles and stats are used for describing total latency values,
 	 * even though the variable names themselves start with clat_.
 	 *
@@ -3084,12 +3398,9 @@ void add_lat_sample(struct thread_data *td, enum fio_ddir ddir,
 	 */
 	if (ts->lat_percentiles) {
 		add_lat_percentile_sample(ts, nsec, ddir, FIO_LAT);
-		add_lat_percentile_prio_sample(ts, nsec, ddir, high_prio);
-		if (high_prio)
-			add_stat_sample(&ts->clat_high_prio_stat[ddir], nsec);
-		else
-			add_stat_sample(&ts->clat_low_prio_stat[ddir], nsec);
-
+		add_lat_percentile_prio_sample(ts, nsec, ddir, clat_prio_index);
+		add_stat_prio_sample(ts->clat_prio[ddir], clat_prio_index,
+				     nsec);
 	}
 	if (needs_lock)
 		__td_io_u_unlock(td);
diff --git a/stat.h b/stat.h
index 15ca4eff..dce0bb0d 100644
--- a/stat.h
+++ b/stat.h
@@ -158,6 +158,12 @@ enum fio_lat {
 	FIO_LAT_CNT = 3,
 };
 
+struct clat_prio_stat {
+	uint64_t io_u_plat[FIO_IO_U_PLAT_NR];
+	struct io_stat clat_stat;
+	uint32_t ioprio;
+};
+
 struct thread_stat {
 	char name[FIO_JOBNAME_SIZE];
 	char verror[FIO_VERROR_SIZE];
@@ -168,6 +174,7 @@ struct thread_stat {
 	char description[FIO_JOBDESC_SIZE];
 	uint32_t members;
 	uint32_t unified_rw_rep;
+	uint32_t disable_prio_stat;
 
 	/*
 	 * bandwidth and latency stats
@@ -252,21 +259,40 @@ struct thread_stat {
 	fio_fp64_t ss_deviation;
 	fio_fp64_t ss_criterion;
 
-	uint64_t io_u_plat_high_prio[DDIR_RWDIR_CNT][FIO_IO_U_PLAT_NR] __attribute__((aligned(8)));;
-	uint64_t io_u_plat_low_prio[DDIR_RWDIR_CNT][FIO_IO_U_PLAT_NR];
-	struct io_stat clat_high_prio_stat[DDIR_RWDIR_CNT] __attribute__((aligned(8)));
-	struct io_stat clat_low_prio_stat[DDIR_RWDIR_CNT];
+	/* A mirror of td->ioprio. */
+	uint32_t ioprio;
 
 	union {
 		uint64_t *ss_iops_data;
+		/*
+		 * For FIO_NET_CMD_TS, the pointed to data will temporarily
+		 * be stored at this offset from the start of the payload.
+		 */
+		uint64_t ss_iops_data_offset;
 		uint64_t pad4;
 	};
 
 	union {
 		uint64_t *ss_bw_data;
+		/*
+		 * For FIO_NET_CMD_TS, the pointed to data will temporarily
+		 * be stored at this offset from the start of the payload.
+		 */
+		uint64_t ss_bw_data_offset;
 		uint64_t pad5;
 	};
 
+	union {
+		struct clat_prio_stat *clat_prio[DDIR_RWDIR_CNT];
+		/*
+		 * For FIO_NET_CMD_TS, the pointed to data will temporarily
+		 * be stored at this offset from the start of the payload.
+		 */
+		uint64_t clat_prio_offset[DDIR_RWDIR_CNT];
+		uint64_t pad6;
+	};
+	uint32_t nr_clat_prio[DDIR_RWDIR_CNT];
+
 	uint64_t cachehit;
 	uint64_t cachemiss;
 } __attribute__((packed));
@@ -342,9 +368,9 @@ extern void update_rusage_stat(struct thread_data *);
 extern void clear_rusage_stat(struct thread_data *);
 
 extern void add_lat_sample(struct thread_data *, enum fio_ddir, unsigned long long,
-			   unsigned long long, uint64_t, unsigned int, bool);
+			   unsigned long long, uint64_t, unsigned int, unsigned short);
 extern void add_clat_sample(struct thread_data *, enum fio_ddir, unsigned long long,
-			    unsigned long long, uint64_t, unsigned int, bool);
+			    unsigned long long, uint64_t, unsigned int, unsigned short);
 extern void add_slat_sample(struct thread_data *, enum fio_ddir, unsigned long long,
 				unsigned long long, uint64_t, unsigned int);
 extern void add_agg_sample(union io_sample_data, enum fio_ddir, unsigned long long);
@@ -355,6 +381,8 @@ extern void add_bw_sample(struct thread_data *, struct io_u *,
 extern void add_sync_clat_sample(struct thread_stat *ts,
 				unsigned long long nsec);
 extern int calc_log_samples(void);
+extern void free_clat_prio_stats(struct thread_stat *);
+extern int alloc_clat_prio_stat_ddir(struct thread_stat *, enum fio_ddir, int);
 
 extern void print_disk_util(struct disk_util_stat *, struct disk_util_agg *, int terse, struct buf_output *);
 extern void json_array_add_disk_util(struct disk_util_stat *dus,
diff --git a/t/latency_percentiles.py b/t/latency_percentiles.py
index cc437426..9e37d9fe 100755
--- a/t/latency_percentiles.py
+++ b/t/latency_percentiles.py
@@ -80,6 +80,7 @@ import time
 import argparse
 import platform
 import subprocess
+from collections import Counter
 from pathlib import Path
 
 
@@ -125,7 +126,8 @@ class FioLatTest():
             "--output-format={output-format}".format(**self.test_options),
         ]
         for opt in ['slat_percentiles', 'clat_percentiles', 'lat_percentiles',
-                    'unified_rw_reporting', 'fsync', 'fdatasync', 'numjobs', 'cmdprio_percentage']:
+                    'unified_rw_reporting', 'fsync', 'fdatasync', 'numjobs',
+                    'cmdprio_percentage', 'bssplit', 'cmdprio_bssplit']:
             if opt in self.test_options:
                 option = '--{0}={{{0}}}'.format(opt)
                 fio_args.append(option.format(**self.test_options))
@@ -363,20 +365,19 @@ class FioLatTest():
 
     def check_nocmdprio_lat(self, job):
         """
-        Make sure no high/low priority latencies appear.
+        Make sure no per priority latencies appear.
 
         job         JSON object to check
         """
 
         for ddir in ['read', 'write', 'trim']:
             if ddir in job:
-                if 'lat_high_prio' in job[ddir] or 'lat_low_prio' in job[ddir] or \
-                    'clat_high_prio' in job[ddir] or 'clat_low_prio' in job[ddir]:
-                    print("Unexpected high/low priority latencies found in %s output" % ddir)
+                if 'prios' in job[ddir]:
+                    print("Unexpected per priority latencies found in %s output" % ddir)
                     return False
 
         if self.debug:
-            print("No high/low priority latencies found")
+            print("No per priority latencies found")
 
         return True
 
@@ -497,7 +498,7 @@ class FioLatTest():
         return retval
 
     def check_prio_latencies(self, jsondata, clat=True, plus=False):
-        """Check consistency of high/low priority latencies.
+        """Check consistency of per priority latencies.
 
         clat                True if we should check clat data; other check lat data
         plus                True if we have json+ format data where additional checks can
@@ -506,78 +507,78 @@ class FioLatTest():
         """
 
         if clat:
-            high = 'clat_high_prio'
-            low = 'clat_low_prio'
-            combined = 'clat_ns'
+            obj = combined = 'clat_ns'
         else:
-            high = 'lat_high_prio'
-            low = 'lat_low_prio'
-            combined = 'lat_ns'
+            obj = combined = 'lat_ns'
 
-        if not high in jsondata or not low in jsondata or not combined in jsondata:
-            print("Error identifying high/low priority latencies")
+        if not 'prios' in jsondata or not combined in jsondata:
+            print("Error identifying per priority latencies")
             return False
 
-        if jsondata[high]['N'] + jsondata[low]['N'] != jsondata[combined]['N']:
-            print("High %d + low %d != combined sample size %d" % \
-                    (jsondata[high]['N'], jsondata[low]['N'], jsondata[combined]['N']))
+        sum_sample_size = sum([x[obj]['N'] for x in jsondata['prios']])
+        if sum_sample_size != jsondata[combined]['N']:
+            print("Per prio sample size sum %d != combined sample size %d" %
+                  (sum_sample_size, jsondata[combined]['N']))
             return False
         elif self.debug:
-            print("High %d + low %d == combined sample size %d" % \
-                    (jsondata[high]['N'], jsondata[low]['N'], jsondata[combined]['N']))
+            print("Per prio sample size sum %d == combined sample size %d" %
+                  (sum_sample_size, jsondata[combined]['N']))
 
-        if min(jsondata[high]['min'], jsondata[low]['min']) != jsondata[combined]['min']:
-            print("Min of high %d, low %d min latencies does not match min %d from combined data" % \
-                    (jsondata[high]['min'], jsondata[low]['min'], jsondata[combined]['min']))
+        min_val = min([x[obj]['min'] for x in jsondata['prios']])
+        if min_val != jsondata[combined]['min']:
+            print("Min per prio min latency %d does not match min %d from combined data" %
+                  (min_val, jsondata[combined]['min']))
             return False
         elif self.debug:
-            print("Min of high %d, low %d min latencies matches min %d from combined data" % \
-                    (jsondata[high]['min'], jsondata[low]['min'], jsondata[combined]['min']))
+            print("Min per prio min latency %d matches min %d from combined data" %
+                  (min_val, jsondata[combined]['min']))
 
-        if max(jsondata[high]['max'], jsondata[low]['max']) != jsondata[combined]['max']:
-            print("Max of high %d, low %d max latencies does not match max %d from combined data" % \
-                    (jsondata[high]['max'], jsondata[low]['max'], jsondata[combined]['max']))
+        max_val = max([x[obj]['max'] for x in jsondata['prios']])
+        if max_val != jsondata[combined]['max']:
+            print("Max per prio max latency %d does not match max %d from combined data" %
+                  (max_val, jsondata[combined]['max']))
             return False
         elif self.debug:
-            print("Max of high %d, low %d max latencies matches max %d from combined data" % \
-                    (jsondata[high]['max'], jsondata[low]['max'], jsondata[combined]['max']))
+            print("Max per prio max latency %d matches max %d from combined data" %
+                  (max_val, jsondata[combined]['max']))
 
-        weighted_avg = (jsondata[high]['mean'] * jsondata[high]['N'] + \
-                        jsondata[low]['mean'] * jsondata[low]['N']) / jsondata[combined]['N']
+        weighted_vals = [x[obj]['mean'] * x[obj]['N'] for x in jsondata['prios']]
+        weighted_avg = sum(weighted_vals) / jsondata[combined]['N']
         delta = abs(weighted_avg - jsondata[combined]['mean'])
         if (delta / jsondata[combined]['mean']) > 0.0001:
-            print("Difference between weighted average %f of high, low means "
+            print("Difference between merged per prio weighted average %f mean "
                   "and actual mean %f exceeds 0.01%%" % (weighted_avg, jsondata[combined]['mean']))
             return False
         elif self.debug:
-            print("Weighted average %f of high, low means matches actual mean %f" % \
-                    (weighted_avg, jsondata[combined]['mean']))
+            print("Merged per prio weighted average %f mean matches actual mean %f" %
+                  (weighted_avg, jsondata[combined]['mean']))
 
         if plus:
-            if not self.check_jsonplus(jsondata[high]):
-                return False
-            if not self.check_jsonplus(jsondata[low]):
-                return False
+            for prio in jsondata['prios']:
+                if not self.check_jsonplus(prio[obj]):
+                    return False
 
-            bins = {**jsondata[high]['bins'], **jsondata[low]['bins']}
-            for duration in bins.keys():
-                if duration in jsondata[high]['bins'] and duration in jsondata[low]['bins']:
-                    bins[duration] = jsondata[high]['bins'][duration] + \
-                            jsondata[low]['bins'][duration]
+            counter = Counter()
+            for prio in jsondata['prios']:
+                counter.update(prio[obj]['bins'])
+
+            bins = dict(counter)
 
             if len(bins) != len(jsondata[combined]['bins']):
-                print("Number of combined high/low bins does not match number of overall bins")
+                print("Number of merged bins %d does not match number of overall bins %d" %
+                      (len(bins), len(jsondata[combined]['bins'])))
                 return False
             elif self.debug:
-                print("Number of bins from merged high/low data matches number of overall bins")
+                print("Number of merged bins %d matches number of overall bins %d" %
+                      (len(bins), len(jsondata[combined]['bins'])))
 
             for duration in bins.keys():
                 if bins[duration] != jsondata[combined]['bins'][duration]:
-                    print("Merged high/low count does not match overall count for duration %d" \
-                            % duration)
+                    print("Merged per prio count does not match overall count for duration %d" %
+                          duration)
                     return False
 
-        print("Merged high/low priority latency data match combined latency data")
+        print("Merged per priority latency data match combined latency data")
         return True
 
     def check(self):
@@ -602,7 +603,7 @@ class Test001(FioLatTest):
             print("Unexpected trim data found in output")
             retval = False
         if not self.check_nocmdprio_lat(job):
-            print("Unexpected high/low priority latencies found")
+            print("Unexpected per priority latencies found")
             retval = False
 
         retval &= self.check_latencies(job['read'], 0, slat=False)
@@ -626,7 +627,7 @@ class Test002(FioLatTest):
             print("Unexpected trim data found in output")
             retval = False
         if not self.check_nocmdprio_lat(job):
-            print("Unexpected high/low priority latencies found")
+            print("Unexpected per priority latencies found")
             retval = False
 
         retval &= self.check_latencies(job['write'], 1, slat=False, clat=False)
@@ -650,7 +651,7 @@ class Test003(FioLatTest):
             print("Unexpected write data found in output")
             retval = False
         if not self.check_nocmdprio_lat(job):
-            print("Unexpected high/low priority latencies found")
+            print("Unexpected per priority latencies found")
             retval = False
 
         retval &= self.check_latencies(job['trim'], 2, slat=False, tlat=False)
@@ -674,7 +675,7 @@ class Test004(FioLatTest):
             print("Unexpected trim data found in output")
             retval = False
         if not self.check_nocmdprio_lat(job):
-            print("Unexpected high/low priority latencies found")
+            print("Unexpected per priority latencies found")
             retval = False
 
         retval &= self.check_latencies(job['read'], 0, plus=True)
@@ -698,7 +699,7 @@ class Test005(FioLatTest):
             print("Unexpected trim data found in output")
             retval = False
         if not self.check_nocmdprio_lat(job):
-            print("Unexpected high/low priority latencies found")
+            print("Unexpected per priority latencies found")
             retval = False
 
         retval &= self.check_latencies(job['write'], 1, slat=False, plus=True)
@@ -722,7 +723,7 @@ class Test006(FioLatTest):
             print("Unexpected trim data found in output")
             retval = False
         if not self.check_nocmdprio_lat(job):
-            print("Unexpected high/low priority latencies found")
+            print("Unexpected per priority latencies found")
             retval = False
 
         retval &= self.check_latencies(job['read'], 0, slat=False, tlat=False, plus=True)
@@ -743,7 +744,7 @@ class Test007(FioLatTest):
             print("Unexpected trim data found in output")
             retval = False
         if not self.check_nocmdprio_lat(job):
-            print("Unexpected high/low priority latencies found")
+            print("Unexpected per priority latencies found")
             retval = False
 
         retval &= self.check_latencies(job['read'], 0, clat=False, tlat=False, plus=True)
@@ -761,11 +762,11 @@ class Test008(FioLatTest):
         job = self.json_data['jobs'][0]
 
         retval = True
-        if 'read' in job or 'write'in job or 'trim' in job:
+        if 'read' in job or 'write' in job or 'trim' in job:
             print("Unexpected data direction found in fio output")
             retval = False
         if not self.check_nocmdprio_lat(job):
-            print("Unexpected high/low priority latencies found")
+            print("Unexpected per priority latencies found")
             retval = False
 
         retval &= self.check_latencies(job['mixed'], 0, plus=True, unified=True)
@@ -792,7 +793,7 @@ class Test009(FioLatTest):
             print("Error checking fsync latency data")
             retval = False
         if not self.check_nocmdprio_lat(job):
-            print("Unexpected high/low priority latencies found")
+            print("Unexpected per priority latencies found")
             retval = False
 
         retval &= self.check_latencies(job['write'], 1, slat=False, plus=True)
@@ -813,7 +814,7 @@ class Test010(FioLatTest):
             print("Unexpected trim data found in output")
             retval = False
         if not self.check_nocmdprio_lat(job):
-            print("Unexpected high/low priority latencies found")
+            print("Unexpected per priority latencies found")
             retval = False
 
         retval &= self.check_latencies(job['read'], 0, plus=True)
@@ -839,7 +840,7 @@ class Test011(FioLatTest):
             print("Unexpected trim data found in output")
             retval = False
         if not self.check_nocmdprio_lat(job):
-            print("Unexpected high/low priority latencies found")
+            print("Unexpected per priority latencies found")
             retval = False
 
         retval &= self.check_latencies(job['read'], 0, slat=False, clat=False, plus=True)
@@ -953,7 +954,7 @@ class Test019(FioLatTest):
         job = self.json_data['jobs'][0]
 
         retval = True
-        if 'read' in job or 'write'in job or 'trim' in job:
+        if 'read' in job or 'write' in job or 'trim' in job:
             print("Unexpected data direction found in fio output")
             retval = False
 
@@ -963,6 +964,27 @@ class Test019(FioLatTest):
         return retval
 
 
+class Test021(FioLatTest):
+    """Test object for Test 21."""
+
+    def check(self):
+        """Check Test 21 output."""
+
+        job = self.json_data['jobs'][0]
+
+        retval = True
+        if not self.check_empty(job['trim']):
+            print("Unexpected trim data found in output")
+            retval = False
+
+        retval &= self.check_latencies(job['read'], 0, slat=False, tlat=False, plus=True)
+        retval &= self.check_latencies(job['write'], 1, slat=False, tlat=False, plus=True)
+        retval &= self.check_prio_latencies(job['read'], clat=True, plus=True)
+        retval &= self.check_prio_latencies(job['write'], clat=True, plus=True)
+
+        return retval
+
+
 def parse_args():
     """Parse command-line arguments."""
 
@@ -1007,7 +1029,7 @@ def main():
             # randread, null
             # enable slat, clat, lat
             # only clat and lat will appear because
-            # because the null ioengine is syncrhonous
+            # because the null ioengine is synchronous
             "test_id": 1,
             "runtime": 2,
             "output-format": "json",
@@ -1047,7 +1069,7 @@ def main():
         {
             # randread, aio
             # enable slat, clat, lat
-            # all will appear because liaio is asynchronous
+            # all will appear because libaio is asynchronous
             "test_id": 4,
             "runtime": 5,
             "output-format": "json+",
@@ -1153,9 +1175,9 @@ def main():
             # randread, null
             # enable slat, clat, lat
             # only clat and lat will appear because
-            # because the null ioengine is syncrhonous
-            # same as Test 1 except
-            # numjobs = 4 to test sum_thread_stats() changes
+            # because the null ioengine is synchronous
+            # same as Test 1 except add numjobs = 4 to test
+            # sum_thread_stats() changes
             "test_id": 12,
             "runtime": 2,
             "output-format": "json",
@@ -1170,9 +1192,9 @@ def main():
         {
             # randread, aio
             # enable slat, clat, lat
-            # all will appear because liaio is asynchronous
-            # same as Test 4 except
-            # numjobs = 4 to test sum_thread_stats() changes
+            # all will appear because libaio is asynchronous
+            # same as Test 4 except add numjobs = 4 to test
+            # sum_thread_stats() changes
             "test_id": 13,
             "runtime": 5,
             "output-format": "json+",
@@ -1187,8 +1209,8 @@ def main():
         {
             # 50/50 r/w, aio, unified_rw_reporting
             # enable slat, clat, lata
-            # same as Test 8 except
-            # numjobs = 4 to test sum_thread_stats() changes
+            # same as Test 8 except add numjobs = 4 to test
+            # sum_thread_stats() changes
             "test_id": 14,
             "runtime": 5,
             "output-format": "json+",
@@ -1204,7 +1226,7 @@ def main():
         {
             # randread, aio
             # enable slat, clat, lat
-            # all will appear because liaio is asynchronous
+            # all will appear because libaio is asynchronous
             # same as Test 4 except add cmdprio_percentage
             "test_id": 15,
             "runtime": 5,
@@ -1278,8 +1300,8 @@ def main():
         {
             # 50/50 r/w, aio, unified_rw_reporting
             # enable slat, clat, lat
-            # same as Test 19 except
-            # add numjobs = 4 to test sum_thread_stats() changes
+            # same as Test 19 except add numjobs = 4 to test
+            # sum_thread_stats() changes
             "test_id": 20,
             "runtime": 5,
             "output-format": "json+",
@@ -1293,6 +1315,40 @@ def main():
             'numjobs': 4,
             "test_obj": Test019,
         },
+        {
+            # r/w, aio
+            # enable only clat
+            # test bssplit and cmdprio_bssplit
+            "test_id": 21,
+            "runtime": 5,
+            "output-format": "json+",
+            "slat_percentiles": 0,
+            "clat_percentiles": 1,
+            "lat_percentiles": 0,
+            "ioengine": aio,
+            'rw': 'randrw',
+            'bssplit': '64k/40:1024k/60',
+            'cmdprio_bssplit': '64k/25/1/1:64k/75/3/2:1024k/0',
+            "test_obj": Test021,
+        },
+        {
+            # r/w, aio
+            # enable only clat
+            # same as Test 21 except add numjobs = 4 to test
+            # sum_thread_stats() changes
+            "test_id": 22,
+            "runtime": 5,
+            "output-format": "json+",
+            "slat_percentiles": 0,
+            "clat_percentiles": 1,
+            "lat_percentiles": 0,
+            "ioengine": aio,
+            'rw': 'randrw',
+            'bssplit': '64k/40:1024k/60',
+            'cmdprio_bssplit': '64k/25/1/1:64k/75/3/2:1024k/0',
+            'numjobs': 4,
+            "test_obj": Test021,
+        },
     ]
 
     passed = 0
@@ -1304,9 +1360,10 @@ def main():
            (args.run_only and test['test_id'] not in args.run_only):
             skipped = skipped + 1
             outcome = 'SKIPPED (User request)'
-        elif (platform.system() != 'Linux' or os.geteuid() != 0) and 'cmdprio_percentage' in test:
+        elif (platform.system() != 'Linux' or os.geteuid() != 0) and \
+             ('cmdprio_percentage' in test or 'cmdprio_bssplit' in test):
             skipped = skipped + 1
-            outcome = 'SKIPPED (Linux root required for cmdprio_percentage tests)'
+            outcome = 'SKIPPED (Linux root required for cmdprio tests)'
         else:
             test_obj = test['test_obj'](artifact_root, test, args.debug)
             status = test_obj.run_fio(fio)
diff --git a/thread_options.h b/thread_options.h
index 8f4c8a59..4162c42f 100644
--- a/thread_options.h
+++ b/thread_options.h
@@ -50,6 +50,12 @@ struct split {
 	unsigned long long val2[ZONESPLIT_MAX];
 };
 
+struct split_prio {
+	uint64_t bs;
+	int32_t prio;
+	uint32_t perc;
+};
+
 struct bssplit {
 	uint64_t bs;
 	uint32_t perc;
@@ -166,6 +172,8 @@ struct thread_options {
 	unsigned int log_gz;
 	unsigned int log_gz_store;
 	unsigned int log_unix_epoch;
+	unsigned int log_alternate_epoch;
+	unsigned int log_alternate_epoch_clock_id;
 	unsigned int norandommap;
 	unsigned int softrandommap;
 	unsigned int bs_unaligned;
@@ -482,6 +490,8 @@ struct thread_options_pack {
 	uint32_t log_gz;
 	uint32_t log_gz_store;
 	uint32_t log_unix_epoch;
+	uint32_t log_alternate_epoch;
+	uint32_t log_alternate_epoch_clock_id;
 	uint32_t norandommap;
 	uint32_t softrandommap;
 	uint32_t bs_unaligned;
@@ -702,4 +712,8 @@ extern int str_split_parse(struct thread_data *td, char *str,
 extern int split_parse_ddir(struct thread_options *o, struct split *split,
 			    char *str, bool absolute, unsigned int max_splits);
 
+extern int split_parse_prio_ddir(struct thread_options *o,
+				 struct split_prio **entries, int *nr_entries,
+				 char *str);
+
 #endif
diff --git a/time.c b/time.c
index cd0e2a89..5c4d6de0 100644
--- a/time.c
+++ b/time.c
@@ -172,14 +172,14 @@ void set_genesis_time(void)
 	fio_gettime(&genesis, NULL);
 }
 
-void set_epoch_time(struct thread_data *td, int log_unix_epoch)
+void set_epoch_time(struct thread_data *td, int log_alternate_epoch, clockid_t clock_id)
 {
 	fio_gettime(&td->epoch, NULL);
-	if (log_unix_epoch) {
-		struct timeval tv;
-		gettimeofday(&tv, NULL);
-		td->unix_epoch = (unsigned long long)(tv.tv_sec) * 1000 +
-		                 (unsigned long long)(tv.tv_usec) / 1000;
+	if (log_alternate_epoch) {
+		struct timespec ts;
+		clock_gettime(clock_id, &ts);
+		td->alternate_epoch = (unsigned long long)(ts.tv_sec) * 1000 +
+		                 (unsigned long long)(ts.tv_nsec) / 1000000;
 	}
 }
 
