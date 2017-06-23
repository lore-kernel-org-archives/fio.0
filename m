Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:57758 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751189AbdFWMAE (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 23 Jun 2017 08:00:04 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
        by bombadil.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1dONFr-0001I0-63
        for fio@vger.kernel.org; Fri, 23 Jun 2017 12:00:03 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20170623120002.06D702C0235@kernel.dk>
Date: Fri, 23 Jun 2017 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit b2fcbe01bdac01bc5d7f8ddea94f264b9f8c2003:

  Ensure that thread_stat alignment is correct (2017-06-19 16:41:51 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to cf6b7fb4f1883af9cbc443ed2536e7454ed51215:

  t/time-test: cleanups (2017-06-22 19:29:35 -0600)

----------------------------------------------------------------
Jens Axboe (10):
      Merge branch 'nanosecond-2stage' of https://github.com/vincentkfu/fio into nsec
      Fixup some style issues
      Merge branch 'nsec'
      crc32c: use bool
      arch: tsc_reliable can be a bool
      client/server: bool conversion
      iolog: get work items out of shared memory pool
      iolog: punt freeing of data back to original thread
      iolog: ensure proper flushing of compressed logs
      t/time-test: cleanups

Vincent Fu (12):
      nanosecond: initial commit changing timeval to timespec
      nanosecond: update completion latency recording and normal, json output to use nanoseconds
      nanosecond: reconcile terse output with nanosecond timing for latencies
      nanosecond: alter gfio to accommodate nanosecond timing
      nanosecond: fiologparser_hist set default --group_nr to 29 to match stat.h FIO_IO_U_PLAT_GROUP_NR
      nanosecond: fix up conversion of ticks to nsec by doing the conversion in 2 stages
      nanosecond: add test program t/time-test for experimenting with cpu clock ticks to nsec conversion
      lib/seqlock: #include "types.h" for bool type
      nanosecond: update t/time-test.c to include experiments using seqlock for conversion
      gettime: for better accuracy calculate cycles_per_msec instead of cycles_per_usec
      gettime: drop tv_valid->last_cycles and tv_valid->last_tv_valid
      server: bump server version for the change to FIO_IO_U_PLAT_GROUP_NR

 HOWTO                           |   2 +-
 Makefile                        |   7 +
 arch/arch-ia64.h                |   4 +-
 arch/arch-ppc.h                 |   4 +-
 arch/arch-s390.h                |   4 +-
 arch/arch-x86-common.h          |   2 +-
 arch/arch.h                     |   2 +
 backend.c                       |  42 ++--
 client.c                        |  36 +--
 client.h                        |  11 +-
 crc/crc32c-arm64.c              |   9 +-
 crc/crc32c-intel.c              |   6 +-
 crc/crc32c.h                    |   5 +-
 crc/test.c                      |   6 +-
 diskutil.c                      |   2 +-
 diskutil.h                      |   2 +-
 engines/guasi.c                 |   2 +-
 engines/libaio.c                |   8 +-
 engines/rdma.c                  |   2 +-
 eta.c                           |   6 +-
 fio.h                           |  24 +-
 fio_time.h                      |  16 +-
 gclient.c                       |  56 +++--
 gettime-thread.c                |  14 +-
 gettime.c                       | 193 ++++++++++----
 gettime.h                       |  14 +-
 helper_thread.c                 |  32 +--
 idletime.c                      |  14 +-
 idletime.h                      |   4 +-
 io_u.c                          |  91 +++++--
 io_u.h                          |   4 +-
 ioengines.c                     |   4 +-
 iolog.c                         |  52 +++-
 iolog.h                         |   7 +-
 lib/seqlock.h                   |   1 +
 libfio.c                        |   8 +-
 mutex.c                         |  12 +-
 options.c                       |   2 +-
 os/windows/posix.c              |   6 +-
 profiles/act.c                  |   2 +-
 server.c                        |  13 +-
 server.h                        |   6 +-
 stat.c                          | 217 ++++++++++------
 stat.h                          |  38 ++-
 steadystate.c                   |   2 +-
 steadystate.h                   |   2 +-
 t/arch.c                        |   2 +-
 t/debug.c                       |   2 +-
 t/dedupe.c                      |   2 +-
 t/lfsr-test.c                   |   2 +-
 t/time-test.c                   | 544 ++++++++++++++++++++++++++++++++++++++++
 time.c                          |  36 ++-
 tools/hist/fiologparser_hist.py |   2 +-
 verify.c                        |   2 +-
 54 files changed, 1203 insertions(+), 385 deletions(-)
 create mode 100644 t/time-test.c

---

Diff of recent changes:

diff --git a/HOWTO b/HOWTO
index d3a5783..22c5a5b 100644
--- a/HOWTO
+++ b/HOWTO
@@ -3189,7 +3189,7 @@ Split up, the format is as follows:
 
         Total IO (KiB), bandwidth (KiB/sec), IOPS, runtime (msec)
         Submission latency: min, max, mean, stdev (usec)
-        Completion latency: min, max, mean, stdev(usec)
+        Completion latency: min, max, mean, stdev (usec)
         Completion latency percentiles: 20 fields (see below)
         Total latency: min, max, mean, stdev (usec)
         Bw (KiB/s): min, max, aggregate percentage of total, mean, stdev
diff --git a/Makefile b/Makefile
index d7786d2..64fa97a 100644
--- a/Makefile
+++ b/Makefile
@@ -250,6 +250,9 @@ T_PIPE_ASYNC_PROGS = t/read-to-pipe-async
 T_MEMLOCK_OBJS = t/memlock.o
 T_MEMLOCK_PROGS = t/memlock
 
+T_TT_OBJS = t/time-test.o
+T_TT_PROGS = t/time-test
+
 T_OBJS = $(T_SMALLOC_OBJS)
 T_OBJS += $(T_IEEE_OBJS)
 T_OBJS += $(T_ZIPF_OBJS)
@@ -261,6 +264,7 @@ T_OBJS += $(T_DEDUPE_OBJS)
 T_OBJS += $(T_VS_OBJS)
 T_OBJS += $(T_PIPE_ASYNC_OBJS)
 T_OBJS += $(T_MEMLOCK_OBJS)
+T_OBJS += $(T_TT_OBJS)
 
 ifneq (,$(findstring CYGWIN,$(CONFIG_TARGET_OS)))
     T_DEDUPE_OBJS += os/windows/posix.o lib/hweight.o
@@ -434,6 +438,9 @@ t/fio-dedupe: $(T_DEDUPE_OBJS)
 t/fio-verify-state: $(T_VS_OBJS)
 	$(QUIET_LINK)$(CC) $(LDFLAGS) $(CFLAGS) -o $@ $(T_VS_OBJS) $(LIBS)
 
+t/time-test: $(T_TT_OBJS)
+	$(QUIET_LINK)$(CC) $(LDFLAGS) $(CFLAGS) -o $@ $(T_TT_OBJS) $(LIBS)
+
 clean: FORCE
 	@rm -f .depend $(FIO_OBJS) $(GFIO_OBJS) $(OBJS) $(T_OBJS) $(PROGS) $(T_PROGS) $(T_TEST_PROGS) core.* core gfio FIO-VERSION-FILE *.d lib/*.d oslib/*.d crc/*.d engines/*.d profiles/*.d t/*.d config-host.mak config-host.h y.tab.[ch] lex.yy.c exp/*.[do] lexer.h
 	@rm -rf  doc/output
diff --git a/arch/arch-ia64.h b/arch/arch-ia64.h
index 53c049f..ece3f7e 100644
--- a/arch/arch-ia64.h
+++ b/arch/arch-ia64.h
@@ -28,10 +28,10 @@ static inline unsigned long long get_cpu_clock(void)
 }
 
 #define ARCH_HAVE_INIT
-extern int tsc_reliable;
+extern bool tsc_reliable;
 static inline int arch_init(char *envp[])
 {
-	tsc_reliable = 1;
+	tsc_reliable = true;
 	return 0;
 }
 
diff --git a/arch/arch-ppc.h b/arch/arch-ppc.h
index 4a8aa97..ba452b1 100644
--- a/arch/arch-ppc.h
+++ b/arch/arch-ppc.h
@@ -117,12 +117,12 @@ static void atb_clocktest(void)
 #endif
 
 #define ARCH_HAVE_INIT
-extern int tsc_reliable;
+extern bool tsc_reliable;
 
 static inline int arch_init(char *envp[])
 {
 #if 0
-	tsc_reliable = 1;
+	tsc_reliable = true;
 	atb_clocktest();
 #endif
 	return 0;
diff --git a/arch/arch-s390.h b/arch/arch-s390.h
index 2e84bf8..6bf033b 100644
--- a/arch/arch-s390.h
+++ b/arch/arch-s390.h
@@ -28,10 +28,10 @@ static inline unsigned long long get_cpu_clock(void)
 #undef ARCH_CPU_CLOCK_WRAPS
 
 #define ARCH_HAVE_INIT
-extern int tsc_reliable;
+extern bool tsc_reliable;
 static inline int arch_init(char *envp[])
 {
-	tsc_reliable = 1;
+	tsc_reliable = true;
 	return 0;
 }
 
diff --git a/arch/arch-x86-common.h b/arch/arch-x86-common.h
index cbf66b8..c51c04c 100644
--- a/arch/arch-x86-common.h
+++ b/arch/arch-x86-common.h
@@ -14,7 +14,7 @@ static inline void cpuid(unsigned int op,
 
 #define ARCH_HAVE_INIT
 
-extern int tsc_reliable;
+extern bool tsc_reliable;
 extern int arch_random;
 
 static inline void arch_init_intel(unsigned int level)
diff --git a/arch/arch.h b/arch/arch.h
index 00d247c..4fb9b51 100644
--- a/arch/arch.h
+++ b/arch/arch.h
@@ -1,6 +1,8 @@
 #ifndef ARCH_H
 #define ARCH_H
 
+#include "../lib/types.h"
+
 enum {
 	arch_x86_64 = 1,
 	arch_x86,
diff --git a/backend.c b/backend.c
index 9a684ed..fe15997 100644
--- a/backend.c
+++ b/backend.c
@@ -136,7 +136,7 @@ static void set_sig_handlers(void)
 /*
  * Check if we are above the minimum rate given.
  */
-static bool __check_min_rate(struct thread_data *td, struct timeval *now,
+static bool __check_min_rate(struct thread_data *td, struct timespec *now,
 			     enum fio_ddir ddir)
 {
 	unsigned long long bytes = 0;
@@ -223,7 +223,7 @@ static bool __check_min_rate(struct thread_data *td, struct timeval *now,
 	return false;
 }
 
-static bool check_min_rate(struct thread_data *td, struct timeval *now)
+static bool check_min_rate(struct thread_data *td, struct timespec *now)
 {
 	bool ret = false;
 
@@ -335,18 +335,18 @@ static int fio_file_fsync(struct thread_data *td, struct fio_file *f)
 	return ret;
 }
 
-static inline void __update_tv_cache(struct thread_data *td)
+static inline void __update_ts_cache(struct thread_data *td)
 {
-	fio_gettime(&td->tv_cache, NULL);
+	fio_gettime(&td->ts_cache, NULL);
 }
 
-static inline void update_tv_cache(struct thread_data *td)
+static inline void update_ts_cache(struct thread_data *td)
 {
-	if ((++td->tv_cache_nr & td->tv_cache_mask) == td->tv_cache_mask)
-		__update_tv_cache(td);
+	if ((++td->ts_cache_nr & td->ts_cache_mask) == td->ts_cache_mask)
+		__update_ts_cache(td);
 }
 
-static inline bool runtime_exceeded(struct thread_data *td, struct timeval *t)
+static inline bool runtime_exceeded(struct thread_data *td, struct timespec *t)
 {
 	if (in_ramp_time(td))
 		return false;
@@ -430,7 +430,7 @@ static void check_update_rusage(struct thread_data *td)
 	}
 }
 
-static int wait_for_completions(struct thread_data *td, struct timeval *time)
+static int wait_for_completions(struct thread_data *td, struct timespec *time)
 {
 	const int full = queue_full(td);
 	int min_evts = 0;
@@ -462,7 +462,7 @@ static int wait_for_completions(struct thread_data *td, struct timeval *time)
 
 int io_queue_event(struct thread_data *td, struct io_u *io_u, int *ret,
 		   enum fio_ddir ddir, uint64_t *bytes_issued, int from_verify,
-		   struct timeval *comp_time)
+		   struct timespec *comp_time)
 {
 	int ret2;
 
@@ -633,12 +633,12 @@ static void do_verify(struct thread_data *td, uint64_t verify_bytes)
 		enum fio_ddir ddir;
 		int full;
 
-		update_tv_cache(td);
+		update_ts_cache(td);
 		check_update_rusage(td);
 
-		if (runtime_exceeded(td, &td->tv_cache)) {
-			__update_tv_cache(td);
-			if (runtime_exceeded(td, &td->tv_cache)) {
+		if (runtime_exceeded(td, &td->ts_cache)) {
+			__update_ts_cache(td);
+			if (runtime_exceeded(td, &td->ts_cache)) {
 				fio_mark_td_terminate(td);
 				break;
 			}
@@ -874,7 +874,7 @@ static void do_io(struct thread_data *td, uint64_t *bytes_done)
 	while ((td->o.read_iolog_file && !flist_empty(&td->io_log_list)) ||
 		(!flist_empty(&td->trim_list)) || !io_issue_bytes_exceeded(td) ||
 		td->o.time_based) {
-		struct timeval comp_time;
+		struct timespec comp_time;
 		struct io_u *io_u;
 		int full;
 		enum fio_ddir ddir;
@@ -884,11 +884,11 @@ static void do_io(struct thread_data *td, uint64_t *bytes_done)
 		if (td->terminate || td->done)
 			break;
 
-		update_tv_cache(td);
+		update_ts_cache(td);
 
-		if (runtime_exceeded(td, &td->tv_cache)) {
-			__update_tv_cache(td);
-			if (runtime_exceeded(td, &td->tv_cache)) {
+		if (runtime_exceeded(td, &td->ts_cache)) {
+			__update_ts_cache(td);
+			if (runtime_exceeded(td, &td->ts_cache)) {
 				fio_mark_td_terminate(td);
 				break;
 			}
@@ -1686,7 +1686,7 @@ static void *thread_main(void *data)
 		uint64_t verify_bytes;
 
 		fio_gettime(&td->start, NULL);
-		memcpy(&td->tv_cache, &td->start, sizeof(td->start));
+		memcpy(&td->ts_cache, &td->start, sizeof(td->start));
 
 		if (clear_state) {
 			clear_io_state(td, 0);
@@ -2202,7 +2202,7 @@ reap:
 
 	while (todo) {
 		struct thread_data *map[REAL_MAX_JOBS];
-		struct timeval this_start;
+		struct timespec this_start;
 		int this_jobs = 0, left;
 		struct fork_data *fd;
 
diff --git a/client.c b/client.c
index 80096bf..7a986aa 100644
--- a/client.c
+++ b/client.c
@@ -48,7 +48,7 @@ struct client_ops fio_client_ops = {
 	.client_type	= FIO_CLIENT_TYPE_CLI,
 };
 
-static struct timeval eta_tv;
+static struct timespec eta_ts;
 
 static FLIST_HEAD(client_list);
 static FLIST_HEAD(eta_list);
@@ -318,7 +318,7 @@ struct fio_client *fio_client_add_explicit(struct client_ops *ops,
 	client->hostname = strdup(hostname);
 
 	if (type == Fio_client_socket)
-		client->is_sock = 1;
+		client->is_sock = true;
 	else {
 		int ipv6;
 
@@ -728,7 +728,7 @@ static int __fio_client_send_remote_ini(struct fio_client *client,
 	strcpy((char *) pdu->file, filename);
 	pdu->client_type = cpu_to_le16((uint16_t) client->type);
 
-	client->sent_job = 1;
+	client->sent_job = true;
 	ret = fio_net_send_cmd(client->fd, FIO_NET_CMD_LOAD_FILE, pdu, p_size,NULL, NULL);
 	free(pdu);
 	return ret;
@@ -781,7 +781,7 @@ static int __fio_client_send_local_ini(struct fio_client *client,
 	pdu->buf_len = __cpu_to_le32(sb.st_size);
 	pdu->client_type = cpu_to_le32(client->type);
 
-	client->sent_job = 1;
+	client->sent_job = true;
 	ret = fio_net_send_cmd(client->fd, FIO_NET_CMD_JOB, pdu, p_size, NULL, NULL);
 	free(pdu);
 	close(fd);
@@ -799,7 +799,7 @@ int fio_client_send_ini(struct fio_client *client, const char *filename,
 		ret = __fio_client_send_remote_ini(client, filename);
 
 	if (!ret)
-		client->sent_job = 1;
+		client->sent_job = true;
 
 	return ret;
 }
@@ -908,6 +908,8 @@ static void convert_ts(struct thread_stat *dst, struct thread_stat *src)
 		dst->io_u_complete[i]	= le32_to_cpu(src->io_u_complete[i]);
 	}
 
+	for (i = 0; i < FIO_IO_U_LAT_N_NR; i++)
+		dst->io_u_lat_n[i]	= le32_to_cpu(src->io_u_lat_n[i]);
 	for (i = 0; i < FIO_IO_U_LAT_U_NR; i++)
 		dst->io_u_lat_u[i]	= le32_to_cpu(src->io_u_lat_u[i]);
 	for (i = 0; i < FIO_IO_U_LAT_M_NR; i++)
@@ -1001,7 +1003,7 @@ static void handle_ts(struct fio_client *client, struct fio_net_cmd *cmd)
 		opt_list = &client->opt_lists[p->ts.thread_number - 1];
 
 	tsobj = show_thread_status(&p->ts, &p->rs, opt_list, NULL);
-	client->did_stat = 1;
+	client->did_stat = true;
 	if (tsobj) {
 		json_object_add_client_info(tsobj, client);
 		json_array_add_value_object(clients_array, tsobj);
@@ -1123,7 +1125,7 @@ static void handle_du(struct fio_client *client, struct fio_net_cmd *cmd)
 	struct cmd_du_pdu *du = (struct cmd_du_pdu *) cmd->payload;
 
 	if (!client->disk_stats_shown) {
-		client->disk_stats_shown = 1;
+		client->disk_stats_shown = true;
 		log_info("\nDisk stats (read/write):\n");
 	}
 
@@ -1869,7 +1871,7 @@ static int handle_cmd_timeout(struct fio_client *client,
 }
 
 static int client_check_cmd_timeout(struct fio_client *client,
-				    struct timeval *now)
+				    struct timespec *now)
 {
 	struct fio_net_cmd_reply *reply;
 	struct flist_head *entry, *tmp;
@@ -1878,7 +1880,7 @@ static int client_check_cmd_timeout(struct fio_client *client,
 	flist_for_each_safe(entry, tmp, &client->cmd_list) {
 		reply = flist_entry(entry, struct fio_net_cmd_reply, list);
 
-		if (mtime_since(&reply->tv, now) < FIO_NET_CLIENT_TIMEOUT)
+		if (mtime_since(&reply->ts, now) < FIO_NET_CLIENT_TIMEOUT)
 			continue;
 
 		if (!handle_cmd_timeout(client, reply))
@@ -1896,10 +1898,10 @@ static int fio_check_clients_timed_out(void)
 {
 	struct fio_client *client;
 	struct flist_head *entry, *tmp;
-	struct timeval tv;
+	struct timespec ts;
 	int ret = 0;
 
-	fio_gettime(&tv, NULL);
+	fio_gettime(&ts, NULL);
 
 	flist_for_each_safe(entry, tmp, &client_list) {
 		client = flist_entry(entry, struct fio_client, list);
@@ -1907,7 +1909,7 @@ static int fio_check_clients_timed_out(void)
 		if (flist_empty(&client->cmd_list))
 			continue;
 
-		if (!client_check_cmd_timeout(client, &tv))
+		if (!client_check_cmd_timeout(client, &ts))
 			continue;
 
 		if (client->ops->timed_out)
@@ -1928,7 +1930,7 @@ int fio_handle_clients(struct client_ops *ops)
 	struct pollfd *pfds;
 	int i, ret = 0, retval = 0;
 
-	fio_gettime(&eta_tv, NULL);
+	fio_gettime(&eta_ts, NULL);
 
 	pfds = malloc(nr_clients * sizeof(struct pollfd));
 
@@ -1960,13 +1962,13 @@ int fio_handle_clients(struct client_ops *ops)
 		assert(i == nr_clients);
 
 		do {
-			struct timeval tv;
+			struct timespec ts;
 			int timeout;
 
-			fio_gettime(&tv, NULL);
-			if (mtime_since(&eta_tv, &tv) >= 900) {
+			fio_gettime(&ts, NULL);
+			if (mtime_since(&eta_ts, &ts) >= 900) {
 				request_client_etas(ops);
-				memcpy(&eta_tv, &tv, sizeof(tv));
+				memcpy(&eta_ts, &ts, sizeof(ts));
 
 				if (fio_check_clients_timed_out())
 					break;
diff --git a/client.h b/client.h
index fc9c196..394b685 100644
--- a/client.h
+++ b/client.h
@@ -6,6 +6,7 @@
 #include <netinet/in.h>
 #include <arpa/inet.h>
 
+#include "lib/types.h"
 #include "stat.h"
 
 struct fio_net_cmd;
@@ -45,16 +46,16 @@ struct fio_client {
 
 	int state;
 
-	int skip_newline;
-	int is_sock;
-	int disk_stats_shown;
+	bool skip_newline;
+	bool is_sock;
+	bool disk_stats_shown;
 	unsigned int jobs;
 	unsigned int nr_stat;
 	int error;
 	int signal;
 	int ipv6;
-	int sent_job;
-	int did_stat;
+	bool sent_job;
+	bool did_stat;
 	uint32_t type;
 
 	uint32_t thread_number;
diff --git a/crc/crc32c-arm64.c b/crc/crc32c-arm64.c
index c3f42c7..08177ba 100644
--- a/crc/crc32c-arm64.c
+++ b/crc/crc32c-arm64.c
@@ -19,7 +19,7 @@
 #define HWCAP_CRC32             (1 << 7)
 #endif /* HWCAP_CRC32 */
 
-int crc32c_arm64_available = 0;
+bool crc32c_arm64_available = false;
 
 #ifdef ARCH_HAVE_ARM64_CRC_CRYPTO
 
@@ -27,7 +27,7 @@ int crc32c_arm64_available = 0;
 #include <arm_acle.h>
 #include <arm_neon.h>
 
-static int crc32c_probed;
+static bool crc32c_probed;
 
 /*
  * Function to calculate reflected crc with PMULL Instruction
@@ -106,9 +106,8 @@ void crc32c_arm64_probe(void)
 
 	if (!crc32c_probed) {
 		hwcap = getauxval(AT_HWCAP);
-		if (hwcap & HWCAP_CRC32)
-			crc32c_arm64_available = 1;
-		crc32c_probed = 1;
+		crc32c_arm64_available = (hwcap & HWCAP_CRC32) != 0;
+		crc32c_probed = true;
 	}
 }
 
diff --git a/crc/crc32c-intel.c b/crc/crc32c-intel.c
index 0b0f193..05a087d 100644
--- a/crc/crc32c-intel.c
+++ b/crc/crc32c-intel.c
@@ -18,7 +18,7 @@
  * Volume 2A: Instruction Set Reference, A-M
  */
 
-int crc32c_intel_available = 0;
+bool crc32c_intel_available = false;
 
 #ifdef ARCH_HAVE_SSE4_2
 
@@ -30,7 +30,7 @@ int crc32c_intel_available = 0;
 #define SCALE_F 4
 #endif
 
-static int crc32c_probed;
+static bool crc32c_probed;
 
 static uint32_t crc32c_intel_le_hw_byte(uint32_t crc, unsigned char const *data,
 					unsigned long length)
@@ -87,7 +87,7 @@ void crc32c_intel_probe(void)
 
 		do_cpuid(&eax, &ebx, &ecx, &edx);
 		crc32c_intel_available = (ecx & (1 << 20)) != 0;
-		crc32c_probed = 1;
+		crc32c_probed = true;
 	}
 }
 
diff --git a/crc/crc32c.h b/crc/crc32c.h
index 5d66407..d513f3a 100644
--- a/crc/crc32c.h
+++ b/crc/crc32c.h
@@ -19,10 +19,11 @@
 #define CRC32C_H
 
 #include "../arch/arch.h"
+#include "../lib/types.h"
 
 extern uint32_t crc32c_sw(unsigned char const *, unsigned long);
-extern int crc32c_arm64_available;
-extern int crc32c_intel_available;
+extern bool crc32c_arm64_available;
+extern bool crc32c_intel_available;
 
 #ifdef ARCH_HAVE_ARM64_CRC_CRYPTO
 extern uint32_t crc32c_arm64(unsigned char const *, unsigned long);
diff --git a/crc/test.c b/crc/test.c
index 368229e..b119872 100644
--- a/crc/test.c
+++ b/crc/test.c
@@ -392,7 +392,7 @@ int fio_crctest(const char *type)
 	fill_random_buf(&state, buf, CHUNK);
 
 	for (i = 0; t[i].name; i++) {
-		struct timeval tv;
+		struct timespec ts;
 		double mb_sec;
 		uint64_t usec;
 		char pre[3];
@@ -409,9 +409,9 @@ int fio_crctest(const char *type)
 			t[i].fn(&t[i], buf, CHUNK);
 		}
 
-		fio_gettime(&tv, NULL);
+		fio_gettime(&ts, NULL);
 		t[i].fn(&t[i], buf, CHUNK);
-		usec = utime_since_now(&tv);
+		usec = utime_since_now(&ts);
 
 		if (usec) {
 			mb_sec = (double) mb / (double) usec;
diff --git a/diskutil.c b/diskutil.c
index 9767ea2..4fe554f 100644
--- a/diskutil.c
+++ b/diskutil.c
@@ -84,7 +84,7 @@ static int get_io_ticks(struct disk_util *du, struct disk_util_stat *dus)
 static void update_io_tick_disk(struct disk_util *du)
 {
 	struct disk_util_stat __dus, *dus, *ldus;
-	struct timeval t;
+	struct timespec t;
 
 	if (!du->users)
 		return;
diff --git a/diskutil.h b/diskutil.h
index f773066..91b4202 100644
--- a/diskutil.h
+++ b/diskutil.h
@@ -64,7 +64,7 @@ struct disk_util {
 	 */
 	struct flist_head slaves;
 
-	struct timeval time;
+	struct timespec time;
 
 	struct fio_mutex *lock;
 	unsigned long users;
diff --git a/engines/guasi.c b/engines/guasi.c
index eb12c89..9644ee5 100644
--- a/engines/guasi.c
+++ b/engines/guasi.c
@@ -132,7 +132,7 @@ static void fio_guasi_queued(struct thread_data *td, struct io_u **io_us, int nr
 {
 	int i;
 	struct io_u *io_u;
-	struct timeval now;
+	struct timespec now;
 
 	if (!fio_fill_issue_time(td))
 		return;
diff --git a/engines/libaio.c b/engines/libaio.c
index e15c519..e0d7cbb 100644
--- a/engines/libaio.c
+++ b/engines/libaio.c
@@ -220,7 +220,7 @@ static int fio_libaio_queue(struct thread_data *td, struct io_u *io_u)
 static void fio_libaio_queued(struct thread_data *td, struct io_u **io_us,
 			      unsigned int nr)
 {
-	struct timeval now;
+	struct timespec now;
 	unsigned int i;
 
 	if (!fio_fill_issue_time(td))
@@ -241,7 +241,7 @@ static int fio_libaio_commit(struct thread_data *td)
 	struct libaio_data *ld = td->io_ops_data;
 	struct iocb **iocbs;
 	struct io_u **io_us;
-	struct timeval tv;
+	struct timespec ts;
 	int ret, wait_start = 0;
 
 	if (!ld->queued)
@@ -282,9 +282,9 @@ static int fio_libaio_commit(struct thread_data *td)
 				break;
 			}
 			if (!wait_start) {
-				fio_gettime(&tv, NULL);
+				fio_gettime(&ts, NULL);
 				wait_start = 1;
-			} else if (mtime_since_now(&tv) > 30000) {
+			} else if (mtime_since_now(&ts) > 30000) {
 				log_err("fio: aio appears to be stalled, giving up\n");
 				break;
 			}
diff --git a/engines/rdma.c b/engines/rdma.c
index 10e60dc..8d31ff3 100644
--- a/engines/rdma.c
+++ b/engines/rdma.c
@@ -802,7 +802,7 @@ static void fio_rdmaio_queued(struct thread_data *td, struct io_u **io_us,
 			      unsigned int nr)
 {
 	struct rdmaio_data *rd = td->io_ops_data;
-	struct timeval now;
+	struct timespec now;
 	unsigned int i;
 
 	if (!fio_fill_issue_time(td))
diff --git a/eta.c b/eta.c
index adf7f94..baaa681 100644
--- a/eta.c
+++ b/eta.c
@@ -358,12 +358,12 @@ bool calc_thread_status(struct jobs_eta *je, int force)
 	uint64_t rate_time, disp_time, bw_avg_time, *eta_secs;
 	unsigned long long io_bytes[DDIR_RWDIR_CNT];
 	unsigned long long io_iops[DDIR_RWDIR_CNT];
-	struct timeval now;
+	struct timespec now;
 
 	static unsigned long long rate_io_bytes[DDIR_RWDIR_CNT];
 	static unsigned long long disp_io_bytes[DDIR_RWDIR_CNT];
 	static unsigned long long disp_io_iops[DDIR_RWDIR_CNT];
-	static struct timeval rate_prev_time, disp_prev_time;
+	static struct timespec rate_prev_time, disp_prev_time;
 
 	if (!force) {
 		if (!(output_format & FIO_OUTPUT_NORMAL) &&
@@ -511,7 +511,7 @@ bool calc_thread_status(struct jobs_eta *je, int force)
 
 void display_thread_status(struct jobs_eta *je)
 {
-	static struct timeval disp_eta_new_line;
+	static struct timespec disp_eta_new_line;
 	static int eta_new_line_init, eta_new_line_pending;
 	static int linelen_last;
 	static int eta_good;
diff --git a/fio.h b/fio.h
index 6c06a0c..d5d6bfe 100644
--- a/fio.h
+++ b/fio.h
@@ -165,10 +165,10 @@ struct thread_data {
 	struct thread_data *parent;
 
 	uint64_t stat_io_bytes[DDIR_RWDIR_CNT];
-	struct timeval bw_sample_time;
+	struct timespec bw_sample_time;
 
 	uint64_t stat_io_blocks[DDIR_RWDIR_CNT];
-	struct timeval iops_sample_time;
+	struct timespec iops_sample_time;
 
 	volatile int update_rusage;
 	struct fio_mutex *rusage_sem;
@@ -287,7 +287,7 @@ struct thread_data {
 	unsigned long rate_bytes[DDIR_RWDIR_CNT];
 	unsigned long rate_blocks[DDIR_RWDIR_CNT];
 	unsigned long long rate_io_issue_bytes[DDIR_RWDIR_CNT];
-	struct timeval lastrate[DDIR_RWDIR_CNT];
+	struct timespec lastrate[DDIR_RWDIR_CNT];
 	int64_t last_usec[DDIR_RWDIR_CNT];
 	struct frand_state poisson_state[DDIR_RWDIR_CNT];
 
@@ -323,21 +323,21 @@ struct thread_data {
 	 */
 	struct frand_state random_state;
 
-	struct timeval start;	/* start of this loop */
-	struct timeval epoch;	/* time job was started */
+	struct timespec start;	/* start of this loop */
+	struct timespec epoch;	/* time job was started */
 	unsigned long long unix_epoch; /* Time job was started, unix epoch based. */
-	struct timeval last_issue;
+	struct timespec last_issue;
 	long time_offset;
-	struct timeval tv_cache;
-	struct timeval terminate_time;
-	unsigned int tv_cache_nr;
-	unsigned int tv_cache_mask;
+	struct timespec ts_cache;
+	struct timespec terminate_time;
+	unsigned int ts_cache_nr;
+	unsigned int ts_cache_mask;
 	unsigned int ramp_time_over;
 
 	/*
 	 * Time since last latency_window was started
 	 */
-	struct timeval latency_ts;
+	struct timespec latency_ts;
 	unsigned int latency_qd;
 	unsigned int latency_qd_high;
 	unsigned int latency_qd_low;
@@ -642,7 +642,7 @@ extern void reset_all_stats(struct thread_data *);
 
 extern int io_queue_event(struct thread_data *td, struct io_u *io_u, int *ret,
 		   enum fio_ddir ddir, uint64_t *bytes_issued, int from_verify,
-		   struct timeval *comp_time);
+		   struct timespec *comp_time);
 
 /*
  * Latency target helpers
diff --git a/fio_time.h b/fio_time.h
index b49cc82..f4eac79 100644
--- a/fio_time.h
+++ b/fio_time.h
@@ -4,22 +4,24 @@
 #include "lib/types.h"
 
 struct thread_data;
-extern uint64_t utime_since(const struct timeval *,const  struct timeval *);
-extern uint64_t utime_since_now(const struct timeval *);
-extern uint64_t mtime_since(const struct timeval *, const struct timeval *);
-extern uint64_t mtime_since_now(const struct timeval *);
-extern uint64_t time_since_now(const struct timeval *);
+extern uint64_t ntime_since(const struct timespec *, const struct timespec *);
+extern uint64_t utime_since(const struct timespec *, const struct timespec *);
+extern uint64_t utime_since_now(const struct timespec *);
+extern uint64_t mtime_since(const struct timespec *, const struct timespec *);
+extern uint64_t mtime_since_now(const struct timespec *);
+extern uint64_t mtime_since_tv(const struct timeval *, const struct timeval *);
+extern uint64_t time_since_now(const struct timespec *);
 extern uint64_t time_since_genesis(void);
 extern uint64_t mtime_since_genesis(void);
 extern uint64_t utime_since_genesis(void);
 extern uint64_t usec_spin(unsigned int);
 extern uint64_t usec_sleep(struct thread_data *, unsigned long);
-extern void fill_start_time(struct timeval *);
+extern void fill_start_time(struct timespec *);
 extern void set_genesis_time(void);
 extern bool ramp_time_over(struct thread_data *);
 extern bool in_ramp_time(struct thread_data *);
 extern void fio_time_init(void);
-extern void timeval_add_msec(struct timeval *, unsigned int);
+extern void timespec_add_msec(struct timespec *, unsigned int);
 extern void set_epoch_time(struct thread_data *, int);
 
 #endif
diff --git a/gclient.c b/gclient.c
index 928a1b7..4eb99a0 100644
--- a/gclient.c
+++ b/gclient.c
@@ -930,8 +930,10 @@ static gint on_config_lat_drawing_area(GtkWidget *w, GdkEventConfigure *event,
 static void gfio_show_latency_buckets(struct gfio_client *gc, GtkWidget *vbox,
 				      struct thread_stat *ts)
 {
-	double io_u_lat[FIO_IO_U_LAT_U_NR + FIO_IO_U_LAT_M_NR];
-	const char *ranges[] = { "2us", "4us", "10us", "20us", "50us", "100us",
+	double io_u_lat[FIO_IO_U_LAT_N_NR + FIO_IO_U_LAT_U_NR + FIO_IO_U_LAT_M_NR];
+	const char *ranges[] = { "2ns", "4ns", "10ns", "20ns", "50ns", "100ns",
+				 "250ns", "500ns", "750ns", "1000ns", "2us",
+				 "4us", "10us", "20us", "50us", "100us",
 				 "250us", "500us", "750us", "1ms", "2ms",
 				 "4ms", "10ms", "20ms", "50ms", "100ms",
 				 "250ms", "500ms", "750ms", "1s", "2s", ">= 2s" };
@@ -940,8 +942,9 @@ static void gfio_show_latency_buckets(struct gfio_client *gc, GtkWidget *vbox,
 	GtkWidget *frame, *tree_view, *hbox, *completion_vbox, *drawing_area;
 	struct gui_entry *ge = gc->ge;
 
-	stat_calc_lat_u(ts, io_u_lat);
-	stat_calc_lat_m(ts, &io_u_lat[FIO_IO_U_LAT_U_NR]);
+	stat_calc_lat_n(ts, io_u_lat);
+	stat_calc_lat_u(ts, &io_u_lat[FIO_IO_U_LAT_N_NR]);
+	stat_calc_lat_m(ts, &io_u_lat[FIO_IO_U_LAT_N_NR + FIO_IO_U_LAT_U_NR]);
 
 	/*
 	 * Found out which first bucket has entries, and which last bucket
@@ -983,16 +986,18 @@ static void gfio_show_latency_buckets(struct gfio_client *gc, GtkWidget *vbox,
 	gtk_box_pack_start(GTK_BOX(hbox), tree_view, TRUE, TRUE, 3);
 }
 
-static void gfio_show_lat(GtkWidget *vbox, const char *name, unsigned long min,
-			  unsigned long max, double mean, double dev)
+static void gfio_show_lat(GtkWidget *vbox, const char *name, unsigned long long min,
+			  unsigned long long max, double mean, double dev)
 {
-	const char *base = "(usec)";
+	const char *base = "(nsec)";
 	GtkWidget *hbox, *label, *frame;
 	char *minp, *maxp;
 	char tmp[64];
 
-	if (usec_to_msec(&min, &max, &mean, &dev))
+	if (nsec_to_msec(&min, &max, &mean, &dev))
 		base = "(msec)";
+	else if (nsec_to_usec(&min, &max, &mean, &dev))
+		base = "(usec)";
 
 	minp = num2str(min, 6, 1, 0, N2S_NONE);
 	maxp = num2str(max, 6, 1, 0, N2S_NONE);
@@ -1019,7 +1024,7 @@ static void gfio_show_lat(GtkWidget *vbox, const char *name, unsigned long min,
 	free(maxp);
 }
 
-static GtkWidget *gfio_output_clat_percentiles(unsigned int *ovals,
+static GtkWidget *gfio_output_clat_percentiles(unsigned long long *ovals,
 					       fio_fp64_t *plist,
 					       unsigned int len,
 					       const char *base,
@@ -1030,10 +1035,10 @@ static GtkWidget *gfio_output_clat_percentiles(unsigned int *ovals,
 	GtkTreeSelection *selection;
 	GtkListStore *model;
 	GtkTreeIter iter;
-	int i;
+	int i, j;
 
 	for (i = 0; i < len; i++)
-		types[i] = G_TYPE_INT;
+		types[i] = G_TYPE_ULONG;
 
 	model = gtk_list_store_newv(len, types);
 
@@ -1056,15 +1061,15 @@ static GtkWidget *gfio_output_clat_percentiles(unsigned int *ovals,
 	gtk_list_store_append(model, &iter);
 
 	for (i = 0; i < len; i++) {
-		if (scale)
+		for (j = 0; j < scale; j++)
 			ovals[i] = (ovals[i] + 999) / 1000;
-		gtk_list_store_set(model, &iter, i, ovals[i], -1);
+		gtk_list_store_set(model, &iter, i, (unsigned long) ovals[i], -1);
 	}
 
 	return tree_view;
 }
 
-static struct graph *setup_clat_graph(char *title, unsigned int *ovals,
+static struct graph *setup_clat_graph(char *title, unsigned long long *ovals,
 				      fio_fp64_t *plist,
 				      unsigned int len,
 				      double xdim, double ydim)
@@ -1096,7 +1101,8 @@ static void gfio_show_clat_percentiles(struct gfio_client *gc,
 	unsigned int *io_u_plat = ts->io_u_plat[ddir];
 	unsigned long nr = ts->clat_stat[ddir].samples;
 	fio_fp64_t *plist = ts->percentile_list;
-	unsigned int *ovals, len, minv, maxv, scale_down;
+	unsigned int len, scale_down;
+	unsigned long long *ovals, minv, maxv;
 	const char *base;
 	GtkWidget *tree_view, *frame, *hbox, *drawing_area, *completion_vbox;
 	struct gui_entry *ge = gc->ge;
@@ -1107,16 +1113,19 @@ static void gfio_show_clat_percentiles(struct gfio_client *gc,
 		goto out;
 
 	/*
-	 * We default to usecs, but if the value range is such that we
-	 * should scale down to msecs, do that.
+	 * We default to nsecs, but if the value range is such that we
+	 * should scale down to usecs or msecs, do that.
 	 */
-	if (minv > 2000 && maxv > 99999) {
-		scale_down = 1;
+        if (minv > 2000000 && maxv > 99999999ULL) {
+                scale_down = 2;
 		base = "msec";
-	} else {
-		scale_down = 0;
+        } else if (minv > 2000 && maxv > 99999) {
+                scale_down = 1;
 		base = "usec";
-	}
+        } else {
+                scale_down = 0;
+		base = "nsec";
+        }
 
 	sprintf(tmp, "Completion percentiles (%s)", base);
 	tree_view = gfio_output_clat_percentiles(ovals, plist, len, base, scale_down);
@@ -1152,7 +1161,8 @@ static void gfio_show_ddir_status(struct gfio_client *gc, GtkWidget *mbox,
 {
 	const char *ddir_label[3] = { "Read", "Write", "Trim" };
 	GtkWidget *frame, *label, *box, *vbox, *main_vbox;
-	unsigned long min[3], max[3], runt;
+	unsigned long long min[3], max[3];
+	unsigned long runt;
 	unsigned long long bw, iops;
 	unsigned int flags = 0;
 	double mean[3], dev[3];
diff --git a/gettime-thread.c b/gettime-thread.c
index 19541b4..cbb81dc 100644
--- a/gettime-thread.c
+++ b/gettime-thread.c
@@ -6,30 +6,30 @@
 #include "fio.h"
 #include "smalloc.h"
 
-struct timeval *fio_tv = NULL;
+struct timespec *fio_ts = NULL;
 int fio_gtod_offload = 0;
 static pthread_t gtod_thread;
 static os_cpu_mask_t fio_gtod_cpumask;
 
 void fio_gtod_init(void)
 {
-	if (fio_tv)
+	if (fio_ts)
 		return;
 
-	fio_tv = smalloc(sizeof(struct timeval));
-	if (!fio_tv)
+	fio_ts = smalloc(sizeof(*fio_ts));
+	if (!fio_ts)
 		log_err("fio: smalloc pool exhausted\n");
 }
 
 static void fio_gtod_update(void)
 {
-	if (fio_tv) {
+	if (fio_ts) {
 		struct timeval __tv;
 
 		gettimeofday(&__tv, NULL);
-		fio_tv->tv_sec = __tv.tv_sec;
+		fio_ts->tv_sec = __tv.tv_sec;
 		write_barrier();
-		fio_tv->tv_usec = __tv.tv_usec;
+		fio_ts->tv_nsec = __tv.tv_usec * 1000;
 		write_barrier();
 	}
 }
diff --git a/gettime.c b/gettime.c
index 628aad6..5741932 100644
--- a/gettime.c
+++ b/gettime.c
@@ -15,19 +15,22 @@
 
 #if defined(ARCH_HAVE_CPU_CLOCK)
 #ifndef ARCH_CPU_CLOCK_CYCLES_PER_USEC
-static unsigned long cycles_per_usec;
-static unsigned long inv_cycles_per_usec;
-static uint64_t max_cycles_for_mult;
+static unsigned long cycles_per_msec;
+static unsigned long long cycles_start;
+static unsigned long long clock_mult;
+static unsigned long long max_cycles_mask;
+static unsigned long long nsecs_for_max_cycles;
+static unsigned int clock_shift;
+static unsigned int max_cycles_shift;
+#define MAX_CLOCK_SEC 60*60
 #endif
 #ifdef ARCH_CPU_CLOCK_WRAPS
-static unsigned long long cycles_start, cycles_wrap;
+static unsigned int cycles_wrap;
 #endif
 #endif
-int tsc_reliable = 0;
+bool tsc_reliable = false;
 
 struct tv_valid {
-	uint64_t last_cycles;
-	int last_tv_valid;
 	int warned;
 };
 #ifdef ARCH_HAVE_CPU_CLOCK
@@ -143,31 +146,31 @@ static int fill_clock_gettime(struct timespec *ts)
 }
 #endif
 
-static void __fio_gettime(struct timeval *tp)
+static void __fio_gettime(struct timespec *tp)
 {
 	switch (fio_clock_source) {
 #ifdef CONFIG_GETTIMEOFDAY
-	case CS_GTOD:
-		gettimeofday(tp, NULL);
+	case CS_GTOD: {
+		struct timeval tv;
+		gettimeofday(&tv, NULL);
+
+		tp->tv_sec = tv.tv_sec;
+		tp->tv_nsec = tv.tv_usec * 1000;
 		break;
+		}
 #endif
 #ifdef CONFIG_CLOCK_GETTIME
 	case CS_CGETTIME: {
-		struct timespec ts;
-
-		if (fill_clock_gettime(&ts) < 0) {
+		if (fill_clock_gettime(tp) < 0) {
 			log_err("fio: clock_gettime fails\n");
 			assert(0);
 		}
-
-		tp->tv_sec = ts.tv_sec;
-		tp->tv_usec = ts.tv_nsec / 1000;
 		break;
 		}
 #endif
 #ifdef ARCH_HAVE_CPU_CLOCK
 	case CS_CPUCLOCK: {
-		uint64_t usecs, t;
+		uint64_t nsecs, t, multiples;
 		struct tv_valid *tv;
 
 #ifdef CONFIG_TLS_THREAD
@@ -184,21 +187,17 @@ static void __fio_gettime(struct timeval *tp)
 			log_err("fio: double CPU clock wrap\n");
 			tv->warned = 1;
 		}
-
-		t -= cycles_start;
 #endif
-		tv->last_cycles = t;
-		tv->last_tv_valid = 1;
 #ifdef ARCH_CPU_CLOCK_CYCLES_PER_USEC
-		usecs = t / ARCH_CPU_CLOCK_CYCLES_PER_USEC;
+		nsecs = t / ARCH_CPU_CLOCK_CYCLES_PER_USEC * 1000;
 #else
-		if (t < max_cycles_for_mult)
-			usecs = (t * inv_cycles_per_usec) / 16777216UL;
-		else
-			usecs = t / cycles_per_usec;
+		t -= cycles_start;
+		multiples = t >> max_cycles_shift;
+		nsecs = multiples * nsecs_for_max_cycles;
+		nsecs += ((t & max_cycles_mask) * clock_mult) >> clock_shift;
 #endif
-		tp->tv_sec = usecs / 1000000;
-		tp->tv_usec = usecs % 1000000;
+		tp->tv_sec = nsecs / 1000000000ULL;
+		tp->tv_nsec = nsecs % 1000000000ULL;
 		break;
 		}
 #endif
@@ -209,9 +208,9 @@ static void __fio_gettime(struct timeval *tp)
 }
 
 #ifdef FIO_DEBUG_TIME
-void fio_gettime(struct timeval *tp, void *caller)
+void fio_gettime(struct timespec *tp, void *caller)
 #else
-void fio_gettime(struct timeval *tp, void fio_unused *caller)
+void fio_gettime(struct timespec *tp, void fio_unused *caller)
 #endif
 {
 #ifdef FIO_DEBUG_TIME
@@ -227,9 +226,9 @@ void fio_gettime(struct timeval *tp, void fio_unused *caller)
 }
 
 #if defined(ARCH_HAVE_CPU_CLOCK) && !defined(ARCH_CPU_CLOCK_CYCLES_PER_USEC)
-static unsigned long get_cycles_per_usec(void)
+static unsigned long get_cycles_per_msec(void)
 {
-	struct timeval s, e;
+	struct timespec s, e;
 	uint64_t c_s, c_e;
 	enum fio_cs old_cs = fio_clock_source;
 	uint64_t elapsed;
@@ -253,7 +252,7 @@ static unsigned long get_cycles_per_usec(void)
 	} while (1);
 
 	fio_clock_source = old_cs;
-	return (c_e - c_s) / elapsed;
+	return (c_e - c_s) * 1000 / elapsed;
 }
 
 #define NR_TIME_ITERS	50
@@ -262,12 +261,13 @@ static int calibrate_cpu_clock(void)
 {
 	double delta, mean, S;
 	uint64_t minc, maxc, avg, cycles[NR_TIME_ITERS];
-	int i, samples;
+	int i, samples, sft = 0;
+	unsigned long long tmp, max_ticks, max_mult;
 
-	cycles[0] = get_cycles_per_usec();
+	cycles[0] = get_cycles_per_msec();
 	S = delta = mean = 0.0;
 	for (i = 0; i < NR_TIME_ITERS; i++) {
-		cycles[i] = get_cycles_per_usec();
+		cycles[i] = get_cycles_per_msec();
 		delta = cycles[i] - mean;
 		if (delta) {
 			mean += delta / (i + 1.0);
@@ -304,19 +304,67 @@ static int calibrate_cpu_clock(void)
 		dprint(FD_TIME, "cycles[%d]=%llu\n", i, (unsigned long long) cycles[i]);
 
 	avg /= samples;
+	cycles_per_msec = avg;
 	dprint(FD_TIME, "avg: %llu\n", (unsigned long long) avg);
 	dprint(FD_TIME, "min=%llu, max=%llu, mean=%f, S=%f\n",
 			(unsigned long long) minc,
 			(unsigned long long) maxc, mean, S);
 
-	cycles_per_usec = avg;
-	inv_cycles_per_usec = 16777216UL / cycles_per_usec;
-	max_cycles_for_mult = ~0ULL / inv_cycles_per_usec;
-	dprint(FD_TIME, "inv_cycles_per_usec=%lu\n", inv_cycles_per_usec);
-#ifdef ARCH_CPU_CLOCK_WRAPS
+	max_ticks = MAX_CLOCK_SEC * cycles_per_msec * 1000ULL;
+	max_mult = ULLONG_MAX / max_ticks;
+	dprint(FD_TIME, "\n\nmax_ticks=%llu, __builtin_clzll=%d, "
+			"max_mult=%llu\n", max_ticks,
+			__builtin_clzll(max_ticks), max_mult);
+
+        /*
+         * Find the largest shift count that will produce
+         * a multiplier that does not exceed max_mult
+         */
+        tmp = max_mult * cycles_per_msec / 1000000;
+        while (tmp > 1) {
+                tmp >>= 1;
+                sft++;
+                dprint(FD_TIME, "tmp=%llu, sft=%u\n", tmp, sft);
+        }
+
+	clock_shift = sft;
+	clock_mult = (1ULL << sft) * 1000000 / cycles_per_msec;
+	dprint(FD_TIME, "clock_shift=%u, clock_mult=%llu\n", clock_shift,
+							clock_mult);
+
+	/*
+	 * Find the greatest power of 2 clock ticks that is less than the
+	 * ticks in MAX_CLOCK_SEC_2STAGE
+	 */
+	max_cycles_shift = max_cycles_mask = 0;
+	tmp = MAX_CLOCK_SEC * 1000ULL * cycles_per_msec;
+	dprint(FD_TIME, "tmp=%llu, max_cycles_shift=%u\n", tmp,
+							max_cycles_shift);
+	while (tmp > 1) {
+		tmp >>= 1;
+		max_cycles_shift++;
+		dprint(FD_TIME, "tmp=%llu, max_cycles_shift=%u\n", tmp, max_cycles_shift);
+	}
+	/*
+	 * if use use (1ULL << max_cycles_shift) * 1000 / cycles_per_msec
+	 * here we will have a discontinuity every
+	 * (1ULL << max_cycles_shift) cycles
+	 */
+	nsecs_for_max_cycles = ((1ULL << max_cycles_shift) * clock_mult)
+					>> clock_shift;
+
+	/* Use a bitmask to calculate ticks % (1ULL << max_cycles_shift) */
+	for (tmp = 0; tmp < max_cycles_shift; tmp++)
+		max_cycles_mask |= 1ULL << tmp;
+
+	dprint(FD_TIME, "max_cycles_shift=%u, 2^max_cycles_shift=%llu, "
+			"nsecs_for_max_cycles=%llu, "
+			"max_cycles_mask=%016llx\n",
+			max_cycles_shift, (1ULL << max_cycles_shift),
+			nsecs_for_max_cycles, max_cycles_mask);
+
 	cycles_start = get_cpu_clock();
 	dprint(FD_TIME, "cycles_start=%llu\n", cycles_start);
-#endif
 	return 0;
 }
 #else
@@ -365,7 +413,7 @@ void fio_clock_init(void)
 	fio_clock_source_inited = fio_clock_source;
 
 	if (calibrate_cpu_clock())
-		tsc_reliable = 0;
+		tsc_reliable = false;
 
 	/*
 	 * If the arch sets tsc_reliable != 0, then it must be good enough
@@ -379,12 +427,32 @@ void fio_clock_init(void)
 		log_info("fio: clocksource=cpu may not be reliable\n");
 }
 
-uint64_t utime_since(const struct timeval *s, const struct timeval *e)
+uint64_t ntime_since(const struct timespec *s, const struct timespec *e)
+{
+       int64_t sec, nsec;
+
+       sec = e->tv_sec - s->tv_sec;
+       nsec = e->tv_nsec - s->tv_nsec;
+       if (sec > 0 && nsec < 0) {
+	       sec--;
+	       nsec += 1000000000LL;
+       }
+
+       /*
+	* time warp bug on some kernels?
+	*/
+       if (sec < 0 || (sec == 0 && nsec < 0))
+	       return 0;
+
+       return nsec + (sec * 1000000000LL);
+}
+
+uint64_t utime_since(const struct timespec *s, const struct timespec *e)
 {
 	int64_t sec, usec;
 
 	sec = e->tv_sec - s->tv_sec;
-	usec = e->tv_usec - s->tv_usec;
+	usec = (e->tv_nsec - s->tv_nsec) / 1000;
 	if (sec > 0 && usec < 0) {
 		sec--;
 		usec += 1000000;
@@ -399,9 +467,9 @@ uint64_t utime_since(const struct timeval *s, const struct timeval *e)
 	return usec + (sec * 1000000);
 }
 
-uint64_t utime_since_now(const struct timeval *s)
+uint64_t utime_since_now(const struct timespec *s)
 {
-	struct timeval t;
+	struct timespec t;
 #ifdef FIO_DEBUG_TIME
 	void *p = __builtin_return_address(0);
 
@@ -413,12 +481,12 @@ uint64_t utime_since_now(const struct timeval *s)
 	return utime_since(s, &t);
 }
 
-uint64_t mtime_since(const struct timeval *s, const struct timeval *e)
+uint64_t mtime_since_tv(const struct timeval *s, const struct timeval *e)
 {
-	long sec, usec;
+	int64_t sec, usec;
 
 	sec = e->tv_sec - s->tv_sec;
-	usec = e->tv_usec - s->tv_usec;
+	usec = (e->tv_usec - s->tv_usec);
 	if (sec > 0 && usec < 0) {
 		sec--;
 		usec += 1000000;
@@ -432,9 +500,9 @@ uint64_t mtime_since(const struct timeval *s, const struct timeval *e)
 	return sec + usec;
 }
 
-uint64_t mtime_since_now(const struct timeval *s)
+uint64_t mtime_since_now(const struct timespec *s)
 {
-	struct timeval t;
+	struct timespec t;
 #ifdef FIO_DEBUG_TIME
 	void *p = __builtin_return_address(0);
 
@@ -446,7 +514,26 @@ uint64_t mtime_since_now(const struct timeval *s)
 	return mtime_since(s, &t);
 }
 
-uint64_t time_since_now(const struct timeval *s)
+uint64_t mtime_since(const struct timespec *s, const struct timespec *e)
+{
+	int64_t sec, usec;
+
+	sec = e->tv_sec - s->tv_sec;
+	usec = (e->tv_nsec - s->tv_nsec) / 1000;
+	if (sec > 0 && usec < 0) {
+		sec--;
+		usec += 1000000;
+	}
+
+	if (sec < 0 || (sec == 0 && usec < 0))
+		return 0;
+
+	sec *= 1000;
+	usec /= 1000;
+	return sec + usec;
+}
+
+uint64_t time_since_now(const struct timespec *s)
 {
 	return mtime_since_now(s) / 1000;
 }
diff --git a/gettime.h b/gettime.h
index 86d55bd..11e2a7b 100644
--- a/gettime.h
+++ b/gettime.h
@@ -13,27 +13,27 @@ enum fio_cs {
 	CS_INVAL,
 };
 
-extern void fio_gettime(struct timeval *, void *);
+extern void fio_gettime(struct timespec *, void *);
 extern void fio_gtod_init(void);
 extern void fio_clock_init(void);
 extern int fio_start_gtod_thread(void);
 extern int fio_monotonic_clocktest(int debug);
 extern void fio_local_clock_init(int);
 
-extern struct timeval *fio_tv;
+extern struct timespec *fio_ts;
 
-static inline int fio_gettime_offload(struct timeval *tv)
+static inline int fio_gettime_offload(struct timespec *ts)
 {
 	time_t last_sec;
 
-	if (!fio_tv)
+	if (!fio_ts)
 		return 0;
 
 	do {
 		read_barrier();
-		last_sec = tv->tv_sec = fio_tv->tv_sec;
-		tv->tv_usec = fio_tv->tv_usec;
-	} while (fio_tv->tv_sec != last_sec);
+		last_sec = ts->tv_sec = fio_ts->tv_sec;
+		ts->tv_nsec = fio_ts->tv_nsec;
+	} while (fio_ts->tv_sec != last_sec);
 
 	return 1;
 }
diff --git a/helper_thread.c b/helper_thread.c
index 47ec728..9c6e0a2 100644
--- a/helper_thread.c
+++ b/helper_thread.c
@@ -71,45 +71,45 @@ static void *helper_thread_main(void *data)
 {
 	struct helper_data *hd = data;
 	unsigned int msec_to_next_event, next_log, next_ss = STEADYSTATE_MSEC;
-	struct timeval tv, last_du, last_ss;
+	struct timeval tv;
+	struct timespec ts, last_du, last_ss;
 	int ret = 0;
 
 	sk_out_assign(hd->sk_out);
 
 	gettimeofday(&tv, NULL);
-	memcpy(&last_du, &tv, sizeof(tv));
-	memcpy(&last_ss, &tv, sizeof(tv));
+	ts.tv_sec = tv.tv_sec;
+	ts.tv_nsec = tv.tv_usec * 1000;
+	memcpy(&last_du, &ts, sizeof(ts));
+	memcpy(&last_ss, &ts, sizeof(ts));
 
 	fio_mutex_up(hd->startup_mutex);
 
 	msec_to_next_event = DISK_UTIL_MSEC;
 	while (!ret && !hd->exit) {
-		struct timespec ts;
-		struct timeval now;
 		uint64_t since_du, since_ss = 0;
 
-		timeval_add_msec(&tv, msec_to_next_event);
-		ts.tv_sec = tv.tv_sec;
-		ts.tv_nsec = tv.tv_usec * 1000;
+		timespec_add_msec(&ts, msec_to_next_event);
 
 		pthread_mutex_lock(&hd->lock);
 		pthread_cond_timedwait(&hd->cond, &hd->lock, &ts);
 
-		gettimeofday(&now, NULL);
+		gettimeofday(&tv, NULL);
+		ts.tv_sec = tv.tv_sec;
+		ts.tv_nsec = tv.tv_usec * 1000;
 
 		if (hd->reset) {
-			memcpy(&tv, &now, sizeof(tv));
-			memcpy(&last_du, &now, sizeof(last_du));
-			memcpy(&last_ss, &now, sizeof(last_ss));
+			memcpy(&last_du, &ts, sizeof(ts));
+			memcpy(&last_ss, &ts, sizeof(ts));
 			hd->reset = 0;
 		}
 
 		pthread_mutex_unlock(&hd->lock);
 
-		since_du = mtime_since(&last_du, &now);
+		since_du = mtime_since(&last_du, &ts);
 		if (since_du >= DISK_UTIL_MSEC || DISK_UTIL_MSEC - since_du < 10) {
 			ret = update_io_ticks();
-			timeval_add_msec(&last_du, DISK_UTIL_MSEC);
+			timespec_add_msec(&last_du, DISK_UTIL_MSEC);
 			msec_to_next_event = DISK_UTIL_MSEC;
 			if (since_du >= DISK_UTIL_MSEC)
 				msec_to_next_event -= (since_du - DISK_UTIL_MSEC);
@@ -126,10 +126,10 @@ static void *helper_thread_main(void *data)
 			next_log = DISK_UTIL_MSEC;
 
 		if (steadystate_enabled) {
-			since_ss = mtime_since(&last_ss, &now);
+			since_ss = mtime_since(&last_ss, &ts);
 			if (since_ss >= STEADYSTATE_MSEC || STEADYSTATE_MSEC - since_ss < 10) {
 				steadystate_check();
-				timeval_add_msec(&last_ss, since_ss);
+				timespec_add_msec(&last_ss, since_ss);
 				if (since_ss > STEADYSTATE_MSEC)
 					next_ss = STEADYSTATE_MSEC - (since_ss - STEADYSTATE_MSEC);
 				else
diff --git a/idletime.c b/idletime.c
index 4c00d80..90bc1d9 100644
--- a/idletime.c
+++ b/idletime.c
@@ -11,7 +11,7 @@ static volatile struct idle_prof_common ipc;
 static double calibrate_unit(unsigned char *data)
 {
 	unsigned long t, i, j, k;
-	struct timeval tps;
+	struct timespec tps;
 	double tunit = 0.0;
 
 	for (i = 0; i < CALIBRATE_RUNS; i++) {
@@ -183,7 +183,6 @@ static void calibration_stats(void)
 void fio_idle_prof_init(void)
 {
 	int i, ret;
-	struct timeval tp;
 	struct timespec ts;
 	pthread_attr_t tattr;
 	struct idle_prof_thread *ipt;
@@ -282,9 +281,8 @@ void fio_idle_prof_init(void)
 		pthread_mutex_lock(&ipt->init_lock);
 		while ((ipt->state != TD_EXITED) &&
 		       (ipt->state!=TD_INITIALIZED)) {
-			fio_gettime(&tp, NULL);
-			ts.tv_sec = tp.tv_sec + 1;
-			ts.tv_nsec = tp.tv_usec * 1000;
+			fio_gettime(&ts, NULL);
+			ts.tv_sec += 1;
 			pthread_cond_timedwait(&ipt->cond, &ipt->init_lock, &ts);
 		}
 		pthread_mutex_unlock(&ipt->init_lock);
@@ -325,7 +323,6 @@ void fio_idle_prof_stop(void)
 {
 	int i;
 	uint64_t runt;
-	struct timeval tp;
 	struct timespec ts;
 	struct idle_prof_thread *ipt;
 
@@ -343,9 +340,8 @@ void fio_idle_prof_stop(void)
 		pthread_mutex_lock(&ipt->start_lock);
 		while ((ipt->state != TD_EXITED) &&
 		       (ipt->state!=TD_NOT_CREATED)) {
-			fio_gettime(&tp, NULL);
-			ts.tv_sec = tp.tv_sec + 1;
-			ts.tv_nsec = tp.tv_usec * 1000;
+			fio_gettime(&ts, NULL);
+			ts.tv_sec += 1;
 			/* timed wait in case a signal is not received */
 			pthread_cond_timedwait(&ipt->cond, &ipt->start_lock, &ts);
 		}
diff --git a/idletime.h b/idletime.h
index 84c1fbb..b8376c2 100644
--- a/idletime.h
+++ b/idletime.h
@@ -26,8 +26,8 @@ struct idle_prof_thread {
 	pthread_t thread;
 	int cpu;
 	int state;
-	struct timeval tps;
-	struct timeval tpe;
+	struct timespec tps;
+	struct timespec tpe;
 	double cali_time; /* microseconds to finish a unit work */
 	double loops;
 	double idleness;
diff --git a/io_u.c b/io_u.c
index fd63119..375413f 100644
--- a/io_u.c
+++ b/io_u.c
@@ -20,7 +20,7 @@ struct io_completion_data {
 
 	int error;			/* output */
 	uint64_t bytes_done[DDIR_RWDIR_CNT];	/* output */
-	struct timeval time;		/* output */
+	struct timespec time;		/* output */
 };
 
 /*
@@ -989,11 +989,52 @@ void io_u_mark_depth(struct thread_data *td, unsigned int nr)
 	td->ts.io_u_map[idx] += nr;
 }
 
-static void io_u_mark_lat_usec(struct thread_data *td, unsigned long usec)
+static void io_u_mark_lat_nsec(struct thread_data *td, unsigned long long nsec)
 {
 	int idx = 0;
 
-	assert(usec < 1000);
+	assert(nsec < 1000);
+
+	switch (nsec) {
+	case 750 ... 999:
+		idx = 9;
+		break;
+	case 500 ... 749:
+		idx = 8;
+		break;
+	case 250 ... 499:
+		idx = 7;
+		break;
+	case 100 ... 249:
+		idx = 6;
+		break;
+	case 50 ... 99:
+		idx = 5;
+		break;
+	case 20 ... 49:
+		idx = 4;
+		break;
+	case 10 ... 19:
+		idx = 3;
+		break;
+	case 4 ... 9:
+		idx = 2;
+		break;
+	case 2 ... 3:
+		idx = 1;
+	case 0 ... 1:
+		break;
+	}
+
+	assert(idx < FIO_IO_U_LAT_N_NR);
+	td->ts.io_u_lat_n[idx]++;
+}
+
+static void io_u_mark_lat_usec(struct thread_data *td, unsigned long long usec)
+{
+	int idx = 0;
+
+	assert(usec < 1000 && usec >= 1);
 
 	switch (usec) {
 	case 750 ... 999:
@@ -1030,10 +1071,12 @@ static void io_u_mark_lat_usec(struct thread_data *td, unsigned long usec)
 	td->ts.io_u_lat_u[idx]++;
 }
 
-static void io_u_mark_lat_msec(struct thread_data *td, unsigned long msec)
+static void io_u_mark_lat_msec(struct thread_data *td, unsigned long long msec)
 {
 	int idx = 0;
 
+	assert(msec >= 1);
+
 	switch (msec) {
 	default:
 		idx = 11;
@@ -1075,12 +1118,14 @@ static void io_u_mark_lat_msec(struct thread_data *td, unsigned long msec)
 	td->ts.io_u_lat_m[idx]++;
 }
 
-static void io_u_mark_latency(struct thread_data *td, unsigned long usec)
+static void io_u_mark_latency(struct thread_data *td, unsigned long long nsec)
 {
-	if (usec < 1000)
-		io_u_mark_lat_usec(td, usec);
+	if (nsec < 1000)
+		io_u_mark_lat_nsec(td, nsec);
+	else if (nsec < 1000000)
+		io_u_mark_lat_usec(td, nsec / 1000);
 	else
-		io_u_mark_lat_msec(td, usec / 1000);
+		io_u_mark_lat_msec(td, nsec / 1000000);
 }
 
 static unsigned int __get_next_fileno_rand(struct thread_data *td)
@@ -1572,7 +1617,7 @@ static void small_content_scramble(struct io_u *io_u)
 		 * the buffer, given by the product of the usec time
 		 * and the actual offset.
 		 */
-		offset = (io_u->start_time.tv_usec ^ boffset) & 511;
+		offset = ((io_u->start_time.tv_nsec/1000) ^ boffset) & 511;
 		offset &= ~(sizeof(uint64_t) - 1);
 		if (offset >= 512 - sizeof(uint64_t))
 			offset -= sizeof(uint64_t);
@@ -1729,7 +1774,7 @@ static void account_io_completion(struct thread_data *td, struct io_u *io_u,
 				  const enum fio_ddir idx, unsigned int bytes)
 {
 	const int no_reduce = !gtod_reduce(td);
-	unsigned long lusec = 0;
+	unsigned long long llnsec = 0;
 
 	if (td->parent)
 		td = td->parent;
@@ -1738,37 +1783,37 @@ static void account_io_completion(struct thread_data *td, struct io_u *io_u,
 		return;
 
 	if (no_reduce)
-		lusec = utime_since(&io_u->issue_time, &icd->time);
+		llnsec = ntime_since(&io_u->issue_time, &icd->time);
 
 	if (!td->o.disable_lat) {
-		unsigned long tusec;
+		unsigned long long tnsec;
 
-		tusec = utime_since(&io_u->start_time, &icd->time);
-		add_lat_sample(td, idx, tusec, bytes, io_u->offset);
+		tnsec = ntime_since(&io_u->start_time, &icd->time);
+		add_lat_sample(td, idx, tnsec, bytes, io_u->offset);
 
 		if (td->flags & TD_F_PROFILE_OPS) {
 			struct prof_io_ops *ops = &td->prof_io_ops;
 
 			if (ops->io_u_lat)
-				icd->error = ops->io_u_lat(td, tusec);
+				icd->error = ops->io_u_lat(td, tnsec/1000);
 		}
 
-		if (td->o.max_latency && tusec > td->o.max_latency)
-			lat_fatal(td, icd, tusec, td->o.max_latency);
-		if (td->o.latency_target && tusec > td->o.latency_target) {
+		if (td->o.max_latency && tnsec/1000 > td->o.max_latency)
+			lat_fatal(td, icd, tnsec/1000, td->o.max_latency);
+		if (td->o.latency_target && tnsec/1000 > td->o.latency_target) {
 			if (lat_target_failed(td))
-				lat_fatal(td, icd, tusec, td->o.latency_target);
+				lat_fatal(td, icd, tnsec/1000, td->o.latency_target);
 		}
 	}
 
 	if (ddir_rw(idx)) {
 		if (!td->o.disable_clat) {
-			add_clat_sample(td, idx, lusec, bytes, io_u->offset);
-			io_u_mark_latency(td, lusec);
+			add_clat_sample(td, idx, llnsec, bytes, io_u->offset);
+			io_u_mark_latency(td, llnsec);
 		}
 
 		if (!td->o.disable_bw && per_unit_log(td->bw_log))
-			add_bw_sample(td, io_u, bytes, lusec);
+			add_bw_sample(td, io_u, bytes, llnsec);
 
 		if (no_reduce && per_unit_log(td->iops_log))
 			add_iops_sample(td, io_u, bytes);
@@ -2000,7 +2045,7 @@ void io_u_queued(struct thread_data *td, struct io_u *io_u)
 	if (!td->o.disable_slat && ramp_time_over(td) && td->o.stats) {
 		unsigned long slat_time;
 
-		slat_time = utime_since(&io_u->start_time, &io_u->issue_time);
+		slat_time = ntime_since(&io_u->start_time, &io_u->issue_time);
 
 		if (td->parent)
 			td = td->parent;
diff --git a/io_u.h b/io_u.h
index 155344d..b228e2e 100644
--- a/io_u.h
+++ b/io_u.h
@@ -31,8 +31,8 @@ enum {
  * The io unit
  */
 struct io_u {
-	struct timeval start_time;
-	struct timeval issue_time;
+	struct timespec start_time;
+	struct timespec issue_time;
 
 	struct fio_file *file;
 	unsigned int flags;
diff --git a/ioengines.c b/ioengines.c
index 2d55065..abbaa9a 100644
--- a/ioengines.c
+++ b/ioengines.c
@@ -281,7 +281,7 @@ int td_io_queue(struct thread_data *td, struct io_u *io_u)
 		 */
 		if (td->o.read_iolog_file)
 			memcpy(&td->last_issue, &io_u->issue_time,
-					sizeof(struct timeval));
+					sizeof(io_u->issue_time));
 	}
 
 	if (ddir_rw(ddir)) {
@@ -356,7 +356,7 @@ int td_io_queue(struct thread_data *td, struct io_u *io_u)
 		 */
 		if (td->o.read_iolog_file)
 			memcpy(&td->last_issue, &io_u->issue_time,
-					sizeof(struct timeval));
+					sizeof(io_u->issue_time));
 	}
 
 	return ret;
diff --git a/iolog.c b/iolog.c
index 01b82e8..27c14eb 100644
--- a/iolog.c
+++ b/iolog.c
@@ -65,7 +65,7 @@ static void iolog_delay(struct thread_data *td, unsigned long delay)
 {
 	uint64_t usec = utime_since_now(&td->last_issue);
 	uint64_t this_delay;
-	struct timeval tv;
+	struct timespec ts;
 
 	if (delay < td->time_offset) {
 		td->time_offset = 0;
@@ -78,7 +78,7 @@ static void iolog_delay(struct thread_data *td, unsigned long delay)
 
 	delay -= usec;
 
-	fio_gettime(&tv, NULL);
+	fio_gettime(&ts, NULL);
 	while (delay && !td->terminate) {
 		this_delay = delay;
 		if (this_delay > 500000)
@@ -88,7 +88,7 @@ static void iolog_delay(struct thread_data *td, unsigned long delay)
 		delay -= this_delay;
 	}
 
-	usec = utime_since_now(&tv);
+	usec = utime_since_now(&ts);
 	if (usec > delay)
 		td->time_offset = usec - delay;
 	else
@@ -643,6 +643,7 @@ void setup_log(struct io_log **log, struct log_params *p,
 		l->log_gz = 0;
 	else if (l->log_gz || l->log_gz_store) {
 		mutex_init_pshared(&l->chunk_lock);
+		mutex_init_pshared(&l->deferred_free_lock);
 		p->td->flags |= TD_F_COMPRESS_LOG;
 	}
 
@@ -1144,6 +1145,42 @@ size_t log_chunk_sizes(struct io_log *log)
 
 #ifdef CONFIG_ZLIB
 
+static bool warned_on_drop;
+
+static void iolog_put_deferred(struct io_log *log, void *ptr)
+{
+	if (!ptr)
+		return;
+
+	pthread_mutex_lock(&log->deferred_free_lock);
+	if (log->deferred < IOLOG_MAX_DEFER) {
+		log->deferred_items[log->deferred] = ptr;
+		log->deferred++;
+	} else if (!warned_on_drop) {
+		log_err("fio: had to drop log entry free\n");
+		warned_on_drop = true;
+	}
+	pthread_mutex_unlock(&log->deferred_free_lock);
+}
+
+static void iolog_free_deferred(struct io_log *log)
+{
+	int i;
+
+	if (!log->deferred)
+		return;
+
+	pthread_mutex_lock(&log->deferred_free_lock);
+
+	for (i = 0; i < log->deferred; i++) {
+		free(log->deferred_items[i]);
+		log->deferred_items[i] = NULL;
+	}
+
+	log->deferred = 0;
+	pthread_mutex_unlock(&log->deferred_free_lock);
+}
+
 static int gz_work(struct iolog_flush_data *data)
 {
 	struct iolog_compress *c = NULL;
@@ -1236,7 +1273,7 @@ static int gz_work(struct iolog_flush_data *data)
 	if (ret != Z_OK)
 		log_err("fio: deflateEnd %d\n", ret);
 
-	free(data->samples);
+	iolog_put_deferred(data->log, data->samples);
 
 	if (!flist_empty(&list)) {
 		pthread_mutex_lock(&data->log->chunk_lock);
@@ -1247,7 +1284,7 @@ static int gz_work(struct iolog_flush_data *data)
 	ret = 0;
 done:
 	if (data->free)
-		free(data);
+		sfree(data);
 	return ret;
 err:
 	while (!flist_empty(&list)) {
@@ -1348,7 +1385,7 @@ int iolog_cur_flush(struct io_log *log, struct io_logs *cur_log)
 {
 	struct iolog_flush_data *data;
 
-	data = malloc(sizeof(*data));
+	data = smalloc(sizeof(*data));
 	if (!data)
 		return 1;
 
@@ -1362,6 +1399,9 @@ int iolog_cur_flush(struct io_log *log, struct io_logs *cur_log)
 	cur_log->log = NULL;
 
 	workqueue_enqueue(&log->td->log_compress_wq, &data->work);
+
+	iolog_free_deferred(log);
+
 	return 0;
 }
 #else
diff --git a/iolog.h b/iolog.h
index 0733ad3..d157fa2 100644
--- a/iolog.h
+++ b/iolog.h
@@ -131,6 +131,11 @@ struct io_log {
 	pthread_mutex_t chunk_lock;
 	unsigned int chunk_seq;
 	struct flist_head chunk_list;
+
+	pthread_mutex_t deferred_free_lock;
+#define IOLOG_MAX_DEFER	8
+	void *deferred_items[IOLOG_MAX_DEFER];
+	unsigned int deferred;
 };
 
 /*
@@ -259,7 +264,7 @@ struct log_params {
 
 static inline bool per_unit_log(struct io_log *log)
 {
-	return log && !log->avg_msec;
+	return log && (!log->avg_msec || log->log_gz || log->log_gz_store);
 }
 
 static inline bool inline_log(struct io_log *log)
diff --git a/lib/seqlock.h b/lib/seqlock.h
index 1ac1eb6..762b6ec 100644
--- a/lib/seqlock.h
+++ b/lib/seqlock.h
@@ -1,6 +1,7 @@
 #ifndef FIO_SEQLOCK_H
 #define FIO_SEQLOCK_H
 
+#include "types.h"
 #include "../arch/arch.h"
 
 struct seqlock {
diff --git a/libfio.c b/libfio.c
index da22456..14ddc4d 100644
--- a/libfio.c
+++ b/libfio.c
@@ -144,10 +144,10 @@ void reset_all_stats(struct thread_data *td)
 	}
 
 	set_epoch_time(td, td->o.log_unix_epoch);
-	memcpy(&td->start, &td->epoch, sizeof(struct timeval));
-	memcpy(&td->iops_sample_time, &td->epoch, sizeof(struct timeval));
-	memcpy(&td->bw_sample_time, &td->epoch, sizeof(struct timeval));
-	memcpy(&td->ss.prev_time, &td->epoch, sizeof(struct timeval));
+	memcpy(&td->start, &td->epoch, sizeof(td->epoch));
+	memcpy(&td->iops_sample_time, &td->epoch, sizeof(td->epoch));
+	memcpy(&td->bw_sample_time, &td->epoch, sizeof(td->epoch));
+	memcpy(&td->ss.prev_time, &td->epoch, sizeof(td->epoch));
 
 	lat_target_reset(td);
 	clear_rusage_stat(td);
diff --git a/mutex.c b/mutex.c
index d8c4825..9fab715 100644
--- a/mutex.c
+++ b/mutex.c
@@ -141,11 +141,15 @@ struct fio_mutex *fio_mutex_init(int value)
 	return NULL;
 }
 
-static bool mutex_timed_out(struct timeval *t, unsigned int msecs)
+static bool mutex_timed_out(struct timespec *t, unsigned int msecs)
 {
-	struct timeval now;
+	struct timeval tv;
+	struct timespec now;
+
+	gettimeofday(&tv, NULL);
+	now.tv_sec = tv.tv_sec;
+	now.tv_nsec = tv.tv_usec * 1000;
 
-	gettimeofday(&now, NULL);
 	return mtime_since(t, &now) >= msecs;
 }
 
@@ -177,7 +181,7 @@ int fio_mutex_down_timeout(struct fio_mutex *mutex, unsigned int msecs)
 		 * way too early, double check.
 		 */
 		ret = pthread_cond_timedwait(&mutex->cond, &mutex->lock, &t);
-		if (ret == ETIMEDOUT && !mutex_timed_out(&tv_s, msecs))
+		if (ret == ETIMEDOUT && !mutex_timed_out(&t, msecs))
 			ret = 0;
 	}
 	mutex->waiters--;
diff --git a/options.c b/options.c
index a8fdde4..7431ed8 100644
--- a/options.c
+++ b/options.c
@@ -1381,7 +1381,7 @@ static int str_gtod_reduce_cb(void *data, int *il)
 	td->o.disable_bw = !!val;
 	td->o.clat_percentiles = !val;
 	if (val)
-		td->tv_cache_mask = 63;
+		td->ts_cache_mask = 63;
 
 	return 0;
 }
diff --git a/os/windows/posix.c b/os/windows/posix.c
index eae8c86..488d0ed 100755
--- a/os/windows/posix.c
+++ b/os/windows/posix.c
@@ -25,8 +25,8 @@
 #include "../os-windows.h"
 #include "../../lib/hweight.h"
 
-extern unsigned long mtime_since_now(struct timeval *);
-extern void fio_gettime(struct timeval *, void *);
+extern unsigned long mtime_since_now(struct timespec *);
+extern void fio_gettime(struct timespec *, void *);
 
 /* These aren't defined in the MinGW headers */
 HRESULT WINAPI StringCchCopyA(
@@ -852,7 +852,7 @@ int poll(struct pollfd fds[], nfds_t nfds, int timeout)
 
 int nanosleep(const struct timespec *rqtp, struct timespec *rmtp)
 {
-	struct timeval tv;
+	struct timespec tv;
 	DWORD ms_remaining;
 	DWORD ms_total = (rqtp->tv_sec * 1000) + (rqtp->tv_nsec / 1000000.0);
 
diff --git a/profiles/act.c b/profiles/act.c
index 643f8a8..59e5005 100644
--- a/profiles/act.c
+++ b/profiles/act.c
@@ -47,7 +47,7 @@ struct act_run_data {
 static struct act_run_data *act_run_data;
 
 struct act_prof_data {
-	struct timeval sample_tv;
+	struct timespec sample_tv;
 	struct act_slice *slices;
 	unsigned int cur_slice;
 	unsigned int nr_slices;
diff --git a/server.c b/server.c
index 8a5e75d..8b36e38 100644
--- a/server.c
+++ b/server.c
@@ -438,7 +438,7 @@ static uint64_t alloc_reply(uint64_t tag, uint16_t opcode)
 
 	reply = calloc(1, sizeof(*reply));
 	INIT_FLIST_HEAD(&reply->list);
-	fio_gettime(&reply->tv, NULL);
+	fio_gettime(&reply->ts, NULL);
 	reply->saved_tag = tag;
 	reply->opcode = opcode;
 
@@ -1497,6 +1497,8 @@ void fio_server_send_ts(struct thread_stat *ts, struct group_run_stats *rs)
 		p.ts.io_u_complete[i]	= cpu_to_le32(ts->io_u_complete[i]);
 	}
 
+	for (i = 0; i < FIO_IO_U_LAT_N_NR; i++)
+		p.ts.io_u_lat_n[i]	= cpu_to_le32(ts->io_u_lat_n[i]);
 	for (i = 0; i < FIO_IO_U_LAT_U_NR; i++)
 		p.ts.io_u_lat_u[i]	= cpu_to_le32(ts->io_u_lat_u[i]);
 	for (i = 0; i < FIO_IO_U_LAT_M_NR; i++)
@@ -2268,7 +2270,7 @@ int fio_server_parse_host(const char *host, int ipv6, struct in_addr *inp,
  * For local domain sockets:
  *	*ptr is the filename, *is_sock is 1.
  */
-int fio_server_parse_string(const char *str, char **ptr, int *is_sock,
+int fio_server_parse_string(const char *str, char **ptr, bool *is_sock,
 			    int *port, struct in_addr *inp,
 			    struct in6_addr *inp6, int *ipv6)
 {
@@ -2277,13 +2279,13 @@ int fio_server_parse_string(const char *str, char **ptr, int *is_sock,
 	int lport = 0;
 
 	*ptr = NULL;
-	*is_sock = 0;
+	*is_sock = false;
 	*port = fio_net_port;
 	*ipv6 = 0;
 
 	if (!strncmp(str, "sock:", 5)) {
 		*ptr = strdup(str + 5);
-		*is_sock = 1;
+		*is_sock = true;
 
 		return 0;
 	}
@@ -2362,7 +2364,8 @@ int fio_server_parse_string(const char *str, char **ptr, int *is_sock,
 static int fio_handle_server_arg(void)
 {
 	int port = fio_net_port;
-	int is_sock, ret = 0;
+	bool is_sock;
+	int ret = 0;
 
 	saddr_in.sin_addr.s_addr = htonl(INADDR_ANY);
 
diff --git a/server.h b/server.h
index f002f3b..7f235f3 100644
--- a/server.h
+++ b/server.h
@@ -43,13 +43,13 @@ struct fio_net_cmd {
 
 struct fio_net_cmd_reply {
 	struct flist_head list;
-	struct timeval tv;
+	struct timespec ts;
 	uint64_t saved_tag;
 	uint16_t opcode;
 };
 
 enum {
-	FIO_SERVER_VER			= 63,
+	FIO_SERVER_VER			= 64,
 
 	FIO_SERVER_MAX_FRAGMENT_PDU	= 1024,
 	FIO_SERVER_MAX_CMD_MB		= 2048,
@@ -212,7 +212,7 @@ extern int fio_server_text_output(int, const char *, size_t);
 extern int fio_net_send_cmd(int, uint16_t, const void *, off_t, uint64_t *, struct flist_head *);
 extern int fio_net_send_simple_cmd(int, uint16_t, uint64_t, struct flist_head *);
 extern void fio_server_set_arg(const char *);
-extern int fio_server_parse_string(const char *, char **, int *, int *, struct in_addr *, struct in6_addr *, int *);
+extern int fio_server_parse_string(const char *, char **, bool *, int *, struct in_addr *, struct in6_addr *, int *);
 extern int fio_server_parse_host(const char *, int, struct in_addr *, struct in6_addr *);
 extern const char *fio_server_op(unsigned int);
 extern void fio_server_got_signal(int);
diff --git a/stat.c b/stat.c
index fd3ad5a..5042650 100644
--- a/stat.c
+++ b/stat.c
@@ -37,9 +37,9 @@ void update_rusage_stat(struct thread_data *td)
 	struct thread_stat *ts = &td->ts;
 
 	fio_getrusage(&td->ru_end);
-	ts->usr_time += mtime_since(&td->ru_start.ru_utime,
+	ts->usr_time += mtime_since_tv(&td->ru_start.ru_utime,
 					&td->ru_end.ru_utime);
-	ts->sys_time += mtime_since(&td->ru_start.ru_stime,
+	ts->sys_time += mtime_since_tv(&td->ru_start.ru_stime,
 					&td->ru_end.ru_stime);
 	ts->ctx += td->ru_end.ru_nvcsw + td->ru_end.ru_nivcsw
 			- (td->ru_start.ru_nvcsw + td->ru_start.ru_nivcsw);
@@ -58,7 +58,7 @@ void update_rusage_stat(struct thread_data *td)
  * group by looking at the index bits.
  *
  */
-static unsigned int plat_val_to_idx(unsigned int val)
+static unsigned int plat_val_to_idx(unsigned long long val)
 {
 	unsigned int msb, error_bits, base, offset, idx;
 
@@ -66,7 +66,7 @@ static unsigned int plat_val_to_idx(unsigned int val)
 	if (val == 0)
 		msb = 0;
 	else
-		msb = (sizeof(val)*8) - __builtin_clz(val) - 1;
+		msb = (sizeof(val)*8) - __builtin_clzll(val) - 1;
 
 	/*
 	 * MSB <= (FIO_IO_U_PLAT_BITS-1), cannot be rounded off. Use
@@ -135,16 +135,16 @@ static int double_cmp(const void *a, const void *b)
 }
 
 unsigned int calc_clat_percentiles(unsigned int *io_u_plat, unsigned long nr,
-				   fio_fp64_t *plist, unsigned int **output,
-				   unsigned int *maxv, unsigned int *minv)
+				   fio_fp64_t *plist, unsigned long long **output,
+				   unsigned long long *maxv, unsigned long long *minv)
 {
 	unsigned long sum = 0;
 	unsigned int len, i, j = 0;
 	unsigned int oval_len = 0;
-	unsigned int *ovals = NULL;
+	unsigned long long *ovals = NULL;
 	int is_last;
 
-	*minv = -1U;
+	*minv = -1ULL;
 	*maxv = 0;
 
 	len = 0;
@@ -173,7 +173,7 @@ unsigned int calc_clat_percentiles(unsigned int *io_u_plat, unsigned long nr,
 
 			if (j == oval_len) {
 				oval_len += 100;
-				ovals = realloc(ovals, oval_len * sizeof(unsigned int));
+				ovals = realloc(ovals, oval_len * sizeof(*ovals));
 			}
 
 			ovals[j] = plat_idx_to_val(i);
@@ -201,9 +201,10 @@ static void show_clat_percentiles(unsigned int *io_u_plat, unsigned long nr,
 				  fio_fp64_t *plist, unsigned int precision,
 				  struct buf_output *out)
 {
-	unsigned int len, j = 0, minv, maxv;
-	unsigned int *ovals;
-	int is_last, per_line, scale_down;
+	unsigned int divisor, len, i, j = 0;
+	unsigned long long minv, maxv;
+	unsigned long long *ovals;
+	int is_last, per_line, scale_down, time_width;
 	char fmt[32];
 
 	len = calc_clat_percentiles(io_u_plat, nr, plist, &ovals, &maxv, &minv);
@@ -211,23 +212,31 @@ static void show_clat_percentiles(unsigned int *io_u_plat, unsigned long nr,
 		goto out;
 
 	/*
-	 * We default to usecs, but if the value range is such that we
-	 * should scale down to msecs, do that.
+	 * We default to nsecs, but if the value range is such that we
+	 * should scale down to usecs or msecs, do that.
 	 */
-	if (minv > 2000 && maxv > 99999) {
-		scale_down = 1;
+	if (minv > 2000000 && maxv > 99999999ULL) {
+		scale_down = 2;
+		divisor = 1000000;
 		log_buf(out, "    clat percentiles (msec):\n     |");
+	} else if (minv > 2000 && maxv > 99999) {
+		scale_down = 1;
+		divisor = 1000;
+		log_buf(out, "    clat percentiles (usec):\n     |");
 	} else {
 		scale_down = 0;
-		log_buf(out, "    clat percentiles (usec):\n     |");
+		divisor = 1;
+		log_buf(out, "    clat percentiles (nsec):\n     |");
 	}
 
-	snprintf(fmt, sizeof(fmt), "%%1.%uf", precision);
-	per_line = (80 - 7) / (precision + 14);
 
-	for (j = 0; j < len; j++) {
-		char fbuf[16], *ptr = fbuf;
+	time_width = max(5, (int) (log10(maxv / divisor) + 1));
+	snprintf(fmt, sizeof(fmt), " %%%u.%ufth=[%%%dllu]%%c", precision + 3,
+			precision, time_width);
+	/* fmt will be something like " %5.2fth=[%4llu]%c" */
+	per_line = (80 - 7) / (precision + 10 + time_width);
 
+	for (j = 0; j < len; j++) {
 		/* for formatting */
 		if (j != 0 && (j % per_line) == 0)
 			log_buf(out, "     |");
@@ -235,15 +244,10 @@ static void show_clat_percentiles(unsigned int *io_u_plat, unsigned long nr,
 		/* end of the list */
 		is_last = (j == len - 1);
 
-		if (plist[j].u.f < 10.0)
-			ptr += sprintf(fbuf, " ");
-
-		snprintf(ptr, sizeof(fbuf), fmt, plist[j].u.f);
-
-		if (scale_down)
+		for (i = 0; i < scale_down; i++)
 			ovals[j] = (ovals[j] + 999) / 1000;
 
-		log_buf(out, " %sth=[%5u]%c", fbuf, ovals[j], is_last ? '\n' : ',');
+		log_buf(out, fmt, plist[j].u.f, ovals[j], is_last ? '\n' : ',');
 
 		if (is_last)
 			break;
@@ -257,8 +261,8 @@ out:
 		free(ovals);
 }
 
-bool calc_lat(struct io_stat *is, unsigned long *min, unsigned long *max,
-	      double *mean, double *dev)
+bool calc_lat(struct io_stat *is, unsigned long long *min,
+	      unsigned long long *max, double *mean, double *dev)
 {
 	double n = (double) is->samples;
 
@@ -355,6 +359,28 @@ static void stat_calc_lat(struct thread_stat *ts, double *dst,
 	}
 }
 
+/*
+ * To keep the terse format unaltered, add all of the ns latency
+ * buckets to the first us latency bucket
+ */
+void stat_calc_lat_nu(struct thread_stat *ts, double *io_u_lat_u)
+{
+	unsigned long ntotal = 0, total = ddir_rw_sum(ts->total_io_u);
+	int i;
+
+	stat_calc_lat(ts, io_u_lat_u, ts->io_u_lat_u, FIO_IO_U_LAT_U_NR);
+
+	for (i = 0; i < FIO_IO_U_LAT_N_NR; i++)
+		ntotal += ts->io_u_lat_n[i];
+
+	io_u_lat_u[0] += 100.0 * (double) ntotal / (double) total;
+}
+
+void stat_calc_lat_n(struct thread_stat *ts, double *io_u_lat)
+{
+	stat_calc_lat(ts, io_u_lat, ts->io_u_lat_n, FIO_IO_U_LAT_N_NR);
+}
+
 void stat_calc_lat_u(struct thread_stat *ts, double *io_u_lat)
 {
 	stat_calc_lat(ts, io_u_lat, ts->io_u_lat_u, FIO_IO_U_LAT_U_NR);
@@ -365,14 +391,17 @@ void stat_calc_lat_m(struct thread_stat *ts, double *io_u_lat)
 	stat_calc_lat(ts, io_u_lat, ts->io_u_lat_m, FIO_IO_U_LAT_M_NR);
 }
 
-static void display_lat(const char *name, unsigned long min, unsigned long max,
-			double mean, double dev, struct buf_output *out)
+static void display_lat(const char *name, unsigned long long min,
+			unsigned long long max, double mean, double dev,
+			struct buf_output *out)
 {
-	const char *base = "(usec)";
+	const char *base = "(nsec)";
 	char *minp, *maxp;
 
-	if (usec_to_msec(&min, &max, &mean, &dev))
+	if (nsec_to_msec(&min, &max, &mean, &dev))
 		base = "(msec)";
+	else if (nsec_to_usec(&min, &max, &mean, &dev))
+		base = "(usec)";
 
 	minp = num2str(min, 6, 1, 0, N2S_NONE);
 	maxp = num2str(max, 6, 1, 0, N2S_NONE);
@@ -388,8 +417,8 @@ static void show_ddir_status(struct group_run_stats *rs, struct thread_stat *ts,
 			     int ddir, struct buf_output *out)
 {
 	const char *str[] = { " read", "write", " trim" };
-	unsigned long min, max, runt;
-	unsigned long long bw, iops;
+	unsigned long runt;
+	unsigned long long min, max, bw, iops;
 	double mean, dev;
 	char *io_p, *bw_p, *bw_p_alt, *iops_p;
 	int i2p;
@@ -467,7 +496,7 @@ static void show_ddir_status(struct group_run_stats *rs, struct thread_stat *ts,
 			bw_str = (rs->unit_base == 1 ? "Mibit" : "MiB");
 		}
 
-		log_buf(out, "   bw (%5s/s): min=%5lu, max=%5lu, per=%3.2f%%, avg=%5.02f, stdev=%5.02f\n",
+		log_buf(out, "   bw (%5s/s): min=%5llu, max=%5llu, per=%3.2f%%, avg=%5.02f, stdev=%5.02f\n",
 			bw_str, min, max, p_of_agg, mean, dev);
 	}
 }
@@ -502,6 +531,14 @@ static int show_lat(double *io_u_lat, int nr, const char **ranges,
 	return shown;
 }
 
+static void show_lat_n(double *io_u_lat_n, struct buf_output *out)
+{
+	const char *ranges[] = { "2=", "4=", "10=", "20=", "50=", "100=",
+				 "250=", "500=", "750=", "1000=", };
+
+	show_lat(io_u_lat_n, FIO_IO_U_LAT_N_NR, ranges, "nsec", out);
+}
+
 static void show_lat_u(double *io_u_lat_u, struct buf_output *out)
 {
 	const char *ranges[] = { "2=", "4=", "10=", "20=", "50=", "100=",
@@ -521,12 +558,15 @@ static void show_lat_m(double *io_u_lat_m, struct buf_output *out)
 
 static void show_latencies(struct thread_stat *ts, struct buf_output *out)
 {
+	double io_u_lat_n[FIO_IO_U_LAT_N_NR];
 	double io_u_lat_u[FIO_IO_U_LAT_U_NR];
 	double io_u_lat_m[FIO_IO_U_LAT_M_NR];
 
+	stat_calc_lat_n(ts, io_u_lat_n);
 	stat_calc_lat_u(ts, io_u_lat_u);
 	stat_calc_lat_m(ts, io_u_lat_m);
 
+	show_lat_n(io_u_lat_n, out);
 	show_lat_u(io_u_lat_u, out);
 	show_lat_m(io_u_lat_m, out);
 }
@@ -818,11 +858,10 @@ static void show_ddir_status_terse(struct thread_stat *ts,
 				   struct group_run_stats *rs, int ddir,
 				   struct buf_output *out)
 {
-	unsigned long min, max;
-	unsigned long long bw, iops;
-	unsigned int *ovals = NULL;
+	unsigned long long min, max, minv, maxv, bw, iops;
+	unsigned long long *ovals = NULL;
 	double mean, dev;
-	unsigned int len, minv, maxv;
+	unsigned int len;
 	int i;
 
 	assert(ddir_rw(ddir));
@@ -840,14 +879,14 @@ static void show_ddir_status_terse(struct thread_stat *ts,
 					(unsigned long long) ts->runtime[ddir]);
 
 	if (calc_lat(&ts->slat_stat[ddir], &min, &max, &mean, &dev))
-		log_buf(out, ";%lu;%lu;%f;%f", min, max, mean, dev);
+		log_buf(out, ";%llu;%llu;%f;%f", min/1000, max/1000, mean/1000, dev/1000);
 	else
-		log_buf(out, ";%lu;%lu;%f;%f", 0UL, 0UL, 0.0, 0.0);
+		log_buf(out, ";%llu;%llu;%f;%f", 0ULL, 0ULL, 0.0, 0.0);
 
 	if (calc_lat(&ts->clat_stat[ddir], &min, &max, &mean, &dev))
-		log_buf(out, ";%lu;%lu;%f;%f", min, max, mean, dev);
+		log_buf(out, ";%llu;%llu;%f;%f", min/1000, max/1000, mean/1000, dev/1000);
 	else
-		log_buf(out, ";%lu;%lu;%f;%f", 0UL, 0UL, 0.0, 0.0);
+		log_buf(out, ";%llu;%llu;%f;%f", 0ULL, 0ULL, 0.0, 0.0);
 
 	if (ts->clat_percentiles) {
 		len = calc_clat_percentiles(ts->io_u_plat[ddir],
@@ -862,13 +901,13 @@ static void show_ddir_status_terse(struct thread_stat *ts,
 			log_buf(out, ";0%%=0");
 			continue;
 		}
-		log_buf(out, ";%f%%=%u", ts->percentile_list[i].u.f, ovals[i]);
+		log_buf(out, ";%f%%=%llu", ts->percentile_list[i].u.f, ovals[i]/1000);
 	}
 
 	if (calc_lat(&ts->lat_stat[ddir], &min, &max, &mean, &dev))
-		log_buf(out, ";%lu;%lu;%f;%f", min, max, mean, dev);
+		log_buf(out, ";%llu;%llu;%f;%f", min/1000, max/1000, mean/1000, dev/1000);
 	else
-		log_buf(out, ";%lu;%lu;%f;%f", 0UL, 0UL, 0.0, 0.0);
+		log_buf(out, ";%llu;%llu;%f;%f", 0ULL, 0ULL, 0.0, 0.0);
 
 	if (ovals)
 		free(ovals);
@@ -882,19 +921,19 @@ static void show_ddir_status_terse(struct thread_stat *ts,
 				p_of_agg = 100.0;
 		}
 
-		log_buf(out, ";%lu;%lu;%f%%;%f;%f", min, max, p_of_agg, mean, dev);
+		log_buf(out, ";%llu;%llu;%f%%;%f;%f", min, max, p_of_agg, mean, dev);
 	} else
-		log_buf(out, ";%lu;%lu;%f%%;%f;%f", 0UL, 0UL, 0.0, 0.0, 0.0);
+		log_buf(out, ";%llu;%llu;%f%%;%f;%f", 0ULL, 0ULL, 0.0, 0.0, 0.0);
 }
 
 static void add_ddir_status_json(struct thread_stat *ts,
 		struct group_run_stats *rs, int ddir, struct json_object *parent)
 {
-	unsigned long min, max;
+	unsigned long long min, max, minv, maxv;
 	unsigned long long bw;
-	unsigned int *ovals = NULL;
+	unsigned long long *ovals = NULL;
 	double mean, dev, iops;
-	unsigned int len, minv, maxv;
+	unsigned int len;
 	int i;
 	const char *ddirname[] = {"read", "write", "trim"};
 	struct json_object *dir_object, *tmp_object, *percentile_object, *clat_bins_object;
@@ -933,7 +972,7 @@ static void add_ddir_status_json(struct thread_stat *ts,
 		mean = dev = 0.0;
 	}
 	tmp_object = json_create_object();
-	json_object_add_value_object(dir_object, "slat", tmp_object);
+	json_object_add_value_object(dir_object, "slat_ns", tmp_object);
 	json_object_add_value_int(tmp_object, "min", min);
 	json_object_add_value_int(tmp_object, "max", max);
 	json_object_add_value_float(tmp_object, "mean", mean);
@@ -944,7 +983,7 @@ static void add_ddir_status_json(struct thread_stat *ts,
 		mean = dev = 0.0;
 	}
 	tmp_object = json_create_object();
-	json_object_add_value_object(dir_object, "clat", tmp_object);
+	json_object_add_value_object(dir_object, "clat_ns", tmp_object);
 	json_object_add_value_int(tmp_object, "min", min);
 	json_object_add_value_int(tmp_object, "max", max);
 	json_object_add_value_float(tmp_object, "mean", mean);
@@ -985,7 +1024,7 @@ static void add_ddir_status_json(struct thread_stat *ts,
 		mean = dev = 0.0;
 	}
 	tmp_object = json_create_object();
-	json_object_add_value_object(dir_object, "lat", tmp_object);
+	json_object_add_value_object(dir_object, "lat_ns", tmp_object);
 	json_object_add_value_int(tmp_object, "min", min);
 	json_object_add_value_int(tmp_object, "max", max);
 	json_object_add_value_float(tmp_object, "mean", mean);
@@ -1047,7 +1086,7 @@ static void show_thread_status_terse_v2(struct thread_stat *ts,
 
 	/* Calc % distribution of IO depths, usecond, msecond latency */
 	stat_calc_dist(ts->io_u_map, ddir_rw_sum(ts->total_io_u), io_u_dist);
-	stat_calc_lat_u(ts, io_u_lat_u);
+	stat_calc_lat_nu(ts, io_u_lat_u);
 	stat_calc_lat_m(ts, io_u_lat_m);
 
 	/* Only show fixed 7 I/O depth levels*/
@@ -1112,7 +1151,7 @@ static void show_thread_status_terse_v3_v4(struct thread_stat *ts,
 
 	/* Calc % distribution of IO depths, usecond, msecond latency */
 	stat_calc_dist(ts->io_u_map, ddir_rw_sum(ts->total_io_u), io_u_dist);
-	stat_calc_lat_u(ts, io_u_lat_u);
+	stat_calc_lat_nu(ts, io_u_lat_u);
 	stat_calc_lat_m(ts, io_u_lat_m);
 
 	/* Only show fixed 7 I/O depth levels*/
@@ -1173,6 +1212,7 @@ static struct json_object *show_thread_status_json(struct thread_stat *ts,
 	struct json_object *root, *tmp;
 	struct jobs_eta *je;
 	double io_u_dist[FIO_IO_U_MAP_NR];
+	double io_u_lat_n[FIO_IO_U_LAT_N_NR];
 	double io_u_lat_u[FIO_IO_U_LAT_U_NR];
 	double io_u_lat_m[FIO_IO_U_LAT_M_NR];
 	double usr_cpu, sys_cpu;
@@ -1217,6 +1257,7 @@ static struct json_object *show_thread_status_json(struct thread_stat *ts,
 
 	/* Calc % distribution of IO depths, usecond, msecond latency */
 	stat_calc_dist(ts->io_u_map, ddir_rw_sum(ts->total_io_u), io_u_dist);
+	stat_calc_lat_n(ts, io_u_lat_n);
 	stat_calc_lat_u(ts, io_u_lat_u);
 	stat_calc_lat_m(ts, io_u_lat_m);
 
@@ -1232,9 +1273,17 @@ static struct json_object *show_thread_status_json(struct thread_stat *ts,
 		json_object_add_value_float(tmp, (const char *)name, io_u_dist[i]);
 	}
 
+	/* Nanosecond latency */
 	tmp = json_create_object();
-	json_object_add_value_object(root, "latency_us", tmp);
+	json_object_add_value_object(root, "latency_ns", tmp);
+	for (i = 0; i < FIO_IO_U_LAT_N_NR; i++) {
+		const char *ranges[] = { "2", "4", "10", "20", "50", "100",
+				 "250", "500", "750", "1000", };
+		json_object_add_value_float(tmp, ranges[i], io_u_lat_n[i]);
+	}
 	/* Microsecond latency */
+	tmp = json_create_object();
+	json_object_add_value_object(root, "latency_us", tmp);
 	for (i = 0; i < FIO_IO_U_LAT_U_NR; i++) {
 		const char *ranges[] = { "2", "4", "10", "20", "50", "100",
 				 "250", "500", "750", "1000", };
@@ -1494,6 +1543,8 @@ void sum_thread_stats(struct thread_stat *dst, struct thread_stat *src,
 		dst->io_u_submit[k] += src->io_u_submit[k];
 	for (k = 0; k < FIO_IO_U_MAP_NR; k++)
 		dst->io_u_complete[k] += src->io_u_complete[k];
+	for (k = 0; k < FIO_IO_U_LAT_N_NR; k++)
+		dst->io_u_lat_n[k] += src->io_u_lat_n[k];
 	for (k = 0; k < FIO_IO_U_LAT_U_NR; k++)
 		dst->io_u_lat_u[k] += src->io_u_lat_u[k];
 	for (k = 0; k < FIO_IO_U_LAT_M_NR; k++)
@@ -1849,22 +1900,22 @@ void __show_running_run_stats(void)
 {
 	struct thread_data *td;
 	unsigned long long *rt;
-	struct timeval tv;
+	struct timespec ts;
 	int i;
 
 	fio_mutex_down(stat_mutex);
 
 	rt = malloc(thread_number * sizeof(unsigned long long));
-	fio_gettime(&tv, NULL);
+	fio_gettime(&ts, NULL);
 
 	for_each_td(td, i) {
 		td->update_rusage = 1;
 		td->ts.io_bytes[DDIR_READ] = td->io_bytes[DDIR_READ];
 		td->ts.io_bytes[DDIR_WRITE] = td->io_bytes[DDIR_WRITE];
 		td->ts.io_bytes[DDIR_TRIM] = td->io_bytes[DDIR_TRIM];
-		td->ts.total_run_time = mtime_since(&td->epoch, &tv);
+		td->ts.total_run_time = mtime_since(&td->epoch, &ts);
 
-		rt[i] = mtime_since(&td->start, &tv);
+		rt[i] = mtime_since(&td->start, &ts);
 		if (td_read(td) && td->ts.io_bytes[DDIR_READ])
 			td->ts.runtime[DDIR_READ] += rt[i];
 		if (td_write(td) && td->ts.io_bytes[DDIR_WRITE])
@@ -1899,7 +1950,7 @@ void __show_running_run_stats(void)
 }
 
 static int status_interval_init;
-static struct timeval status_time;
+static struct timespec status_time;
 static int status_file_disabled;
 
 #define FIO_STATUS_FILE		"fio-dump-status"
@@ -1955,7 +2006,7 @@ void check_for_running_stats(void)
 	}
 }
 
-static inline void add_stat_sample(struct io_stat *is, unsigned long data)
+static inline void add_stat_sample(struct io_stat *is, unsigned long long data)
 {
 	double val = data;
 	double delta;
@@ -2188,6 +2239,8 @@ void reset_io_stats(struct thread_data *td)
 		ts->io_u_complete[i] = 0;
 	}
 
+	for (i = 0; i < FIO_IO_U_LAT_N_NR; i++)
+		ts->io_u_lat_n[i] = 0;
 	for (i = 0; i < FIO_IO_U_LAT_U_NR; i++)
 		ts->io_u_lat_u[i] = 0;
 	for (i = 0; i < FIO_IO_U_LAT_M_NR; i++)
@@ -2303,16 +2356,16 @@ void add_agg_sample(union io_sample_data data, enum fio_ddir ddir, unsigned int
 }
 
 static void add_clat_percentile_sample(struct thread_stat *ts,
-				unsigned long usec, enum fio_ddir ddir)
+				unsigned long long nsec, enum fio_ddir ddir)
 {
-	unsigned int idx = plat_val_to_idx(usec);
+	unsigned int idx = plat_val_to_idx(nsec);
 	assert(idx < FIO_IO_U_PLAT_NR);
 
 	ts->io_u_plat[ddir][idx]++;
 }
 
 void add_clat_sample(struct thread_data *td, enum fio_ddir ddir,
-		     unsigned long usec, unsigned int bs, uint64_t offset)
+		     unsigned long long nsec, unsigned int bs, uint64_t offset)
 {
 	unsigned long elapsed, this_window;
 	struct thread_stat *ts = &td->ts;
@@ -2320,14 +2373,14 @@ void add_clat_sample(struct thread_data *td, enum fio_ddir ddir,
 
 	td_io_u_lock(td);
 
-	add_stat_sample(&ts->clat_stat[ddir], usec);
+	add_stat_sample(&ts->clat_stat[ddir], nsec);
 
 	if (td->clat_log)
-		add_log_sample(td, td->clat_log, sample_val(usec), ddir, bs,
+		add_log_sample(td, td->clat_log, sample_val(nsec), ddir, bs,
 			       offset);
 
 	if (ts->clat_percentiles)
-		add_clat_percentile_sample(ts, usec, ddir);
+		add_clat_percentile_sample(ts, nsec, ddir);
 
 	if (iolog && iolog->hist_msec) {
 		struct io_hist *hw = &iolog->hist_window[ddir];
@@ -2389,7 +2442,7 @@ void add_slat_sample(struct thread_data *td, enum fio_ddir ddir,
 }
 
 void add_lat_sample(struct thread_data *td, enum fio_ddir ddir,
-		    unsigned long usec, unsigned int bs, uint64_t offset)
+		    unsigned long long nsec, unsigned int bs, uint64_t offset)
 {
 	struct thread_stat *ts = &td->ts;
 
@@ -2398,23 +2451,23 @@ void add_lat_sample(struct thread_data *td, enum fio_ddir ddir,
 
 	td_io_u_lock(td);
 
-	add_stat_sample(&ts->lat_stat[ddir], usec);
+	add_stat_sample(&ts->lat_stat[ddir], nsec);
 
 	if (td->lat_log)
-		add_log_sample(td, td->lat_log, sample_val(usec), ddir, bs,
+		add_log_sample(td, td->lat_log, sample_val(nsec), ddir, bs,
 			       offset);
 
 	td_io_u_unlock(td);
 }
 
 void add_bw_sample(struct thread_data *td, struct io_u *io_u,
-		   unsigned int bytes, unsigned long spent)
+		   unsigned int bytes, unsigned long long spent)
 {
 	struct thread_stat *ts = &td->ts;
 	unsigned long rate;
 
 	if (spent)
-		rate = bytes * 1000 / spent;
+		rate = (unsigned long) (bytes * 1000000ULL / spent);
 	else
 		rate = 0;
 
@@ -2430,8 +2483,8 @@ void add_bw_sample(struct thread_data *td, struct io_u *io_u,
 	td_io_u_unlock(td);
 }
 
-static int __add_samples(struct thread_data *td, struct timeval *parent_tv,
-			 struct timeval *t, unsigned int avg_time,
+static int __add_samples(struct thread_data *td, struct timespec *parent_tv,
+			 struct timespec *t, unsigned int avg_time,
 			 uint64_t *this_io_bytes, uint64_t *stat_io_bytes,
 			 struct io_stat *stat, struct io_log *log,
 			 bool is_kb)
@@ -2481,7 +2534,7 @@ static int __add_samples(struct thread_data *td, struct timeval *parent_tv,
 		stat_io_bytes[ddir] = this_io_bytes[ddir];
 	}
 
-	timeval_add_msec(parent_tv, avg_time);
+	timespec_add_msec(parent_tv, avg_time);
 
 	td_io_u_unlock(td);
 
@@ -2493,7 +2546,7 @@ static int __add_samples(struct thread_data *td, struct timeval *parent_tv,
 	return min(next, next_log);
 }
 
-static int add_bw_samples(struct thread_data *td, struct timeval *t)
+static int add_bw_samples(struct thread_data *td, struct timespec *t)
 {
 	return __add_samples(td, &td->bw_sample_time, t, td->o.bw_avg_time,
 				td->this_io_bytes, td->stat_io_bytes,
@@ -2517,7 +2570,7 @@ void add_iops_sample(struct thread_data *td, struct io_u *io_u,
 	td_io_u_unlock(td);
 }
 
-static int add_iops_samples(struct thread_data *td, struct timeval *t)
+static int add_iops_samples(struct thread_data *td, struct timespec *t)
 {
 	return __add_samples(td, &td->iops_sample_time, t, td->o.iops_avg_time,
 				td->this_io_blocks, td->stat_io_blocks,
@@ -2531,7 +2584,7 @@ int calc_log_samples(void)
 {
 	struct thread_data *td;
 	unsigned int next = ~0U, tmp;
-	struct timeval now;
+	struct timespec now;
 	int i;
 
 	fio_gettime(&now, NULL);
diff --git a/stat.h b/stat.h
index d8a0803..132dee3 100644
--- a/stat.h
+++ b/stat.h
@@ -19,6 +19,7 @@ struct group_run_stats {
  * How many depth levels to log
  */
 #define FIO_IO_U_MAP_NR	7
+#define FIO_IO_U_LAT_N_NR 10
 #define FIO_IO_U_LAT_U_NR 10
 #define FIO_IO_U_LAT_M_NR 12
 
@@ -108,7 +109,7 @@ struct group_run_stats {
 
 #define FIO_IO_U_PLAT_BITS 6
 #define FIO_IO_U_PLAT_VAL (1 << FIO_IO_U_PLAT_BITS)
-#define FIO_IO_U_PLAT_GROUP_NR 19
+#define FIO_IO_U_PLAT_GROUP_NR 29
 #define FIO_IO_U_PLAT_NR (FIO_IO_U_PLAT_GROUP_NR * FIO_IO_U_PLAT_VAL)
 #define FIO_IO_U_LIST_MAX_LEN 20 /* The size of the default and user-specified
 					list of percentiles */
@@ -178,6 +179,7 @@ struct thread_stat {
 	uint32_t io_u_map[FIO_IO_U_MAP_NR];
 	uint32_t io_u_submit[FIO_IO_U_MAP_NR];
 	uint32_t io_u_complete[FIO_IO_U_MAP_NR];
+	uint32_t io_u_lat_n[FIO_IO_U_LAT_N_NR];
 	uint32_t io_u_lat_u[FIO_IO_U_LAT_U_NR];
 	uint32_t io_u_lat_m[FIO_IO_U_LAT_M_NR];
 	uint32_t io_u_plat[DDIR_RWDIR_CNT][FIO_IO_U_PLAT_NR];
@@ -286,8 +288,9 @@ extern void sum_group_stats(struct group_run_stats *dst, struct group_run_stats
 extern void init_thread_stat(struct thread_stat *ts);
 extern void init_group_run_stat(struct group_run_stats *gs);
 extern void eta_to_str(char *str, unsigned long eta_sec);
-extern bool calc_lat(struct io_stat *is, unsigned long *min, unsigned long *max, double *mean, double *dev);
-extern unsigned int calc_clat_percentiles(unsigned int *io_u_plat, unsigned long nr, fio_fp64_t *plist, unsigned int **output, unsigned int *maxv, unsigned int *minv);
+extern bool calc_lat(struct io_stat *is, unsigned long long *min, unsigned long long *max, double *mean, double *dev);
+extern unsigned int calc_clat_percentiles(unsigned int *io_u_plat, unsigned long nr, fio_fp64_t *plist, unsigned long long **output, unsigned long long *maxv, unsigned long long *minv);
+extern void stat_calc_lat_n(struct thread_stat *ts, double *io_u_lat);
 extern void stat_calc_lat_m(struct thread_stat *ts, double *io_u_lat);
 extern void stat_calc_lat_u(struct thread_stat *ts, double *io_u_lat);
 extern void stat_calc_dist(unsigned int *map, unsigned long total, double *io_u_dist);
@@ -295,9 +298,9 @@ extern void reset_io_stats(struct thread_data *);
 extern void update_rusage_stat(struct thread_data *);
 extern void clear_rusage_stat(struct thread_data *);
 
-extern void add_lat_sample(struct thread_data *, enum fio_ddir, unsigned long,
+extern void add_lat_sample(struct thread_data *, enum fio_ddir, unsigned long long,
 				unsigned int, uint64_t);
-extern void add_clat_sample(struct thread_data *, enum fio_ddir, unsigned long,
+extern void add_clat_sample(struct thread_data *, enum fio_ddir, unsigned long long,
 				unsigned int, uint64_t);
 extern void add_slat_sample(struct thread_data *, enum fio_ddir, unsigned long,
 				unsigned int, uint64_t);
@@ -305,16 +308,17 @@ extern void add_agg_sample(union io_sample_data, enum fio_ddir, unsigned int);
 extern void add_iops_sample(struct thread_data *, struct io_u *,
 				unsigned int);
 extern void add_bw_sample(struct thread_data *, struct io_u *,
-				unsigned int, unsigned long);
+				unsigned int, unsigned long long);
 extern int calc_log_samples(void);
 
 extern struct io_log *agg_io_log[DDIR_RWDIR_CNT];
 extern int write_bw_log;
 
-static inline bool usec_to_msec(unsigned long *min, unsigned long *max,
-				double *mean, double *dev)
+static inline bool nsec_to_usec(unsigned long long *min,
+				unsigned long long *max, double *mean,
+				double *dev)
 {
-	if (*min > 1000 && *max > 1000 && *mean > 1000.0 && *dev > 1000.0) {
+	if (*min > 2000 && *max > 99999 && *dev > 1000.0) {
 		*min /= 1000;
 		*max /= 1000;
 		*mean /= 1000.0;
@@ -324,6 +328,22 @@ static inline bool usec_to_msec(unsigned long *min, unsigned long *max,
 
 	return false;
 }
+
+static inline bool nsec_to_msec(unsigned long long *min,
+				unsigned long long *max, double *mean,
+				double *dev)
+{
+	if (*min > 2000000 && *max > 99999999ULL && *dev > 1000000.0) {
+		*min /= 1000000;
+		*max /= 1000000;
+		*mean /= 1000000.0;
+		*dev /= 1000000.0;
+		return true;
+	}
+
+	return false;
+}
+
 /*
  * Worst level condensing would be 1:5, so allow enough room for that
  */
diff --git a/steadystate.c b/steadystate.c
index 98f027c..45d4f5d 100644
--- a/steadystate.c
+++ b/steadystate.c
@@ -196,7 +196,7 @@ void steadystate_check(void)
 	int i, j, ddir, prev_groupid, group_ramp_time_over = 0;
 	unsigned long rate_time;
 	struct thread_data *td, *td2;
-	struct timeval now;
+	struct timespec now;
 	uint64_t group_bw = 0, group_iops = 0;
 	uint64_t td_iops, td_bytes;
 	bool ret;
diff --git a/steadystate.h b/steadystate.h
index 20ccd30..bbc3945 100644
--- a/steadystate.h
+++ b/steadystate.h
@@ -35,7 +35,7 @@ struct steadystate_data {
 	uint64_t sum_xy;
 	uint64_t oldest_y;
 
-	struct timeval prev_time;
+	struct timespec prev_time;
 	uint64_t prev_iops;
 	uint64_t prev_bytes;
 };
diff --git a/t/arch.c b/t/arch.c
index befb7c7..bd28a84 100644
--- a/t/arch.c
+++ b/t/arch.c
@@ -1,5 +1,5 @@
 #include "../arch/arch.h"
 
 unsigned long arch_flags = 0;
-int tsc_reliable;
+bool tsc_reliable;
 int arch_random;
diff --git a/t/debug.c b/t/debug.c
index bf6f460..8965cfb 100644
--- a/t/debug.c
+++ b/t/debug.c
@@ -1,7 +1,7 @@
 #include <stdio.h>
 
 FILE *f_err;
-struct timeval *fio_tv = NULL;
+struct timespec *fio_ts = NULL;
 unsigned long fio_debug = 0;
 
 void __dprint(int type, const char *str, ...)
diff --git a/t/dedupe.c b/t/dedupe.c
index 1f172a2..c3b837f 100644
--- a/t/dedupe.c
+++ b/t/dedupe.c
@@ -334,7 +334,7 @@ static void *thread_fn(void *data)
 static void show_progress(struct worker_thread *threads, unsigned long total)
 {
 	unsigned long last_nitems = 0;
-	struct timeval last_tv;
+	struct timespec last_tv;
 
 	fio_gettime(&last_tv, NULL);
 
diff --git a/t/lfsr-test.c b/t/lfsr-test.c
index 7016f26..4009b62 100644
--- a/t/lfsr-test.c
+++ b/t/lfsr-test.c
@@ -27,7 +27,7 @@ void usage()
 int main(int argc, char *argv[])
 {
 	int r;
-	struct timeval start, end;
+	struct timespec start, end;
 	struct fio_lfsr *fl;
 	int verify = 0;
 	unsigned int spin = 0;
diff --git a/t/time-test.c b/t/time-test.c
new file mode 100644
index 0000000..a74d920
--- /dev/null
+++ b/t/time-test.c
@@ -0,0 +1,544 @@
+/*
+ * Carry out arithmetic to explore conversion of CPU clock ticks to nsec
+ *
+ * When we use the CPU clock for timing, we do the following:
+ *
+ * 1) Calibrate the CPU clock to relate the frequency of CPU clock ticks
+ *    to actual time.
+ *
+ *    Using gettimeofday() or clock_gettime(), count how many CPU clock
+ *    ticks occur per usec
+ *
+ * 2) Calculate conversion factors so that we can ultimately convert
+ *    from clocks ticks to nsec with
+ *      nsec = (ticks * clock_mult) >> clock_shift
+ *
+ *    This is equivalent to
+ *	nsec = ticks * (MULTIPLIER / cycles_per_nsec) / MULTIPLIER
+ *    where
+ *	clock_mult = MULTIPLIER / cycles_per_nsec
+ *      MULTIPLIER = 2^clock_shift
+ *
+ *    It would be simpler to just calculate nsec = ticks / cycles_per_nsec,
+ *    but all of this is necessary because of rounding when calculating
+ *    cycles_per_nsec. With a 3.0GHz CPU, cycles_per_nsec would simply
+ *    be 3. But with a 3.33GHz CPU or a 4.5GHz CPU, the fractional
+ *    portion is lost with integer arithmetic.
+ *
+ *    This multiply and shift calculation also has a performance benefit
+ *    as multiplication and bit shift operations are faster than integer
+ *    division.
+ *
+ * 3) Dynamically determine clock_shift and clock_mult at run time based
+ *    on MAX_CLOCK_SEC and cycles_per_usec. MAX_CLOCK_SEC is the maximum
+ *    duration for which the conversion will be valid.
+ *
+ *    The primary constraint is that (ticks * clock_mult) must not overflow
+ *    when ticks is at its maximum value.
+ *
+ *    So we have
+ *	max_ticks = MAX_CLOCK_SEC * 1000000000 * cycles_per_nsec
+ *	max_ticks * clock_mult <= ULLONG_MAX
+ *	max_ticks * MULTIPLIER / cycles_per_nsec <= ULLONG_MAX
+ *      MULTIPLIER <= ULLONG_MAX * cycles_per_nsec / max_ticks
+ *
+ *    Then choose the largest clock_shift that satisfies
+ *	2^clock_shift <= ULLONG_MAX * cycles_per_nsec / max_ticks
+ *
+ *    Finally calculate the appropriate clock_mult associated with clock_shift
+ *	clock_mult = 2^clock_shift / cycles_per_nsec
+ *
+ * 4) In the code below we have cycles_per_usec and use
+ *	cycles_per_nsec = cycles_per_usec / 1000
+ *
+ *
+ * The code below implements 4 clock tick to nsec conversion strategies
+ *
+ *   i) 64-bit arithmetic for the (ticks * clock_mult) product with the
+ *	conversion valid for at most MAX_CLOCK_SEC
+ *
+ *  ii) NOT IMPLEMENTED Use 64-bit integers to emulate 128-bit multiplication
+ *	for the (ticks * clock_mult) product
+ *
+ * iii) 64-bit arithmetic with clock ticks to nsec conversion occurring in
+ *	two stages. The first stage counts the number of discrete, large chunks
+ *	of time that have elapsed. To this is added the time represented by
+ *	the remaining clock ticks. The advantage of this strategy is better
+ *	accuracy because the (ticks * clock_mult) product used for final
+ *	fractional chunk
+ *
+ *  iv) 64-bit arithmetic with the clock ticks to nsec conversion occuring in
+ *	two stages. This is carried out using locks to update the number of
+ *	large time chunks (MAX_CLOCK_SEC_2STAGE) that have elapsed.
+ *
+ *   v) 128-bit arithmetic used for the clock ticks to nsec conversion.
+ *
+ */
+
+#include <stdio.h>
+#include <stdlib.h>
+#include <limits.h>
+#include <assert.h>
+#include <stdlib.h>
+#include "lib/seqlock.h"
+
+#define DEBUG 0
+#define MAX_CLOCK_SEC 365*24*60*60ULL
+#define MAX_CLOCK_SEC_2STAGE 60*60ULL
+#define dprintf(...) if (DEBUG) { printf(__VA_ARGS__); }
+
+enum {
+	__CLOCK64_BIT		= 1 << 0,
+	__CLOCK128_BIT		= 1 << 1,
+	__CLOCK_MULT_SHIFT	= 1 << 2,
+	__CLOCK_EMULATE_128	= 1 << 3,
+	__CLOCK_2STAGE		= 1 << 4,
+	__CLOCK_LOCK		= 1 << 5,
+
+	CLOCK64_MULT_SHIFT	= __CLOCK64_BIT | __CLOCK_MULT_SHIFT,
+	CLOCK64_EMULATE_128	= __CLOCK64_BIT | __CLOCK_EMULATE_128,
+	CLOCK64_2STAGE		= __CLOCK64_BIT | __CLOCK_2STAGE,
+	CLOCK64_LOCK		= __CLOCK64_BIT | __CLOCK_LOCK,
+	CLOCK128_MULT_SHIFT	= __CLOCK128_BIT | __CLOCK_MULT_SHIFT,
+};
+
+static struct seqlock clock_seqlock;
+static unsigned long long cycles_start;
+static unsigned long long elapsed_nsec;
+
+static unsigned int max_cycles_shift;
+static unsigned long long max_cycles_mask;
+static unsigned long long nsecs_for_max_cycles;
+
+static unsigned int clock_shift;
+static unsigned long long clock_mult;
+
+static unsigned long long *nsecs;
+static unsigned long long clock_mult64_128[2];
+static __uint128_t clock_mult128;
+
+/*
+ * Functions for carrying out 128-bit
+ * arithmetic using 64-bit integers
+ *
+ * 128-bit integers are stored as
+ * arrays of two 64-bit integers
+ *
+ * Ordering is little endian
+ *
+ * a[0] has the less significant bits
+ * a[1] has the more significant bits
+ *
+ * NOT FULLY IMPLEMENTED
+ */
+static void do_mult(unsigned long long a[2], unsigned long long b,
+		    unsigned long long product[2])
+{
+	product[0] = product[1] = 0;
+	return;
+}
+
+static void do_div(unsigned long long a[2], unsigned long long b,
+		   unsigned long long c[2])
+{
+	return;
+}
+
+static void do_shift64(unsigned long long a[2], unsigned int count)
+{
+	a[0] = a[1] >> (count-64);
+	a[1] = 0;
+}
+
+static void do_shift(unsigned long long a[2], unsigned int count)
+{
+	if (count > 64)
+		do_shift64(a, count);
+	else {
+		while (count--) {
+			a[0] >>= 1;
+			a[0] |= a[1] << 63;
+			a[1] >>= 1;
+		}
+	}
+}
+
+static void update_clock(unsigned long long t)
+{
+	write_seqlock_begin(&clock_seqlock);
+	elapsed_nsec = (t >> max_cycles_shift) * nsecs_for_max_cycles;
+	cycles_start = t & ~max_cycles_mask;
+	write_seqlock_end(&clock_seqlock);
+}
+
+static unsigned long long _get_nsec(int mode, unsigned long long t)
+{
+	switch(mode) {
+	case CLOCK64_MULT_SHIFT:
+		return (t * clock_mult) >> clock_shift;
+	case CLOCK64_EMULATE_128: {
+		unsigned long long product[2] =  { };
+
+		do_mult(clock_mult64_128, t, product);
+		do_shift(product, clock_shift);
+		return product[0];
+		}
+	case CLOCK64_2STAGE: {
+		unsigned long long multiples, nsec;
+
+		multiples = t >> max_cycles_shift;
+		dprintf("multiples=%llu\n", multiples);
+		nsec = multiples * nsecs_for_max_cycles;
+		nsec += ((t & max_cycles_mask) * clock_mult) >> clock_shift;
+		return nsec;
+		}
+	case CLOCK64_LOCK: {
+		unsigned int seq;
+		unsigned long long nsec;
+
+		do {
+			seq = read_seqlock_begin(&clock_seqlock);
+			nsec = elapsed_nsec;
+			nsec += ((t - cycles_start) * clock_mult) >> clock_shift;
+		} while (read_seqlock_retry(&clock_seqlock, seq));
+		return nsec;
+		}
+	case CLOCK128_MULT_SHIFT:
+		return (unsigned long long)((t * clock_mult128) >> clock_shift);
+		default:
+			assert(0);
+	}
+}
+
+static unsigned long long get_nsec(int mode, unsigned long long t)
+{
+	if (mode == CLOCK64_LOCK) {
+		update_clock(t);
+	}
+
+	return _get_nsec(mode, t);
+}
+
+static void calc_mult_shift(int mode, void *mult, unsigned int *shift,
+			    unsigned long long max_sec,
+			    unsigned long long cycles_per_usec)
+{
+	unsigned long long max_ticks;
+	max_ticks = max_sec * cycles_per_usec * 1000000ULL;
+
+	switch (mode) {
+	case CLOCK64_MULT_SHIFT: {
+		unsigned long long max_mult, tmp;
+		unsigned int sft = 0;
+
+		/*
+		 * Calculate the largest multiplier that will not
+		 * produce a 64-bit overflow in the multiplication
+		 * step of the clock ticks to nsec conversion
+		 */
+		max_mult = ULLONG_MAX / max_ticks;
+		dprintf("max_ticks=%llu, __builtin_clzll=%d, max_mult=%llu\n", max_ticks, __builtin_clzll(max_ticks), max_mult);
+
+		/*
+		 * Find the largest shift count that will produce
+		 * a multiplier less than max_mult
+		 */
+		tmp = max_mult * cycles_per_usec / 1000;
+		while (tmp > 1) {
+			tmp >>= 1;
+			sft++;
+			dprintf("tmp=%llu, sft=%u\n", tmp, sft);
+		}
+
+		*shift = sft;
+		*((unsigned long long *)mult) = (unsigned long long) ((1ULL << sft) * 1000 / cycles_per_usec);
+		break;
+		}
+	case CLOCK64_EMULATE_128: {
+		unsigned long long max_mult[2], tmp[2] = { };
+		unsigned int sft = 0;
+
+		/*
+		 * Calculate the largest multiplier that will not
+		 * produce a 128-bit overflow in the multiplication
+		 * step of the clock ticks to nsec conversion,
+		 * but use only 64-bit integers in the process
+		 */
+		max_mult[0] = max_mult[1] = ULLONG_MAX;
+		do_div(max_mult, max_ticks, max_mult);
+		dprintf("max_ticks=%llu, __builtin_clzll=%d, max_mult=0x%016llx%016llx\n",
+			max_ticks, __builtin_clzll(max_ticks), max_mult[1], max_mult[0]);
+
+		/*
+		 * Find the largest shift count that will produce
+		 * a multiplier less than max_mult
+		 */
+		do_div(max_mult, cycles_per_usec, tmp);
+		do_div(tmp, 1000ULL, tmp);
+		while (tmp[0] > 1 || tmp[1] > 1) {
+			do_shift(tmp, 1);
+			sft++;
+			dprintf("tmp=0x%016llx%016llx, sft=%u\n", tmp[1], tmp[0], sft);
+		}
+
+		*shift = sft;
+//		*((unsigned long long *)mult) = (__uint128_t) (((__uint128_t)1 << sft) * 1000 / cycles_per_usec);
+		break;
+		}
+	case CLOCK64_2STAGE: {
+		unsigned long long tmp;
+/*
+ * This clock tick to nsec conversion requires two stages.
+ *
+ * Stage 1: Determine how many ~MAX_CLOCK_SEC_2STAGE periods worth of clock ticks
+ * 	have elapsed and set nsecs to the appropriate value for those
+ *	~MAX_CLOCK_SEC_2STAGE periods.
+ * Stage 2: Subtract the ticks for the elapsed ~MAX_CLOCK_SEC_2STAGE periods from
+ *	Stage 1. Convert remaining clock ticks to nsecs and add to previously
+ *	set nsec value.
+ *
+ * To optimize the arithmetic operations, use the greatest power of 2 ticks
+ * less than the number of ticks in MAX_CLOCK_SEC_2STAGE seconds.
+ *
+ */
+		// Use a period shorter than MAX_CLOCK_SEC here for better accuracy
+		calc_mult_shift(CLOCK64_MULT_SHIFT, mult, shift, MAX_CLOCK_SEC_2STAGE, cycles_per_usec);
+
+		// Find the greatest power of 2 clock ticks that is less than the ticks in MAX_CLOCK_SEC_2STAGE
+		max_cycles_shift = max_cycles_mask = 0;
+		tmp = MAX_CLOCK_SEC_2STAGE * 1000000ULL * cycles_per_usec;
+		dprintf("tmp=%llu, max_cycles_shift=%u\n", tmp, max_cycles_shift);
+		while (tmp > 1) {
+			tmp >>= 1;
+			max_cycles_shift++;
+			dprintf("tmp=%llu, max_cycles_shift=%u\n", tmp, max_cycles_shift);
+		}
+		// if use use (1ULL << max_cycles_shift) * 1000 / cycles_per_usec here we will
+		// have a discontinuity every (1ULL << max_cycles_shift) cycles
+		nsecs_for_max_cycles = (1ULL << max_cycles_shift) * *((unsigned long long *)mult) >> *shift;
+
+		// Use a bitmask to calculate ticks % (1ULL << max_cycles_shift)
+		for (tmp = 0; tmp < max_cycles_shift; tmp++)
+			max_cycles_mask |= 1ULL << tmp;
+
+		dprintf("max_cycles_shift=%u, 2^max_cycles_shift=%llu, nsecs_for_max_cycles=%llu, max_cycles_mask=%016llx\n",
+				max_cycles_shift, (1ULL << max_cycles_shift),
+				nsecs_for_max_cycles, max_cycles_mask);
+
+
+		break;
+		}
+	case CLOCK64_LOCK: {
+/*
+ * This clock tick to nsec conversion also requires two stages.
+ *
+ * Stage 1: Add to nsec the current running total of elapsed long periods
+ * Stage 2: Subtract from clock ticks the tick count corresponding to the
+ *	most recently elapsed long period. Convert the remaining ticks to
+ *	nsec and add to the previous nsec value.
+ *
+ * In practice the elapsed nsec from Stage 1 and the tick count subtracted
+ * in Stage 2 will be maintained in a separate thread.
+ *
+ */
+		calc_mult_shift(CLOCK64_2STAGE, mult, shift, MAX_CLOCK_SEC, cycles_per_usec);
+		cycles_start = 0;
+		break;
+		}
+	case CLOCK128_MULT_SHIFT: {
+		__uint128_t max_mult, tmp;
+		unsigned int sft = 0;
+
+		/*
+		 * Calculate the largest multiplier that will not
+		 * produce a 128-bit overflow in the multiplication
+		 * step of the clock ticks to nsec conversion
+		 */
+		max_mult = ((__uint128_t) ULLONG_MAX) << 64 | ULLONG_MAX;
+		max_mult /= max_ticks;
+		dprintf("max_ticks=%llu, __builtin_clzll=%d, max_mult=0x%016llx%016llx\n",
+				max_ticks, __builtin_clzll(max_ticks),
+				(unsigned long long) (max_mult >> 64),
+				(unsigned long long) max_mult);
+
+		/*
+		 * Find the largest shift count that will produce
+		 * a multiplier less than max_mult
+		 */
+		tmp = max_mult * cycles_per_usec / 1000;
+		while (tmp > 1) {
+			tmp >>= 1;
+			sft++;
+			dprintf("tmp=0x%016llx%016llx, sft=%u\n",
+					(unsigned long long) (tmp >> 64),
+					(unsigned long long) tmp, sft);
+		}
+
+		*shift = sft;
+		*((__uint128_t *)mult) = (__uint128_t) (((__uint128_t)1 << sft) * 1000 / cycles_per_usec);
+		break;
+		}
+	}
+}
+
+static int discontinuity(int mode, int delta_ticks, int delta_nsec,
+			 unsigned long long start, unsigned long len)
+{
+	int i;
+	unsigned long mismatches = 0, bad_mismatches = 0;
+	unsigned long long delta, max_mismatch = 0;
+	unsigned long long *ns = nsecs;
+
+	for (i = 0; i < len; ns++, i++) {
+		*ns = get_nsec(mode, start + i);
+		if (i - delta_ticks >= 0) {
+			if (*ns > *(ns - delta_ticks))
+				delta = *ns - *(ns - delta_ticks);
+			else
+				delta = *(ns - delta_ticks) - *ns;
+			if (delta > delta_nsec)
+				delta -= delta_nsec;
+			else
+				delta = delta_nsec - delta;
+			if (delta) {
+				mismatches++;
+				if (delta > 1)
+					bad_mismatches++;
+				if (delta > max_mismatch)
+					max_mismatch = delta;
+			}
+		}
+		if (!bad_mismatches)
+			assert(max_mismatch == 0 || max_mismatch == 1);
+		if (!mismatches)
+			assert(max_mismatch == 0);
+	}
+
+	printf("%lu discontinuities (%lu%%) (%lu errors > 1ns, max delta = %lluns) for ticks = %llu...%llu\n",
+		mismatches, (mismatches * 100) / len, bad_mismatches, max_mismatch, start,
+		start + len - 1);
+	return mismatches;
+}
+
+#define MIN_TICKS 1ULL
+#define LEN 1000000000ULL
+#define NSEC_ONE_SEC 1000000000ULL
+#define TESTLEN 9
+
+static long long test_clock(int mode, int cycles_per_usec, int fast_test,
+			    int quiet, int delta_ticks, int delta_nsec)
+{
+	int i;
+	long long delta;
+	unsigned long long max_ticks;
+	unsigned long long nsecs;
+	void *mult;
+	unsigned long long test_ns[TESTLEN] =
+			{NSEC_ONE_SEC, NSEC_ONE_SEC,
+			 NSEC_ONE_SEC, NSEC_ONE_SEC*60, NSEC_ONE_SEC*60*60,
+			 NSEC_ONE_SEC*60*60*2, NSEC_ONE_SEC*60*60*4,
+			 NSEC_ONE_SEC*60*60*8, NSEC_ONE_SEC*60*60*24};
+	unsigned long long test_ticks[TESTLEN];
+
+	max_ticks = MAX_CLOCK_SEC * (unsigned long long) cycles_per_usec * 1000000ULL;
+
+	switch(mode) {
+	case CLOCK64_MULT_SHIFT:
+		mult = &clock_mult;
+		break;
+	case CLOCK64_EMULATE_128:
+		mult = clock_mult64_128;
+		break;
+	case CLOCK64_2STAGE:
+		mult = &clock_mult;
+		break;
+	case CLOCK64_LOCK:
+		mult = &clock_mult;
+		break;
+	case CLOCK128_MULT_SHIFT:
+		mult = &clock_mult128;
+		break;
+	default:
+		assert(0);
+	}
+	calc_mult_shift(mode, mult, &clock_shift, MAX_CLOCK_SEC, cycles_per_usec);
+	nsecs = get_nsec(mode, max_ticks);
+	delta = nsecs/1000000 - MAX_CLOCK_SEC*1000;
+
+	if (mode == CLOCK64_2STAGE) {
+		test_ns[0] = nsecs_for_max_cycles - 1;
+		test_ns[1] = nsecs_for_max_cycles;
+		test_ticks[0] = (1ULL << max_cycles_shift) - 1;
+		test_ticks[1] = (1ULL << max_cycles_shift);
+
+		for (i = 2; i < TESTLEN; i++)
+			test_ticks[i] = test_ns[i] / 1000 * cycles_per_usec;
+	}
+	else {
+		for (i = 0; i < TESTLEN; i++)
+			test_ticks[i] = test_ns[i] / 1000 * cycles_per_usec;
+	}
+
+	if (!quiet) {
+		printf("cycles_per_usec=%d, delta_ticks=%d, delta_nsec=%d, max_ticks=%llu, shift=%u, 2^shift=%llu\n",
+			cycles_per_usec, delta_ticks, delta_nsec, max_ticks, clock_shift, (1ULL << clock_shift));
+		switch(mode) {
+			case CLOCK64_LOCK:
+			case CLOCK64_2STAGE:
+			case CLOCK64_MULT_SHIFT: {
+				printf("clock_mult=%llu, clock_mult / 2^clock_shift=%f\n",
+					clock_mult, (double) clock_mult / (1ULL << clock_shift));
+				break;
+			}
+			case CLOCK64_EMULATE_128: {
+				printf("clock_mult=0x%016llx%016llx\n",
+					clock_mult64_128[1], clock_mult64_128[0]);
+				break;
+			}
+			case CLOCK128_MULT_SHIFT: {
+				printf("clock_mult=0x%016llx%016llx\n",
+					(unsigned long long) (clock_mult128 >> 64),
+					(unsigned long long) clock_mult128);
+				break;
+			}
+		}
+		printf("get_nsec(max_ticks) = %lluns, should be %lluns, error<=abs(%lld)ms\n",
+			nsecs, MAX_CLOCK_SEC*1000000000ULL, delta);
+	}
+
+	for (i = 0; i < TESTLEN; i++)
+	{
+		nsecs = get_nsec(mode, test_ticks[i]);
+		delta = nsecs > test_ns[i] ? nsecs - test_ns[i] : test_ns[i] - nsecs;
+		if (!quiet || delta > 0)
+			printf("get_nsec(%llu)=%llu, expected %llu, delta=%llu\n",
+				test_ticks[i], nsecs, test_ns[i], delta);
+	}
+
+	if (!fast_test) {
+		discontinuity(mode, delta_ticks, delta_nsec, max_ticks - LEN + 1, LEN);
+		discontinuity(mode, delta_ticks, delta_nsec, MIN_TICKS, LEN);
+	}
+
+	if (!quiet)
+		printf("\n\n");
+
+	return delta;
+}
+
+int main(int argc, char *argv[])
+{
+	nsecs = malloc(LEN * sizeof(unsigned long long));
+
+	test_clock(CLOCK64_LOCK, 3333, 1, 0, 0, 0);
+	test_clock(CLOCK64_LOCK, 1000, 1, 0, 1, 1);
+	test_clock(CLOCK64_LOCK, 1100, 1, 0, 11, 10);
+	test_clock(CLOCK64_LOCK, 3000, 1, 0, 3, 1);
+	test_clock(CLOCK64_LOCK, 3333, 1, 0, 3333, 1000);
+	test_clock(CLOCK64_LOCK, 3392, 1, 0, 424, 125);
+	test_clock(CLOCK64_LOCK, 4500, 1, 0, 9, 2);
+	test_clock(CLOCK64_LOCK, 5000, 1, 0, 5, 1);
+
+	free(nsecs);
+	return 0;
+}
diff --git a/time.c b/time.c
index 279ee48..edfe779 100644
--- a/time.c
+++ b/time.c
@@ -3,23 +3,23 @@
 
 #include "fio.h"
 
-static struct timeval genesis;
+static struct timespec genesis;
 static unsigned long ns_granularity;
 
-void timeval_add_msec(struct timeval *tv, unsigned int msec)
+void timespec_add_msec(struct timespec *ts, unsigned int msec)
 {
-	unsigned long adj_usec = 1000 * msec;
+	unsigned long adj_nsec = 1000000 * msec;
 
-	tv->tv_usec += adj_usec;
-	if (adj_usec >= 1000000) {
-		unsigned long adj_sec = adj_usec / 1000000;
+	ts->tv_nsec += adj_nsec;
+	if (adj_nsec >= 1000000000) {
+		unsigned long adj_sec = adj_nsec / 1000000000UL;
 
-		tv->tv_usec -=  adj_sec * 1000000;
-		tv->tv_sec += adj_sec;
+		ts->tv_nsec -=  adj_sec * 1000000000UL;
+		ts->tv_sec += adj_sec;
 	}
-	if (tv->tv_usec >= 1000000){
-		tv->tv_usec -= 1000000;
-		tv->tv_sec++;
+	if (ts->tv_nsec >= 1000000000UL){
+		ts->tv_nsec -= 1000000000UL;
+		ts->tv_sec++;
 	}
 }
 
@@ -28,7 +28,7 @@ void timeval_add_msec(struct timeval *tv, unsigned int msec)
  */
 uint64_t usec_spin(unsigned int usec)
 {
-	struct timeval start;
+	struct timespec start;
 	uint64_t t;
 
 	fio_gettime(&start, NULL);
@@ -41,7 +41,7 @@ uint64_t usec_spin(unsigned int usec)
 uint64_t usec_sleep(struct thread_data *td, unsigned long usec)
 {
 	struct timespec req;
-	struct timeval tv;
+	struct timespec tv;
 	uint64_t t = 0;
 
 	do {
@@ -111,13 +111,10 @@ static void parent_update_ramp(struct thread_data *td)
 
 bool ramp_time_over(struct thread_data *td)
 {
-	struct timeval tv;
-
 	if (!td->o.ramp_time || td->ramp_time_over)
 		return true;
 
-	fio_gettime(&tv, NULL);
-	if (utime_since(&td->epoch, &tv) >= td->o.ramp_time) {
+	if (utime_since_now(&td->epoch) >= td->o.ramp_time) {
 		td->ramp_time_over = 1;
 		reset_all_stats(td);
 		td_set_runstate(td, TD_RAMP);
@@ -138,8 +135,7 @@ void fio_time_init(void)
 	 * Check the granularity of the nanosleep function
 	 */
 	for (i = 0; i < 10; i++) {
-		struct timeval tv;
-		struct timespec ts;
+		struct timespec tv, ts;
 		unsigned long elapsed;
 
 		fio_gettime(&tv, NULL);
@@ -170,7 +166,7 @@ void set_epoch_time(struct thread_data *td, int log_unix_epoch)
 	}
 }
 
-void fill_start_time(struct timeval *t)
+void fill_start_time(struct timespec *t)
 {
 	memcpy(t, &genesis, sizeof(genesis));
 }
diff --git a/tools/hist/fiologparser_hist.py b/tools/hist/fiologparser_hist.py
index ead5e54..ad97a54 100755
--- a/tools/hist/fiologparser_hist.py
+++ b/tools/hist/fiologparser_hist.py
@@ -373,7 +373,7 @@ if __name__ == '__main__':
         help='print warning messages to stderr')
 
     arg('--group_nr',
-        default=19,
+        default=29,
         type=int,
         help='FIO_IO_U_PLAT_GROUP_NR as defined in stat.h')
 
diff --git a/verify.c b/verify.c
index 1c39fa2..ffd8707 100644
--- a/verify.c
+++ b/verify.c
@@ -1167,7 +1167,7 @@ static void __fill_hdr(struct thread_data *td, struct io_u *io_u,
 	hdr->rand_seed = rand_seed;
 	hdr->offset = io_u->offset + header_num * td->o.verify_interval;
 	hdr->time_sec = io_u->start_time.tv_sec;
-	hdr->time_usec = io_u->start_time.tv_usec;
+	hdr->time_usec = io_u->start_time.tv_nsec / 1000;
 	hdr->thread = td->thread_number;
 	hdr->numberio = io_u->numberio;
 	hdr->crc32 = fio_crc32c(p, offsetof(struct verify_header, crc32));
