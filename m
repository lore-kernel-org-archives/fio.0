Return-Path: <fio-owner@vger.kernel.org>
Received: from na3sys009aog104.obsmtp.com ([74.125.149.73]:55841 "EHLO
	na3sys009aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751330Ab3GSSYa (ORCPT
	<rfc822;fio@vger.kernel.org>); Fri, 19 Jul 2013 14:24:30 -0400
Received: by mail-ob0-f178.google.com with SMTP id fb19so5750742obc.37
        for <fio@vger.kernel.org>; Fri, 19 Jul 2013 11:24:30 -0700 (PDT)
MIME-Version: 1.0
From: Shawn Bohrer <sbohrer@rgmadvisors.com>
Subject: [PATCH 2/5] net: Allow setting network interface to use for multicast
Date: Fri, 19 Jul 2013 13:24:07 -0500
Message-Id: <1374258250-9801-2-git-send-email-sbohrer@rgmadvisors.com>
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
 engines/net.c |   37 ++++++++++++++++++++++++++++++++++---
 fio.1         |    4 ++++
 3 files changed, 42 insertions(+), 3 deletions(-)

diff --git a/HOWTO b/HOWTO
index 3791e7d..38eafdd 100644
--- a/HOWTO
+++ b/HOWTO
@@ -1444,6 +1444,10 @@ that defines them is selected.
 [netsplice] port=int
 [net] port=int	The TCP or UDP port to bind to or connect to.
 
+[netsplice] interface=str
+[net] interface=str  The IP address of the network interface used to send or
+		receive UDP multicast
+
 [netsplice] nodelay=bool
 [net] nodelay=bool	Set TCP_NODELAY on TCP connections.
 
diff --git a/engines/net.c b/engines/net.c
index dd376cc..645285d 100644
--- a/engines/net.c
+++ b/engines/net.c
@@ -37,6 +37,7 @@ struct netio_options {
 	unsigned int listen;
 	unsigned int pingpong;
 	unsigned int nodelay;
+	char * interface;
 };
 
 struct udp_close_msg {
@@ -129,6 +130,15 @@ static struct fio_option options[] = {
 		.group	= FIO_OPT_G_NETIO,
 	},
 	{
+		.name	= "interface",
+		.lname	= "net engine interface",
+		.type	= FIO_OPT_STR_STORE,
+		.off1	= offsetof(struct netio_options, interface),
+		.help	= "Network interface to use",
+		.category = FIO_OPT_C_ENGINE,
+		.group	= FIO_OPT_G_NETIO,
+	},
+	{
 		.name	= NULL,
 	},
 };
@@ -531,9 +541,22 @@ static int fio_netio_connect(struct thread_data *td, struct fio_file *f)
 	}
 #endif
 
-	if (o->proto == FIO_TYPE_UDP)
+	if (o->proto == FIO_TYPE_UDP) {
+		if (o->interface && fio_netio_is_multicast(td->o.filename)) {
+			struct in_addr interface_addr;
+			if (inet_aton(o->interface, &interface_addr) == 0) {
+				log_err("fio: interface not valid interface IP\n");
+				close(f->fd);
+				return 1;
+			}
+			if (setsockopt(f->fd, IPPROTO_IP, IP_MULTICAST_IF, &interface_addr, sizeof(interface_addr)) < 0) {
+				td_verror(td, errno, "setsockopt IP_MULTICAST_IF");
+				close(f->fd);
+				return 1;
+			}
+		}
 		return 0;
-	else if (o->proto == FIO_TYPE_TCP) {
+	} else if (o->proto == FIO_TYPE_TCP) {
 		socklen_t len = sizeof(nd->addr);
 
 		if (connect(f->fd, (struct sockaddr *) &nd->addr, len) < 0) {
@@ -839,7 +862,15 @@ static int fio_netio_setup_listen_inet(struct thread_data *td, short port)
 		inet_aton(td->o.filename, &sin.sin_addr);
 
 		mr.imr_multiaddr = sin.sin_addr;
-		mr.imr_interface.s_addr = htonl(INADDR_ANY);
+		if (o->interface) {
+			if (inet_aton(o->interface, &mr.imr_interface) == 0) {
+				log_err("fio: interface not valid interface IP\n");
+				close(fd);
+				return 1;
+			}
+		} else {
+			mr.imr_interface.s_addr = htonl(INADDR_ANY);
+		}
 		if (setsockopt(fd, IPPROTO_IP, IP_ADD_MEMBERSHIP, &mr, sizeof(mr)) < 0) {
 			td_verror(td, errno, "setsockopt IP_ADD_MEMBERSHIP");
 			close(fd);
diff --git a/fio.1 b/fio.1
index eba748b..ca8a5ca 100644
--- a/fio.1
+++ b/fio.1
@@ -1221,6 +1221,10 @@ used and must be omitted unless it is a valid UDP multicast address.
 .BI (net,netsplice)port \fR=\fPint
 The TCP or UDP port to bind to or connect to.
 .TP
+.BI (net,netsplice)interface \fR=\fPstr
+The IP address of the network interface used to send or receive UDP multicast
+packets.
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
