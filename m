Return-Path: <fio-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:42191 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932159AbaLKNAH (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 11 Dec 2014 08:00:07 -0500
Received: from kernel.dk ([54.225.238.116] helo=lyth.info)
	by casper.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1Xz3Lh-00082k-90
	for fio@vger.kernel.org; Thu, 11 Dec 2014 13:00:05 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20141211130002.D79E640157@lyth.info>
Date: Thu, 11 Dec 2014 06:00:02 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 3b577774803435109e070cc8f4313fc485c9160f:

  Fix server/client set_options conversion (2014-12-09 14:12:47 -0700)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to a4d3b4dbf594be6223a21a47a7ce4c21c7dddaf0:

  Update size/io_size descriptions (2014-12-10 19:21:37 -0700)

----------------------------------------------------------------
Fabrice Bacchella (1):
      Improved support for libhdfs

Jens Axboe (3):
      gluster: wire up sync/datasync opcodes
      btrace2fio: add support for collapsing close entries
      Update size/io_size descriptions

 HOWTO                     |   27 ++++---
 Makefile                  |    4 +-
 configure                 |    5 +-
 engines/glusterfs_async.c |    2 +
 engines/glusterfs_sync.c  |    4 +
 fio.1                     |   22 +++---
 options.c                 |    5 +-
 t/btrace2fio.c            |  177 ++++++++++++++++++++++++++++++++++++++++++---
 8 files changed, 210 insertions(+), 36 deletions(-)

---

Diff of recent changes:

diff --git a/HOWTO b/HOWTO
index 57d3fb7..8da5527 100644
--- a/HOWTO
+++ b/HOWTO
@@ -462,23 +462,26 @@ fadvise_hint=bool By default, fio will use fadvise() to advise the kernel
 
 size=int	The total size of file io for this job. Fio will run until
 		this many bytes has been transferred, unless runtime is
-		limited by other options (such as 'runtime', for instance).
-		Unless specific nrfiles and filesize options are given,
-		fio will divide this size between the available files
-		specified by the job. If not set, fio will use the full
-		size of the given files or devices. If the files do not
-		exist, size must be given. It is also possible to give
-		size as a percentage between 1 and 100. If size=20% is
-		given, fio will use 20% of the full size of the given
-		files or devices.
-
+		limited by other options (such as 'runtime', for instance,
+		or increased/decreased by 'io_size'). Unless specific nrfiles
+		and filesize options are given, fio will divide this size
+		between the available files specified by the job. If not set,
+		fio will use the full size of the given files or devices.
+		If the files do not exist, size must be given. It is also
+		possible to give size as a percentage between 1 and 100. If
+		size=20% is given, fio will use 20% of the full size of the
+		given files or devices.
+
+io_size=int
 io_limit=int	Normally fio operates within the region set by 'size', which
 		means that the 'size' option sets both the region and size of
 		IO to be performed. Sometimes that is not what you want. With
 		this option, it is possible to define just the amount of IO
 		that fio should do. For instance, if 'size' is set to 20G and
-		'io_limit' is set to 5G, fio will perform IO within the first
-		20G but exit when 5G have been done.
+		'io_size' is set to 5G, fio will perform IO within the first
+		20G but exit when 5G have been done. The opposite is also
+		possible - if 'size' is set to 20G, and 'io_size' is set to
+		40G, then fio will do 40G of IO within the 0..20G region.
 
 filesize=int	Individual file sizes. May be a range, in which case fio
 		will select sizes for files at random within the given range
diff --git a/Makefile b/Makefile
index ff00c0c..52e515b 100644
--- a/Makefile
+++ b/Makefile
@@ -40,7 +40,7 @@ SOURCE := gettime.c ioengines.c init.c stat.c log.c time.c filesetup.c \
 
 ifdef CONFIG_LIBHDFS
   HDFSFLAGS= -I $(JAVA_HOME)/include -I $(JAVA_HOME)/include/linux -I $(FIO_LIBHDFS_INCLUDE)
-  HDFSLIB= $(JAVA_HOME)/jre/lib/amd64/server/libjvm.so $(FIO_LIBHDFS_LIB)/liblibhdfs.a
+  HDFSLIB= -Wl,-rpath $(JAVA_HOME)/jre/lib/amd64/server -L$(JAVA_HOME)/jre/lib/amd64/server -ljvm $(FIO_LIBHDFS_LIB)/libhdfs.a
   CFLAGS += $(HDFSFLAGS)
   SOURCE += engines/libhdfs.c
 endif
@@ -334,7 +334,7 @@ fio: $(FIO_OBJS)
 	$(QUIET_LINK)$(CC) $(LDFLAGS) $(CFLAGS) -o $@ $(FIO_OBJS) $(LIBS) $(HDFSLIB)
 
 gfio: $(GFIO_OBJS)
-	$(QUIET_LINK)$(CC) $(filter-out -static, $(LDFLAGS)) -o gfio $(GFIO_OBJS) $(LIBS) $(GFIO_LIBS) $(GTK_LDFLAGS)
+	$(QUIET_LINK)$(CC) $(filter-out -static, $(LDFLAGS)) -o gfio $(GFIO_OBJS) $(LIBS) $(GFIO_LIBS) $(GTK_LDFLAGS) $(HDFSLIB)
 
 t/fio-genzipf: $(T_ZIPF_OBJS)
 	$(QUIET_LINK)$(CC) $(LDFLAGS) $(CFLAGS) -o $@ $(T_ZIPF_OBJS) $(LIBS)
diff --git a/configure b/configure
index 5e5596d..172b235 100755
--- a/configure
+++ b/configure
@@ -1566,7 +1566,10 @@ if test "$gf_trim" = "yes" ; then
 fi
 if test "$libhdfs" = "yes" ; then
   output_sym "CONFIG_LIBHDFS"
-fi
+  echo "JAVA_HOME=$JAVA_HOME" >> $config_host_mak
+  echo "FIO_LIBHDFS_INCLUDE=$FIO_LIBHDFS_INCLUDE" >> $config_host_mak
+  echo "FIO_LIBHDFS_LIB=$FIO_LIBHDFS_LIB" >> $config_host_mak
+ fi
 if test "$arith" = "yes" ; then
   output_sym "CONFIG_ARITHMETIC"
   if test "$yacc_is_bison" = "yes" ; then
diff --git a/engines/glusterfs_async.c b/engines/glusterfs_async.c
index 95ca84e..8283f8b 100644
--- a/engines/glusterfs_async.c
+++ b/engines/glusterfs_async.c
@@ -117,6 +117,8 @@ static int fio_gf_async_queue(struct thread_data fio_unused * td,
 		r = glfs_discard_async(g->fd, io_u->offset, io_u->xfer_buflen,
 				       gf_async_cb, io_u);
 #endif
+	else if (io_u->ddir == DDIR_DATASYNC)
+		r = glfs_fdatasync_async(g->fd, gf_async_cb, io_u);
 	else if (io_u->ddir == DDIR_SYNC)
 		r = glfs_fsync_async(g->fd, gf_async_cb, io_u);
 	else
diff --git a/engines/glusterfs_sync.c b/engines/glusterfs_sync.c
index 235d74f..6de4ee2 100644
--- a/engines/glusterfs_sync.c
+++ b/engines/glusterfs_sync.c
@@ -41,6 +41,10 @@ static int fio_gf_queue(struct thread_data *td, struct io_u *io_u)
 		ret = glfs_read(g->fd, io_u->xfer_buf, io_u->xfer_buflen, 0);
 	else if (io_u->ddir == DDIR_WRITE)
 		ret = glfs_write(g->fd, io_u->xfer_buf, io_u->xfer_buflen, 0);
+	else if (io_u->ddir == DDIR_SYNC)
+		ret = glfs_fsync(g->fd);
+	else if (io_u->ddir == DDIR_DATASYNC)
+		ret = glfs_fdatasync(g->fd);
 	else {
 		log_err("unsupported operation.\n");
 		return -EINVAL;
diff --git a/fio.1 b/fio.1
index 0e66206..33b26cc 100644
--- a/fio.1
+++ b/fio.1
@@ -377,21 +377,23 @@ are likely to be issued. Default: true.
 .TP
 .BI size \fR=\fPint
 Total size of I/O for this job.  \fBfio\fR will run until this many bytes have
-been transferred, unless limited by other options (\fBruntime\fR, for instance).
-Unless \fBnrfiles\fR and \fBfilesize\fR options are given, this amount will be
-divided between the available files for the job. If not set, fio will use the
-full size of the given files or devices. If the files do not exist, size
-must be given. It is also possible to give size as a percentage between 1 and
-100. If size=20% is given, fio will use 20% of the full size of the given
-files or devices.
-.TP
-.BI io_limit \fR=\fPint
+been transferred, unless limited by other options (\fBruntime\fR, for instance,
+or increased/descreased by \fBio_size\fR). Unless \fBnrfiles\fR and
+\fBfilesize\fR options are given, this amount will be divided between the
+available files for the job. If not set, fio will use the full size of the
+given files or devices. If the files do not exist, size must be given. It is
+also possible to give size as a percentage between 1 and 100. If size=20% is
+given, fio will use 20% of the full size of the given files or devices.
+.TP
+.BI io_size \fR=\fPint "\fR,\fB io_limit \fR=\fPint
 Normally fio operates within the region set by \fBsize\fR, which means that
 the \fBsize\fR option sets both the region and size of IO to be performed.
 Sometimes that is not what you want. With this option, it is possible to
 define just the amount of IO that fio should do. For instance, if \fBsize\fR
 is set to 20G and \fBio_limit\fR is set to 5G, fio will perform IO within
-the first 20G but exit when 5G have been done.
+the first 20G but exit when 5G have been done. The opposite is also
+possible - if \fBsize\fR is set to 20G, and \fBio_size\fR is set to 40G, then
+fio will do 40G of IO within the 0..20G region.
 .TP
 .BI fill_device \fR=\fPbool "\fR,\fB fill_fs" \fR=\fPbool
 Sets size to something really large and waits for ENOSPC (no space left on
diff --git a/options.c b/options.c
index afca727..a01b2d9 100644
--- a/options.c
+++ b/options.c
@@ -1641,8 +1641,9 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.group	= FIO_OPT_G_INVALID,
 	},
 	{
-		.name	= "io_limit",
-		.lname	= "IO Limit",
+		.name	= "io_size",
+		.alias	= "io_limit",
+		.lname	= "IO Size",
 		.type	= FIO_OPT_STR_VAL,
 		.off1	= td_var_offset(io_limit),
 		.interval = 1024 * 1024,
diff --git a/t/btrace2fio.c b/t/btrace2fio.c
index 04d4a28..fc1e4c7 100644
--- a/t/btrace2fio.c
+++ b/t/btrace2fio.c
@@ -2,6 +2,7 @@
 #include <stdio.h>
 #include <unistd.h>
 #include <inttypes.h>
+#include <math.h>
 #include <assert.h>
 
 #include "../io_ddir.h"
@@ -23,6 +24,13 @@ static unsigned int max_depth = 256;
 static int output_ascii = 1;
 static char *filename;
 
+/*
+ * Collapse defaults
+ */
+static unsigned int collapse_entries = 0;
+static unsigned int depth_diff = 1;
+static unsigned int random_diff = 5;
+
 struct bs {
 	unsigned int bs;
 	unsigned int nr;
@@ -61,9 +69,14 @@ struct btrace_pid {
 	struct flist_head pid_list;
 	pid_t pid;
 
+	pid_t *merge_pids;
+	unsigned int nr_merge_pids;
+
 	struct trace_file *files;
 	int nr_files;
 	unsigned int last_major, last_minor;
+	int numjobs;
+	int ignore;
 
 	struct btrace_out o;
 };
@@ -448,6 +461,7 @@ static struct btrace_pid *pid_hash_get(pid_t pid)
 		}
 
 		p->pid = pid;
+		p->numjobs = 1;
 		flist_add_tail(&p->hash_list, hash_list);
 		flist_add_tail(&p->pid_list, &pid_list);
 	}
@@ -585,7 +599,11 @@ static void __output_p_ascii(struct btrace_pid *p, unsigned long *ios)
 	unsigned long total, usec;
 	int i, j;
 
-	printf("[pid:\t%u]\n", p->pid);
+	printf("[pid:\t%u", p->pid);
+	if (p->nr_merge_pids)
+		for (i = 0; i < p->nr_merge_pids; i++)
+			printf(", %u", p->merge_pids[i]);
+	printf("]\n");
 
 	total = ddir_rw_sum(o->ios);
 	for (i = 0; i < DDIR_RWDIR_CNT; i++) {
@@ -641,7 +659,13 @@ static int __output_p_fio(struct btrace_pid *p, unsigned long *ios)
 		return 1;
 	}
 
-	printf("[pid%u]\n", p->pid);
+	printf("[pid%u", p->pid);
+	if (p->nr_merge_pids)
+		for (i = 0; i < p->nr_merge_pids; i++)
+			printf(",pid%u", p->merge_pids[i]);
+	printf("]\n");
+
+	printf("numjobs=%u\n", p->numjobs);
 	printf("direct=1\n");
 	if (o->depth == 1)
 		printf("ioengine=sync\n");
@@ -658,7 +682,7 @@ static int __output_p_fio(struct btrace_pid *p, unsigned long *ios)
 		printf("rw=randrw\n");
 		total = ddir_rw_sum(o->ios);
 		perc = ((float) o->ios[0] * 100.0) / (float) total;
-		printf("rwmixread=%u\n", (int) (perc + 0.99));
+		printf("rwmixread=%u\n", (int) floor(perc + 0.50));
 	}
 
 	printf("percentage_random=");
@@ -673,7 +697,7 @@ static int __output_p_fio(struct btrace_pid *p, unsigned long *ios)
 		if (i)
 			printf(",");
 		perc = 100.0 - perc;
-		printf("%u", (int) perc);
+		printf("%u", (int) floor(perc + 0.5));
 	}
 	printf("\n");
 
@@ -685,7 +709,8 @@ static int __output_p_fio(struct btrace_pid *p, unsigned long *ios)
 	}
 	printf("\n");
 
