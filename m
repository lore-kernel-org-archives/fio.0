Return-Path: <fio-owner@vger.kernel.org>
Received: from mx5-phx2.redhat.com ([209.132.183.37]:51191 "EHLO
	mx5-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750770AbbBOW1H (ORCPT <rfc822;fio@vger.kernel.org>);
	Sun, 15 Feb 2015 17:27:07 -0500
Received: from zmail16.collab.prod.int.phx2.redhat.com (zmail16.collab.prod.int.phx2.redhat.com [10.5.83.18])
	by mx5-phx2.redhat.com (8.14.4/8.14.4) with ESMTP id t1FMR6Xl060578
	for <fio@vger.kernel.org>; Sun, 15 Feb 2015 17:27:06 -0500
Date: Sun, 15 Feb 2015 17:27:06 -0500 (EST)
From: Ben England <bengland@redhat.com>
Message-ID: <456053038.10476591.1424039226439.JavaMail.zimbra@redhat.com>
In-Reply-To: <177931222.1695665.1422463951931.JavaMail.zimbra@redhat.com>
References: <596106035.8980737.1421443175599.JavaMail.zimbra@redhat.com> <54B982D7.1070503@kernel.dk> <177931222.1695665.1422463951931.JavaMail.zimbra@redhat.com>
Subject: suggestion for fio --client to remove garbled output
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

This patch makes fio --client JSON output work better when many server threads are used by removing interleaved output from fio servers with --output-format=json .  

Background: Red Hat is testing large numbers of OpenStack guests with Cinder block devices backed by Ceph storage using fio.  Originally we were using ssh to start independent fio processes on the guests, but we ran into problems with threads not starting and stopping at the same time, despite using options to use fixed elapsed time for all threads.   But when we started using --client, we noticed that thread time skew is greatly reduced, because fio is *already running* on the server and we only have to connect to it and start the test.    This is great, but for large numbers of fio servers, it becomes impossible to parse the output.  

For example, here's a sample of per-VM JSON output:

Disk stats (read/write):
<vm4> {
<vm4>   "fio version" : "fio-2.2.4",
<vm4>   "timestamp" : 1421677173,
<vm4>   "time" : "Mon Jan 19 09:19:33 2015",
<vm4>   "jobs" : [
<vm4> 
<vm4>   ],
<vm4>   "disk_util" : [
...
<vm4>   ]
<vm4> }

https://s3.amazonaws.com/ben.england/client.c.diff
https://s3.amazonaws.com/ben.england/fio-results.2015-01-20-11-50.json.gz

The above output works fine for a few threads and is not hard to filter out, but the various guests' output sections get mixed together for large thread counts such as 256 client threads.  if you look at the previous URL fio-results*json.gz containing garbled output, the cause of this output is the handle_text() routine, which is called by fio whenever a FIO_NET_CMD_TEXT PDU is received by the fio client (in fio_handle_client()).  If you use --debug=all you can see that these PDUs are processed in whatever order they are received from the fio server processes, essentially in random order.  But almost all of this info is in the final json object output at the end of the file (except for the timestamp field which I wish was there!) so there is no reason to output twice, except as a debugging tool perhaps.  The patch is to V2.2.4.

[ben@localhost fio-master]$ diff -u client.{c.sav2,c}
--- client.c.sav2	2015-01-28 11:30:02.657073505 -0500
+++ client.c	2015-01-28 11:33:02.248373685 -0500
@@ -968,12 +968,6 @@
 	const char *name;
 	int fio_unused ret;
 
-	name = client->name ? client->name : client->hostname;
-
-	if (!client->skip_newline)
-		fprintf(f_out, "<%s> ", name);
-	ret = fwrite(buf, pdu->buf_len, 1, f_out);
-	fflush(f_out);
 	client->skip_newline = strchr(buf, '\n') == NULL;
 }

