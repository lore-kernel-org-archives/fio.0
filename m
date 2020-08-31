Return-Path: <aherrmann@suse.com>
From: Andreas Herrmann <aherrmann@suse.com>
Subject: [PATCH v2 4/4] cgroup: Support BFQ's weight attributes
Date: Mon, 31 Aug 2020 11:21:09 +0200
Message-ID: <20200831092104.3892-5-aherrmann@suse.com>
In-Reply-To: <20200831092104.3892-1-aherrmann@suse.com>
References: <20200831092104.3892-1-aherrmann@suse.com>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
Return-Path: aherrmann@suse.com
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>
Cc: fio <fio@vger.kernel.org>, Andreas Herrmann <aherrmann@suse.com>
List-ID: <fio@vger.kernel.org>

Signed-off-by: Andreas Herrmann <aherrmann@suse.com>
---
 cgroup.c | 30 ++++++++++++++++++++++--------
 1 file changed, 22 insertions(+), 8 deletions(-)

diff --git a/cgroup.c b/cgroup.c
index c6369f54..903c569e 100644
--- a/cgroup.c
+++ b/cgroup.c
@@ -236,15 +236,29 @@ int cgroup_setup(struct thread_data *td, struct flist=
_head *clist, struct cgroup
 			if (write_str_to_file(td, (*mnt)->path, "cgroup.subtree_control",
 						"+io", "cgroup open cgroup.subtree_control"))
 				goto err;
-			if (write_int_to_file(td, root, "io.weight",
-						td->o.cgroup_weight,
-						"cgroup open io.weight"))
-				goto err;
+			if (td->o.cgroup_use_bfq) {
+				if (write_int_to_file(td, root, "io.bfq.weight",
+							td->o.cgroup_weight,
+							"cgroup open io.bfq.weight"))
+					goto err;
+			} else {
+				if (write_int_to_file(td, root, "io.weight",
+							td->o.cgroup_weight,
+							"cgroup open io.weight"))
+					goto err;
+			}
 		} else {
-			if (write_int_to_file(td, root, "blkio.weight",
-						td->o.cgroup_weight,
-						"cgroup open blkio.weight"))
-				goto err;
+			if (td->o.cgroup_use_bfq) {
+				if (write_int_to_file(td, root, "blkio.bfq.weight",
+							td->o.cgroup_weight,
+							"cgroup open blkio.bfq.weight"))
+					goto err;
+			} else {
+				if (write_int_to_file(td, root, "blkio.weight",
+							td->o.cgroup_weight,
+							"cgroup open blkio.weight"))
+					goto err;
+			}
 		}
 	}
=20
--=20
2.28.0


