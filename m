Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: kusumi.tomohiro@gmail.com
Subject: [PATCH 1/3] Be more verbose on endianness detection failure
Date: Sat, 11 Feb 2017 16:28:52 +0200
Message-Id: <20170211142854.23620-1-tkusumi@tuxera.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

From: Tomohiro Kusumi <tkusumi@tuxera.com>

Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
---
 libfio.c | 29 ++++++++++++++++++++++++-----
 1 file changed, 24 insertions(+), 5 deletions(-)

diff --git a/libfio.c b/libfio.c
index 960daf6..096efe2 100644
--- a/libfio.c
+++ b/libfio.c
@@ -327,16 +327,16 @@ static int endian_check(void)
 
 #if defined(CONFIG_LITTLE_ENDIAN)
 	if (be)
-		return 1;
+		return 1; /* should be little */
 #elif defined(CONFIG_BIG_ENDIAN)
 	if (le)
-		return 1;
+		return 2; /* should be big */
 #else
-	return 1;
+	return 3; /* configured for neither */
 #endif
 
 	if (!le && !be)
-		return 1;
+		return 4; /* broken */
 
 	return 0;
 }
@@ -344,6 +344,7 @@ static int endian_check(void)
 int initialize_fio(char *envp[])
 {
 	long ps;
+	int err;
 
 	/*
 	 * We need these to be properly 64-bit aligned, otherwise we
@@ -359,8 +360,26 @@ int initialize_fio(char *envp[])
 	compiletime_assert((offsetof(struct thread_options_pack, percentile_list) % 8) == 0, "percentile_list");
 	compiletime_assert((offsetof(struct thread_options_pack, latency_percentile) % 8) == 0, "latency_percentile");
 
-	if (endian_check()) {
+	err = endian_check();
+	if (err) {
 		log_err("fio: endianness settings appear wrong.\n");
+		switch (err) {
+		case 1:
+			log_err("fio: got big-endian when configured for little\n");
+			break;
+		case 2:
+			log_err("fio: got little-endian when configured for big\n");
+			break;
+		case 3:
+			log_err("fio: not configured to any endianness\n");
+			break;
+		case 4:
+			log_err("fio: failed to find endianness\n");
+			break;
+		default:
+			assert(0);
+			break;
+		}
 		log_err("fio: please report this to fio@vger.kernel.org\n");
 		return 1;
 	}
-- 
2.9.3


