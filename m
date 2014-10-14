Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:58933 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755194AbaJNMAE (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 14 Oct 2014 08:00:04 -0400
Received: from kernel.dk ([54.225.238.116] helo=lyth.info)
	by bombadil.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1Xe0lo-0003CW-BG
	for fio@vger.kernel.org; Tue, 14 Oct 2014 12:00:04 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20141014120003.61125401D9@lyth.info>
Date: Tue, 14 Oct 2014 06:00:03 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 91c0e7c5de1b4413c5fab8f5746272d1aee10f78:

  Set genesis time when running only network clients (2014-10-12 13:11:35 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to e5c9093db2c18166bd572f2ab40d5eba16a25b07:

  server/client: don't use __ conversion functions if not needed (2014-10-13 16:05:10 -0600)

----------------------------------------------------------------
Jens Axboe (8):
      stat: set kb/unit_base, if not already set
      client: always output summed output for all clients
      client: get rid of (now) unused client->nr_stat
      client: partial revert of 9899aff3e345
      smalloc: use log_err() for errors
      backend: use log_info_flush(), not fflush()
      engines: don't use printf or stderr directly
      server/client: don't use __ conversion functions if not needed

 backend.c                 |    4 ++--
 client.c                  |   10 +++-------
 engines/glusterfs_async.c |    5 +++--
 engines/libhdfs.c         |    7 +++----
 server.c                  |   10 +++++-----
 smalloc.c                 |   11 ++++++-----
 stat.c                    |    4 ++++
 7 files changed, 26 insertions(+), 25 deletions(-)

---

Diff of recent changes:

diff --git a/backend.c b/backend.c
index 981625b..3016e98 100644
--- a/backend.c
+++ b/backend.c
@@ -87,7 +87,7 @@ static void sig_int(int sig)
 			fio_server_got_signal(sig);
 		else {
 			log_info("\nfio: terminating on signal %d\n", sig);
-			fflush(stdout);
+			log_info_flush();
 			exit_value = 128;
 		}
 
@@ -1763,7 +1763,7 @@ static void run_threads(void)
 						nr_process > 1 ? "es" : "");
 		}
 		log_info("\n");
-		fflush(stdout);
+		log_info_flush();
 	}
 
 	todo = thread_number;
diff --git a/client.c b/client.c
index 1879e44..6b9fdd8 100644
--- a/client.c
+++ b/client.c
@@ -60,7 +60,6 @@ static int sum_stat_nr;
 static struct json_object *root = NULL;
 static struct json_array *clients_array = NULL;
 static struct json_array *du_array = NULL;
-static int do_output_all_clients;
 
 #define FIO_CLIENT_HASH_BITS	7
 #define FIO_CLIENT_HASH_SZ	(1 << FIO_CLIENT_HASH_BITS)
@@ -150,7 +149,7 @@ void fio_put_client(struct fio_client *client)
 		free(client->files);
 
 	if (!client->did_stat)
-		sum_stat_clients -= client->nr_stat;
+		sum_stat_clients--;
 
 	free(client);
 }
@@ -895,7 +894,7 @@ static void handle_ts(struct fio_client *client, struct fio_net_cmd *cmd)
 		json_array_add_value_object(clients_array, tsobj);
 	}
 
-	if (!do_output_all_clients)
+	if (sum_stat_clients <= 1)
 		return;
 
 	sum_thread_stats(&client_ts, &p->ts, sum_stat_nr);
@@ -953,7 +952,7 @@ static void convert_agg(struct disk_util_agg *agg)
 	agg->io_ticks		= le32_to_cpu(agg->io_ticks);
 	agg->time_in_queue	= le32_to_cpu(agg->time_in_queue);
 	agg->slavecount		= le32_to_cpu(agg->slavecount);
-	agg->max_util.u.f	= fio_uint64_to_double(__le64_to_cpu(agg->max_util.u.i));
+	agg->max_util.u.f	= fio_uint64_to_double(le64_to_cpu(agg->max_util.u.i));
 }
 
 static void convert_dus(struct disk_util_stat *dus)
