Return-Path: <fio-owner@vger.kernel.org>
Received: from na3sys009aog134.obsmtp.com ([74.125.149.83]:59064 "EHLO
	na3sys009aog134.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759986Ab3GSSbF (ORCPT
	<rfc822;fio@vger.kernel.org>); Fri, 19 Jul 2013 14:31:05 -0400
Received: by mail-oa0-f45.google.com with SMTP id j1so6457308oag.4
        for <fio@vger.kernel.org>; Fri, 19 Jul 2013 11:31:04 -0700 (PDT)
MIME-Version: 1.0
From: Shawn Bohrer <sbohrer@rgmadvisors.com>
Subject: [PATCH 1/5] net: Add UDP multicast support
Date: Fri, 19 Jul 2013 13:24:06 -0500
Message-Id: <1374258250-9801-1-git-send-email-sbohrer@rgmadvisors.com>
Content-Type: text/plain; charset=US-ASCII
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org
Cc: tomk@rgmadvisors.com, Shawn Bohrer <sbohrer@rgmadvisors.com>

Allow UDP readers to listen to UDP multicast traffic if hostname is set
to a valid UDP multicast address.

Signed-off-by: Shawn Bohrer <sbohrer@rgmadvisors.com>
---
 HOWTO         |    8 +++++-
 engines/net.c |   58 ++++++++++++++++++++++++++++++++++++++++++++++++--------
 fio.1         |    7 +++--
 3 files changed, 59 insertions(+), 14 deletions(-)

diff --git a/HOWTO b/HOWTO
index 4fd0251..3791e7d 100644
--- a/HOWTO
+++ b/HOWTO
@@ -1438,7 +1438,8 @@ that defines them is selected.
 [netsplice] hostname=str
 [net] hostname=str The host name or IP address to use for TCP or UDP based IO.
 		If the job is a TCP listener or UDP reader, the hostname is not
-		used and must be omitted.
+		used and must be omitted unless it is a valid UDP multicast
+		address.
 
 [netsplice] port=int
 [net] port=int	The TCP or UDP port to bind to or connect to.
@@ -1463,7 +1464,7 @@ that defines them is selected.
 [net] listen	For TCP network connections, tell fio to listen for incoming
 		connections rather than initiating an outgoing connection. The
 		hostname must be omitted if this option is used.
-[net] pingpong	Normal a network writer will just continue writing data, and
+[net] pingpong	Normaly a network writer will just continue writing data, and
 		a network reader will just consume packages. If pingpong=1
 		is set, a writer will send its normal payload to the reader,
 		then wait for the reader to send the same payload back. This
@@ -1471,6 +1472,9 @@ that defines them is selected.
 		and completion latencies then measure local time spent
 		sending or receiving, and the completion latency measures
 		how long it took for the other end to receive and send back.
+		For UDP multicast traffic pingpong=1 should only be set for a
+		single reader when multiple readers are listening to the same
+		address.
 
 [e4defrag] donorname=str
 	        File will be used as a block donor(swap extents between files)
diff --git a/engines/net.c b/engines/net.c
index d5a5f36..dd376cc 100644
--- a/engines/net.c
+++ b/engines/net.c
@@ -164,6 +164,20 @@ static int poll_wait(struct thread_data *td, int fd, short events)
 	return -1;
 }
 
