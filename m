Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH 1/2] fio: work with cgroup2 as well
References: <20180629133335.14618-1-josef@toxicpanda.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <af016933-59fd-a7ba-f635-2eee863e0be7@kernel.dk>
Date: Fri, 29 Jun 2018 07:50:07 -0600
MIME-Version: 1.0
In-Reply-To: <20180629133335.14618-1-josef@toxicpanda.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Josef Bacik <josef@toxicpanda.com>, fio@vger.kernel.org, kernel-team@fb.com
List-ID: <fio@vger.kernel.org>

On 6/29/18 7:33 AM, Josef Bacik wrote:
> The current code only works with cgroupv1, but as long as you don't want
> to set blkio.weight or anything we can use the 'cgroup=' setting with
> cgroupv2 easily with cgroupv1, we just need to write the thread pids to
> a different file for cgroup2.

Thanks Josef - applied, but with the below fixup on top.

diff --git a/cgroup.h b/cgroup.h
index e5b6addcf190..5afac7f7551f 100644
--- a/cgroup.h
+++ b/cgroup.h
@@ -18,13 +18,13 @@ void cgroup_kill(struct flist_head *list);
 struct cgroup_mnt;
 
 static inline int cgroup_setup(struct thread_data *td, struct flist_head *list,
-			       char **mnt)
+			       struct cgroup_mount **mnt)
 {
 	td_verror(td, EINVAL, "cgroup_setup");
 	return 1;
 }
 
-static inline void cgroup_shutdown(struct thread_data *td, struct cgroup_mnt **mnt)
+static inline void cgroup_shutdown(struct thread_data *td, struct cgroup_mnt *mnt)
 {
 }
 


-- 
Jens Axboe


