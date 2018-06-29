Return-Path: <josef@toxicpanda.com>
Return-Path: <josef@toxicpanda.com>
From: Josef Bacik <josef@toxicpanda.com>
Subject: [PATCH 1/2] fio: work with cgroup2 as well
Date: Fri, 29 Jun 2018 09:33:34 -0400
Message-Id: <20180629133335.14618-1-josef@toxicpanda.com>
To: fio@vger.kernel.org, kernel-team@fb.com, axboe@kernel.dk
List-ID: <fio@vger.kernel.org>

The current code only works with cgroupv1, but as long as you don't want
to set blkio.weight or anything we can use the 'cgroup=' setting with
cgroupv2 easily with cgroupv1, we just need to write the thread pids to
a different file for cgroup2.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 backend.c |  5 ++---
 cgroup.c  | 64 ++++++++++++++++++++++++++++++++++++++++++++-------------------
 cgroup.h  | 13 ++++++++++---
 3 files changed, 57 insertions(+), 25 deletions(-)

diff --git a/backend.c b/backend.c
index c52eba58fa10..a7e91843a0be 100644
--- a/backend.c
+++ b/backend.c
@@ -50,7 +50,7 @@
 
 static struct fio_sem *startup_sem;
 static struct flist_head *cgroup_list;
-static char *cgroup_mnt;
+static struct cgroup_mnt *cgroup_mnt;
 static int exit_value;
 static volatile int fio_abort;
 static unsigned int nr_process = 0;
@@ -1886,7 +1886,7 @@ err:
 	close_and_free_files(td);
 	cleanup_io_u(td);
 	close_ioengine(td);
-	cgroup_shutdown(td, &cgroup_mnt);
+	cgroup_shutdown(td, cgroup_mnt);
 	verify_free_state(td);
 
 	if (td->zone_state_index) {
@@ -2508,7 +2508,6 @@ int fio_backend(struct sk_out *sk_out)
 		cgroup_kill(cgroup_list);
 		sfree(cgroup_list);
 	}
-	sfree(cgroup_mnt);
 
 	fio_sem_remove(startup_sem);
 	stat_exit();
diff --git a/cgroup.c b/cgroup.c
index 629047b495b3..77e31a4d0e22 100644
--- a/cgroup.c
+++ b/cgroup.c
@@ -18,12 +18,13 @@ struct cgroup_member {
 	unsigned int cgroup_nodelete;
 };
 
-static char *find_cgroup_mnt(struct thread_data *td)
+static struct cgroup_mnt *find_cgroup_mnt(struct thread_data *td)
 {
-	char *mntpoint = NULL;
+	struct cgroup_mnt *cgroup_mnt = NULL;
 	struct mntent *mnt, dummy;
 	char buf[256] = {0};
 	FILE *f;
+	bool cgroup2 = false;
 
 	f = setmntent("/proc/mounts", "r");
 	if (!f) {
@@ -35,15 +36,29 @@ static char *find_cgroup_mnt(struct thread_data *td)
 		if (!strcmp(mnt->mnt_type, "cgroup") &&
 		    strstr(mnt->mnt_opts, "blkio"))
 			break;
+		if (!strcmp(mnt->mnt_type, "cgroup2")) {
+			cgroup2 = true;
+			break;
+		}
 	}
 
-	if (mnt)
-		mntpoint = smalloc_strdup(mnt->mnt_dir);
-	else
+	if (mnt) {
+		cgroup_mnt = smalloc(sizeof(*cgroup_mnt));
+		if (cgroup_mnt) {
+			cgroup_mnt->path = smalloc_strdup(mnt->mnt_dir);
+			if (!cgroup_mnt->path) {
+				sfree(cgroup_mnt);
+				log_err("fio: could not allocate memory\n");
+			} else {
+				cgroup_mnt->cgroup2 = cgroup2;
+			}
+		}
+	} else {
 		log_err("fio: cgroup blkio does not appear to be mounted\n");
+	}
 
 	endmntent(f);
-	return mntpoint;
+	return cgroup_mnt;
 }
 
 static void add_cgroup(struct thread_data *td, const char *name,
@@ -96,14 +111,14 @@ void cgroup_kill(struct flist_head *clist)
 	fio_sem_up(lock);
 }
 
