Return-Path: <fio-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:46080 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754090AbaJJMAI (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 10 Oct 2014 08:00:08 -0400
Received: from kernel.dk ([54.225.238.116] helo=lyth.info)
	by casper.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1XcYre-0003nS-SA
	for fio@vger.kernel.org; Fri, 10 Oct 2014 12:00:07 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20141010120003.3BDF140155@lyth.info>
Date: Fri, 10 Oct 2014 06:00:03 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit c5dd6d8975fc36da778d08c21d3e051add6d3030:

  net: use SIGTERM for terminate (2014-10-08 14:14:05 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 3441a52d588b95267f31491d4dca5f1418b1dcf5:

  engines/libaio: better protect against a busy loop in getevents() (2014-10-09 20:14:27 -0600)

----------------------------------------------------------------
Andrey Kuzmin (1):
      engines/libaio: better protect against a busy loop in getevents()

Jens Axboe (12):
      net: fix error reported on job exit and full residual
      engines/net: add socket buffer window size setting
      engines/net: add TCP_MAXSEG setting (mss)
      engines/net: add start of tracking how many UDP packages are dropped
      stat: add dropped ios to the standard output
      engines/net: turn off UDP package dropping if buf size doesn't match
      eta: don't count TD_SETTING_UP as a running process
      engines/net: use link close message on TCP as well
      configure: only print gtk status if --enable-gfio used
      engines/net: add subjob number to given port
      Update documentation on net engine port usage
      stat: add total/short/drop ios to the json output

 HOWTO            |    9 ++-
 client.c         |    1 +
 configure        |   56 ++++++++++++++--
 engines/libaio.c |    4 +-
 engines/net.c    |  196 +++++++++++++++++++++++++++++++++++++++++++++++++-----
 eta.c            |    5 +-
 fio.1            |   10 ++-
 server.c         |    1 +
 stat.c           |   18 +++--
 stat.h           |    1 +
 10 files changed, 268 insertions(+), 33 deletions(-)

---

Diff of recent changes:

diff --git a/HOWTO b/HOWTO
index 2cecbbb..e18eadb 100644
--- a/HOWTO
+++ b/HOWTO
@@ -1640,7 +1640,9 @@ that defines them is selected.
 		address.
 
 [netsplice] port=int
-[net] port=int	The TCP or UDP port to bind to or connect to.
+[net] port=int	The TCP or UDP port to bind to or connect to. If this is used
+with numjobs to spawn multiple instances of the same job type, then this will
+be the starting port number since fio will use a range of ports.
 
 [netsplice] interface=str
 [net] interface=str  The IP address of the network interface used to send or
@@ -1672,6 +1674,7 @@ that defines them is selected.
 [net] listen	For TCP network connections, tell fio to listen for incoming
 		connections rather than initiating an outgoing connection. The
 		hostname must be omitted if this option is used.
+
 [net] pingpong	Normaly a network writer will just continue writing data, and
 		a network reader will just consume packages. If pingpong=1
 		is set, a writer will send its normal payload to the reader,
@@ -1684,6 +1687,10 @@ that defines them is selected.
 		single reader when multiple readers are listening to the same
 		address.
 
+[net] window_size	Set the desired socket buffer size for the connection.
+
+[net] mss	Set the TCP maximum segment size (TCP_MAXSEG).
+
 [e4defrag] donorname=str
 	        File will be used as a block donor(swap extents between files)
 [e4defrag] inplace=int
diff --git a/client.c b/client.c
index 66f982c..1879e44 100644
--- a/client.c
+++ b/client.c
@@ -831,6 +831,7 @@ static void convert_ts(struct thread_stat *dst, struct thread_stat *src)
 	for (i = 0; i < DDIR_RWDIR_CNT; i++) {
 		dst->total_io_u[i]	= le64_to_cpu(src->total_io_u[i]);
 		dst->short_io_u[i]	= le64_to_cpu(src->short_io_u[i]);
+		dst->drop_io_u[i]	= le64_to_cpu(src->drop_io_u[i]);
 	}
 
 	dst->total_submit	= le64_to_cpu(src->total_submit);
diff --git a/configure b/configure
index e3ec252..58f02fa 100755
--- a/configure
+++ b/configure
@@ -133,7 +133,7 @@ cpu=""
 # default options
 show_help="no"
 exit_val=0
-gfio="no"
+gfio_check="no"
 libhdfs="no"
 
 # parse options
@@ -153,7 +153,7 @@ for opt do
   --build-32bit-win) build_32bit_win="yes"
   ;;
   --enable-gfio)
