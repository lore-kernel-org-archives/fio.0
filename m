Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13D2145BF1
	for <fio@vger.kernel.org>; Tue, 13 Feb 2024 13:00:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707829217; cv=none; b=cBjCYLB9t7TPZIFLjaqneM6o7cWiHucDW/MyodJQa7Fs4BBnupjjjVGTOYJ5CX8ov+XetPh+591AQPrXnqZnkeHrFxGBpB4qpM95Lp5n27Zjw7EsKzOQm1LVJMQ4KGFttnF7u8Y6bLLbaLX2n2CCKwZLbcSXfwG9vADvL+Stjro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707829217; c=relaxed/simple;
	bh=sJrZ4vRoPG9iL3JXtrFqXlNNxfK9/fHjUxQn9OdxAUE=;
	h=Subject:From:To:Message-Id:Date; b=nP8OKxRjGh2ZlECihR/EtH/PTQDpOLag7WLCcSf0DpfOuRNEUNzM7rD/EKT2ogH2NenRW6sSRH2P58JDrpPQL2jcMJzsOQ3iFl0O46Z/eU2gScrFsg8N+C4tmt21Fp7r7AQRdnilr4FZXbOu3HoBJXIk4ImX6B8Ln2D85g7rt9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=fail smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Hb2wtrdC; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Hb2wtrdC"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Date:Message-Id:To:From:Subject:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=TU/jRnPbHWlGm/LRhUv9q1ygmRbVnvpDSPxZeFupFBE=; b=Hb2wtrdCNL9qvIvlllNkaevygs
	x6nH0jBjQsFI6BA6mmxBWPaVHmKtmhBgyinAem8p/9g2GLPizO79sCWw6+v9C3b4TdiALcMmjJ6WT
	igE0s2C/3nWjcjDBs12WfyUzsLqkGxxGcH0X/dvfwaTV4mQbqzmzG9msVFCUr656vKEAfu05wpNIc
	a3PPmP3LyVn7wZbLEuV0IZrCpH7LqtQgqovTxVMUDODueMsT4mm/EKbwdfaGrOuhDjGKjHv1If9bz
	XWJMIJ89vnuxRB6Qrwbs83N4VTZjP8wOVsj3PhrGL4Fgs6MQPiFuEFJdfb0qt/2R7+iMLp7IBjem/
	HUElh7lw==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by casper.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rZsOO-0000000DmIp-0f6l
	for fio@vger.kernel.org;
	Tue, 13 Feb 2024 13:00:09 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id D82EC1BC0156; Tue, 13 Feb 2024 06:00:01 -0700 (MST)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20240213130001.D82EC1BC0156@kernel.dk>
Date: Tue, 13 Feb 2024 06:00:01 -0700 (MST)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>

The following changes since commit 9cfa60d874e9a1da057677619a370409428ea3cf:

  verify: fix potential overflow before widen (2024-02-08 17:45:41 -0500)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 097af663e93f86106f32580bfa59e68fae007035:

  Merge branch 'vsock' of https://github.com/MPinna/fio (2024-02-12 11:56:33 -0700)

----------------------------------------------------------------
Jens Axboe (1):
      Merge branch 'vsock' of https://github.com/MPinna/fio

Marco Pinna (1):
      Add support for VSOCK to engine/net.c

 HOWTO.rst                         |   7 +-
 configure                         |  22 +++++++
 engines/net.c                     | 132 +++++++++++++++++++++++++++++++++++++-
 examples/netio_vsock.fio          |  22 +++++++
 examples/netio_vsock_receiver.fio |  14 ++++
 examples/netio_vsock_sender.fio   |  17 +++++
 fio.1                             |   9 ++-
 7 files changed, 217 insertions(+), 6 deletions(-)
 create mode 100644 examples/netio_vsock.fio
 create mode 100644 examples/netio_vsock_receiver.fio
 create mode 100644 examples/netio_vsock_sender.fio

---

Diff of recent changes:

diff --git a/HOWTO.rst b/HOWTO.rst
index ba160551..53b03021 100644
--- a/HOWTO.rst
+++ b/HOWTO.rst
@@ -2626,10 +2626,13 @@ with the caveat that when used on the command line, they must come after the
 		User datagram protocol V6.
 	**unix**
 		UNIX domain socket.
+	**vsock**
+		VSOCK protocol.
 
-	When the protocol is TCP or UDP, the port must also be given, as well as the
-	hostname if the job is a TCP listener or UDP reader. For unix sockets, the
+	When the protocol is TCP, UDP or VSOCK, the port must also be given, as well as the
+	hostname if the job is a TCP or VSOCK listener or UDP reader. For unix sockets, the
 	normal :option:`filename` option should be used and the port is invalid.
+	When the protocol is VSOCK, the :option:`hostname` is the CID of the remote VM.
 
 .. option:: listen : [netsplice] [net]
 
