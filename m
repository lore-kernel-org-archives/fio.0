Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:51564 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751575AbcF3MAD (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 30 Jun 2016 08:00:03 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
	by bombadil.infradead.org with esmtpsa (Exim 4.85_2 #1 (Red Hat Linux))
	id 1bIadX-0004NS-4K
	for fio@vger.kernel.org; Thu, 30 Jun 2016 12:00:03 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20160630120002.3F2692C23FF@kernel.dk>
Date: Thu, 30 Jun 2016 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit bccdc0d0c9d41749515131226aab71baa59e03cd:

  Fio 2.12 (2016-06-13 15:42:44 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 8a09277d18f942ed35354e31e38df50d991a595a:

  HOWTO: remove old use cases for the net IO engine (2016-06-29 13:09:15 -0600)

----------------------------------------------------------------
Jens Axboe (1):
      HOWTO: remove old use cases for the net IO engine

Vincent Fu (2):
      Remove hard-coded precision for printing JSON float values
      helper_thread: remove impossible branch

 HOWTO           | 21 +++++++++------------
 helper_thread.c |  8 ++------
 json.c          |  2 +-
 3 files changed, 12 insertions(+), 19 deletions(-)

---

Diff of recent changes:

diff --git a/HOWTO b/HOWTO
index 67fd833..a50f93e 100644
--- a/HOWTO
+++ b/HOWTO
@@ -329,18 +329,15 @@ directory=str	Prefix filenames with this directory. Used to place files
 filename=str	Fio normally makes up a filename based on the job name,
 		thread number, and file number. If you want to share
 		files between threads in a job or several jobs, specify
-		a filename for each of them to override the default. If
-		the ioengine used is 'net', the filename is the host, port,
-		and protocol to use in the format of =host,port,protocol.
-		See ioengine=net for more. If the ioengine is file based, you
-		can specify a number of files by separating the names with a
-		':' colon. So if you wanted a job to open /dev/sda and /dev/sdb
-		as the two working files, you would use
-		filename=/dev/sda:/dev/sdb. On Windows, disk devices are
-		accessed as \\.\PhysicalDrive0 for the first device,
-		\\.\PhysicalDrive1 for the second etc. Note: Windows and
-		FreeBSD prevent write access to areas of the disk containing
-		in-use data (e.g. filesystems).
+		a filename for each of them to override the default.
+		If the ioengine is file based, you can specify a number of
+		files by separating the names with a ':' colon. So if you
+		wanted a job to open /dev/sda and /dev/sdb as the two working
+		files, you would use filename=/dev/sda:/dev/sdb. On Windows,
+		disk devices are accessed as \\.\PhysicalDrive0 for the first
+		device, \\.\PhysicalDrive1 for the second etc. Note: Windows
+		and FreeBSD prevent write access to areas of the disk
+		containing in-use data (e.g. filesystems).
 		If the wanted filename does need to include a colon, then
 		escape that with a '\' character. For instance, if the filename
 		is "/dev/dsk/foo@3,0:c", then you would use
diff --git a/helper_thread.c b/helper_thread.c
index e788af5..f031df4 100644
--- a/helper_thread.c
+++ b/helper_thread.c
@@ -110,12 +110,8 @@ static void *helper_thread_main(void *data)
 			msec_to_next_event = DISK_UTIL_MSEC;
 			if (since_du >= DISK_UTIL_MSEC)
 				msec_to_next_event -= (since_du - DISK_UTIL_MSEC);
-		} else {
-			if (since_du >= DISK_UTIL_MSEC)
-				msec_to_next_event = DISK_UTIL_MSEC - (DISK_UTIL_MSEC - since_du);
-			else
-				msec_to_next_event = DISK_UTIL_MSEC;
-		}
+		} else
+			msec_to_next_event = DISK_UTIL_MSEC - since_du;
 
 		if (hd->do_stat) {
 			hd->do_stat = 0;
diff --git a/json.c b/json.c
index f3ec0bb..190fa9e 100644
--- a/json.c
+++ b/json.c
@@ -347,7 +347,7 @@ static void json_print_value(struct json_value *value, struct buf_output *out)
 		log_buf(out, "%lld", value->integer_number);
 		break;
 	case JSON_TYPE_FLOAT:
-		log_buf(out, "%.2f", value->float_number);
+		log_buf(out, "%f", value->float_number);
 		break;
 	case JSON_TYPE_OBJECT:
 		json_print_object(value->object, out);
