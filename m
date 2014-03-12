Return-Path: <axboe@kernel.dk>
Message-ID: <5320B5E6.7010902@kernel.dk>
Date: Wed, 12 Mar 2014 13:30:46 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: ioengine=sync issue on Windows
References: <8a71414766f34cfe98805c5dd2e94d2e@DB4PR03MB572.eurprd03.prod.outlook.com> <53208C60.8090708@kernel.dk> <07a59dd29eae446f83d85387bff2a130@BLUPR04MB467.namprd04.prod.outlook.com> <5320B15F.1060401@kernel.dk> <bd155da4787d49eb88221a9cc7f4612a@BLUPR04MB467.namprd04.prod.outlook.com>
In-Reply-To: <bd155da4787d49eb88221a9cc7f4612a@BLUPR04MB467.namprd04.prod.outlook.com>
Content-Type: multipart/mixed;
 boundary="------------020503080004000000050404"
To: Bruce Cran <BCran@fusionio.com>, =?ISO-8859-1?Q?S=E9bastien_Bouchex?= =?ISO-8859-1?Q?_Bellomi=E9?= <sbouchex@infovista.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

This is a multi-part message in MIME format.
--------------020503080004000000050404
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

On 03/12/2014 01:24 PM, Bruce Cran wrote:
> There's already code to use the environment variables TMP or TEMP, except it appends "tmp" to whatever it gets.
>

Yes, my point was to use it. Something like the attached.

-- 
Jens Axboe


--------------020503080004000000050404
Content-Type: text/x-patch;
 name="fio-tmp.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="fio-tmp.patch"

diff --git a/os/os-windows.h b/os/os-windows.h
index 49f96068ff32..499e098f8b82 100644
--- a/os/os-windows.h
+++ b/os/os-windows.h
@@ -167,6 +167,8 @@ static inline void os_get_tmpdir(char *path, int len)
 	GetTempPath(len, path);
 }
 
+#define FIO_HAVE_OS_GET_TMPDIR
+
 static inline int gettid(void)
 {
 	return GetCurrentThreadId();
diff --git a/stat.c b/stat.c
index e43db8f9d075..df3bd93d32e5 100644
--- a/stat.c
+++ b/stat.c
@@ -13,6 +13,7 @@
 #include "json.h"
 #include "lib/getrusage.h"
 #include "idletime.h"
+#include "os/os.h"
 
 static struct fio_mutex *stat_mutex;
 
@@ -1480,7 +1481,7 @@ void show_running_run_stats(void)
 static int status_interval_init;
 static struct timeval status_time;
 
-#define FIO_STATUS_FILE		"/tmp/fio-dump-status"
+#define FIO_STATUS_FILE		"fio-dump-status"
 
 static int check_status_file(void)
 {
@@ -1491,10 +1492,22 @@ static int check_status_file(void)
 	temp_dir = getenv("TMPDIR");
 	if (temp_dir == NULL)
 		temp_dir = getenv("TEMP");
-	if (temp_dir == NULL)
+	if (temp_dir == NULL) {
+#ifdef FIO_HAVE_OS_GET_TMPDIR
+		temp_dir = NULL;
+		os_get_tmpdir(status_file_path, sizeof(status_file_path));
+#else
 		temp_dir = "/tmp";
+#endif
+	}
 
-	snprintf(fio_status_file_path, sizeof(fio_status_file_path), "%s/%s", temp_dir, FIO_STATUS_FILE);
+	if (temp_dir)
+		snprintf(fio_status_file_path, sizeof(fio_status_file_path), "%s/%s", temp_dir, FIO_STATUS_FILE);
+	else {
+		size_t len = strlen(fio_status_file_path);
+
+		snprintf(fio_status_file_path + len, sizeof(fio_status_file_path) - len, "%s", FIO_STATUS_FILE);
+	}
 
 	if (stat(fio_status_file_path, &sb))
 		return 0;

--------------020503080004000000050404--