diff --git a/configure b/configure
index dea8d07d..becb193e 100755
--- a/configure
+++ b/configure
@@ -1728,6 +1728,25 @@ elif compile_prog "" "-lws2_32" "TCP_NODELAY"; then
 fi
 print_config "TCP_NODELAY" "$tcp_nodelay"
 
+##########################################
+# Check whether we have vsock
+if test "$vsock" != "yes" ; then
+  vsock="no"
+fi
+cat > $TMPC << EOF
+#include <sys/types.h>
+#include <sys/socket.h>
+#include <linux/vm_sockets.h>
+int main(int argc, char **argv)
+{
+  return socket(AF_VSOCK, SOCK_STREAM, 0);
+}
+EOF
+if compile_prog "" "" "vsock"; then
+  vsock="yes"
+fi
+print_config "vsock" "$vsock"
+
 ##########################################
 # Check whether we have SO_SNDBUF
 if test "$window_size" != "yes" ; then
@@ -3192,6 +3211,9 @@ fi
 if test "$ipv6" = "yes" ; then
   output_sym "CONFIG_IPV6"
 fi
+if test "$vsock" = "yes"; then
+  output_sym "CONFIG_VSOCK"
+fi
 if test "$http" = "yes" ; then
   output_sym "CONFIG_HTTP"
 fi
diff --git a/engines/net.c b/engines/net.c
index fec53d74..29150bb3 100644
--- a/engines/net.c
+++ b/engines/net.c
@@ -18,6 +18,16 @@
 #include <sys/socket.h>
 #include <sys/un.h>
 
+#ifdef CONFIG_VSOCK
+#include <linux/vm_sockets.h>
+#else
+struct sockaddr_vm {
+};
+#ifndef AF_VSOCK
+#define AF_VSOCK	-1
+#endif
+#endif
+
 #include "../fio.h"
 #include "../verify.h"
 #include "../optgroup.h"
@@ -30,6 +40,7 @@ struct netio_data {
 	struct sockaddr_in addr;
 	struct sockaddr_in6 addr6;
 	struct sockaddr_un addr_un;
+	struct sockaddr_vm addr_vm;
 	uint64_t udp_send_seq;
 	uint64_t udp_recv_seq;
 };
@@ -69,6 +80,7 @@ enum {
 	FIO_TYPE_UNIX	= 3,
 	FIO_TYPE_TCP_V6	= 4,
 	FIO_TYPE_UDP_V6	= 5,
+	FIO_TYPE_VSOCK_STREAM   = 6,
 };
 
 static int str_hostname_cb(void *data, const char *input);
@@ -126,6 +138,10 @@ static struct fio_option options[] = {
 			    .oval = FIO_TYPE_UNIX,
 			    .help = "UNIX domain socket",
 			  },
+			  { .ival = "vsock",
+			    .oval = FIO_TYPE_VSOCK_STREAM,
+			    .help = "Virtual socket",
+			  },
 		},
 		.category = FIO_OPT_C_ENGINE,
 		.group	= FIO_OPT_G_NETIO,
@@ -223,6 +239,11 @@ static inline int is_ipv6(struct netio_options *o)
 	return o->proto == FIO_TYPE_UDP_V6 || o->proto == FIO_TYPE_TCP_V6;
 }
 
+static inline int is_vsock(struct netio_options *o)
+{
+	return o->proto == FIO_TYPE_VSOCK_STREAM;
+}
+
 static int set_window_size(struct thread_data *td, int fd)
 {
 #ifdef CONFIG_NET_WINDOWSIZE
@@ -732,6 +753,9 @@ static int fio_netio_connect(struct thread_data *td, struct fio_file *f)
 	} else if (o->proto == FIO_TYPE_UNIX) {
 		domain = AF_UNIX;
 		type = SOCK_STREAM;
+	} else if (is_vsock(o)) {
+		domain = AF_VSOCK;
+		type = SOCK_STREAM;
 	} else {
 		log_err("fio: bad network type %d\n", o->proto);
 		f->fd = -1;
@@ -809,7 +833,14 @@ static int fio_netio_connect(struct thread_data *td, struct fio_file *f)
 			close(f->fd);
 			return 1;
 		}
