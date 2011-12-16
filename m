Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:38139 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752355Ab1LPUkh (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 16 Dec 2011 15:40:37 -0500
Received: by yenm11 with SMTP id m11so2518255yen.19
        for <fio@vger.kernel.org>; Fri, 16 Dec 2011 12:40:37 -0800 (PST)
MIME-Version: 1.0
From: Yufei Ren <renyufei83@gmail.com>
Date: Fri, 16 Dec 2011 15:40:16 -0500
Message-ID: <CAG5pYQeVKT=90W0U3GEcC58TXPHNvjp=GoyfmV7SiO6KWeeoDg@mail.gmail.com>
Subject: [PATCH] fix net engine client read server write bug
Content-Type: text/plain; charset=ISO-8859-1
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org
Cc: "Yufei Ren(Y!)" <renyufei83@yahoo.com.cn>

The net engine was updated with specific 'listen' parameter which used
for identifying whether it is a tcp server, instead of previous
'rw=read' side must be the server. This let fio support bi-direction
net io test. fio_netio_open_file() has to follow this
principle. Otherwise, the following tcp client 'rw=read' and tcp
server 'rw=write' case doesn't work.

[global]
ioengine=net
port=8888
protocol=tcp
bs=4k
size=10g

[server]
listen
rw=write

[client]
hostname=localhost
startdelay=1
rw=read

BTW, examples/netio needs 'listen' and 'hostname' adjusted.

---
 engines/net.c  |    3 ++-
 examples/netio |    3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/engines/net.c b/engines/net.c
index 3401039..6748a3e 100644
--- a/engines/net.c
+++ b/engines/net.c
@@ -496,8 +496,9 @@ static int fio_netio_accept(struct thread_data
*td, struct fio_file *f)
 static int fio_netio_open_file(struct thread_data *td, struct fio_file *f)
 {
 	int ret;
+	struct netio_options *o = td->eo;

-	if (td_read(td))
+	if (o->listen)
 		ret = fio_netio_accept(td, f);
 	else
 		ret = fio_netio_connect(td, f);
diff --git a/examples/netio b/examples/netio
index bd44adb..3b1a7cd 100644
--- a/examples/netio
+++ b/examples/netio
@@ -2,7 +2,6 @@
 [global]
 ioengine=net
 #Use hostname=/tmp.fio.sock for local unix domain sockets
-hostname=localhost
 port=8888
 #Use =udp for UDP, =unix for local unix domain socket
 protocol=tcp
@@ -12,8 +11,10 @@ size=10g
 #verify=md5

 [receiver]
+listen
 rw=read

 [sender]
+hostname=localhost
 startdelay=1
 rw=write
-- 
1.7.2.3
