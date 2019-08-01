Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:35436 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727455AbfHAMAM (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 1 Aug 2019 08:00:12 -0400
Received: from [65.144.74.35] (helo=kernel.dk)
        by bombadil.infradead.org with esmtpsa (Exim 4.92 #3 (Red Hat Linux))
        id 1ht9ki-0007uy-1u
        for fio@vger.kernel.org; Thu, 01 Aug 2019 12:00:12 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20190801120002.064092C0099@kernel.dk>
Date: Thu,  1 Aug 2019 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 029b42ace698eae477c5e261d2f82b191507526b:

  Document io_uring feature (2019-07-26 09:53:43 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 66b182f90c3f08dcbd0592ce70cb350ca5ac0cc0:

  smalloc: cleanup firstfree() (2019-07-31 15:29:48 -0600)

----------------------------------------------------------------
Alexander Kapshuna (1):
      fio2gnuplot: fix TabErrors when running with Python 3

Damien Le Moal (1):
      bssplit: Fix handling of 0 percentage

Jens Axboe (5):
      Merge branch 'gnuplot-tabs' of https://github.com/kapsh/fio
      Merge branch 'dev' of https://github.com/smartxworks/fio
      Merge branch 'smalloc-gc' of https://github.com/vincentkfu/fio
      Remove unused fio_assert()
      smalloc: cleanup firstfree()

Kyle Zhang (1):
      libiscsi: continue working when meets EINTR or EAGAIN

Vincent Fu (4):
      smalloc: print debug info on oom error
      t/stest: make the test more challenging
      smalloc: fix garbage collection problem
      smalloc: fix compiler warning on Windows

 engines/libiscsi.c     |   3 +
 fio.h                  |  10 ---
 io_u.c                 |   4 +-
 smalloc.c              | 108 ++++++++++++++++++++++-
 smalloc.h              |   1 +
 t/stest.c              |  21 ++++-
 tools/plot/fio2gnuplot | 234 ++++++++++++++++++++++++-------------------------
 7 files changed, 247 insertions(+), 134 deletions(-)

---

Diff of recent changes:

diff --git a/engines/libiscsi.c b/engines/libiscsi.c
index bea94c5a..58667fb2 100644
--- a/engines/libiscsi.c
+++ b/engines/libiscsi.c
@@ -351,6 +351,9 @@ static int fio_iscsi_getevents(struct thread_data *td, unsigned int min,
 
 		ret = poll(iscsi_info->pfds, iscsi_info->nr_luns, -1);
 		if (ret < 0) {
+			if (errno == EINTR || errno == EAGAIN) {
+				continue;
+			}
 			log_err("iscsi: failed to poll events: %s.\n",
 				strerror(errno));
 			break;
diff --git a/fio.h b/fio.h
index 2103151d..2094d30b 100644
--- a/fio.h
+++ b/fio.h
@@ -705,16 +705,6 @@ extern void lat_target_reset(struct thread_data *);
 	    	 (i) < (td)->o.nr_files && ((f) = (td)->files[i]) != NULL; \
 		 (i)++)
 
-#define fio_assert(td, cond)	do {	\
-	if (!(cond)) {			\
-		int *__foo = NULL;	\
-		fprintf(stderr, "file:%s:%d, assert %s failed\n", __FILE__, __LINE__, #cond);	\
-		td_set_runstate((td), TD_EXITED);	\
-		(td)->error = EFAULT;		\
-		*__foo = 0;			\
-	}	\
-} while (0)
-
 static inline bool fio_fill_issue_time(struct thread_data *td)
 {
 	if (td->o.read_iolog_file ||
diff --git a/io_u.c b/io_u.c
index 910b7deb..80df2854 100644
--- a/io_u.c
+++ b/io_u.c
@@ -557,10 +557,10 @@ static unsigned long long get_next_buflen(struct thread_data *td, struct io_u *i
 			for (i = 0; i < td->o.bssplit_nr[ddir]; i++) {
 				struct bssplit *bsp = &td->o.bssplit[ddir][i];
 
+				if (!bsp->perc)
+					continue;
 				buflen = bsp->bs;
 				perc += bsp->perc;
-				if (!perc)
-					break;
 				if ((r / perc <= frand_max / 100ULL) &&
 				    io_u_fits(td, io_u, buflen))
 					break;
diff --git a/smalloc.c b/smalloc.c
index a2ad25a0..125e07bf 100644
--- a/smalloc.c
+++ b/smalloc.c
@@ -48,6 +48,12 @@ struct block_hdr {
 #endif
 };
 
+/*
+ * This suppresses the voluminous potential bitmap printout when
+ * smalloc encounters an OOM error
+ */
+static const bool enable_smalloc_debug = false;
+
 static struct pool mp[MAX_POOLS];
 static unsigned int nr_pools;
 static unsigned int last_pool;
@@ -332,6 +338,25 @@ void sfree(void *ptr)
 	log_err("smalloc: ptr %p not from smalloc pool\n", ptr);
 }
 
+static unsigned int find_best_index(struct pool *pool)
+{
+	unsigned int i;
+
+	assert(pool->free_blocks);
+
+	for (i = pool->next_non_full; pool->bitmap[i] == -1U; i++) {
+		if (i == pool->nr_blocks - 1) {
+			unsigned int j;
+
+			for (j = 0; j < pool->nr_blocks; j++)
+				if (pool->bitmap[j] != -1U)
+					return j;
+		}
+	}
+
+	return i;
+}
+
 static void *__smalloc_pool(struct pool *pool, size_t size)
 {
 	size_t nr_blocks;
@@ -346,15 +371,16 @@ static void *__smalloc_pool(struct pool *pool, size_t size)
 	if (nr_blocks > pool->free_blocks)
 		goto fail;
 
-	i = pool->next_non_full;
+	pool->next_non_full = find_best_index(pool);
+
 	last_idx = 0;
 	offset = -1U;
+	i = pool->next_non_full;
 	while (i < pool->nr_blocks) {
 		unsigned int idx;
 
 		if (pool->bitmap[i] == -1U) {
 			i++;
-			pool->next_non_full = i;
 			last_idx = 0;
 			continue;
 		}
@@ -387,10 +413,9 @@ fail:
 	return ret;
 }
 
-static void *smalloc_pool(struct pool *pool, size_t size)
+static size_t size_to_alloc_size(size_t size)
 {
 	size_t alloc_size = size + sizeof(struct block_hdr);
-	void *ptr;
 
 	/*
 	 * Round to int alignment, so that the postred pointer will
@@ -401,6 +426,14 @@ static void *smalloc_pool(struct pool *pool, size_t size)
 	alloc_size = (alloc_size + int_mask) & ~int_mask;
 #endif
 
+	return alloc_size;
+}
+
+static void *smalloc_pool(struct pool *pool, size_t size)
+{
+	size_t alloc_size = size_to_alloc_size(size);
+	void *ptr;
+
 	ptr = __smalloc_pool(pool, alloc_size);
 	if (ptr) {
 		struct block_hdr *hdr = ptr;
@@ -415,6 +448,72 @@ static void *smalloc_pool(struct pool *pool, size_t size)
 	return ptr;
 }
 
+static void smalloc_print_bitmap(struct pool *pool)
+{
+	size_t nr_blocks = pool->nr_blocks;
+	unsigned int *bitmap = pool->bitmap;
+	unsigned int i, j;
+	char *buffer;
+
+	if (!enable_smalloc_debug)
+		return;
+
+	buffer = malloc(SMALLOC_BPI + 1);
+	if (!buffer)
+		return;
+	buffer[SMALLOC_BPI] = '\0';
+
+	for (i = 0; i < nr_blocks; i++) {
+		unsigned int line = bitmap[i];
+
+		/* skip completely full lines */
+		if (line == -1U)
+			continue;
+
+		for (j = 0; j < SMALLOC_BPI; j++)
+			if ((1 << j) & line)
+				buffer[SMALLOC_BPI-1-j] = '1';
+			else
+				buffer[SMALLOC_BPI-1-j] = '0';
+
+		log_err("smalloc: bitmap %5u, %s\n", i, buffer);
+	}
+
+	free(buffer);
+}
+
+void smalloc_debug(size_t size)
+{
+	unsigned int i;
+	size_t alloc_size = size_to_alloc_size(size);
+	size_t alloc_blocks;
+
+	alloc_blocks = size_to_blocks(alloc_size);
+
+	if (size)
+		log_err("smalloc: size = %lu, alloc_size = %lu, blocks = %lu\n",
+			(unsigned long) size, (unsigned long) alloc_size,
+			(unsigned long) alloc_blocks);
+	for (i = 0; i < nr_pools; i++) {
+		log_err("smalloc: pool %u, free/total blocks %u/%u\n", i,
+			(unsigned int) (mp[i].free_blocks),
+			(unsigned int) (mp[i].nr_blocks*sizeof(unsigned int)*8));
+		if (size && mp[i].free_blocks >= alloc_blocks) {
+			void *ptr = smalloc_pool(&mp[i], size);
+			if (ptr) {
+				sfree(ptr);
+				last_pool = i;
+				log_err("smalloc: smalloc_pool %u succeeded\n", i);
+			} else {
+				log_err("smalloc: smalloc_pool %u failed\n", i);
+				log_err("smalloc: next_non_full=%u, nr_blocks=%u\n",
+					(unsigned int) mp[i].next_non_full, (unsigned int) mp[i].nr_blocks);
+				smalloc_print_bitmap(&mp[i]);
+			}
+		}
+	}
+}
+
 void *smalloc(size_t size)
 {
 	unsigned int i, end_pool;
@@ -445,6 +544,7 @@ void *smalloc(size_t size)
 
 	log_err("smalloc: OOM. Consider using --alloc-size to increase the "
 		"shared memory available.\n");
+	smalloc_debug(size);
 	return NULL;
 }
 
diff --git a/smalloc.h b/smalloc.h
index 8df10e6f..1f7716f4 100644
--- a/smalloc.h
+++ b/smalloc.h
@@ -9,6 +9,7 @@ extern void sfree(void *);
 extern char *smalloc_strdup(const char *);
 extern void sinit(void);
 extern void scleanup(void);
+extern void smalloc_debug(size_t);
 
 extern unsigned int smalloc_pool_size;
 
diff --git a/t/stest.c b/t/stest.c
index b95968f1..515ae5a5 100644
--- a/t/stest.c
+++ b/t/stest.c
@@ -11,11 +11,14 @@
 #define MAGIC2	0xf0a1e9b3
 
 #define LOOPS	32
+#define MAXSMALLOC	120*1024*1024UL
+#define LARGESMALLOC	128*1024U
 
 struct elem {
 	unsigned int magic1;
 	struct flist_head list;
 	unsigned int magic2;
+	unsigned int size;
 };
 
 static FLIST_HEAD(list);
@@ -25,13 +28,15 @@ static int do_rand_allocs(void)
 	unsigned int size, nr, rounds = 0;
 	unsigned long total;
 	struct elem *e;
+	bool error;
 
 	while (rounds++ < LOOPS) {
 #ifdef STEST_SEED
 		srand(MAGIC1);
 #endif
+		error = false;
 		nr = total = 0;
-		while (total < 120*1024*1024UL) {
+		while (total < MAXSMALLOC) {
 			size = 8 * sizeof(struct elem) + (int) (999.0 * (rand() / (RAND_MAX + 1.0)));
 			e = smalloc(size);
 			if (!e) {
@@ -40,6 +45,7 @@ static int do_rand_allocs(void)
 			}
 			e->magic1 = MAGIC1;
 			e->magic2 = MAGIC2;
+			e->size = size;
 			total += size;
 			flist_add_tail(&e->list, &list);
 			nr++;
@@ -51,8 +57,20 @@ static int do_rand_allocs(void)
 			e = flist_entry(list.next, struct elem, list);
 			assert(e->magic1 == MAGIC1);
 			assert(e->magic2 == MAGIC2);
+			total -= e->size;
 			flist_del(&e->list);
 			sfree(e);
+
+			if (!error) {
+				e = smalloc(LARGESMALLOC);
+				if (!e) {
+					error = true;
+					printf("failure allocating %u bytes at %lu allocated during sfree phase\n",
+						LARGESMALLOC, total);
+				}
+				else
+					sfree(e);
+			}
 		}
 	}
 
@@ -66,6 +84,7 @@ int main(int argc, char *argv[])
 	debug_init();
 
 	do_rand_allocs();
+	smalloc_debug(0);	/* free and total blocks should match */
 
 	scleanup();
 	return 0;
diff --git a/tools/plot/fio2gnuplot b/tools/plot/fio2gnuplot
index 4d1815cf..cc4ea4c7 100755
--- a/tools/plot/fio2gnuplot
+++ b/tools/plot/fio2gnuplot
@@ -36,10 +36,10 @@ def find_file(path, pattern):
 	fio_data_file=[]
 	# For all the local files
 	for file in os.listdir(path):
-	    # If the file matches the glob
-	    if fnmatch.fnmatch(file, pattern):
-		# Let's consider this file
-		fio_data_file.append(file)
+		# If the file matches the glob
+		if fnmatch.fnmatch(file, pattern):
+			# Let's consider this file
+			fio_data_file.append(file)
 
 	return fio_data_file
 
@@ -51,7 +51,7 @@ def generate_gnuplot_script(fio_data_file,title,gnuplot_output_filename,gnuplot_
 
 	# Plotting 3D or comparing graphs doesn't have a meaning unless if there is at least 2 traces
 	if len(fio_data_file) > 1:
-        	f.write("call \'%s/graph3D.gpm\' \'%s' \'%s\' \'\' \'%s\' \'%s\'\n" % (gpm_dir,title,gnuplot_output_filename,gnuplot_output_filename,mode))
+		f.write("call \'%s/graph3D.gpm\' \'%s' \'%s\' \'\' \'%s\' \'%s\'\n" % (gpm_dir,title,gnuplot_output_filename,gnuplot_output_filename,mode))
 
 		# Setting up the compare files that will be plot later
 		compare=open(gnuplot_output_dir + 'compare.gnuplot','w')
@@ -93,10 +93,10 @@ set style line 1 lt 1 lw 3 pt 3 linecolor rgb "green"
 		compare_smooth.write("plot %s w l ls 1 ti 'Global average value (%.2f)'" % (global_avg,global_avg));
 		compare_trend.write("plot %s w l ls 1 ti 'Global average value (%.2f)'" % (global_avg,global_avg));
 
-        pos=0
-        # Let's create a temporary file for each selected fio file
-        for file in fio_data_file:
-                tmp_filename = "gnuplot_temp_file.%d" % pos
+		pos=0
+		# Let's create a temporary file for each selected fio file
+		for file in fio_data_file:
+			tmp_filename = "gnuplot_temp_file.%d" % pos
 
 		# Plotting comparing graphs doesn't have a meaning unless if there is at least 2 traces
 		if len(fio_data_file) > 1:
@@ -106,12 +106,12 @@ set style line 1 lt 1 lw 3 pt 3 linecolor rgb "green"
 			compare_trend.write(",\\\n'%s' using 2:3 smooth bezier title '%s'" % (tmp_filename,fio_data_file[pos]))
 
 		png_file=file.replace('.log','')
-                raw_filename = "%s-2Draw" % (png_file)
-                smooth_filename = "%s-2Dsmooth" % (png_file)
-                trend_filename = "%s-2Dtrend" % (png_file)
-                avg  = average(disk_perf[pos])
-                f.write("call \'%s/graph2D.gpm\' \'%s' \'%s\' \'%s\' \'%s\' \'%s\' \'%s\' \'%s\' \'%f\'\n" % (gpm_dir,title,tmp_filename,fio_data_file[pos],raw_filename,mode,smooth_filename,trend_filename,avg))
-                pos = pos +1
+		raw_filename = "%s-2Draw" % (png_file)
+		smooth_filename = "%s-2Dsmooth" % (png_file)
+		trend_filename = "%s-2Dtrend" % (png_file)
+		avg  = average(disk_perf[pos])
+		f.write("call \'%s/graph2D.gpm\' \'%s' \'%s\' \'%s\' \'%s\' \'%s\' \'%s\' \'%s\' \'%f\'\n" % (gpm_dir,title,tmp_filename,fio_data_file[pos],raw_filename,mode,smooth_filename,trend_filename,avg))
+		pos = pos +1
 
 	# Plotting comparing graphs doesn't have a meaning unless if there is at least 2 traces
 	if len(fio_data_file) > 1:
@@ -125,7 +125,7 @@ def generate_gnuplot_math_script(title,gnuplot_output_filename,mode,average,gnup
 	filename=gnuplot_output_dir+'mymath';
 	temporary_files.append(filename)
 	f=open(filename,'a')
-        f.write("call \'%s/math.gpm\' \'%s' \'%s\' \'\' \'%s\' \'%s\' %s\n" % (gpm_dir,title,gnuplot_output_filename,gnuplot_output_filename,mode,average))
+	f.write("call \'%s/math.gpm\' \'%s' \'%s\' \'\' \'%s\' \'%s\' %s\n" % (gpm_dir,title,gnuplot_output_filename,gnuplot_output_filename,mode,average))
 	f.close()
 
 def compute_aggregated_file(fio_data_file, gnuplot_output_filename, gnuplot_output_dir):
@@ -250,10 +250,10 @@ def compute_math(fio_data_file, title,gnuplot_output_filename,gnuplot_output_dir
 	stddev_file.write('DiskName %s\n'% mode )
 	for disk in range(len(fio_data_file)):
 #		print disk_perf[disk]
-	    	min_file.write("# Disk%d was coming from %s\n" % (disk,fio_data_file[disk]))
-	    	max_file.write("# Disk%d was coming from %s\n" % (disk,fio_data_file[disk]))
-	    	average_file.write("# Disk%d was coming from %s\n" % (disk,fio_data_file[disk]))
-	    	stddev_file.write("# Disk%d was coming from %s\n" % (disk,fio_data_file[disk]))
+		min_file.write("# Disk%d was coming from %s\n" % (disk,fio_data_file[disk]))
+		max_file.write("# Disk%d was coming from %s\n" % (disk,fio_data_file[disk]))
+		average_file.write("# Disk%d was coming from %s\n" % (disk,fio_data_file[disk]))
+		stddev_file.write("# Disk%d was coming from %s\n" % (disk,fio_data_file[disk]))
 		avg  = average(disk_perf[disk])
 		variance = [(x - avg)**2 for x in disk_perf[disk]]
 		standard_deviation = math.sqrt(average(variance))
@@ -406,126 +406,126 @@ def main(argv):
     force_keep_temp_files=False
 
     if not os.path.isfile(gpm_dir+'math.gpm'):
-	    gpm_dir="/usr/local/share/fio/"
-    	    if not os.path.isfile(gpm_dir+'math.gpm'):
-		    print("Looks like fio didn't get installed properly as no gpm files found in '/usr/share/fio' or '/usr/local/share/fio'\n")
-		    sys.exit(3)
+        gpm_dir="/usr/local/share/fio/"
+        if not os.path.isfile(gpm_dir+'math.gpm'):
+            print("Looks like fio didn't get installed properly as no gpm files found in '/usr/share/fio' or '/usr/local/share/fio'\n")
+            sys.exit(3)
 
     try:
-	    opts, args = getopt.getopt(argv[1:],"ghkbivo:d:t:p:G:m:M:",['bandwidth', 'iops', 'pattern', 'outputfile', 'outputdir', 'title', 'min_time', 'max_time', 'gnuplot', 'Global', 'help', 'verbose','keep'])
+        opts, args = getopt.getopt(argv[1:],"ghkbivo:d:t:p:G:m:M:",['bandwidth', 'iops', 'pattern', 'outputfile', 'outputdir', 'title', 'min_time', 'max_time', 'gnuplot', 'Global', 'help', 'verbose','keep'])
     except getopt.GetoptError:
-	 print("Error: One of the options passed to the cmdline was not supported")
-	 print("Please fix your command line or read the help (-h option)")
-         sys.exit(2)
+        print("Error: One of the options passed to the cmdline was not supported")
+        print("Please fix your command line or read the help (-h option)")
+        sys.exit(2)
 
     for opt, arg in opts:
-      if opt in ("-b", "--bandwidth"):
-         pattern='*_bw.log'
-      elif opt in ("-i", "--iops"):
-         pattern='*_iops.log'
-      elif opt in ("-v", "--verbose"):
-	 verbose=True
-      elif opt in ("-k", "--keep"):
-	 #User really wants to keep the temporary files
-	 force_keep_temp_files=True
-      elif opt in ("-p", "--pattern"):
-         pattern_set_by_user=True
-	 pattern=arg
-	 pattern=pattern.replace('\\','')
-      elif opt in ("-o", "--outputfile"):
-         gnuplot_output_filename=arg
-      elif opt in ("-d", "--outputdir"):
-         gnuplot_output_dir=arg
-	 if not gnuplot_output_dir.endswith('/'):
-		gnuplot_output_dir=gnuplot_output_dir+'/'
-	 if not os.path.exists(gnuplot_output_dir):
-		os.makedirs(gnuplot_output_dir)
-      elif opt in ("-t", "--title"):
-         title=arg
-      elif opt in ("-m", "--min_time"):
-	 min_time=arg
-      elif opt in ("-M", "--max_time"):
-	 max_time=arg
-      elif opt in ("-g", "--gnuplot"):
-	 run_gnuplot=True
-      elif opt in ("-G", "--Global"):
-	 parse_global=True
-	 global_search=arg
-      elif opt in ("-h", "--help"):
-	  print_help()
-	  sys.exit(1)
+        if opt in ("-b", "--bandwidth"):
+            pattern='*_bw.log'
+        elif opt in ("-i", "--iops"):
+            pattern='*_iops.log'
+        elif opt in ("-v", "--verbose"):
+            verbose=True
+        elif opt in ("-k", "--keep"):
+            #User really wants to keep the temporary files
+            force_keep_temp_files=True
+        elif opt in ("-p", "--pattern"):
+            pattern_set_by_user=True
+            pattern=arg
+            pattern=pattern.replace('\\','')
+        elif opt in ("-o", "--outputfile"):
+            gnuplot_output_filename=arg
+        elif opt in ("-d", "--outputdir"):
+            gnuplot_output_dir=arg
+            if not gnuplot_output_dir.endswith('/'):
+                gnuplot_output_dir=gnuplot_output_dir+'/'
+            if not os.path.exists(gnuplot_output_dir):
+                os.makedirs(gnuplot_output_dir)
+        elif opt in ("-t", "--title"):
+            title=arg
+        elif opt in ("-m", "--min_time"):
+            min_time=arg
+        elif opt in ("-M", "--max_time"):
+            max_time=arg
+        elif opt in ("-g", "--gnuplot"):
+            run_gnuplot=True
+        elif opt in ("-G", "--Global"):
+            parse_global=True
+            global_search=arg
+        elif opt in ("-h", "--help"):
+            print_help()
+            sys.exit(1)
 
     # Adding .global extension to the file
     if parse_global==True:
-	    if not gnuplot_output_filename.endswith('.global'):
-	    	pattern = pattern+'.global'
+        if not gnuplot_output_filename.endswith('.global'):
+            pattern = pattern+'.global'
 
     fio_data_file=find_file('.',pattern)
     if len(fio_data_file) == 0:
-	    print("No log file found with pattern %s!" % pattern)
-	    # Try numjob log file format if per_numjob_logs=1
-            if (pattern == '*_bw.log'):
-                fio_data_file=find_file('.','*_bw.*.log')
-            if (pattern == '*_iops.log'):
-                fio_data_file=find_file('.','*_iops.*.log')
-            if len(fio_data_file) == 0:
-                sys.exit(1)
-            else:
-                print("Using log file per job format instead")
+        print("No log file found with pattern %s!" % pattern)
+        # Try numjob log file format if per_numjob_logs=1
+        if (pattern == '*_bw.log'):
+            fio_data_file=find_file('.','*_bw.*.log')
+        if (pattern == '*_iops.log'):
+            fio_data_file=find_file('.','*_iops.*.log')
+        if len(fio_data_file) == 0:
+            sys.exit(1)
+        else:
+            print("Using log file per job format instead")
     else:
-	    print("%d files Selected with pattern '%s'" % (len(fio_data_file), pattern))
+        print("%d files Selected with pattern '%s'" % (len(fio_data_file), pattern))
 
     fio_data_file=sorted(fio_data_file, key=str.lower)
     for file in fio_data_file:
-	print(' |-> %s' % file)
-	if "_bw.log" in file :
-		mode="Bandwidth (KB/sec)"
-	if "_iops.log" in file :
-		mode="IO per Seconds (IO/sec)"
+        print(' |-> %s' % file)
+        if "_bw.log" in file :
+            mode="Bandwidth (KB/sec)"
+        if "_iops.log" in file :
+            mode="IO per Seconds (IO/sec)"
     if (title == 'No title') and (mode != 'unknown'):
-	    if "Bandwidth" in mode:
-		    title='Bandwidth benchmark with %d fio results' % len(fio_data_file)
-	    if "IO" in mode:
-		    title='IO benchmark with %d fio results' % len(fio_data_file)
+        if "Bandwidth" in mode:
+            title='Bandwidth benchmark with %d fio results' % len(fio_data_file)
+        if "IO" in mode:
+            title='IO benchmark with %d fio results' % len(fio_data_file)
 
     print()
     #We need to adjust the output filename regarding the pattern required by the user
     if (pattern_set_by_user == True):
-	    gnuplot_output_filename=pattern
-	    # As we do have some glob in the pattern, let's make this simpliest
-	    # We do remove the simpliest parts of the expression to get a clear file name
-	    gnuplot_output_filename=gnuplot_output_filename.replace('-*-','-')
-	    gnuplot_output_filename=gnuplot_output_filename.replace('*','-')
-	    gnuplot_output_filename=gnuplot_output_filename.replace('--','-')
-	    gnuplot_output_filename=gnuplot_output_filename.replace('.log','')
-	    # Insure that we don't have any starting or trailing dash to the filename
-	    gnuplot_output_filename = gnuplot_output_filename[:-1] if gnuplot_output_filename.endswith('-') else gnuplot_output_filename
-	    gnuplot_output_filename = gnuplot_output_filename[1:] if gnuplot_output_filename.startswith('-') else gnuplot_output_filename
-	    if (gnuplot_output_filename == ''):
-            	gnuplot_output_filename='default'	
+        gnuplot_output_filename=pattern
+        # As we do have some glob in the pattern, let's make this simpliest
+        # We do remove the simpliest parts of the expression to get a clear file name
+        gnuplot_output_filename=gnuplot_output_filename.replace('-*-','-')
+        gnuplot_output_filename=gnuplot_output_filename.replace('*','-')
+        gnuplot_output_filename=gnuplot_output_filename.replace('--','-')
+        gnuplot_output_filename=gnuplot_output_filename.replace('.log','')
+        # Insure that we don't have any starting or trailing dash to the filename
+        gnuplot_output_filename = gnuplot_output_filename[:-1] if gnuplot_output_filename.endswith('-') else gnuplot_output_filename
+        gnuplot_output_filename = gnuplot_output_filename[1:] if gnuplot_output_filename.startswith('-') else gnuplot_output_filename
+        if (gnuplot_output_filename == ''):
+            gnuplot_output_filename='default'
 
     if parse_global==True:
-	parse_global_files(fio_data_file, global_search)
+        parse_global_files(fio_data_file, global_search)
     else:
-    	blk_size=compute_temp_file(fio_data_file,disk_perf,gnuplot_output_dir,min_time,max_time)
-    	title="%s @ Blocksize = %dK" % (title,blk_size/1024)
-    	compute_aggregated_file(fio_data_file, gnuplot_output_filename, gnuplot_output_dir)
-    	compute_math(fio_data_file,title,gnuplot_output_filename,gnuplot_output_dir,mode,disk_perf,gpm_dir)
-    	generate_gnuplot_script(fio_data_file,title,gnuplot_output_filename,gnuplot_output_dir,mode,disk_perf,gpm_dir)
-
-    	if (run_gnuplot==True):
-    		render_gnuplot(fio_data_file, gnuplot_output_dir)
-
-	# Shall we clean the temporary files ?
-	if keep_temp_files==False and force_keep_temp_files==False:
-	    	# Cleaning temporary files
-		if verbose: print("Cleaning temporary files")
-		for f in enumerate(temporary_files):
-			if verbose: print(" -> %s"%f[1])
-			try:
-			    os.remove(f[1])
-			except:
-			    True
+        blk_size=compute_temp_file(fio_data_file,disk_perf,gnuplot_output_dir,min_time,max_time)
+        title="%s @ Blocksize = %dK" % (title,blk_size/1024)
+        compute_aggregated_file(fio_data_file, gnuplot_output_filename, gnuplot_output_dir)
+        compute_math(fio_data_file,title,gnuplot_output_filename,gnuplot_output_dir,mode,disk_perf,gpm_dir)
+        generate_gnuplot_script(fio_data_file,title,gnuplot_output_filename,gnuplot_output_dir,mode,disk_perf,gpm_dir)
+
+        if (run_gnuplot==True):
+            render_gnuplot(fio_data_file, gnuplot_output_dir)
+
+        # Shall we clean the temporary files ?
+        if keep_temp_files==False and force_keep_temp_files==False:
+            # Cleaning temporary files
+            if verbose: print("Cleaning temporary files")
+            for f in enumerate(temporary_files):
+                if verbose: print(" -> %s"%f[1])
+                try:
+                    os.remove(f[1])
+                except:
+                    True
 
 #Main
 if __name__ == "__main__":