+	} else if (is_vsock(o)) {
+		socklen_t len = sizeof(nd->addr_vm);
 
+		if (connect(f->fd, (struct sockaddr *) &nd->addr_vm, len) < 0) {
+			td_verror(td, errno, "connect");
+			close(f->fd);
+			return 1;
+		}
 	} else {
 		struct sockaddr_un *addr = &nd->addr_un;
 		socklen_t len;
@@ -849,6 +880,9 @@ static int fio_netio_accept(struct thread_data *td, struct fio_file *f)
 	if (o->proto == FIO_TYPE_TCP) {
 		socklen = sizeof(nd->addr);
 		f->fd = accept(nd->listenfd, (struct sockaddr *) &nd->addr, &socklen);
+	} else if (is_vsock(o)) {
+		socklen = sizeof(nd->addr_vm);
+		f->fd = accept(nd->listenfd, (struct sockaddr *) &nd->addr_vm, &socklen);
 	} else {
 		socklen = sizeof(nd->addr6);
 		f->fd = accept(nd->listenfd, (struct sockaddr *) &nd->addr6, &socklen);
@@ -890,6 +924,9 @@ static void fio_netio_send_close(struct thread_data *td, struct fio_file *f)
 	if (is_ipv6(o)) {
 		to = (struct sockaddr *) &nd->addr6;
 		len = sizeof(nd->addr6);
+	} else if (is_vsock(o)) {
+		to = NULL;
+		len = 0;
 	} else {
 		to = (struct sockaddr *) &nd->addr;
 		len = sizeof(nd->addr);
@@ -960,6 +997,9 @@ static int fio_netio_send_open(struct thread_data *td, struct fio_file *f)
 	if (is_ipv6(o)) {
 		len = sizeof(nd->addr6);
 		to = (struct sockaddr *) &nd->addr6;
+	} else if (is_vsock(o)) {
+		len = sizeof(nd->addr_vm);
+		to = (struct sockaddr *) &nd->addr_vm;
 	} else {
 		len = sizeof(nd->addr);
 		to = (struct sockaddr *) &nd->addr;
@@ -1023,13 +1063,17 @@ static int fio_fill_addr(struct thread_data *td, const char *host, int af,
 
 	memset(&hints, 0, sizeof(hints));
 
-	if (is_tcp(o))
+	if (is_tcp(o) || is_vsock(o))
 		hints.ai_socktype = SOCK_STREAM;
 	else
 		hints.ai_socktype = SOCK_DGRAM;
 
 	if (is_ipv6(o))
 		hints.ai_family = AF_INET6;
+#ifdef CONFIG_VSOCK
+	else if (is_vsock(o))
+		hints.ai_family = AF_VSOCK;
+#endif
 	else
 		hints.ai_family = AF_INET;
 
@@ -1110,12 +1154,50 @@ static int fio_netio_setup_connect_unix(struct thread_data *td,
 	return 0;
 }
 
+static int fio_netio_setup_connect_vsock(struct thread_data *td,
+					const char *host, unsigned short port)
+{
+#ifdef CONFIG_VSOCK
+	struct netio_data *nd = td->io_ops_data;
+	struct sockaddr_vm *addr = &nd->addr_vm;
+	int cid;
+
+	if (!host) {
+		log_err("fio: connect with no host to connect to.\n");
+		if (td_read(td))
+			log_err("fio: did you forget to set 'listen'?\n");
+
+		td_verror(td, EINVAL, "no hostname= set");
+		return 1;
+	}
+
+	addr->svm_family = AF_VSOCK;
+	addr->svm_port = port;
+
+	if (host) {
+		cid = atoi(host);
+		if (cid < 0 || cid > UINT32_MAX) {
+			log_err("fio: invalid CID %d\n", cid);
+			return 1;
+		}
+		addr->svm_cid = cid;
+	}
+
+	return 0;
+#else
+	td_verror(td, -EINVAL, "vsock not supported");
+	return 1;
+#endif
+}
+
 static int fio_netio_setup_connect(struct thread_data *td)
 {
 	struct netio_options *o = td->eo;
 
 	if (is_udp(o) || is_tcp(o))
 		return fio_netio_setup_connect_inet(td, td->o.filename,o->port);
+	else if (is_vsock(o))
+		return fio_netio_setup_connect_vsock(td, td->o.filename, o->port);
 	else
 		return fio_netio_setup_connect_unix(td, td->o.filename);
 }
@@ -1268,6 +1350,47 @@ static int fio_netio_setup_listen_inet(struct thread_data *td, short port)
 	return 0;
 }
 
+static int fio_netio_setup_listen_vsock(struct thread_data *td, short port, int type)
+{
+#ifdef CONFIG_VSOCK
+	struct netio_data *nd = td->io_ops_data;
+	struct sockaddr_vm *addr = &nd->addr_vm;
+	int fd, opt;
+	socklen_t len;
+
+	fd = socket(AF_VSOCK, type, 0);
+	if (fd < 0) {
+		td_verror(td, errno, "socket");
+		return 1;
+	}
+
+	opt = 1;
+	if (setsockopt(fd, SOL_SOCKET, SO_REUSEADDR, (void *) &opt, sizeof(opt)) < 0) {
+		td_verror(td, errno, "setsockopt");
+		close(fd);
+		return 1;
+	}
+
+	len = sizeof(*addr);
+
+	nd->addr_vm.svm_family = AF_VSOCK;
+	nd->addr_vm.svm_cid = VMADDR_CID_ANY;
+	nd->addr_vm.svm_port = port;
+
+	if (bind(fd, (struct sockaddr *) addr, len) < 0) {
+		td_verror(td, errno, "bind");
+		close(fd);
+		return 1;
+	}
+
+	nd->listenfd = fd;
+	return 0;
+#else
+	td_verror(td, -EINVAL, "vsock not supported");
+	return -1;
+#endif
+}
+
 static int fio_netio_setup_listen(struct thread_data *td)
 {
 	struct netio_data *nd = td->io_ops_data;
@@ -1276,6 +1399,8 @@ static int fio_netio_setup_listen(struct thread_data *td)
 
 	if (is_udp(o) || is_tcp(o))
 		ret = fio_netio_setup_listen_inet(td, o->port);
+	else if (is_vsock(o))
+		ret = fio_netio_setup_listen_vsock(td, o->port, SOCK_STREAM);
 	else
 		ret = fio_netio_setup_listen_unix(td, td->o.filename);
 
@@ -1311,6 +1436,9 @@ static int fio_netio_init(struct thread_data *td)
 	if (o->proto == FIO_TYPE_UNIX && o->port) {
 		log_err("fio: network IO port not valid with unix socket\n");
 		return 1;
+	} else if (is_vsock(o) && !o->port) {
+		log_err("fio: network IO requires port for vsock\n");
+		return 1;
 	} else if (o->proto != FIO_TYPE_UNIX && !o->port) {
 		log_err("fio: network IO requires port for tcp or udp\n");
 		return 1;
@@ -1318,7 +1446,7 @@ static int fio_netio_init(struct thread_data *td)
 
 	o->port += td->subjob_number;
 
-	if (!is_tcp(o)) {
+	if (!is_tcp(o) && !is_vsock(o)) {
 		if (o->listen) {
 			log_err("fio: listen only valid for TCP proto IO\n");
 			return 1;
diff --git a/examples/netio_vsock.fio b/examples/netio_vsock.fio
new file mode 100644
index 00000000..8c328f7d
--- /dev/null
+++ b/examples/netio_vsock.fio
@@ -0,0 +1,22 @@
+# Example network vsock job, just defines two clients that send/recv data
+[global]
+ioengine=net
+
+port=8888
+protocol=vsock
+bs=4k
+size=100g
+
+#set the below option to enable end-to-end data integrity tests
+#verify=md5
+
+[receiver]
+listen
+rw=read
+
+[sender]
+# 1 (VMADDR_CID_LOCAL) is the well-known address
+# for local communication (loopback)
+hostname=1
+startdelay=1
+rw=write
diff --git a/examples/netio_vsock_receiver.fio b/examples/netio_vsock_receiver.fio
new file mode 100644
index 00000000..e2a00c4d
--- /dev/null
+++ b/examples/netio_vsock_receiver.fio
@@ -0,0 +1,14 @@
+# Example network vsock job, just defines a receiver
+[global]
+ioengine=net
+port=8888
+protocol=vsock
+bs=4k
+size=100g
+
+#set the below option to enable end-to-end data integrity tests
+#verify=md5
+
+[receiver]
+listen
+rw=read
diff --git a/examples/netio_vsock_sender.fio b/examples/netio_vsock_sender.fio
new file mode 100644
index 00000000..2451d990
--- /dev/null
+++ b/examples/netio_vsock_sender.fio
@@ -0,0 +1,17 @@
+# Example network vsock job, just defines a sender
+[global]
+ioengine=net
+port=8888
+protocol=vsock
+bs=4k
+size=100g
+
+#set the below option to enable end-to-end data integrity tests
+#verify=md5
+
+[sender]
+# set the 'hostname' option to the CID of the listening domain
+hostname=3
+startdelay=1
+rw=write
+
diff --git a/fio.1 b/fio.1
index aef1dc85..227fcb47 100644
--- a/fio.1
+++ b/fio.1
@@ -2376,11 +2376,16 @@ User datagram protocol V6.
 .TP
 .B unix
 UNIX domain socket.
+.TP
+.B vsock
+VSOCK protocol.
 .RE
 .P
-When the protocol is TCP or UDP, the port must also be given, as well as the
-hostname if the job is a TCP listener or UDP reader. For unix sockets, the
+When the protocol is TCP, UDP or VSOCK, the port must also be given, as well as the
+hostname if the job is a TCP or VSOCK listener or UDP reader. For unix sockets, the
 normal \fBfilename\fR option should be used and the port is invalid.
+When the protocol is VSOCK, the \fBhostname\fR is the CID of the remote VM.
+
 .RE
 .TP
 .BI (netsplice,net)listen