-  gfio="yes"
+  gfio_check="yes"
   ;;
   --disable-numa) disable_numa="yes"
   ;;
@@ -982,7 +982,8 @@ echo "__thread                      $tls_thread"
 
 ##########################################
 # Check if we have required gtk/glib support for gfio
-if test "$gfio" = "yes" ; then
+gfio="no"
+if test "$gfio_check" = "yes" ; then
   cat > $TMPC << EOF
 #include <glib.h>
 #include <cairo.h>
@@ -1021,7 +1022,9 @@ else
 fi
 fi
 
-echo "gtk 2.18 or higher            $gfio"
+if test "$gfio_check" = "yes" ; then
+  echo "gtk 2.18 or higher            $gfio"
+fi
 
 # Check whether we have getrusage(RUSAGE_THREAD)
 rusage_thread="no"
@@ -1075,6 +1078,45 @@ fi
 echo "TCP_NODELAY                   $tcp_nodelay"
 
 ##########################################
+# Check whether we have SO_SNDBUF
+window_size="no"
+cat > $TMPC << EOF
+#include <stdio.h>
+#include <sys/types.h>
+#include <sys/socket.h>
+#include <netinet/tcp.h>
+int main(int argc, char **argv)
+{
+  setsockopt(0, SOL_SOCKET, SO_SNDBUF, NULL, 0);
+  setsockopt(0, SOL_SOCKET, SO_RCVBUF, NULL, 0);
+}
+EOF
+if compile_prog "" "" "SO_SNDBUF"; then
+  window_size="yes"
+fi
+echo "Net engine window_size        $window_size"
+
+##########################################
+# Check whether we have TCP_MAXSEG
+mss="no"
+cat > $TMPC << EOF
+#include <stdio.h>
+#include <sys/types.h>
+#include <sys/socket.h>
+#include <netinet/tcp.h>
+#include <arpa/inet.h>
+#include <netinet/in.h>
+int main(int argc, char **argv)
+{
+  return setsockopt(0, IPPROTO_TCP, TCP_MAXSEG, NULL, 0);
+}
+EOF
+if compile_prog "" "" "TCP_MAXSEG"; then
+  mss="yes"
+fi
+echo "TCP_MAXSEG                    $mss"
+
+##########################################
 # Check whether we have RLIMIT_MEMLOCK
 rlimit_memlock="no"
 cat > $TMPC << EOF
@@ -1429,6 +1471,12 @@ fi
 if test "$tcp_nodelay" = "yes" ; then
   output_sym "CONFIG_TCP_NODELAY"
 fi
+if test "$window_size" = "yes" ; then
+  output_sym "CONFIG_NET_WINDOWSIZE"
+fi
+if test "$mss" = "yes" ; then
+  output_sym "CONFIG_NET_MSS"
+fi
 if test "$rlimit_memlock" = "yes" ; then
   output_sym "CONFIG_RLIMIT_MEMLOCK"
 fi
diff --git a/engines/libaio.c b/engines/libaio.c
index 7c3a42a..12f3b36 100644
--- a/engines/libaio.c
+++ b/engines/libaio.c
@@ -165,9 +165,9 @@ static int fio_libaio_getevents(struct thread_data *td, unsigned int min,
 			r = io_getevents(ld->aio_ctx, actual_min,
 				max, ld->aio_events + events, lt);
 		}
-		if (r >= 0)
+		if (r > 0)
 			events += r;