@@ -1157,9 +1156,6 @@ static void handle_start(struct fio_client *client, struct fio_net_cmd *cmd)
 	client->jobs = le32_to_cpu(pdu->jobs);
 	client->nr_stat = le32_to_cpu(pdu->stat_outputs);
 
-	if (sum_stat_clients > 1)
-		do_output_all_clients = 1;
-
 	sum_stat_clients += client->nr_stat;
 }
 
diff --git a/engines/glusterfs_async.c b/engines/glusterfs_async.c
index 599bc5d..cf6ea70 100644
--- a/engines/glusterfs_async.c
+++ b/engines/glusterfs_async.c
@@ -67,7 +67,7 @@ static void fio_gf_io_u_free(struct thread_data *td, struct io_u *io_u)
 		io_u->engine_data = NULL;
 		free(io);
 	}
-	fprintf(stderr, "issued %lu finished %lu\n", issued, cb_count);
+	log_err("issued %lu finished %lu\n", issued, cb_count);
 }
 
 static int fio_gf_io_u_init(struct thread_data *td, struct io_u *io_u)
@@ -145,8 +145,9 @@ int fio_gf_async_setup(struct thread_data *td)
 {
 	int r = 0;
 	struct gf_data *g = NULL;
+
 #if defined(NOT_YET)
-	fprintf(stderr, "the async interface is still very experimental...\n");
+	log_err("the async interface is still very experimental...\n");
 #endif
 	r = fio_gf_setup(td);
 	if (r) {
diff --git a/engines/libhdfs.c b/engines/libhdfs.c
index 773d46b..658cd6a 100644
--- a/engines/libhdfs.c
+++ b/engines/libhdfs.c
@@ -87,7 +87,7 @@ static int fio_hdfsio_prep(struct thread_data *td, struct io_u *io_u)
 	} else if (io_u->ddir == DDIR_WRITE) {
 		open_flags = O_WRONLY;
 	} else {
-		printf("Invalid I/O Operation\n");
+		log_err("hdfs: Invalid I/O Operation\n");
 	}
 
 	hd->curr_file_id = f_id;
@@ -142,7 +142,7 @@ static int fio_hdfsio_queue(struct thread_data *td, struct io_u *io_u)
 		    hdfsWrite(hd->fs, hd->fp, io_u->xfer_buf,
 			      io_u->xfer_buflen);
 	} else {
-		printf("Invalid I/O Operation\n");
+		log_err("hdfs: Invalid I/O Operation\n");
 	}
 
 	return fio_io_end(td, io_u, ret);
@@ -202,8 +202,7 @@ static int fio_hdfsio_setup(struct thread_data *td)
 			hd->fscount = atol(getenv("FIO_HDFS_FCOUNT"));
 			hd->fsbs = atol(getenv("FIO_HDFS_BS"));
 		} else {
-			fprintf(stderr,
-				"FIO_HDFS_FCOUNT and/or FIO_HDFS_BS not set.\n");
+			log_err("FIO_HDFS_FCOUNT and/or FIO_HDFS_BS not set.\n");
 			return 1;
 		}
 #endif
diff --git a/server.c b/server.c
index 33c512c..b5bf878 100644
--- a/server.c
+++ b/server.c
@@ -980,8 +980,8 @@ static void convert_io_stat(struct io_stat *dst, struct io_stat *src)
 	/*
 	 * Encode to IEEE 754 for network transfer
 	 */
-	dst->mean.u.i	= __cpu_to_le64(fio_double_to_uint64(src->mean.u.f));
-	dst->S.u.i	= __cpu_to_le64(fio_double_to_uint64(src->S.u.f));
+	dst->mean.u.i	= cpu_to_le64(fio_double_to_uint64(src->mean.u.f));
+	dst->S.u.i	= cpu_to_le64(fio_double_to_uint64(src->S.u.f));
 }
 
 static void convert_gs(struct group_run_stats *dst, struct group_run_stats *src)
@@ -1045,7 +1045,7 @@ void fio_server_send_ts(struct thread_stat *ts, struct group_run_stats *rs)
 		fio_fp64_t *src = &ts->percentile_list[i];
 		fio_fp64_t *dst = &p.ts.percentile_list[i];
 
