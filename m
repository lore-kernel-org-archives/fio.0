Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: kusumi.tomohiro@gmail.com
Subject: [PATCH] Be more verbose on endianness detection failure
Date: Mon, 13 Feb 2017 18:13:43 +0200
Message-Id: <20170213161343.39484-1-tkusumi@tuxera.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

From: Tomohiro Kusumi <tkusumi@tuxera.com>

> I think this deserves and enum. That also enables the compiler to check
> if the below switch covers all the potential values.

Updated with enum ENDIAN_XXX, which you can change the naming if it
doesn't sound good.

Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
---
 libfio.c | 36 +++++++++++++++++++++++++++++++-----
 1 file changed, 31 insertions(+), 5 deletions(-)

diff --git a/libfio.c b/libfio.c
index 960daf6..7e0d32c 100644
--- a/libfio.c
+++ b/libfio.c
@@ -311,6 +311,13 @@ int fio_set_fd_nonblocking(int fd, const char *who)
 	return flags;
 }
 
+enum {
+	ENDIAN_INVALID_BE = 1,
+	ENDIAN_INVALID_LE,
+	ENDIAN_INVALID_CONFIG,
+	ENDIAN_BROKEN,
+};
+
 static int endian_check(void)
 {
 	union {
@@ -327,16 +334,16 @@ static int endian_check(void)
 
 #if defined(CONFIG_LITTLE_ENDIAN)
 	if (be)
-		return 1;
+		return ENDIAN_INVALID_BE;
 #elif defined(CONFIG_BIG_ENDIAN)
 	if (le)
-		return 1;
+		return ENDIAN_INVALID_LE;
 #else
-	return 1;
+	return ENDIAN_INVALID_CONFIG;
 #endif
 
 	if (!le && !be)
-		return 1;
+		return ENDIAN_BROKEN;
 
 	return 0;
 }
@@ -344,6 +351,7 @@ static int endian_check(void)
 int initialize_fio(char *envp[])
 {
 	long ps;
+	int err;
 
 	/*
 	 * We need these to be properly 64-bit aligned, otherwise we
@@ -359,8 +367,26 @@ int initialize_fio(char *envp[])
 	compiletime_assert((offsetof(struct thread_options_pack, percentile_list) % 8) == 0, "percentile_list");
 	compiletime_assert((offsetof(struct thread_options_pack, latency_percentile) % 8) == 0, "latency_percentile");
 
-	if (endian_check()) {
+	err = endian_check();
+	if (err) {
 		log_err("fio: endianness settings appear wrong.\n");
+		switch (err) {
+		case ENDIAN_INVALID_BE:
+			log_err("fio: got big-endian when configured for little\n");
+			break;
+		case ENDIAN_INVALID_LE:
+			log_err("fio: got little-endian when configured for big\n");
+			break;
+		case ENDIAN_INVALID_CONFIG:
+			log_err("fio: not configured to any endianness\n");
+			break;
+		case ENDIAN_BROKEN:
+			log_err("fio: failed to detect endianness\n");
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