-		else if (r == -EAGAIN) {
+		else if ((min && r == 0) || r == -EAGAIN) {
 			fio_libaio_commit(td);
 			usleep(100);
 		} else if (r != -EINTR)
diff --git a/engines/net.c b/engines/net.c
index 1d89db1..aa7de96 100644
--- a/engines/net.c
+++ b/engines/net.c
@@ -21,14 +21,18 @@
 #include <sys/un.h>
 
 #include "../fio.h"
+#include "../verify.h"
 
 struct netio_data {
 	int listenfd;
 	int use_splice;
+	int seq_off;
 	int pipes[2];
 	struct sockaddr_in addr;
 	struct sockaddr_in6 addr6;
 	struct sockaddr_un addr_un;
+	uint64_t udp_send_seq;
+	uint64_t udp_recv_seq;
 };
 
 struct netio_options {
@@ -39,6 +43,8 @@ struct netio_options {
 	unsigned int pingpong;
 	unsigned int nodelay;
 	unsigned int ttl;
+	unsigned int window_size;
+	unsigned int mss;
 	char *intfc;
 };
 
@@ -47,10 +53,17 @@ struct udp_close_msg {
 	uint32_t cmd;
 };
 
+struct udp_seq {
+	uint64_t magic;
+	uint64_t seq;
+	uint64_t bs;
+};
+
 enum {
 	FIO_LINK_CLOSE = 0x89,
 	FIO_LINK_OPEN_CLOSE_MAGIC = 0x6c696e6b,
 	FIO_LINK_OPEN = 0x98,
+	FIO_UDP_SEQ_MAGIC = 0x657375716e556563ULL,
 
 	FIO_TYPE_TCP	= 1,
 	FIO_TYPE_UDP	= 2,
@@ -165,6 +178,30 @@ static struct fio_option options[] = {
 		.category = FIO_OPT_C_ENGINE,
 		.group	= FIO_OPT_G_NETIO,
 	},
+#ifdef CONFIG_NET_WINDOWSIZE
+	{
+		.name	= "window_size",
+		.lname	= "Window Size",
+		.type	= FIO_OPT_INT,
+		.off1	= offsetof(struct netio_options, window_size),
+		.minval	= 0,
+		.help	= "Set socket buffer window size",
+		.category = FIO_OPT_C_ENGINE,
+		.group	= FIO_OPT_G_NETIO,
+	},
+#endif
+#ifdef CONFIG_NET_MSS
+	{
+		.name	= "mss",
+		.lname	= "Maximum segment size",
+		.type	= FIO_OPT_INT,
+		.off1	= offsetof(struct netio_options, mss),
+		.minval	= 0,
+		.help	= "Set TCP maximum segment size",
+		.category = FIO_OPT_C_ENGINE,
+		.group	= FIO_OPT_G_NETIO,
+	},
+#endif
 	{
 		.name	= NULL,
 	},
@@ -185,6 +222,65 @@ static inline int is_ipv6(struct netio_options *o)
 	return o->proto == FIO_TYPE_UDP_V6 || o->proto == FIO_TYPE_TCP_V6;
 }
 
+static int set_window_size(struct thread_data *td, int fd)
+{
+#ifdef CONFIG_NET_WINDOWSIZE
+	struct netio_options *o = td->eo;
+	unsigned int wss;
+	int snd, rcv, ret;
+
+	if (!o->window_size)
+		return 0;
+
+	rcv = o->listen || o->pingpong;
+	snd = !o->listen || o->pingpong;
+	wss = o->window_size;
+	ret = 0;
+
+	if (rcv) {
+		ret = setsockopt(fd, SOL_SOCKET, SO_RCVBUF, (void *) &wss,
+					sizeof(wss));
+		if (ret < 0)
+			td_verror(td, errno, "rcvbuf window size");
+	}
+	if (snd && !ret) {
+		ret = setsockopt(fd, SOL_SOCKET, SO_SNDBUF, (void *) &wss,
+					sizeof(wss));
+		if (ret < 0)
+			td_verror(td, errno, "sndbuf window size");
+	}
+
+	return ret;
+#else
+	td_verror(td, -EINVAL, "setsockopt window size");
+	return -1;
+#endif
+}
+
+static int set_mss(struct thread_data *td, int fd)
+{
+#ifdef CONFIG_NET_MSS
+	struct netio_options *o = td->eo;
+	unsigned int mss;
+	int ret;
+
+	if (!o->mss || !is_tcp(o))
+		return 0;
+
+	mss = o->mss;
+	ret = setsockopt(fd, IPPROTO_TCP, TCP_MAXSEG, (void *) &mss,
+				sizeof(mss));
+	if (ret < 0)
+		td_verror(td, errno, "setsockopt TCP_MAXSEG");
+
+	return ret;
+#else
+	td_verror(td, -EINVAL, "setsockopt TCP_MAXSEG");
+	return -1;
+#endif
+}
+
+
 /*
  * Return -1 for error and 'nr events' for a positive number
  * of events
@@ -384,6 +480,41 @@ static int fio_netio_splice_out(struct thread_data *td, struct io_u *io_u)
 }
 #endif
 
+static void store_udp_seq(struct netio_data *nd, struct io_u *io_u)
+{
+	struct udp_seq *us;
+
+	us = io_u->xfer_buf + io_u->xfer_buflen - sizeof(*us);
+	us->magic = cpu_to_le64(FIO_UDP_SEQ_MAGIC);
+	us->bs = cpu_to_le64((uint64_t) io_u->xfer_buflen);
+	us->seq = cpu_to_le64(nd->udp_send_seq++);
+}
+
+static void verify_udp_seq(struct thread_data *td, struct netio_data *nd,
+			   struct io_u *io_u)
+{
+	struct udp_seq *us;
+	uint64_t seq;
+
+	if (nd->seq_off)
+		return;
+
+	us = io_u->xfer_buf + io_u->xfer_buflen - sizeof(*us);
+	if (le64_to_cpu(us->magic) != FIO_UDP_SEQ_MAGIC)
+		return;
+	if (le64_to_cpu(us->bs) != io_u->xfer_buflen) {
+		nd->seq_off = 1;
+		return;
+	}
+
+	seq = le64_to_cpu(us->seq);
+
+	if (seq != nd->udp_recv_seq)
+		td->ts.drop_io_u[io_u->ddir] += seq - nd->udp_recv_seq;
+
+	nd->udp_recv_seq = seq + 1;
+}
+
 static int fio_netio_send(struct thread_data *td, struct io_u *io_u)
 {
 	struct netio_data *nd = td->io_ops->data;
@@ -403,6 +534,9 @@ static int fio_netio_send(struct thread_data *td, struct io_u *io_u)
 				len = sizeof(nd->addr);
 			}
 
+			if (td->o.verify == VERIFY_NONE)
+				store_udp_seq(nd, io_u);
+
 			ret = sendto(io_u->file->fd, io_u->xfer_buf,
 					io_u->xfer_buflen, flags, to, len);
 		} else {
@@ -428,7 +562,7 @@ static int fio_netio_send(struct thread_data *td, struct io_u *io_u)
 	return ret;
 }
 
-static int is_udp_close(struct io_u *io_u, int len)
+static int is_close_msg(struct io_u *io_u, int len)
 {
 	struct udp_close_msg *msg;
 
@@ -436,9 +570,9 @@ static int is_udp_close(struct io_u *io_u, int len)
 		return 0;
 
 	msg = io_u->xfer_buf;
-	if (ntohl(msg->magic) != FIO_LINK_OPEN_CLOSE_MAGIC)
+	if (le32_to_cpu(msg->magic) != FIO_LINK_OPEN_CLOSE_MAGIC)
 		return 0;
-	if (ntohl(msg->cmd) != FIO_LINK_CLOSE)
+	if (le32_to_cpu(msg->cmd) != FIO_LINK_CLOSE)
 		return 0;
 
 	return 1;
@@ -470,13 +604,19 @@ static int fio_netio_recv(struct thread_data *td, struct io_u *io_u)
 
 			ret = recvfrom(io_u->file->fd, io_u->xfer_buf,
 					io_u->xfer_buflen, flags, from, len);
-			if (is_udp_close(io_u, ret)) {
+
+			if (is_close_msg(io_u, ret)) {
 				td->done = 1;
 				return 0;
 			}
 		} else {
 			ret = recv(io_u->file->fd, io_u->xfer_buf,
 					io_u->xfer_buflen, flags);
+
+			if (is_close_msg(io_u, ret)) {
+				td->done = 1;
+				return 0;
+			}
 		}
 		if (ret > 0)
 			break;
@@ -489,6 +629,9 @@ static int fio_netio_recv(struct thread_data *td, struct io_u *io_u)
 		flags |= MSG_WAITALL;
 	} while (1);
 
+	if (is_udp(o) && td->o.verify == VERIFY_NONE)
+		verify_udp_seq(td, nd, io_u);
+
 	return ret;
 }
 
@@ -515,11 +658,13 @@ static int __fio_netio_queue(struct thread_data *td, struct io_u *io_u,
 		ret = 0;	/* must be a SYNC */
 
 	if (ret != (int) io_u->xfer_buflen) {
-		if (ret >= 0) {
+		if (ret > 0) {
 			io_u->resid = io_u->xfer_buflen - ret;
 			io_u->error = 0;
 			return FIO_Q_COMPLETED;
-		} else {
+		} else if (!ret)
+			return FIO_Q_BUSY;
+		else {
 			int err = errno;
 
 			if (ddir == DDIR_WRITE && err == EMSGSIZE)
@@ -601,6 +746,15 @@ static int fio_netio_connect(struct thread_data *td, struct fio_file *f)
 	}
 #endif
 
+	if (set_window_size(td, f->fd)) {
+		close(f->fd);
+		return 1;
+	}
+	if (set_mss(td, f->fd)) {
+		close(f->fd);
+		return 1;
+	}
+
 	if (is_udp(o)) {
 		if (!fio_netio_is_multicast(td->o.filename))
 			return 0;
@@ -715,7 +869,7 @@ err:
 	return 1;
 }
 
-static void fio_netio_udp_close(struct thread_data *td, struct fio_file *f)
+static void fio_netio_send_close(struct thread_data *td, struct fio_file *f)
 {
 	struct netio_data *nd = td->io_ops->data;
 	struct netio_options *o = td->eo;
@@ -732,8 +886,8 @@ static void fio_netio_udp_close(struct thread_data *td, struct fio_file *f)
 		len = sizeof(nd->addr);
 	}
 
-	msg.magic = htonl(FIO_LINK_OPEN_CLOSE_MAGIC);
-	msg.cmd = htonl(FIO_LINK_CLOSE);
+	msg.magic = cpu_to_le32((uint32_t) FIO_LINK_OPEN_CLOSE_MAGIC);
+	msg.cmd = cpu_to_le32((uint32_t) FIO_LINK_CLOSE);
 
 	ret = sendto(f->fd, (void *) &msg, sizeof(msg), MSG_WAITALL, to, len);
 	if (ret < 0)
@@ -742,14 +896,10 @@ static void fio_netio_udp_close(struct thread_data *td, struct fio_file *f)
 
 static int fio_netio_close_file(struct thread_data *td, struct fio_file *f)
 {
-	struct netio_options *o = td->eo;
-
 	/*
-	 * If this is an UDP connection, notify the receiver that we are
-	 * closing down the link
+	 * Notify the receiver that we are closing down the link
 	 */
-	if (is_udp(o))
-		fio_netio_udp_close(td, f);
+	fio_netio_send_close(td, f);
 
 	return generic_close_file(td, f);
 }
@@ -784,10 +934,11 @@ static int fio_netio_udp_recv_open(struct thread_data *td, struct fio_file *f)
 		return -1;
 	}
 
+	fio_gettime(&td->start, NULL);
 	return 0;
 }
 
-static int fio_netio_udp_send_open(struct thread_data *td, struct fio_file *f)
+static int fio_netio_send_open(struct thread_data *td, struct fio_file *f)
 {
 	struct netio_data *nd = td->io_ops->data;
 	struct netio_options *o = td->eo;
@@ -833,7 +984,7 @@ static int fio_netio_open_file(struct thread_data *td, struct fio_file *f)
 
 	if (is_udp(o)) {
 		if (td_write(td))
-			ret = fio_netio_udp_send_open(td, f);
+			ret = fio_netio_send_open(td, f);
 		else {
 			int state;
 
@@ -1042,6 +1193,15 @@ static int fio_netio_setup_listen_inet(struct thread_data *td, short port)
 	}
 #endif
 
+	if (set_window_size(td, fd)) {
+		close(fd);
+		return 1;
+	}
+	if (set_mss(td, fd)) {
+		close(fd);
+		return 1;
+	}
+
 	if (td->o.filename) {
 		if (!is_udp(o) || !fio_netio_is_multicast(td->o.filename)) {
 			log_err("fio: hostname not valid for non-multicast inbound network IO\n");
@@ -1148,6 +1308,8 @@ static int fio_netio_init(struct thread_data *td)
 		return 1;
 	}
 
+	o->port += td->subjob_number;
+
 	if (!is_tcp(o)) {
 		if (o->listen) {
 			log_err("fio: listen only valid for TCP proto IO\n");
diff --git a/eta.c b/eta.c
index 0105cda..baada7b 100644
--- a/eta.c
+++ b/eta.c
@@ -392,10 +392,9 @@ int calc_thread_status(struct jobs_eta *je, int force)
 		} else if (td->runstate == TD_RAMP) {
 			je->nr_running++;
 			je->nr_ramp++;
-		} else if (td->runstate == TD_SETTING_UP) {
-			je->nr_running++;
+		} else if (td->runstate == TD_SETTING_UP)
 			je->nr_setting_up++;
-		} else if (td->runstate < TD_RUNNING)
+		else if (td->runstate < TD_RUNNING)
 			je->nr_pending++;
 
 		if (je->elapsed_sec >= 3)
diff --git a/fio.1 b/fio.1
index 91c3074..8d02632 100644
--- a/fio.1
+++ b/fio.1
@@ -1471,7 +1471,9 @@ If the job is a TCP listener or UDP reader, the hostname is not
 used and must be omitted unless it is a valid UDP multicast address.
 .TP
 .BI (net,netsplice)port \fR=\fPint
-The TCP or UDP port to bind to or connect to.
+The TCP or UDP port to bind to or connect to. If this is used with
+\fBnumjobs\fR to spawn multiple instances of the same job type, then
+this will be the starting port number since fio will use a range of ports.
 .TP
 .BI (net,netsplice)interface \fR=\fPstr
 The IP address of the network interface used to send or receive UDP multicast
@@ -1525,6 +1527,12 @@ completion latency measures how long it took for the other end to receive and
 send back. For UDP multicast traffic pingpong=1 should only be set for a single
 reader when multiple readers are listening to the same address.
 .TP
+.BI (net, window_size) \fR=\fPint
+Set the desired socket buffer size for the connection.
+.TP
+.BI (net, mss) \fR=\fPint
+Set the TCP maximum segment size (TCP_MAXSEG).
+.TP
 .BI (e4defrag,donorname) \fR=\fPstr
 File will be used as a block donor (swap extents between files)
 .TP
diff --git a/server.c b/server.c
index fa029ca..33c512c 100644
--- a/server.c
+++ b/server.c
@@ -1066,6 +1066,7 @@ void fio_server_send_ts(struct thread_stat *ts, struct group_run_stats *rs)
 	for (i = 0; i < DDIR_RWDIR_CNT; i++) {
 		p.ts.total_io_u[i]	= cpu_to_le64(ts->total_io_u[i]);
 		p.ts.short_io_u[i]	= cpu_to_le64(ts->short_io_u[i]);
+		p.ts.drop_io_u[i]	= cpu_to_le64(ts->drop_io_u[i]);
 	}
 
 	p.ts.total_submit	= cpu_to_le64(ts->total_submit);
diff --git a/stat.c b/stat.c
index 89d7194..77e389c 100644
--- a/stat.c
+++ b/stat.c
@@ -506,9 +506,7 @@ static void show_thread_status_normal(struct thread_stat *ts,
 	time_t time_p;
 	char time_buf[64];
 
-	if (!(ts->io_bytes[DDIR_READ] + ts->io_bytes[DDIR_WRITE] +
-	    ts->io_bytes[DDIR_TRIM]) && !(ts->total_io_u[DDIR_READ] +
-	    ts->total_io_u[DDIR_WRITE] + ts->total_io_u[DDIR_TRIM]))
+	if (!ddir_rw_sum(ts->io_bytes) && !ddir_rw_sum(ts->total_io_u))
 		return;
 
 	time(&time_p);
@@ -574,13 +572,17 @@ static void show_thread_status_normal(struct thread_stat *ts,
 					io_u_dist[3], io_u_dist[4],
 					io_u_dist[5], io_u_dist[6]);
 	log_info("     issued    : total=r=%llu/w=%llu/d=%llu,"
-				 " short=r=%llu/w=%llu/d=%llu\n",
+				 " short=r=%llu/w=%llu/d=%llu,"
+				 " drop=r=%llu/w=%llu/d=%llu\n",
 					(unsigned long long) ts->total_io_u[0],
 					(unsigned long long) ts->total_io_u[1],
 					(unsigned long long) ts->total_io_u[2],
 					(unsigned long long) ts->short_io_u[0],
 					(unsigned long long) ts->short_io_u[1],
-					(unsigned long long) ts->short_io_u[2]);
+					(unsigned long long) ts->short_io_u[2],
+					(unsigned long long) ts->drop_io_u[0],
+					(unsigned long long) ts->drop_io_u[1],
+					(unsigned long long) ts->drop_io_u[2]);
 	if (ts->continue_on_error) {
 		log_info("     errors    : total=%llu, first_error=%d/<%s>\n",
 					(unsigned long long)ts->total_err_count,
@@ -703,6 +705,9 @@ static void add_ddir_status_json(struct thread_stat *ts,
 	json_object_add_value_int(dir_object, "bw", bw);
 	json_object_add_value_int(dir_object, "iops", iops);
 	json_object_add_value_int(dir_object, "runtime", ts->runtime[ddir]);
+	json_object_add_value_int(dir_object, "total_ios", ts->total_io_u[ddir]);
+	json_object_add_value_int(dir_object, "short_ios", ts->short_io_u[ddir]);
+	json_object_add_value_int(dir_object, "drop_ios", ts->drop_io_u[ddir]);
 
 	if (!calc_lat(&ts->slat_stat[ddir], &min, &max, &mean, &dev)) {
 		min = max = 0;
@@ -1123,9 +1128,11 @@ void sum_thread_stats(struct thread_stat *dst, struct thread_stat *src, int nr)
 		if (!dst->unified_rw_rep) {
 			dst->total_io_u[k] += src->total_io_u[k];
 			dst->short_io_u[k] += src->short_io_u[k];
+			dst->drop_io_u[k] += src->drop_io_u[k];
 		} else {
 			dst->total_io_u[0] += src->total_io_u[k];
 			dst->short_io_u[0] += src->short_io_u[k];
+			dst->drop_io_u[0] += src->drop_io_u[k];
 		}
 	}
 
@@ -1658,6 +1665,7 @@ void reset_io_stats(struct thread_data *td)
 	for (i = 0; i < 3; i++) {
 		ts->total_io_u[i] = 0;
 		ts->short_io_u[i] = 0;
+		ts->drop_io_u[i] = 0;
 	}
 }
 
diff --git a/stat.h b/stat.h
index 90a7fb3..1727c0c 100644
--- a/stat.h
+++ b/stat.h
@@ -160,6 +160,7 @@ struct thread_stat {
 	uint32_t io_u_plat[DDIR_RWDIR_CNT][FIO_IO_U_PLAT_NR];
 	uint64_t total_io_u[3];
 	uint64_t short_io_u[3];
+	uint64_t drop_io_u[3];
 	uint64_t total_submit;
 	uint64_t total_complete;
 
