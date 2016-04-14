Return-Path: <fio-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:41707 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753248AbcDNMAH (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 14 Apr 2016 08:00:07 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
	by casper.infradead.org with esmtpsa (Exim 4.85_2 #1 (Red Hat Linux))
	id 1aqfwL-0003mR-2l
	for fio@vger.kernel.org; Thu, 14 Apr 2016 12:00:05 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20160414120002.5AA172C18E7@kernel.dk>
Date: Thu, 14 Apr 2016 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 2a442a30385a3b3a338148be46661f4ea3d9eed1:

  Modify RDMA engine to print strerror messages. (2016-04-04 10:06:03 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to bb7816439c44f6f98debd8afd167da14d612574c:

  client: bool conversion (2016-04-13 15:53:06 -0600)

----------------------------------------------------------------
Jens Axboe (4):
      Fix verify state for multiple files
      Cleanup last write logging
      t/fio-verify-state: pretty up output a bit
      client: bool conversion

 backend.c        |  52 +++++++++++++-----
 client.c         |   4 +-
 client.h         |   6 +--
 file.h           |   7 +++
 fio.h            |   7 ---
 gfio.c           |   2 +-
 init.c           |   4 +-
 io_u.c           |  41 ++++++++------
 server.c         |   4 +-
 server.h         |   2 +-
 t/verify-state.c |  77 ++++++++++++++------------
 verify-state.h   |  34 +++++-------
 verify.c         | 162 ++++++++++++++++++++++++++-----------------------------
 13 files changed, 216 insertions(+), 186 deletions(-)

---

Diff of recent changes:

diff --git a/backend.c b/backend.c
index e093f75..1723b8f 100644
--- a/backend.c
+++ b/backend.c
@@ -1070,6 +1070,41 @@ reap:
 		bytes_done[i] = td->bytes_done[i] - bytes_done[i];
 }
 
+static void free_file_completion_logging(struct thread_data *td)
+{
+	struct fio_file *f;
+	unsigned int i;
+
+	for_each_file(td, f, i) {
+		if (!f->last_write_comp)
+			break;
+		sfree(f->last_write_comp);
+	}
+}
+
+static int init_file_completion_logging(struct thread_data *td,
+					unsigned int depth)
+{
+	struct fio_file *f;
+	unsigned int i;
+
+	if (td->o.verify == VERIFY_NONE || !td->o.verify_state_save)
+		return 0;
+
+	for_each_file(td, f, i) {
+		f->last_write_comp = scalloc(depth, sizeof(uint64_t));
+		if (!f->last_write_comp)
+			goto cleanup;
+	}
+
+	return 0;
+
+cleanup:
+	free_file_completion_logging(td);
+	log_err("fio: failed to alloc write comp data\n");
+	return 1;
+}
+
 static void cleanup_io_u(struct thread_data *td)
 {
 	struct io_u *io_u;
@@ -1088,8 +1123,7 @@ static void cleanup_io_u(struct thread_data *td)
 	io_u_qexit(&td->io_u_freelist);
 	io_u_qexit(&td->io_u_all);
 
-	if (td->last_write_comp)
-		sfree(td->last_write_comp);
+	free_file_completion_logging(td);
 }
 
 static int init_io_u(struct thread_data *td)
@@ -1206,13 +1240,8 @@ static int init_io_u(struct thread_data *td)
 		p += max_bs;
 	}
 
-	if (td->o.verify != VERIFY_NONE) {
-		td->last_write_comp = scalloc(max_units, sizeof(uint64_t));
-		if (!td->last_write_comp) {
-			log_err("fio: failed to alloc write comp data\n");
-			return 1;
-		}
-	}
+	if (init_file_completion_logging(td, max_units))
+		return 1;
 
 	return 0;
 }
@@ -1964,12 +1993,11 @@ static int fio_verify_load_state(struct thread_data *td)
 
 	if (is_backend) {
 		void *data;
-		int ver;
 
 		ret = fio_server_get_verify_state(td->o.name,
-					td->thread_number - 1, &data, &ver);
+					td->thread_number - 1, &data);
 		if (!ret)
-			verify_convert_assign_state(td, data, ver);
+			verify_assign_state(td, data);
 	} else
 		ret = verify_load_state(td, "local");
 