-	printf("startdelay=%llus\n", o->start_delay / 1000000ULL);
+	if (o->start_delay / 1000000ULL)
+		printf("startdelay=%llus\n", o->start_delay / 1000000ULL);
 
 	time = o_longest_ttime(o);
 	time = (time + 1000000000ULL - 1) / 1000000000ULL;
@@ -708,7 +733,7 @@ static int __output_p_fio(struct btrace_pid *p, unsigned long *ios)
 			if (j + 1 == o->nr_bs[i])
 				printf("%u/", bs->bs);
 			else
-				printf("%u/%u", bs->bs, (int) perc);
+				printf("%u/%u", bs->bs, (int) floor(perc + 0.5));
 		}
 	}
 	printf("\n");
@@ -819,6 +844,113 @@ static void free_p(struct btrace_pid *p)
 	free(p);
 }
 
+static int entries_close(struct btrace_pid *pida, struct btrace_pid *pidb)
+{
+	float perca, percb, fdiff;
+	int i, idiff;
+
+	for (i = 0; i < DDIR_RWDIR_CNT; i++) {
+		if ((pida->o.ios[i] && !pidb->o.ios[i]) ||
+		    (pidb->o.ios[i] && !pida->o.ios[i]))
+			return 0;
+		if (pida->o.ios[i] && pidb->o.ios[i]) {
+			perca = ((float) pida->o.seq[i] * 100.0) / (float) pida->o.ios[i];
+			percb = ((float) pidb->o.seq[i] * 100.0) / (float) pidb->o.ios[i];
+			fdiff = perca - percb;
+			if (fabs(fdiff) > random_diff)
+				return 0;
+		}
+
+		idiff = pida->o.depth - pidb->o.depth;
+		if (abs(idiff) > depth_diff)
+			return 0;
+	}
+
+	return 1;
+}
+
+static void merge_bs(struct bs **bsap, unsigned int *nr_bsap,
+		     struct bs *bsb, unsigned int nr_bsb)
+{
+	struct bs *bsa = *bsap;
+	unsigned int nr_bsa = *nr_bsap;
+	int a, b;
+
+	for (b = 0; b < nr_bsb; b++) {
+		int next, found = 0;
+
+		for (a = 0; a < nr_bsa; a++) {
+			if (bsb[b].bs != bsa[a].bs)
+				continue;
+
+			bsa[a].nr += bsb[b].nr;
+			bsa[a].merges += bsb[b].merges;
+			found = 1;
+			break;
+		}
+
+		if (found)
+			continue;
+
+		next = *nr_bsap;
+		bsa = realloc(bsa, (next + 1) * sizeof(struct bs));
+		bsa[next].bs = bsb[b].bs;
+		bsa[next].nr = bsb[b].nr;
+		(*nr_bsap)++;
+		*bsap = bsa;
+	}
+}
+
+static int merge_entries(struct btrace_pid *pida, struct btrace_pid *pidb)
+{
+	int i;
+
+	if (!entries_close(pida, pidb))
+		return 0;
+
+	pida->nr_merge_pids++;
+	pida->merge_pids = realloc(pida->merge_pids, pida->nr_merge_pids * sizeof(pid_t));
+	pida->merge_pids[pida->nr_merge_pids - 1] = pidb->pid;
+
+	for (i = 0; i < DDIR_RWDIR_CNT; i++) {
+		struct btrace_out *oa = &pida->o;
+		struct btrace_out *ob = &pidb->o;
+
+		oa->ios[i] += ob->ios[i];
+		oa->merges[i] += ob->merges[i];
+		oa->seq[i] += ob->seq[i];
+		oa->kb[i] += ob->kb[i];
+		oa->first_ttime[i] = min(oa->first_ttime[i], ob->first_ttime[i]);
+		oa->last_ttime[i] = max(oa->last_ttime[i], ob->last_ttime[i]);
+		merge_bs(&oa->bs[i], &oa->nr_bs[i], ob->bs[i], ob->nr_bs[i]);
+	}
+
+	pida->o.start_delay = min(pida->o.start_delay, pidb->o.start_delay);
+	pida->o.depth = (pida->o.depth + pidb->o.depth) / 2;
+	return 1;
+}
+
+static void check_merges(struct btrace_pid *p, struct flist_head *pid_list)
+{
+	struct flist_head *e, *tmp;
+
+	if (p->ignore)
+		return;
+
+	flist_for_each_safe(e, tmp, pid_list) {
+		struct btrace_pid *pidb;
+
+		pidb = flist_entry(e, struct btrace_pid, pid_list);
+		if (pidb == p)
+			continue;
+
+		if (merge_entries(p, pidb)) {
+			pidb->ignore = 1;
+			p->numjobs++;
+		}
+	}
+}
+
 static int output_p(void)
 {
 	unsigned long ios[DDIR_RWDIR_CNT];
@@ -838,6 +970,21 @@ static int output_p(void)
 		depth_disabled += p->o.depth_disabled;
 	}
 