-		dst->u.i = __cpu_to_le64(fio_double_to_uint64(src->u.f));
+		dst->u.i = cpu_to_le64(fio_double_to_uint64(src->u.f));
 	}
 
 	for (i = 0; i < FIO_IO_U_MAP_NR; i++) {
@@ -1087,7 +1087,7 @@ void fio_server_send_ts(struct thread_stat *ts, struct group_run_stats *rs)
 	p.ts.latency_depth	= cpu_to_le32(ts->latency_depth);
 	p.ts.latency_target	= cpu_to_le64(ts->latency_target);
 	p.ts.latency_window	= cpu_to_le64(ts->latency_window);
-	p.ts.latency_percentile.u.i = __cpu_to_le64(fio_double_to_uint64(ts->latency_percentile.u.f));
+	p.ts.latency_percentile.u.i = cpu_to_le64(fio_double_to_uint64(ts->latency_percentile.u.f));
 
 	convert_gs(&p.rs, rs);
 
@@ -1118,7 +1118,7 @@ static void convert_agg(struct disk_util_agg *dst, struct disk_util_agg *src)
 	dst->io_ticks		= cpu_to_le32(src->io_ticks);
 	dst->time_in_queue	= cpu_to_le32(src->time_in_queue);
 	dst->slavecount		= cpu_to_le32(src->slavecount);
-	dst->max_util.u.i	= __cpu_to_le64(fio_double_to_uint64(src->max_util.u.f));
+	dst->max_util.u.i	= cpu_to_le64(fio_double_to_uint64(src->max_util.u.f));
 }
 
 static void convert_dus(struct disk_util_stat *dst, struct disk_util_stat *src)
diff --git a/smalloc.c b/smalloc.c
index d0f732b..5fe0b6f 100644
--- a/smalloc.c
+++ b/smalloc.c
@@ -17,6 +17,7 @@
 #include "arch/arch.h"
 #include "os/os.h"
 #include "smalloc.h"
+#include "log.h"
 
 #define SMALLOC_REDZONE		/* define to detect memory corruption */
 
@@ -221,7 +222,7 @@ static int add_pool(struct pool *pool, unsigned int alloc_size)
 	nr_pools++;
 	return 0;
 out_fail:
-	fprintf(stderr, "smalloc: failed adding pool\n");
+	log_err("smalloc: failed adding pool\n");
 	if (pool->map)
 		munmap(pool->map, pool->mmap_size);
 	return 1;
@@ -283,14 +284,14 @@ static void sfree_check_redzone(struct block_hdr *hdr)
 	unsigned int *postred = postred_ptr(hdr);
 
 	if (hdr->prered != SMALLOC_PRE_RED) {
-		fprintf(stderr, "smalloc pre redzone destroyed!\n");
-		fprintf(stderr, "  ptr=%p, prered=%x, expected %x\n",
+		log_err("smalloc pre redzone destroyed!\n"
+			" ptr=%p, prered=%x, expected %x\n",
 				hdr, hdr->prered, SMALLOC_PRE_RED);
 		assert(0);
 	}
 	if (*postred != SMALLOC_POST_RED) {
-		fprintf(stderr, "smalloc post redzone destroyed!\n");
-		fprintf(stderr, "  ptr=%p, postred=%x, expected %x\n",
+		log_err("smalloc post redzone destroyed!\n"
+			"  ptr=%p, postred=%x, expected %x\n",
 				hdr, *postred, SMALLOC_POST_RED);
 		assert(0);
 	}
diff --git a/stat.c b/stat.c
index 77e389c..03dc458 100644
--- a/stat.c
+++ b/stat.c
@@ -1077,6 +1077,10 @@ void sum_group_stats(struct group_run_stats *dst, struct group_run_stats *src)
 		dst->agg[i] += src->agg[i];
 	}
 
+	if (!dst->kb_base)
+		dst->kb_base = src->kb_base;
+	if (!dst->unit_base)
+		dst->unit_base = src->unit_base;
 }
 
 void sum_thread_stats(struct thread_stat *dst, struct thread_stat *src, int nr)