diff --git a/client.c b/client.c
index 6bc1145..d502a4b 100644
--- a/client.c
+++ b/client.c
@@ -347,7 +347,7 @@ err:
 	return NULL;
 }
 
-int fio_client_add_ini_file(void *cookie, const char *ini_file, int remote)
+int fio_client_add_ini_file(void *cookie, const char *ini_file, bool remote)
 {
 	struct fio_client *client = cookie;
 	struct client_file *cf;
@@ -789,7 +789,7 @@ static int __fio_client_send_local_ini(struct fio_client *client,
 }
 
 int fio_client_send_ini(struct fio_client *client, const char *filename,
-			int remote)
+			bool remote)
 {
 	int ret;
 
diff --git a/client.h b/client.h
index 7fe09d1..ddacf78 100644
--- a/client.h
+++ b/client.h
@@ -22,7 +22,7 @@ enum {
 
 struct client_file {
 	char *file;
-	int remote;
+	bool remote;
 };
 
 struct fio_client {
@@ -124,12 +124,12 @@ extern int fio_clients_connect(void);
 extern int fio_start_client(struct fio_client *);
 extern int fio_start_all_clients(void);
 extern int fio_clients_send_ini(const char *);
-extern int fio_client_send_ini(struct fio_client *, const char *, int);
+extern int fio_client_send_ini(struct fio_client *, const char *, bool);
 extern int fio_handle_clients(struct client_ops *);
 extern int fio_client_add(struct client_ops *, const char *, void **);
 extern struct fio_client *fio_client_add_explicit(struct client_ops *, const char *, int, int);
 extern void fio_client_add_cmd_option(void *, const char *);
-extern int fio_client_add_ini_file(void *, const char *, int);
+extern int fio_client_add_ini_file(void *, const char *, bool);
 extern int fio_client_terminate(struct fio_client *);
 extern void fio_clients_terminate(void);
 extern struct fio_client *fio_get_client(struct fio_client *);
diff --git a/file.h b/file.h
index a631766..e7563b8 100644
--- a/file.h
+++ b/file.h
@@ -98,6 +98,13 @@ struct fio_file {
 	uint64_t last_write;
 
 	/*
+	 * Tracks the last iodepth number of completed writes, if data
+	 * verification is enabled
+	 */
+	uint64_t *last_write_comp;
+	unsigned int last_write_idx;
+
+	/*
 	 * For use by the io engine
 	 */
 	uint64_t engine_data;
diff --git a/fio.h b/fio.h
index 30fbde0..829cc81 100644
--- a/fio.h
+++ b/fio.h
@@ -154,13 +154,6 @@ struct thread_data {
 	uint64_t stat_io_blocks[DDIR_RWDIR_CNT];
 	struct timeval iops_sample_time;
 
-	/*
-	 * Tracks the last iodepth number of completed writes, if data
-	 * verification is enabled
-	 */
-	uint64_t *last_write_comp;
-	unsigned int last_write_idx;
-
 	volatile int update_rusage;
 	struct fio_mutex *rusage_sem;
 	struct rusage ru_start;
diff --git a/gfio.c b/gfio.c
index 42d536e..e3bcbdf 100644
--- a/gfio.c
+++ b/gfio.c
@@ -449,7 +449,7 @@ static int send_job_file(struct gui_entry *ge)
 		free(gco);
 	}
 
-	ret = fio_client_send_ini(gc->client, ge->job_file, 0);
+	ret = fio_client_send_ini(gc->client, ge->job_file, false);
 	if (!ret)
 		return 0;
 
diff --git a/init.c b/init.c
index cc33bf0..89e05c0 100644
--- a/init.c
+++ b/init.c
@@ -2552,14 +2552,14 @@ int parse_cmd_line(int argc, char *argv[], int client_type)
 				    !strncmp(argv[optind], "-", 1))
 					break;
 
-				if (fio_client_add_ini_file(cur_client, argv[optind], 0))
+				if (fio_client_add_ini_file(cur_client, argv[optind], false))
 					break;
 				optind++;
 			}
 			break;
 		case 'R':
 			did_arg = 1;
-			if (fio_client_add_ini_file(cur_client, optarg, 1)) {
+			if (fio_client_add_ini_file(cur_client, optarg, true)) {
 				do_exit++;
 				exit_val = 1;
 			}
diff --git a/io_u.c b/io_u.c
index ea08c92..6622bc0 100644
--- a/io_u.c
+++ b/io_u.c
@@ -1735,6 +1735,28 @@ static void account_io_completion(struct thread_data *td, struct io_u *io_u,
 	}
 }
 
+static void file_log_write_comp(const struct thread_data *td, struct fio_file *f,
+				uint64_t offset, unsigned int bytes)
+{
+	int idx;
+
+	if (!f)
+		return;
+
+	if (f->first_write == -1ULL || offset < f->first_write)
+		f->first_write = offset;
+	if (f->last_write == -1ULL || ((offset + bytes) > f->last_write))
+		f->last_write = offset + bytes;
+
+	if (!f->last_write_comp)
+		return;
+
+	idx = f->last_write_idx++;
+	f->last_write_comp[idx] = offset;
+	if (f->last_write_idx == td->o.iodepth)
+		f->last_write_idx = 0;
+}
+
 static void io_completed(struct thread_data *td, struct io_u **io_u_ptr,
 			 struct io_completion_data *icd)
 {
@@ -1785,23 +1807,8 @@ static void io_completed(struct thread_data *td, struct io_u **io_u_ptr,
 		if (!(io_u->flags & IO_U_F_VER_LIST))
 			td->this_io_bytes[ddir] += bytes;
 
-		if (ddir == DDIR_WRITE) {
-			if (f) {
-				if (f->first_write == -1ULL ||
-				    io_u->offset < f->first_write)
-					f->first_write = io_u->offset;
-				if (f->last_write == -1ULL ||
-				    ((io_u->offset + bytes) > f->last_write))
-					f->last_write = io_u->offset + bytes;
-			}
-			if (td->last_write_comp) {
-				int idx = td->last_write_idx++;
-
-				td->last_write_comp[idx] = io_u->offset;
-				if (td->last_write_idx == td->o.iodepth)
-					td->last_write_idx = 0;
-			}
-		}
+		if (ddir == DDIR_WRITE)
+			file_log_write_comp(td, f, io_u->offset, bytes);
 
 		if (ramp_time_over(td) && (td->runstate == TD_RUNNING ||
 					   td->runstate == TD_VERIFYING))
diff --git a/server.c b/server.c
index 6416a5c..dcb7c2d 100644
--- a/server.c
+++ b/server.c
@@ -1819,7 +1819,7 @@ void fio_server_send_start(struct thread_data *td)
 }
 
 int fio_server_get_verify_state(const char *name, int threadnumber,
-				void **datap, int *version)
+				void **datap)
 {
 	struct thread_io_list *s;
 	struct cmd_sendfile out;
@@ -1871,7 +1871,7 @@ fail:
 	 * the header, and the thread_io_list checksum
 	 */
 	s = rep->data + sizeof(struct verify_state_hdr);
-	if (verify_state_hdr(rep->data, s, version)) {
+	if (verify_state_hdr(rep->data, s)) {
 		ret = EILSEQ;
 		goto fail;
 	}
diff --git a/server.h b/server.h
index fd0a0ce..7fc3ec6 100644
--- a/server.h
+++ b/server.h
@@ -211,7 +211,7 @@ extern void fio_server_send_ts(struct thread_stat *, struct group_run_stats *);
 extern void fio_server_send_gs(struct group_run_stats *);
 extern void fio_server_send_du(void);
 extern void fio_server_send_job_options(struct flist_head *, unsigned int);
-extern int fio_server_get_verify_state(const char *, int, void **, int *);
+extern int fio_server_get_verify_state(const char *, int, void **);
 
 extern struct fio_net_cmd *fio_net_recv_cmd(int sk, bool wait);
 
diff --git a/t/verify-state.c b/t/verify-state.c
index 6e8cd35..95dcf3a 100644
--- a/t/verify-state.c
+++ b/t/verify-state.c
@@ -19,15 +19,45 @@ static void show_s(struct thread_io_list *s, unsigned int no_s)
 {
 	int i;
 
-	printf("Thread %u, %s\n", no_s, s->name);
-	printf("Completions: %llu\n", (unsigned long long) s->no_comps);
-	printf("Depth: %llu\n", (unsigned long long) s->depth);
-	printf("Number IOs: %llu\n", (unsigned long long) s->numberio);
-	printf("Index: %llu\n", (unsigned long long) s->index);
+	printf("Thread:\t\t%u\n", no_s);
+	printf("Name:\t\t%s\n", s->name);
+	printf("Completions:\t%llu\n", (unsigned long long) s->no_comps);
+	printf("Depth:\t\t%llu\n", (unsigned long long) s->depth);
+	printf("Number IOs:\t%llu\n", (unsigned long long) s->numberio);
+	printf("Index:\t\t%llu\n", (unsigned long long) s->index);
 
 	printf("Completions:\n");
-	for (i = 0; i < s->no_comps; i++)
-		printf("\t%llu\n", (unsigned long long) s->offsets[i]);
+	for (i = 0; i < s->no_comps; i++) {
+		printf("\t(file=%2llu) %llu\n",
+				(unsigned long long) s->comps[i].fileno,
+				(unsigned long long) s->comps[i].offset);
+	}
+}
+
+static void show(struct thread_io_list *s, size_t size)
+{
+	int no_s;
+
+	no_s = 0;
+	do {
+		int i;
+
+		s->no_comps = le64_to_cpu(s->no_comps);
+		s->depth = le32_to_cpu(s->depth);
+		s->nofiles = le32_to_cpu(s->nofiles);
+		s->numberio = le64_to_cpu(s->numberio);
+		s->index = le64_to_cpu(s->index);
+
+		for (i = 0; i < s->no_comps; i++) {
+			s->comps[i].fileno = le64_to_cpu(s->comps[i].fileno);
+			s->comps[i].offset = le64_to_cpu(s->comps[i].offset);
+		}
+
+		show_s(s, no_s);
+		no_s++;
+		size -= __thread_io_list_sz(s->depth, s->nofiles);
+		s = (void *) s + __thread_io_list_sz(s->depth, s->nofiles);
+	} while (size != 0);
 }
 
 static void show_verify_state(void *buf, size_t size)
@@ -35,15 +65,14 @@ static void show_verify_state(void *buf, size_t size)
 	struct verify_state_hdr *hdr = buf;
 	struct thread_io_list *s;
 	uint32_t crc;
-	int no_s;
 
 	hdr->version = le64_to_cpu(hdr->version);
 	hdr->size = le64_to_cpu(hdr->size);
 	hdr->crc = le64_to_cpu(hdr->crc);
 
-	printf("Version: %x, Size %u, crc %x\n", (unsigned int) hdr->version,
-						(unsigned int) hdr->size,
-						(unsigned int) hdr->crc);
+	printf("Version:\t0x%x\n", (unsigned int) hdr->version);
+	printf("Size:\t\t%u\n", (unsigned int) hdr->size);
+	printf("CRC:\t\t0x%x\n", (unsigned int) hdr->crc);
 
 	size -= sizeof(*hdr);
 	if (hdr->size != size) {
@@ -58,28 +87,10 @@ static void show_verify_state(void *buf, size_t size)
 		return;
 	}
 
-	if (hdr->version != 0x02) {
-		log_err("Can only handle version 2 headers\n");
-		return;
-	}
-
-	no_s = 0;
-	do {
-		int i;
-
-		s->no_comps = le64_to_cpu(s->no_comps);
-		s->depth = le64_to_cpu(s->depth);
-		s->numberio = le64_to_cpu(s->numberio);
-		s->index = le64_to_cpu(s->index);
-
-		for (i = 0; i < s->no_comps; i++)
-			s->offsets[i] = le64_to_cpu(s->offsets[i]);
-
-		show_s(s, no_s);
-		no_s++;
-		size -= __thread_io_list_sz(s->depth);
-		s = (void *) s + __thread_io_list_sz(s->depth);
-	} while (size != 0);
+	if (hdr->version == 0x03)
+		show(s, size);
+	else
+		log_err("Unsupported version %d\n", (int) hdr->version);
 }
 
 int main(int argc, char *argv[])
diff --git a/verify-state.h b/verify-state.h
index 0d004b0..f1dc069 100644
--- a/verify-state.h
+++ b/verify-state.h
@@ -22,24 +22,20 @@ struct thread_rand_state {
 /*
  * For dumping current write state
  */
-struct thread_io_list {
-	uint64_t no_comps;
-	uint64_t depth;
-	uint64_t numberio;
-	uint64_t index;
-	struct thread_rand_state rand;
-	uint8_t name[64];
-	uint64_t offsets[0];
+struct file_comp {
+	uint64_t fileno;
+	uint64_t offset;
 };
 
-struct thread_io_list_v1 {
+struct thread_io_list {
 	uint64_t no_comps;
-	uint64_t depth;
+	uint32_t depth;
+	uint32_t nofiles;
 	uint64_t numberio;
 	uint64_t index;
-	struct thread_rand32_state rand;
+	struct thread_rand_state rand;
 	uint8_t name[64];
-	uint64_t offsets[0];
+	struct file_comp comps[0];
 };
 
 struct all_io_list {
@@ -47,8 +43,7 @@ struct all_io_list {
 	struct thread_io_list state[0];
 };
 
-#define VSTATE_HDR_VERSION_V1	0x01
-#define VSTATE_HDR_VERSION	0x02
+#define VSTATE_HDR_VERSION	0x03
 
 struct verify_state_hdr {
 	uint64_t version;
@@ -65,18 +60,17 @@ extern void verify_save_state(int mask);
 extern int verify_load_state(struct thread_data *, const char *);
 extern void verify_free_state(struct thread_data *);
 extern int verify_state_should_stop(struct thread_data *, struct io_u *);
-extern void verify_convert_assign_state(struct thread_data *, void *, int);
-extern int verify_state_hdr(struct verify_state_hdr *, struct thread_io_list *,
-				int *);
+extern void verify_assign_state(struct thread_data *, void *);
+extern int verify_state_hdr(struct verify_state_hdr *, struct thread_io_list *);
 
-static inline size_t __thread_io_list_sz(uint64_t depth)
+static inline size_t __thread_io_list_sz(uint32_t depth, uint32_t nofiles)
 {
-	return sizeof(struct thread_io_list) + depth * sizeof(uint64_t);
+	return sizeof(struct thread_io_list) + depth * nofiles * sizeof(struct file_comp);
 }
 
 static inline size_t thread_io_list_sz(struct thread_io_list *s)
 {
-	return __thread_io_list_sz(le64_to_cpu(s->depth));
+	return __thread_io_list_sz(le32_to_cpu(s->depth), le32_to_cpu(s->nofiles));
 }
 
 static inline struct thread_io_list *io_list_next(struct thread_io_list *s)
diff --git a/verify.c b/verify.c
index 0f43a3e..838db10 100644
--- a/verify.c
+++ b/verify.c
@@ -1353,6 +1353,47 @@ int paste_blockoff(char *buf, unsigned int len, void *priv)
 	return 0;
 }
 
+static int __fill_file_completions(struct thread_data *td,
+				   struct thread_io_list *s,
+				   struct fio_file *f, unsigned int *index)
+{
+	unsigned int comps;
+	int i, j;
+
+	if (!f->last_write_comp)
+		return 0;
+
+	if (td->io_blocks[DDIR_WRITE] < td->o.iodepth)
+		comps = td->io_blocks[DDIR_WRITE];
+	else
+		comps = td->o.iodepth;
+
+	j = f->last_write_idx - 1;
+	for (i = 0; i < comps; i++) {
+		if (j == -1)
+			j = td->o.iodepth - 1;
+		s->comps[*index].fileno = __cpu_to_le64(f->fileno);
+		s->comps[*index].offset = cpu_to_le64(f->last_write_comp[j]);
+		(*index)++;
+		j--;
+	}
+
+	return comps;
+}
+
+static int fill_file_completions(struct thread_data *td,
+				 struct thread_io_list *s, unsigned int *index)
+{
+	struct fio_file *f;
+	unsigned int i;
+	int comps = 0;
+
+	for_each_file(td, f, i)
+		comps += __fill_file_completions(td, s, f, index);
+
+	return comps;
+}
+
 struct all_io_list *get_all_io_list(int save_mask, size_t *sz)
 {
 	struct all_io_list *rep;
@@ -1374,7 +1415,7 @@ struct all_io_list *get_all_io_list(int save_mask, size_t *sz)
 			continue;
 		td->stop_io = 1;
 		td->flags |= TD_F_VSTATE_SAVED;
-		depth += td->o.iodepth;
+		depth += (td->o.iodepth * td->o.nr_files);
 		nr++;
 	}
 
@@ -1383,7 +1424,7 @@ struct all_io_list *get_all_io_list(int save_mask, size_t *sz)
 
 	*sz = sizeof(*rep);
 	*sz += nr * sizeof(struct thread_io_list);
-	*sz += depth * sizeof(uint64_t);
+	*sz += depth * sizeof(struct file_comp);
 	rep = malloc(*sz);
 	memset(rep, 0, *sz);
 
@@ -1392,31 +1433,16 @@ struct all_io_list *get_all_io_list(int save_mask, size_t *sz)
 	next = &rep->state[0];
 	for_each_td(td, i) {
 		struct thread_io_list *s = next;
-		unsigned int comps;
+		unsigned int comps, index = 0;
 
 		if (save_mask != IO_LIST_ALL && (i + 1) != save_mask)
 			continue;
 
-		if (td->last_write_comp) {
-			int j, k;
-
-			if (td->io_blocks[DDIR_WRITE] < td->o.iodepth)
-				comps = td->io_blocks[DDIR_WRITE];
-			else
-				comps = td->o.iodepth;
-
-			k = td->last_write_idx - 1;
-			for (j = 0; j < comps; j++) {
-				if (k == -1)
-					k = td->o.iodepth - 1;
-				s->offsets[j] = cpu_to_le64(td->last_write_comp[k]);
-				k--;
-			}
-		} else
-			comps = 0;
+		comps = fill_file_completions(td, s, &index);
 
 		s->no_comps = cpu_to_le64((uint64_t) comps);
 		s->depth = cpu_to_le64((uint64_t) td->o.iodepth);
+		s->nofiles = cpu_to_le64((uint64_t) td->o.nr_files);
 		s->numberio = cpu_to_le64((uint64_t) td->io_issues[DDIR_WRITE]);
 		s->index = cpu_to_le64((uint64_t) i);
 		if (td->random_state.use64) {
@@ -1536,72 +1562,34 @@ void verify_free_state(struct thread_data *td)
 		free(td->vstate);
 }
 
-static struct thread_io_list *convert_v1_list(struct thread_io_list_v1 *s)
+void verify_assign_state(struct thread_data *td, void *p)
 {
-	struct thread_io_list *til;
+	struct thread_io_list *s = p;
 	int i;
 
-	til = malloc(__thread_io_list_sz(s->no_comps));
-	til->no_comps = s->no_comps;
-	til->depth = s->depth;
-	til->numberio = s->numberio;
-	til->index = s->index;
-	memcpy(til->name, s->name, sizeof(til->name));
-
-	til->rand.use64 = 0;
-	for (i = 0; i < 4; i++)
-		til->rand.state32.s[i] = s->rand.s[i];
+	s->no_comps = le64_to_cpu(s->no_comps);
+	s->depth = le32_to_cpu(s->depth);
+	s->nofiles = le32_to_cpu(s->nofiles);
+	s->numberio = le64_to_cpu(s->numberio);
+	s->rand.use64 = le64_to_cpu(s->rand.use64);
 
-	for (i = 0; i < s->no_comps; i++)
-		til->offsets[i] = s->offsets[i];
-
-	return til;
-}
-
-void verify_convert_assign_state(struct thread_data *td, void *p, int version)
-{
-	struct thread_io_list *til;
-	int i;
-
-	if (version == 1) {
-		struct thread_io_list_v1 *s = p;
-
-		s->no_comps = le64_to_cpu(s->no_comps);
-		s->depth = le64_to_cpu(s->depth);
-		s->numberio = le64_to_cpu(s->numberio);
-		for (i = 0; i < 4; i++)
-			s->rand.s[i] = le32_to_cpu(s->rand.s[i]);
-		for (i = 0; i < s->no_comps; i++)
-			s->offsets[i] = le64_to_cpu(s->offsets[i]);
-
-		til = convert_v1_list(s);
-		free(s);
+	if (s->rand.use64) {
+		for (i = 0; i < 6; i++)
+			s->rand.state64.s[i] = le64_to_cpu(s->rand.state64.s[i]);
 	} else {
-		struct thread_io_list *s = p;
-
-		s->no_comps = le64_to_cpu(s->no_comps);
-		s->depth = le64_to_cpu(s->depth);
-		s->numberio = le64_to_cpu(s->numberio);
-		s->rand.use64 = le64_to_cpu(s->rand.use64);
-
-		if (s->rand.use64) {
-			for (i = 0; i < 6; i++)
-				s->rand.state64.s[i] = le64_to_cpu(s->rand.state64.s[i]);
-		} else {
-			for (i = 0; i < 4; i++)
-				s->rand.state32.s[i] = le32_to_cpu(s->rand.state32.s[i]);
-		}
-		for (i = 0; i < s->no_comps; i++)
-			s->offsets[i] = le64_to_cpu(s->offsets[i]);
+		for (i = 0; i < 4; i++)
+			s->rand.state32.s[i] = le32_to_cpu(s->rand.state32.s[i]);
+	}
 
-		til = p;
+	for (i = 0; i < s->no_comps; i++) {
+		s->comps[i].fileno = le64_to_cpu(s->comps[i].fileno);
+		s->comps[i].offset = le64_to_cpu(s->comps[i].offset);
 	}
 
-	td->vstate = til;
+	td->vstate = p;
 }
 
-int verify_state_hdr(struct verify_state_hdr *hdr, struct thread_io_list *s,
-		     int *version)
+int verify_state_hdr(struct verify_state_hdr *hdr, struct thread_io_list *s)
 {
 	uint64_t crc;
 
@@ -1609,15 +1597,13 @@ int verify_state_hdr(struct verify_state_hdr *hdr, struct thread_io_list *s,
 	hdr->size = le64_to_cpu(hdr->size);
 	hdr->crc = le64_to_cpu(hdr->crc);
 
-	if (hdr->version != VSTATE_HDR_VERSION &&
-	    hdr->version != VSTATE_HDR_VERSION_V1)
+	if (hdr->version != VSTATE_HDR_VERSION)
 		return 1;
 
 	crc = fio_crc32c((void *)s, hdr->size);
 	if (crc != hdr->crc)
 		return 1;
 
-	*version = hdr->version;
 	return 0;
 }
 
@@ -1648,9 +1634,9 @@ int verify_load_state(struct thread_data *td, const char *prefix)
 	hdr.size = le64_to_cpu(hdr.size);
 	hdr.crc = le64_to_cpu(hdr.crc);
 
-	if (hdr.version != VSTATE_HDR_VERSION &&
-	    hdr.version != VSTATE_HDR_VERSION_V1) {
-		log_err("fio: bad version in verify state header\n");
+	if (hdr.version != VSTATE_HDR_VERSION) {
+		log_err("fio: unsupported (%d) version in verify state header\n",
+				(unsigned int) hdr.version);
 		goto err;
 	}
 
@@ -1671,7 +1657,7 @@ int verify_load_state(struct thread_data *td, const char *prefix)
 
 	close(fd);
 
-	verify_convert_assign_state(td, s, hdr.version);
+	verify_assign_state(td, s);
 	return 0;
 err:
 	if (s)
@@ -1686,9 +1672,10 @@ err:
 int verify_state_should_stop(struct thread_data *td, struct io_u *io_u)
 {
 	struct thread_io_list *s = td->vstate;
+	struct fio_file *f = io_u->file;
 	int i;
 
-	if (!s)
+	if (!s || !f)
 		return 0;
 
 	/*
@@ -1705,9 +1692,12 @@ int verify_state_should_stop(struct thread_data *td, struct io_u *io_u)
 	 * completed or not. If the IO was seen as completed, then
 	 * lets verify it.
 	 */
-	for (i = 0; i < s->no_comps; i++)
-		if (io_u->offset == s->offsets[i])
+	for (i = 0; i < s->no_comps; i++) {
+		if (s->comps[i].fileno != f->fileno)
+			continue;
+		if (io_u->offset == s->comps[i].offset)
 			return 0;
+	}
 
 	/*
 	 * Not found, we have to stop
