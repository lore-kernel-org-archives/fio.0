Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
Subject: [PATCH] client: suppress non JSON default outputs on --output-format=json/json+
Date: Fri, 24 Aug 2018 09:42:10 -0700
Message-Id: <1535128930-19580-1-git-send-email-kusumi.tomohiro@gmail.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
List-ID: <fio@vger.kernel.org>

Suppress "hostname=...", "Disk stats (read/write)" and thread status
if json/json+ is specified, as these are regular messages.

JSON parsers can't parse the output with these messages, and JSON
spec doesn't support comment either.

--
 # ./fio ./fio.cfg --output-format=json > out
 # python3 -c "import json; json.load(open('out'))"
 # ./fio ./fio.cfg --client=localhost --output-format=json > out
 # python3 -c "import json; json.load(open('out'))"
 Traceback (most recent call last):
   File "<string>", line 1, in <module>
   File "/usr/local/lib/python3.7/json/__init__.py", line 296, in load
     parse_constant=parse_constant, object_pairs_hook=object_pairs_hook, **kw)
   File "/usr/local/lib/python3.7/json/__init__.py", line 348, in loads
     return _default_decoder.decode(s)
   File "/usr/local/lib/python3.7/json/decoder.py", line 337, in decode
     obj, end = self.raw_decode(s, idx=_w(s, 0).end())
   File "/usr/local/lib/python3.7/json/decoder.py", line 355, in raw_decode
     raise JSONDecodeError("Expecting value", s, err.value) from None
 json.decoder.JSONDecodeError: Expecting value: line 1 column 1 (char 0)

Signed-off-by: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
---
 client.c |   19 ++++++++++++++-----
 1 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/client.c b/client.c
index bc0275b..a868e3a 100644
--- a/client.c
+++ b/client.c
@@ -32,6 +32,7 @@ static void handle_stop(struct fio_client *client);
 static void handle_start(struct fio_client *client, struct fio_net_cmd *cmd);
 
 static void convert_text(struct fio_net_cmd *cmd);
+static void client_display_thread_status(struct jobs_eta *je);
 
 struct client_ops fio_client_ops = {
 	.text		= handle_text,
@@ -40,7 +41,7 @@ struct client_ops fio_client_ops = {
 	.group_stats	= handle_gs,
 	.stop		= handle_stop,
 	.start		= handle_start,
-	.eta		= display_thread_status,
+	.eta		= client_display_thread_status,
 	.probe		= handle_probe,
 	.eta_msec	= FIO_CLIENT_DEF_ETA_MSEC,
 	.client_type	= FIO_CLIENT_TYPE_CLI,
@@ -1195,7 +1196,8 @@ static void handle_du(struct fio_client *client, struct fio_net_cmd *cmd)
 
 	if (!client->disk_stats_shown) {
 		client->disk_stats_shown = true;
-		log_info("\nDisk stats (read/write):\n");
+		if (!(output_format & FIO_OUTPUT_JSON))
+			log_info("\nDisk stats (read/write):\n");
 	}
 
 	if (output_format & FIO_OUTPUT_JSON) {
@@ -1477,9 +1479,10 @@ static void handle_probe(struct fio_client *client, struct fio_net_cmd *cmd)
 	sprintf(bit, "%d-bit", probe->bpp * 8);
 	probe->flags = le64_to_cpu(probe->flags);
 
-	log_info("hostname=%s, be=%u, %s, os=%s, arch=%s, fio=%s, flags=%lx\n",
-		probe->hostname, probe->bigendian, bit, os, arch,
-		probe->fio_version, (unsigned long) probe->flags);
+	if (!(output_format & FIO_OUTPUT_JSON))
+		log_info("hostname=%s, be=%u, %s, os=%s, arch=%s, fio=%s, flags=%lx\n",
+			probe->hostname, probe->bigendian, bit, os, arch,
+			probe->fio_version, (unsigned long) probe->flags);
 
 	if (!client->name)
 		client->name = strdup((char *) probe->hostname);
@@ -2112,3 +2115,9 @@ int fio_handle_clients(struct client_ops *ops)
 	free(pfds);
 	return retval || error_clients;
 }
+
+static void client_display_thread_status(struct jobs_eta *je)
+{
+	if (!(output_format & FIO_OUTPUT_JSON))
+		display_thread_status(je);
+}
-- 
1.7.1