+static int fio_netio_is_multicast(const char *mcaddr)
+{
+	in_addr_t addr = inet_network(mcaddr);
+	if (addr == -1)
+		return 0;
+
+	if (inet_network("224.0.0.0") <= addr &&
+	    inet_network("239.255.255.255") >= addr)
+		return 1;
+
+	return 0;
+}
+
+
 static int fio_netio_prep(struct thread_data *td, struct io_u *io_u)
 {
 	struct netio_options *o = td->eo;
@@ -378,11 +392,20 @@ static int fio_netio_recv(struct thread_data *td, struct io_u *io_u)
 
 	do {
 		if (o->proto == FIO_TYPE_UDP) {
-			socklen_t len = sizeof(nd->addr);
-			struct sockaddr *from = (struct sockaddr *) &nd->addr;
+			socklen_t l;
+			socklen_t *len = &l;
+			struct sockaddr *from;
+
+			if (o->listen) {
+				from = (struct sockaddr *) &nd->addr;
+				*len = sizeof(nd->addr);
+			} else {
+				from = NULL;
+				len = NULL;
+			}
 
 			ret = recvfrom(io_u->file->fd, io_u->xfer_buf,
-					io_u->xfer_buflen, flags, from, &len);
+					io_u->xfer_buflen, flags, from, len);
 			if (is_udp_close(io_u, ret)) {
 				td->done = 1;
 				return 0;
@@ -777,8 +800,11 @@ static int fio_netio_setup_listen_inet(struct thread_data *td, short port)
 {
 	struct netio_data *nd = td->io_ops->data;
 	struct netio_options *o = td->eo;
+	struct ip_mreq mr;
+	struct sockaddr_in sin;
 	int fd, opt, type;
 
+	memset(&sin, 0, sizeof(sin));
 	if (o->proto == FIO_TYPE_TCP)
 		type = SOCK_STREAM;
 	else
@@ -802,8 +828,27 @@ static int fio_netio_setup_listen_inet(struct thread_data *td, short port)
 	}
 #endif
 
+	if (td->o.filename){
+		if(o->proto != FIO_TYPE_UDP ||
+		   !fio_netio_is_multicast(td->o.filename)) {
+			log_err("fio: hostname not valid for non-multicast inbound network IO\n");
+			close(fd);
+			return 1;
+		}
+
+		inet_aton(td->o.filename, &sin.sin_addr);
+
+		mr.imr_multiaddr = sin.sin_addr;
+		mr.imr_interface.s_addr = htonl(INADDR_ANY);
+		if (setsockopt(fd, IPPROTO_IP, IP_ADD_MEMBERSHIP, &mr, sizeof(mr)) < 0) {
+			td_verror(td, errno, "setsockopt IP_ADD_MEMBERSHIP");
+			close(fd);
+			return 1;
+		}
+	}
+
 	nd->addr.sin_family = AF_INET;
-	nd->addr.sin_addr.s_addr = htonl(INADDR_ANY);
+	nd->addr.sin_addr.s_addr = sin.sin_addr.s_addr ? sin.sin_addr.s_addr : htonl(INADDR_ANY);
 	nd->addr.sin_port = htons(port);
 
 	if (bind(fd, (struct sockaddr *) &nd->addr, sizeof(nd->addr)) < 0) {
@@ -880,11 +925,6 @@ static int fio_netio_init(struct thread_data *td)
 		o->listen = td_read(td);
 	}
 
-	if (o->proto != FIO_TYPE_UNIX && o->listen && td->o.filename) {
-		log_err("fio: hostname not valid for inbound network IO\n");
-		return 1;
-	}
-
 	if (o->listen)
 		ret = fio_netio_setup_listen(td);
 	else
diff --git a/fio.1 b/fio.1
index 91fd531..eba748b 100644
--- a/fio.1
+++ b/fio.1
@@ -1216,7 +1216,7 @@ iodepth_batch_complete=0).
 .BI (net,netsplice)hostname \fR=\fPstr
 The host name or IP address to use for TCP or UDP based IO.
 If the job is a TCP listener or UDP reader, the hostname is not
-used and must be omitted.
+used and must be omitted unless it is a valid UDP multicast address.
 .TP
 .BI (net,netsplice)port \fR=\fPint
 The TCP or UDP port to bind to or connect to.
@@ -1251,13 +1251,14 @@ connections rather than initiating an outgoing connection. The
 hostname must be omitted if this option is used.
 .TP
 .BI (net, pingpong) \fR=\fPbool
-Normal a network writer will just continue writing data, and a network reader
+Normaly a network writer will just continue writing data, and a network reader
 will just consume packages. If pingpong=1 is set, a writer will send its normal
 payload to the reader, then wait for the reader to send the same payload back.
 This allows fio to measure network latencies. The submission and completion
 latencies then measure local time spent sending or receiving, and the
 completion latency measures how long it took for the other end to receive and
-send back.
+send back. For UDP multicast traffic pingpong=1 should only be set for a single
+reader when multiple readers are listening to the same address.
 .TP
 .BI (e4defrag,donorname) \fR=\fPstr
 File will be used as a block donor (swap extents between files)
-- 
1.7.7.6


-- 

---------------------------------------------------------------
This email, along with any attachments, is confidential. If you 
believe you received this message in error, please contact the 
sender immediately and delete all copies of the message.  
Thank you.