+	if (collapse_entries) {
+		struct btrace_pid *p;
+
+		flist_for_each_safe(e, tmp, &pid_list) {
+			p = flist_entry(e, struct btrace_pid, pid_list);
+			check_merges(p, &pid_list);
+		}
+
+		flist_for_each_safe(e, tmp, &pid_list) {
+			p = flist_entry(e, struct btrace_pid, pid_list);
+			if (p->ignore)
+				free_p(p);
+		}
+	}
+
 	if (depth_disabled)
 		log_err("fio: missing completion traces, depths capped at %u\n", max_depth);
 
@@ -862,14 +1009,17 @@ static int output_p(void)
 
 static int usage(char *argv[])
 {
-	log_err("%s: <blktrace bin file>\n", argv[0]);
+	log_err("%s: [options] <blktrace bin file>\n", argv[0]);
 	log_err("\t-t\tUsec threshold to ignore task\n");
 	log_err("\t-n\tNumber IOS threshold to ignore task\n");
 	log_err("\t-f\tFio job file output\n");
 	log_err("\t-d\tUse this file/device for replay\n");
 	log_err("\t-r\tIgnore jobs with less than this KB/sec rate\n");
-	log_err("\t-R\tSet rate in fio job\n");
+	log_err("\t-R\tSet rate in fio job (def=%u)\n", set_rate);
 	log_err("\t-D\tCap queue depth at this value (def=%u)\n", max_depth);
+	log_err("\t-c\tCollapse \"identical\" jobs (def=%u)\n", collapse_entries);
+	log_err("\t-u\tDepth difference for collapse (def=%u)\n", depth_diff);
+	log_err("\t-x\tRandom difference for collapse (def=%u)\n", random_diff);
 	return 1;
 }
 
@@ -925,7 +1075,7 @@ int main(int argc, char *argv[])
 	if (argc < 2)
 		return usage(argv);
 
-	while ((c = getopt(argc, argv, "t:n:fd:r:RD:")) != -1) {
+	while ((c = getopt(argc, argv, "t:n:fd:r:RD:c:u:x:")) != -1) {
 		switch (c) {
 		case 'R':
 			set_rate = 1;
@@ -948,6 +1098,15 @@ int main(int argc, char *argv[])
 		case 'D':
 			max_depth = atoi(optarg);
 			break;
+		case 'c':
+			collapse_entries = atoi(optarg);
+			break;
+		case 'u':
+			depth_diff = atoi(optarg);
+			break;
+		case 'x':
+			random_diff = atoi(optarg);
+			break;
 		case '?':
 		default:
 			return usage(argv);
