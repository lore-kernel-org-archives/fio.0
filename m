Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: kusumi.tomohiro@gmail.com
Subject: [PATCH 08/13] Don't proceed with error set when failed to pre-read files/devices
Date: Tue, 28 Mar 2017 23:02:56 +0300
Message-Id: <20170328200301.8622-8-tkusumi@tuxera.com>
In-Reply-To: <20170328200301.8622-1-tkusumi@tuxera.com>
References: <20170328200301.8622-1-tkusumi@tuxera.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

From: Tomohiro Kusumi <tkusumi@tuxera.com>

pre_read_files() never fails (never returns negative), and because
of this behavior, fio threads can continue regardless of td_verror()
call while prereading, and results in statistics with error in it,
which is quite confusing as to how it should be interpreted for regular
users.

This commit makes pre_read_files() return -1 if preread fails, and
eventually aborts fio, which is also the case with some other options.
It also changes non error return from 1 to 0, since all it matters
is if it's <0 or not, and fio normally uses 0 for success.

Not sure what the proper way of fixing this is if it legitimately
failed for some error on prereading though. Some options just print
a message to indicate it's unsupported and continue normally withtout
any error set.

Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
---
 filesetup.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/filesetup.c b/filesetup.c
index bd971e8..cd486ea 100644
--- a/filesetup.c
+++ b/filesetup.c
@@ -1119,10 +1119,11 @@ int pre_read_files(struct thread_data *td)
 	dprint(FD_FILE, "pre_read files\n");
 
 	for_each_file(td, f, i) {
-		pre_read_file(td, f);
+		if (pre_read_file(td, f))
+			return -1;
 	}
 
-	return 1;
+	return 0;
 }
 
 static int __init_rand_distribution(struct thread_data *td, struct fio_file *f)
-- 
2.9.3


