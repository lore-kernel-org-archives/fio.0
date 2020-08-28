Return-Path: <aherrmann@suse.com>
Date: Fri, 28 Aug 2020 12:06:15 +0200
From: Andreas Herrmann <aherrmann@suse.com>
Subject: [PATCH 2/2] cgroup: Allow to use weights with cgroup-v2
Message-ID: <20200828100615.GI6041@suselix>
References: <20200828100230.GG6041@suselix>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200828100230.GG6041@suselix>
Return-Path: aherrmann@suse.com
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>


Signed-off-by: Andreas Herrmann <aherrmann@suse.com>
---
 cgroup.c | 56 +++++++++++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 45 insertions(+), 11 deletions(-)

diff --git a/cgroup.c b/cgroup.c
index 6edb5b14..9fcf44ad 100644
--- a/cgroup.c
+++ b/cgroup.c
@@ -165,6 +165,26 @@ static int write_int_to_file(struct thread_data *td, const char *path,
 
 }
 
+static int write_str_to_file(struct thread_data *td, const char *path,
+			     const char *filename, const char *str,
+			     const char *onerr)
+{
+	char tmp[256];
+	FILE *f;
+
+	sprintf(tmp, "%s/%s", path, filename);
+	f = fopen(tmp, "w");
+	if (!f) {
+		td_verror(td, errno, onerr);
+		return 1;
+	}
+
+	fprintf(f, "%s", str);
+	fclose(f);
+	return 0;
+
+}
+
 static int cgroup_write_pid(struct thread_data *td, char *path, bool cgroup2)
 {
 	unsigned int val = td->pid;
@@ -213,18 +233,32 @@ int cgroup_setup(struct thread_data *td, struct flist_head *clist, struct cgroup
 
 	if (td->o.cgroup_weight) {
 		if ((*mnt)->cgroup2) {
-			log_err("fio: cgroup weight doesn't work with cgroup2\n");
-			goto err;
-		}
-		if (write_int_to_file(td, root, "blkio.weight",
-					td->o.cgroup_weight,
-					"cgroup open blkio.weight")) {
-			td_clear_error(td);
-			log_err("Trying to use blkio.bfq.weight\n");
-			if (write_int_to_file(td, root, "blkio.bfq.weight",
-						td->o.cgroup_weight,
-						"cgroup open blkio.bfq.weight"))
+			if (write_str_to_file(td, (*mnt)->path, "cgroup.subtree_control",
+					"+io", "cgroup open cgroup.subtree_control"))
 				goto err;
+			if (!td->o.cgroup_use_bfq) {
+				if (write_int_to_file(td, root, "io.weight",
+							td->o.cgroup_weight,
+							"cgroup open io.weight"))
+					goto err;
+			} else {
+				if (write_int_to_file(td, root, "io.bfq.weight",
+							td->o.cgroup_weight,
+							"cgroup open io.bfq.weight"))
+					goto err;
+			}
+		} else {
+			if (!td->o.cgroup_use_bfq) {
+				if (write_int_to_file(td, root, "blkio.weight",
+							td->o.cgroup_weight,
+							"cgroup open blkio.weight"))
+					goto err;
+			} else {
+				if (write_int_to_file(td, root, "blkio.bfq.weight",
+							td->o.cgroup_weight,
+							"cgroup open blkio.bfq.weight"))
+					goto err;
+			}
 		}
 	}
 
-- 
2.28.0