-static char *get_cgroup_root(struct thread_data *td, char *mnt)
+static char *get_cgroup_root(struct thread_data *td, struct cgroup_mnt *mnt)
 {
 	char *str = malloc(64);
 
 	if (td->o.cgroup)
-		sprintf(str, "%s/%s", mnt, td->o.cgroup);
+		sprintf(str, "%s/%s", mnt->path, td->o.cgroup);
 	else
-		sprintf(str, "%s/%s", mnt, td->o.name);
+		sprintf(str, "%s/%s", mnt->path, td->o.name);
 
 	return str;
 }
@@ -128,22 +143,25 @@ static int write_int_to_file(struct thread_data *td, const char *path,
 
 }
 
-static int cgroup_write_pid(struct thread_data *td, const char *root)
+static int cgroup_write_pid(struct thread_data *td, char *path, bool cgroup2)
 {
 	unsigned int val = td->pid;
 
-	return write_int_to_file(td, root, "tasks", val, "cgroup write pid");
+	if (cgroup2)
+		return write_int_to_file(td, path, "cgroup.procs",
+					 val, "cgroup write pid");
+	return write_int_to_file(td, path, "tasks", val, "cgroup write pid");
 }
 
 /*
  * Move pid to root class
  */
-static int cgroup_del_pid(struct thread_data *td, char *mnt)
+static int cgroup_del_pid(struct thread_data *td, struct cgroup_mnt *mnt)
 {
-	return cgroup_write_pid(td, mnt);
+	return cgroup_write_pid(td, mnt->path, mnt->cgroup2);
 }
 
-int cgroup_setup(struct thread_data *td, struct flist_head *clist, char **mnt)
+int cgroup_setup(struct thread_data *td, struct flist_head *clist, struct cgroup_mnt **mnt)
 {
 	char *root;
 
@@ -172,13 +190,17 @@ int cgroup_setup(struct thread_data *td, struct flist_head *clist, char **mnt)
 		add_cgroup(td, root, clist);
 
 	if (td->o.cgroup_weight) {
+		if ((*mnt)->cgroup2) {
+			log_err("fio: cgroup weit doesn't work with cgroup2\n");
+			goto err;
+		}
 		if (write_int_to_file(td, root, "blkio.weight",
 					td->o.cgroup_weight,
 					"cgroup open weight"))
 			goto err;
 	}
 
-	if (!cgroup_write_pid(td, root)) {
+	if (!cgroup_write_pid(td, root, (*mnt)->cgroup2)) {
 		free(root);
 		return 0;
 	}
@@ -188,14 +210,18 @@ err:
 	return 1;
 }
 
-void cgroup_shutdown(struct thread_data *td, char **mnt)
+void cgroup_shutdown(struct thread_data *td, struct cgroup_mnt *mnt)
 {
-	if (*mnt == NULL)
+	if (mnt == NULL)
 		return;
 	if (!td->o.cgroup_weight && !td->o.cgroup)
-		return;
+		goto out;
 
-	cgroup_del_pid(td, *mnt);
+	cgroup_del_pid(td, mnt);
+out:
+	if (mnt->path)
+		sfree(mnt->path);
+	sfree(mnt);
 }
 
 static void fio_init cgroup_init(void)
diff --git a/cgroup.h b/cgroup.h
index 0bbe25a2cb79..e5b6addcf190 100644
--- a/cgroup.h
+++ b/cgroup.h
@@ -3,13 +3,20 @@
 
 #ifdef FIO_HAVE_CGROUPS
 
-int cgroup_setup(struct thread_data *, struct flist_head *, char **);
-void cgroup_shutdown(struct thread_data *, char **);
+struct cgroup_mnt {
+	char *path;
+	bool cgroup2;
+};
+
+int cgroup_setup(struct thread_data *, struct flist_head *, struct cgroup_mnt **);
+void cgroup_shutdown(struct thread_data *, struct cgroup_mnt *);
 
 void cgroup_kill(struct flist_head *list);
 
 #else
 
+struct cgroup_mnt;
+
 static inline int cgroup_setup(struct thread_data *td, struct flist_head *list,
 			       char **mnt)
 {
@@ -17,7 +24,7 @@ static inline int cgroup_setup(struct thread_data *td, struct flist_head *list,
 	return 1;
 }
 
-static inline void cgroup_shutdown(struct thread_data *td, char **mnt)
+static inline void cgroup_shutdown(struct thread_data *td, struct cgroup_mnt **mnt)
 {
 }
 
-- 
2.14.3


