Return-Path: <tm@tao.ma>
From: Tao Ma <tm@tao.ma>
Subject: [PATCH] fio: Add to cgroup if parameter "cgroup" is enabled.
Date: Thu, 26 Apr 2012 17:24:25 +0800
Message-Id: <1335432265-5519-1-git-send-email-tm@tao.ma>
To: fio@vger.kernel.org
Cc: axboe@kernel.dk
List-ID: <fio@vger.kernel.org>

From: Tao Ma <boyu.mt@taobao.com>

Currently, we only add the tasks to cgroup if cgroup_weight is set by
the user. But if we want to test other blkcg parameters like block
throttle, the fio tasks isn't added to the corresponding cgroup and
it doesn't make sense.

So add the task to the corresponding cgroup if the cgroup name is given.

Signed-off-by: Tao Ma <boyu.mt@taobao.com>
---
 backend.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/backend.c b/backend.c
index f4bc553..e1dc0ac 100644
--- a/backend.c
+++ b/backend.c
@@ -1055,7 +1055,7 @@ static void *thread_main(void *data)
 		}
 	}
 
-	if (td->o.cgroup_weight && cgroup_setup(td, cgroup_list, &cgroup_mnt))
+	if (td->o.cgroup && cgroup_setup(td, cgroup_list, &cgroup_mnt))
 		goto err;
 
 	errno = 0;
-- 
1.7.9.GIT


