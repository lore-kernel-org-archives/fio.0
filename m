Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-eopbgr20130.outbound.protection.outlook.com ([40.107.2.130]:57439
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754399AbeBGQm6 (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 7 Feb 2018 11:42:58 -0500
From: Tim Watts <tim.j.watts@kcl.ac.uk>
Subject: Possible bug in client/server mode - spurious lines leaking into
 logfile fio-3.3-39-g9025
Message-ID: <f4456b3c-214b-ba74-d979-9ed143df9811@kcl.ac.uk>
Date: Wed, 7 Feb 2018 16:42:52 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hi,

fio-3.3-39-g9025 built locally from git

I do apologise if this is a n00b error, but running an fio client 
against an fio server is resulting in spurious lines being emitted by 
the fio server instance, and these are being fed back to the client and 
mixed into the logfile.

eg: broken logfile (json, first few lines only)
==========================================
hostname=vmhost-21, be=0, 64-bit, os=Linux, arch=x86-64, 
fio=fio-3.3-39-g9025, flags=1
<vmhost-21> iops-4k-randrw: (g=0): rw=randrw, bs=(R) 4096B-4096B, (W) 
4096B-4096B, (T) 4096B-4096B, ioengine=libaio, iodepth=64
<vmhost-21> Starting 1 process
<vmhost-21>

{
   "fio version" : "fio-3.3-39-g9025",
   "timestamp" : 1518020657,
   "time" : "Wed Feb  7 16:24:17 2018",
   "global options" : {
     "ioengine" : "libaio",
     "invalidate" : "1",
...
==========================================

The hostname=vmhost-21 is being generated on the fio server instance by 
client.c lines 1416-1418, a log_info() statement

The other stuff looks like it is the result of the server instance 
defaulting output_format to FIO_OUTPUT_NORMAL - and there's no option 
like "--output_format=none" to be able to give to the server

At the end of the email is a hacky patch that "fixes" the problem - but 
almost certainly, it's not done right.


The invocations were:

(Server)
fio --server

(Client)
fio --output=/test/logs/a.log --output-format=json --client=vmhost-21 
/test/fio/a.fio


Before guessing if this is a bug or a user error, I thought I'd send it 
here for your comment :)

All the best,

Tim



==================================================================
diff --git a/client.c b/client.c
index 6fe6d9f..57add86 100644
--- a/client.c
+++ b/client.c
@@ -1413,10 +1413,11 @@ static void handle_probe(struct fio_client 
*client, struct fio_net_cmd *cmd)
         sprintf(bit, "%d-bit", probe->bpp * 8);
         probe->flags = le64_to_cpu(probe->flags);

+/*
         log_info("hostname=%s, be=%u, %s, os=%s, arch=%s, fio=%s, 
flags=%lx\n",
                 probe->hostname, probe->bigendian, bit, os, arch,
                 probe->fio_version, (unsigned long) probe->flags);
-
+*/
         if (!client->name)
                 client->name = strdup((char *) probe->hostname);
  }
diff --git a/server.c b/server.c
index ce9dca3..e2122d9 100644
--- a/server.c
+++ b/server.c
@@ -2523,6 +2523,11 @@ int fio_start_server(char *pidfile)
         WSAStartup(MAKEWORD(2, 2), &wsd);
  #endif

+/*
+* Disable logging if running as server
+*/
+       output_format = 0;
+
         if (!pidfile)
                 return fio_server();
==================================================================



-- 
Tim Watts                               Tel (VOIP): +44 (0)1580 848360
Systems Manager        King's Digital Lab (KDL), King's College London
Systems Messages and Notifications: https://systemsblog.cch.kcl.ac.uk/

