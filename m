Return-Path: <fio-owner@vger.kernel.org>
Received: from na3sys009aog117.obsmtp.com ([74.125.149.242]:53522 "EHLO
	na3sys009aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752645Ab3GSSYb (ORCPT
	<rfc822;fio@vger.kernel.org>); Fri, 19 Jul 2013 14:24:31 -0400
Received: by mail-ob0-f170.google.com with SMTP id ef5so5822181obb.1
        for <fio@vger.kernel.org>; Fri, 19 Jul 2013 11:24:31 -0700 (PDT)
MIME-Version: 1.0
From: Shawn Bohrer <sbohrer@rgmadvisors.com>
Subject: [PATCH 3/5] net: Add option to set outgoing multicast TTL
Date: Fri, 19 Jul 2013 13:24:08 -0500
Message-Id: <1374258250-9801-3-git-send-email-sbohrer@rgmadvisors.com>
In-Reply-To: <1374258250-9801-1-git-send-email-sbohrer@rgmadvisors.com>
References: <1374258250-9801-1-git-send-email-sbohrer@rgmadvisors.com>
Content-Type: text/plain; charset=US-ASCII
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org
Cc: tomk@rgmadvisors.com, Shawn Bohrer <sbohrer@rgmadvisors.com>

Signed-off-by: Shawn Bohrer <sbohrer@rgmadvisors.com>
---
 HOWTO         |    4 ++++
 engines/net.c |   22 +++++++++++++++++++++-
 fio.1         |    3 +++
 3 files changed, 28 insertions(+), 1 deletions(-)

diff --git a/HOWTO b/HOWTO
index 38eafdd..a2de470 100644
--- a/HOWTO
+++ b/HOWTO
@@ -1448,6 +1448,10 @@ that defines them is selected.
 [net] interface=str  The IP address of the network interface used to send or
 		receive UDP multicast
 
+[netsplice] ttl=int
+[net] ttl=int	Time-to-live value for outgoing UDP multicast packets.
+		Default: 1
+
 [netsplice] nodelay=bool
 [net] nodelay=bool	Set TCP_NODELAY on TCP connections.
 
diff --git a/engines/net.c b/engines/net.c
index 645285d..257ab8f 100644
--- a/engines/net.c
+++ b/engines/net.c
@@ -37,6 +37,7 @@ struct netio_options {
 	unsigned int listen;
 	unsigned int pingpong;
 	unsigned int nodelay;
+	unsigned int ttl;
 	char * interface;
 };
 
@@ -139,6 +140,17 @@ static struct fio_option options[] = {
 		.group	= FIO_OPT_G_NETIO,
 	},
 	{
+		.name	= "ttl",
+		.lname	= "net engine multicast ttl",
+		.type	= FIO_OPT_INT,
+		.off1	= offsetof(struct netio_options, ttl),
+		.def    = "1",
+		.minval	= 0,
+		.help	= "Time-to-live value for outgoing UDP multicast packets",
+		.category = FIO_OPT_C_ENGINE,
+		.group	= FIO_OPT_G_NETIO,
+	},
+	{
 		.name	= NULL,
 	},
 };
@@ -542,7 +554,10 @@ static int fio_netio_connect(struct thread_data *td, struct fio_file *f)
 #endif
 
 	if (o->proto == FIO_TYPE_UDP) {
-		if (o->interface && fio_netio_is_multicast(td->o.filename)) {
+		if (!fio_netio_is_multicast(td->o.filename))
+			return 0;
+
+		if (o->interface) {
 			struct in_addr interface_addr;
 			if (inet_aton(o->interface, &interface_addr) == 0) {
 				log_err("fio: interface not valid interface IP\n");
@@ -555,6 +570,11 @@ static int fio_netio_connect(struct thread_data *td, struct fio_file *f)
 				return 1;
 			}
 		}
+		if (setsockopt(f->fd, IPPROTO_IP, IP_MULTICAST_TTL, &o->ttl, sizeof(o->ttl)) < 0) {
+			td_verror(td, errno, "setsockopt IP_MULTICAST_TTL");
+			close(f->fd);
+			return 1;
+		}
 		return 0;
 	} else if (o->proto == FIO_TYPE_TCP) {
 		socklen_t len = sizeof(nd->addr);
diff --git a/fio.1 b/fio.1
index ca8a5ca..62f7bb6 100644
--- a/fio.1
+++ b/fio.1
@@ -1225,6 +1225,9 @@ The TCP or UDP port to bind to or connect to.
 The IP address of the network interface used to send or receive UDP multicast
 packets.
 .TP
+.BI (net,netsplice)ttl \fR=\fPint
+Time-to-live value for outgoing UDP multicast packets. Default: 1
+.TP
 .BI (net,netsplice)nodelay \fR=\fPbool
 Set TCP_NODELAY on TCP connections.
 .TP
-- 
1.7.7.6


-- 

---------------------------------------------------------------
This email, along with any attachments, is confidential. If you 
believe you received this message in error, please contact the 
sender immediately and delete all copies of the message.  
Thank you.
