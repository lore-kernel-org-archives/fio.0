Return-Path: <fio-owner@vger.kernel.org>
Received: from e06smtp18.uk.ibm.com ([195.75.94.114]:56456 "EHLO
	e06smtp18.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753771AbaBSPMr (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 19 Feb 2014 10:12:47 -0500
Received: from /spool/local
	by e06smtp18.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <fio@vger.kernel.org> from <ehrhardt@linux.vnet.ibm.com>;
	Wed, 19 Feb 2014 15:12:46 -0000
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
	by d06dlp03.portsmouth.uk.ibm.com (Postfix) with ESMTP id D57E61B0806B
	for <fio@vger.kernel.org>; Wed, 19 Feb 2014 15:12:20 +0000 (GMT)
Received: from d06av12.portsmouth.uk.ibm.com (d06av12.portsmouth.uk.ibm.com [9.149.37.247])
	by b06cxnps4074.portsmouth.uk.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id s1JFCUXi58261692
	for <fio@vger.kernel.org>; Wed, 19 Feb 2014 15:12:31 GMT
Received: from d06av12.portsmouth.uk.ibm.com (localhost [127.0.0.1])
	by d06av12.portsmouth.uk.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id s1JFCgvc005613
	for <fio@vger.kernel.org>; Wed, 19 Feb 2014 08:12:42 -0700
Message-ID: <5304C9E9.4040202@linux.vnet.ibm.com>
Date: Wed, 19 Feb 2014 16:12:41 +0100
From: Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>
MIME-Version: 1.0
Subject: [patch 5/9] fio: add multi directory support
References: <20140219143639.168501090@linux.vnet.ibm.com>
In-Reply-To: <20140219143639.168501090@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org
Cc: oberpar@linux.vnet.ibm.com, Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>

From: Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>

This patch adds support for ':' seperated multiple directories at the 
directory
config statement in order to achieve an automatic distribution of job clones
(numjob) across directories.

That way people can distribute a load across these directories (usually 
mount
points of disks) automatically - changing numjob will be sufficient to 
get all
job clones evenly (optimal if dirs % numjobs = 0, otherwise as good as
possible) distributed at all times.

To avoid confused users old config Files will behave like they always 
did, old
fio binaries using new config files won't abort but just use the first
specified dir. If one specifies an explcit (non generated) filename the
distribution to many directories is also deactivated.

It also fixes an issue of events seeming out of order like when running with
  --debug=file seeing the "..." message meaning "I created the clones" prior
to the last clone activities.
Now the clones are called with index N-1 .. 1, zero being the base thread as
before.


Signed-off-by: Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>
---

[diffstat]
  engines/net.c |    2 -
  file.h        |    8 +++++
  filesetup.c   |   70 ++++++++++++++++++++++++++++++++++++++++++++++------
  fio.1         |    6 ++++
  init.c        |    9 ++----
  iolog.c       |    2 -
  options.c     |   78 
++++++++++++++++++++++++++++++++++++++++++++++------------
  options.h     |    2 +
  8 files changed, 146 insertions(+), 31 deletions(-)

[diff]

--- a/engines/net.c
+++ b/engines/net.c
@@ -1194,7 +1194,7 @@ static int fio_netio_setup(struct thread
  	struct netio_data *nd;
   	if (!td->files_index) {
-		add_file(td, td->o.filename ?: "net");
+		add_file(td, td->o.filename ?: "net", 0);
  		td->o.nr_files = td->o.nr_files ?: 1;
  	}
  --- a/file.h
+++ b/file.h
@@ -125,6 +125,11 @@ struct fio_file {
  	struct disk_util *du;
  };
  +struct file_name {
+	struct flist_head list;
+	char *filename;
+};
+
  #define FILE_FLAG_FNS(name)						\
  static inline void fio_file_set_##name(struct fio_file *f)		\
  {									\
@@ -162,7 +167,7 @@ extern int __must_check generic_close_fi
  extern int __must_check generic_get_file_size(struct thread_data *, 
struct fio_file *);
  extern int __must_check file_lookup_open(struct fio_file *f, int flags);
  extern int __must_check pre_read_files(struct thread_data *);
-extern int add_file(struct thread_data *, const char *);
+extern int add_file(struct thread_data *, const char *, int);
  extern int add_file_exclusive(struct thread_data *, const char *);
  extern void get_file(struct fio_file *);
  extern int __must_check put_file(struct thread_data *, struct fio_file *);
@@ -175,6 +180,7 @@ extern int init_random_map(struct thread
  extern void dup_files(struct thread_data *, struct thread_data *);
  extern int get_fileno(struct thread_data *, const char *);
  extern void free_release_files(struct thread_data *);
+extern void filesetup_mem_free(void);
  void fio_file_reset(struct thread_data *, struct fio_file *);
  int fio_files_done(struct thread_data *);
  --- a/filesetup.c
+++ b/filesetup.c
@@ -11,6 +11,7 @@
  #include "fio.h"
  #include "smalloc.h"
  #include "filehash.h"
+#include "options.h"
  #include "os/os.h"
  #include "hash.h"
  #include "lib/axmap.h"
@@ -21,6 +22,8 @@
   static int root_warn;
  +static FLIST_HEAD(filename_list);
+
  static inline void clear_error(struct thread_data *td)
  {
  	td->error = 0;
@@ -1101,7 +1104,48 @@ static void get_file_type(struct fio_fil
  	}
  }
  -int add_file(struct thread_data *td, const char *fname)
+static void set_already_allocated(const char *fname) {
+	struct file_name *fn;
+
+	fn = malloc(sizeof(struct file_name));
+	fn->filename = strdup(fname);
+	flist_add_tail(&fn->list, &filename_list);
+}
+
+static int is_already_allocated(const char *fname)
+{
+	struct flist_head *entry;
+	char *filename;
+
+	if (!flist_empty(&filename_list))
+	{
+		flist_for_each(entry, &filename_list) {
+			filename = flist_entry(entry, struct file_name, list)->filename;
+
+			if (strcmp(filename, fname) == 0)
+				return 1;
+		}
+	}
+
+	return 0;
+}
+
+static void free_already_allocated() {
+	struct flist_head *entry, *tmp;
+	struct file_name *fn;
+
+	if (!flist_empty(&filename_list))
+	{
+		flist_for_each_safe(entry, tmp, &filename_list) {
+			fn = flist_entry(entry, struct file_name, list);
+			free(fn->filename);
+			flist_del(&fn->list);
+			free(fn);
+		}
+	}
+}
+
+int add_file(struct thread_data *td, const char *fname, int numjob)
  {
  	int cur_files = td->files_index;
  	char file_name[PATH_MAX];
@@ -1110,6 +1154,15 @@ int add_file(struct thread_data *td, con
   	dprint(FD_FILE, "add file %s\n", fname);
  +	if (td->o.directory)
+		len = set_name_idx(file_name, td->o.directory, numjob);
+
+	sprintf(file_name + len, "%s", fname);
+
+	/* clean cloned siblings using existing files */
+	if (numjob && is_already_allocated(file_name))
+		return 0;
+
  	f = smalloc(sizeof(*f));
  	if (!f) {
  		log_err("fio: smalloc OOM\n");
@@ -1149,10 +1202,6 @@ int add_file(struct thread_data *td, con
  	if (td->io_ops && (td->io_ops->flags & FIO_DISKLESSIO))
  		f->real_file_size = -1ULL;
  -	if (td->o.directory)
-		len = sprintf(file_name, "%s/", td->o.directory);
-
-	sprintf(file_name + len, "%s", fname);
  	f->file_name = smalloc_strdup(file_name);
  	if (!f->file_name) {
  		log_err("fio: smalloc OOM\n");
@@ -1179,6 +1228,8 @@ int add_file(struct thread_data *td, con
  	if (f->filetype == FIO_TYPE_FILE)
  		td->nr_normal_files++;
  +	set_already_allocated(file_name);
+
  	dprint(FD_FILE, "file %p \"%s\" added at %d\n", f, f->file_name,
  							cur_files);
  @@ -1195,7 +1246,7 @@ int add_file_exclusive(struct thread_dat
  			return i;
  	}
  -	return add_file(td, fname);
+	return add_file(td, fname, 0);
  }
   void get_file(struct fio_file *f)
@@ -1304,7 +1355,7 @@ static int recurse_dir(struct thread_dat
  		}
   		if (S_ISREG(sb.st_mode)) {
-			add_file(td, full_path);
+			add_file(td, full_path, 0);
  			td->o.nr_files++;
  			continue;
  		}
@@ -1421,3 +1472,8 @@ int fio_files_done(struct thread_data *t
   	return 1;
  }
+
+/* free memory used in initialization phase only */
+void filesetup_mem_free() {
+	free_already_allocated();
+}
--- a/fio.1
+++ b/fio.1
@@ -158,6 +158,12 @@ otherwise has no special purpose.
  .BI directory \fR=\fPstr
  Prefix filenames with this directory.  Used to place files in a 
location other
  than `./'.
+You can specify a number of directories by separating the names with a ':'
+character. These directories will be assigned equally distributed to 
job clones
+creates with \fInumjobs\fR as long as they are using generated filenames.
+If specific \fIfilename(s)\fR are set fio will use the first listed 
directory,
+and thereby matching the  \fIfilename\fR semantic which generates a 
file each
+clone if not specified, but let all clones use the same if set.
  .TP
  .BI filename \fR=\fPstr
  .B fio
--- a/init.c
+++ b/init.c
@@ -1020,10 +1020,10 @@ static int add_job(struct thread_data *t
  		file_alloced = 1;
   		if (o->nr_files == 1 && exists_and_not_file(jobname))
-			add_file(td, jobname);
+			add_file(td, jobname, job_add_num);
  		else {
  			for (i = 0; i < o->nr_files; i++)
-				add_file(td, make_filename(fname, o, jobname, td->thread_number, i));
+				add_file(td, make_filename(fname, o, jobname, job_add_num, i), 
job_add_num);
  		}
  	}
  @@ -1166,9 +1166,7 @@ static int add_job(struct thread_data *t
  			}
  		}
  -		job_add_num = numjobs - 1;
-
-		if (add_job(td_new, jobname, job_add_num, 1, client_type))
+		if (add_job(td_new, jobname, numjobs, 1, client_type))
  			goto err;
  	}
  @@ -2027,6 +2025,7 @@ int parse_options(int argc, char *argv[]
   	free(ini_file);
  	fio_options_free(&def_thread);
+	filesetup_mem_free();
   	if (!thread_number) {
  		if (parse_dryrun())
--- a/iolog.c
+++ b/iolog.c
@@ -324,7 +324,7 @@ static int read_iolog2(struct thread_dat
  			rw = DDIR_INVAL;
  			if (!strcmp(act, "add")) {
  				td->o.nr_files++;
-				fileno = add_file(td, fname);
+				fileno = add_file(td, fname, 0);
  				file_action = FIO_LOG_ADD_FILE;
  				continue;
  			} else if (!strcmp(act, "open")) {
--- a/options.c
+++ b/options.c
@@ -729,11 +729,11 @@ static int str_random_distribution_cb(vo
  }
   /*
- * Return next file in the string. Files are separated with ':'. If the ':'
+ * Return next name in the string. Files are separated with ':'. If the ':'
   * is escaped with a '\', then that ':' is part of the filename and 
does not
   * indicate a new file.
   */
-static char *get_next_file_name(char **ptr)
+static char *get_next_name(char **ptr)
  {
  	char *str = *ptr;
  	char *p, *start;
@@ -774,6 +774,44 @@ static char *get_next_file_name(char **p
  	return start;
  }
  +
+static int get_max_name_idx(char *input)
+{
+	unsigned int cur_idx;
+	char *str, *p;
+
+	p = str = strdup(input);
+ 	for (cur_idx = 0; ; cur_idx++)
+		if (get_next_name(&str) == NULL)
+			break;
+
+	free(p);
+	return cur_idx;
+}
+
+/*
+ * Returns the directory at the index, indexes > entires will be
+ * assigned via modulo division of the index
+ */
+int set_name_idx(char *target, char *input, int index)
+{
+	unsigned int cur_idx;
+	int len;
+	char *fname, *str, *p;
+
+	p = str = strdup(input);
+
+	index %= get_max_name_idx(input);
+ 	for (cur_idx = 0; cur_idx <= index; cur_idx++) {
+		fname = get_next_name(&str);
+	}
+
+	len = sprintf(target, "%s/", fname);
+	free(p);
+
+	return len;
+}
+
  static int str_filename_cb(void *data, const char *input)
  {
  	struct thread_data *td = data;
@@ -787,10 +825,10 @@ static int str_filename_cb(void *data, c
  	if (!td->files_index)
  		td->o.nr_files = 0;
  -	while ((fname = get_next_file_name(&str)) != NULL) {
+	while ((fname = get_next_name(&str)) != NULL) {
  		if (!strlen(fname))
  			break;
-		add_file(td, fname);
+		add_file(td, fname, 0);
  		td->o.nr_files++;
  	}
  @@ -798,27 +836,35 @@ static int str_filename_cb(void *data, c
  	return 0;
  }
  -static int str_directory_cb(void *data, const char fio_unused *str)
+static int str_directory_cb(void *data, const char fio_unused *unused)
  {
  	struct thread_data *td = data;
  	struct stat sb;
+	char *dirname, *str, *p;
+	int ret = 0;
   	if (parse_dryrun())
  		return 0;
  -	if (lstat(td->o.directory, &sb) < 0) {
-		int ret = errno;
-
-		log_err("fio: %s is not a directory\n", td->o.directory);
-		td_verror(td, ret, "lstat");
-		return 1;
-	}
-	if (!S_ISDIR(sb.st_mode)) {
-		log_err("fio: %s is not a directory\n", td->o.directory);
-		return 1;
+	p = str = strdup(td->o.directory);
+	while ((dirname = get_next_name(&str)) != NULL) {
+		if (lstat(dirname, &sb) < 0) {
+			ret = errno;
+
+			log_err("fio: %s is not a directory\n", dirname);
+			td_verror(td, ret, "lstat");
+			goto out;
+		}
+		if (!S_ISDIR(sb.st_mode)) {
+			log_err("fio: %s is not a directory\n", dirname);
+			ret = 1;
+			goto out;
+		}
  	}
  -	return 0;
+out:
+	free(p);
+	return ret;
  }
   static int str_lockfile_cb(void *data, const char fio_unused *str)
--- a/options.h
+++ b/options.h
@@ -17,6 +17,8 @@ void add_opt_posval(const char *, const
  void del_opt_posval(const char *, const char *);
  struct thread_data;
  void fio_options_free(struct thread_data *);
+char *get_name_idx(char *, int);
+int set_name_idx(char *, char *, int);
   extern struct fio_option fio_options[FIO_MAX_OPTS];


