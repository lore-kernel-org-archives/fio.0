Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:59523 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750716Ab3GWEAG (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 23 Jul 2013 00:00:06 -0400
Received: from kernel.dk ([54.225.238.116])
	by merlin.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1V1Tld-0006XA-Dv
	for fio@vger.kernel.org; Tue, 23 Jul 2013 04:00:05 +0000
Subject: Recent changes (master)
From: Jens Axboe <jaxboe@fusionio.com>
Message-Id: <20130723040002.80F852056D@kernel.dk>
Date: Tue, 23 Jul 2013 04:00:02 +0000 (UTC)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 4a93dec2a85f4a979421638fde2877268c470ab1:

  net: close socket on error (2013-07-20 20:41:23 -0600)

are available in the git repository at:
  git://git.kernel.dk/fio.git master

Erwan Velu (13):
      genfio: Splitting gen_template in 2 parts
      genfio: Adding exec_{pre|post}run support
      genfio: Don't use cat EOF for small prints
      genfio: Use dynamic default values in help
      tools: Adding gitignore
      genfio: Protecting parse_cmdline from spaces
      fio2gnuplot: Fixing Yaxis rendering for 2D plots
      fio2gnuplot: Keep original filename in temp. files
      fio2gnuplot: Don't truncate fio log files
      fio2gnuplot: Don't plot fake data
      core: Removing duplicated code
      core: Don't leak memory if error is unknown
      core: Insure "il" is initialized in all cases

Shawn Bohrer (4):
      net: Add UDP multicast support
      net: Allow setting network interface to use for multicast
      net: Add option to set outgoing multicast TTL
      net: Add UDP multicast example job file

Yufei Ren (1):
      Update for RDMA io engine's compatibility

 HOWTO                        |   16 +++++-
 configure                    |    2 +-
 engines/net.c                |  113 +++++++++++++++++++++++++++++++++++++----
 engines/rdma.c               |   10 ++--
 examples/netio_multicast.fio |   23 +++++++++
 fio.1                        |   14 ++++-
 init.c                       |    2 -
 options.c                    |    1 +
 parse.c                      |    2 +-
 stat.c                       |    6 +--
 tools/.gitignore             |    1 +
 tools/genfio                 |   51 +++++++++++--------
 tools/plot/fio2gnuplot.py    |   20 ++++++--
 tools/plot/graph2D.gpm       |    2 +-
 14 files changed, 206 insertions(+), 57 deletions(-)
 create mode 100644 examples/netio_multicast.fio
 create mode 100644 tools/.gitignore

---

Diff of recent changes:

diff --git a/HOWTO b/HOWTO
index 4fd0251..a2de470 100644
--- a/HOWTO
+++ b/HOWTO
@@ -1438,11 +1438,20 @@ that defines them is selected.
 [netsplice] hostname=str
 [net] hostname=str The host name or IP address to use for TCP or UDP based IO.
 		If the job is a TCP listener or UDP reader, the hostname is not
-		used and must be omitted.
+		used and must be omitted unless it is a valid UDP multicast
+		address.
 
 [netsplice] port=int
 [net] port=int	The TCP or UDP port to bind to or connect to.
 
+[netsplice] interface=str
+[net] interface=str  The IP address of the network interface used to send or
+		receive UDP multicast
+
+[netsplice] ttl=int
+[net] ttl=int	Time-to-live value for outgoing UDP multicast packets.
+		Default: 1
+
 [netsplice] nodelay=bool
 [net] nodelay=bool	Set TCP_NODELAY on TCP connections.
 
@@ -1463,7 +1472,7 @@ that defines them is selected.
 [net] listen	For TCP network connections, tell fio to listen for incoming
 		connections rather than initiating an outgoing connection. The
 		hostname must be omitted if this option is used.
-[net] pingpong	Normal a network writer will just continue writing data, and
+[net] pingpong	Normaly a network writer will just continue writing data, and
 		a network reader will just consume packages. If pingpong=1
 		is set, a writer will send its normal payload to the reader,
 		then wait for the reader to send the same payload back. This
@@ -1471,6 +1480,9 @@ that defines them is selected.
 		and completion latencies then measure local time spent
 		sending or receiving, and the completion latency measures
 		how long it took for the other end to receive and send back.
+		For UDP multicast traffic pingpong=1 should only be set for a
+		single reader when multiple readers are listening to the same
+		address.
 
 [e4defrag] donorname=str
 	        File will be used as a block donor(swap extents between files)
diff --git a/configure b/configure
index 98af5ff..c00a3a4 100755
--- a/configure
+++ b/configure
@@ -1127,7 +1127,7 @@ fi
 if test "$sfaa" = "yes" ; then
   output_sym "CONFIG_SFAA"
 fi
-if test "$libverbs" = "yes" -a "rdmacm" = "yes" ; then
+if test "$libverbs" = "yes" -a "$rdmacm" = "yes" ; then
   output_sym "CONFIG_RDMA"
 fi
 if test "$clock_gettime" = "yes" ; then
diff --git a/engines/net.c b/engines/net.c
index b4ed5df..0c90e1c 100644
--- a/engines/net.c
+++ b/engines/net.c
@@ -37,6 +37,8 @@ struct netio_options {
 	unsigned int listen;
 	unsigned int pingpong;
 	unsigned int nodelay;
+	unsigned int ttl;
+	char * interface;
 };
 
 struct udp_close_msg {
@@ -129,6 +131,26 @@ static struct fio_option options[] = {
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
@@ -164,6 +186,20 @@ static int poll_wait(struct thread_data *td, int fd, short events)
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
@@ -378,11 +414,20 @@ static int fio_netio_recv(struct thread_data *td, struct io_u *io_u)
 
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
@@ -508,9 +553,30 @@ static int fio_netio_connect(struct thread_data *td, struct fio_file *f)
 	}
 #endif
 
-	if (o->proto == FIO_TYPE_UDP)
+	if (o->proto == FIO_TYPE_UDP) {
+		if (!fio_netio_is_multicast(td->o.filename))
+			return 0;
+
+		if (o->interface) {
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
+		if (setsockopt(f->fd, IPPROTO_IP, IP_MULTICAST_TTL, &o->ttl, sizeof(o->ttl)) < 0) {
+			td_verror(td, errno, "setsockopt IP_MULTICAST_TTL");
+			close(f->fd);
+			return 1;
+		}
 		return 0;
-	else if (o->proto == FIO_TYPE_TCP) {
+	} else if (o->proto == FIO_TYPE_TCP) {
 		socklen_t len = sizeof(nd->addr);
 
 		if (connect(f->fd, (struct sockaddr *) &nd->addr, len) < 0) {
@@ -777,8 +843,11 @@ static int fio_netio_setup_listen_inet(struct thread_data *td, short port)
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
@@ -804,8 +873,35 @@ static int fio_netio_setup_listen_inet(struct thread_data *td, short port)
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
+		if (o->interface) {
+			if (inet_aton(o->interface, &mr.imr_interface) == 0) {
+				log_err("fio: interface not valid interface IP\n");
+				close(fd);
+				return 1;
+			}
+		} else {
+			mr.imr_interface.s_addr = htonl(INADDR_ANY);
+		}
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
@@ -882,11 +978,6 @@ static int fio_netio_init(struct thread_data *td)
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
diff --git a/engines/rdma.c b/engines/rdma.c
index ea1af2b..81f1673 100644
--- a/engines/rdma.c
+++ b/engines/rdma.c
@@ -528,10 +528,10 @@ static int fio_rdmaio_getevents(struct thread_data *td, unsigned int min,
 {
 	struct rdmaio_data *rd = td->io_ops->data;
 	enum ibv_wc_opcode comp_opcode;
-	comp_opcode = IBV_WC_RDMA_WRITE;
 	struct ibv_cq *ev_cq;
 	void *ev_ctx;
 	int ret, r = 0;
+	comp_opcode = IBV_WC_RDMA_WRITE;
 
 	switch (rd->rdma_protocol) {
 	case FIO_RDMA_MEM_WRITE:
@@ -1049,12 +1049,11 @@ static int check_set_rlimits(struct thread_data *td)
 static int fio_rdmaio_init(struct thread_data *td)
 {
 	struct rdmaio_data *rd = td->io_ops->data;
-	struct flist_head *entry;
 	unsigned int max_bs;
 	unsigned int port;
 	char host[64], buf[128];
 	char *sep, *portp, *modep;
-	int ret, i = 0;
+	int ret, i;
 
 	if (td_rw(td)) {
 		log_err("fio: rdma connections must be read OR write\n");
@@ -1153,8 +1152,8 @@ static int fio_rdmaio_init(struct thread_data *td)
 
 	max_bs = max(td->o.max_bs[DDIR_READ], td->o.max_bs[DDIR_WRITE]);
 	/* register each io_u in the free list */
-	flist_for_each(entry, &td->io_u_freelist) {
-		struct io_u *io_u = flist_entry(entry, struct io_u, list);
+	for (i = 0; i < td->io_u_freelist.nr; i++) {
+		struct io_u *io_u = td->io_u_freelist.io_us[i];
 
 		io_u->engine_data = malloc(sizeof(struct rdma_io_u_data));
 		memset(io_u->engine_data, 0, sizeof(struct rdma_io_u_data));
@@ -1177,7 +1176,6 @@ static int fio_rdmaio_init(struct thread_data *td)
 #if 0
 		log_info("fio: Send rkey %x addr %" PRIx64 " len %d to client\n", io_u->mr->rkey, io_u->buf, max_bs); */
 #endif
-		i++;
 	}
 
 	rd->send_buf.nr = htonl(i);
diff --git a/examples/netio_multicast.fio b/examples/netio_multicast.fio
new file mode 100644
index 0000000..f7d9d26
--- /dev/null
+++ b/examples/netio_multicast.fio
@@ -0,0 +1,23 @@
+# netio UDP multicast example. Writers and readers can be run on separate hosts.
+[global]
+ioengine=net
+protocol=udp
+bs=64
+size=100m
+# Set interface IP to send/receive traffic through specific network interface
+#interface=10.8.16.22
+port=10000
+hostname=239.0.0.0
+ttl=1
+
+[pingpong_reader]
+pingpong=1
+rw=read
+
+[normal_reader]
+rw=read
+
+[pingpong_writer]
+startdelay=1
+pingpong=1
+rw=write
diff --git a/fio.1 b/fio.1
index 91fd531..62f7bb6 100644
--- a/fio.1
+++ b/fio.1
@@ -1216,11 +1216,18 @@ iodepth_batch_complete=0).
 .BI (net,netsplice)hostname \fR=\fPstr
 The host name or IP address to use for TCP or UDP based IO.
 If the job is a TCP listener or UDP reader, the hostname is not
-used and must be omitted.
+used and must be omitted unless it is a valid UDP multicast address.
 .TP
 .BI (net,netsplice)port \fR=\fPint
 The TCP or UDP port to bind to or connect to.
 .TP
+.BI (net,netsplice)interface \fR=\fPstr
+The IP address of the network interface used to send or receive UDP multicast
+packets.
+.TP
+.BI (net,netsplice)ttl \fR=\fPint
+Time-to-live value for outgoing UDP multicast packets. Default: 1
+.TP
 .BI (net,netsplice)nodelay \fR=\fPbool
 Set TCP_NODELAY on TCP connections.
 .TP
@@ -1251,13 +1258,14 @@ connections rather than initiating an outgoing connection. The
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
diff --git a/init.c b/init.c
index 70b56e3..d808eb6 100644
--- a/init.c
+++ b/init.c
@@ -1755,8 +1755,6 @@ int parse_cmd_line(int argc, char *argv[], int client_type)
 		case FIO_GETOPT_IOENGINE: {
 			const char *opt = l_opts[lidx].name;
 			char *val = optarg;
-			opt = l_opts[lidx].name;
-			val = optarg;
 			ret = fio_cmd_ioengine_option_parse(td, opt, val);
 			break;
 		}
diff --git a/options.c b/options.c
index 6462c67..1c44f42 100644
--- a/options.c
+++ b/options.c
@@ -271,6 +271,7 @@ static int ignore_error_type(struct thread_data *td, int etype, char *str)
 		if (!error[i]) {
 			log_err("Unknown error %s, please use number value \n",
 				  fname);
+			free(error);
 			return 1;
 		}
 		i++;
diff --git a/parse.c b/parse.c
index f54dae6..d3eb2c4 100644
--- a/parse.c
+++ b/parse.c
@@ -380,7 +380,7 @@ static int str_match_len(const struct value_pair *vp, const char *str)
 static int __handle_option(struct fio_option *o, const char *ptr, void *data,
 			   int first, int more, int curr)
 {
-	int il, *ilp;
+	int il=0, *ilp;
 	fio_fp64_t *flp;
 	long long ull, *ullp;
 	long ul1, ul2;
diff --git a/stat.c b/stat.c
index 332ccd0..442caa0 100644
--- a/stat.c
+++ b/stat.c
@@ -243,15 +243,13 @@ out:
 int calc_lat(struct io_stat *is, unsigned long *min, unsigned long *max,
 	     double *mean, double *dev)
 {
-	double n = is->samples;
+	double n = (double) is->samples;
 
-	if (is->samples == 0)
+	if (n == 0)
 		return 0;
 
 	*min = is->min_val;
 	*max = is->max_val;
-
-	n = (double) is->samples;
 	*mean = is->mean.u.f;
 
 	if (n > 1.0)
diff --git a/tools/.gitignore b/tools/.gitignore
new file mode 100644
index 0000000..b25c15b
--- /dev/null
+++ b/tools/.gitignore
@@ -0,0 +1 @@
+*~
diff --git a/tools/genfio b/tools/genfio
index 6d3220d..bbf8833 100755
--- a/tools/genfio
+++ b/tools/genfio
@@ -50,21 +50,23 @@ show_help() {
 					one test after anoter but all disks at the same time
 					Enabled by default
 -D iodepth			: Run with the specified iodepth
-					Default is 32
+					Default is $IODEPTH
 -d disk1[,disk2,disk3,..]	: Run the tests on the selected disks
 					Separated each disk with a comma
 					Disk name shall be "sdxx", /dev/ shall NOT be used here
 -r seconds			: Time in seconds per benchmark
 					0 means till the end of the device
-					Default is 300 seconds
+					Default is $RUNTIME seconds
 -b blocksize[,blocksize1, ...]  : The blocksizes to test under fio format (4k, 1m, ...)
 					Separated each blocksize with a comma
-					Default is 4k
+					Default is $BLOCK_SIZE
 -m mode1,[mode2,mode3, ...]     : Define the fio IO profile to use like read, write, randread, randwrite
-					Default is "write,randwrite,read,randread"
+					Default is "$MODES"
 -x prefix			: Add a prefix to the fio filename
 					Useful to let a context associated with the file
 					If the prefix features a / (slash), prefix will be considered as a directory
+-A cmd_to_run			: System command to run after each job (exec_postrun in fio)
+-B cmd_to_run			: System command to run before each job (exec_prerun in fio)
 
 Example:
 
@@ -89,28 +91,26 @@ Estimated Time = 6000 seconds : 1 hour 40 minutes
 EOF
 }
 
-gen_template() {
-cat >$TEMPLATE << EOF
-[global]
-ioengine=libaio
-iodepth=$IODEPTH
-invalidate=1
-ramp_time=5
-EOF
+finish_template() {
+echo "iodepth=$IODEPTH" >> $TEMPLATE
 
 if [ "$RUNTIME" != "0" ]; then
-cat >>$TEMPLATE << EOF
-runtime=$RUNTIME
-time_based
-EOF
+	echo "runtime=$RUNTIME" >> $TEMPLATE
+	echo "time_based" >> $TEMPLATE
 fi
 
 if [ "$CACHED_IO" = "FALSE" ]; then
-cat >>$TEMPLATE << EOF
-direct=1
-EOF
+	echo "direct=1" >> $TEMPLATE
 fi
+}
 
+gen_template() {
+cat >$TEMPLATE << EOF
+[global]
+ioengine=libaio
+invalidate=1
+ramp_time=5
+EOF
 }
 
 gen_seq_suite() {
@@ -185,7 +185,7 @@ esac
 }
 
 parse_cmdline() {
-while getopts "hacpsd:b:r:m:x:D:" opt; do
+while getopts "hacpsd:b:r:m:x:D:A:B:" opt; do
   case $opt in
     h)
 	show_help
@@ -235,6 +235,12 @@ while getopts "hacpsd:b:r:m:x:D:" opt; do
     a)
 	SEQ=2
       ;;
+    B)
+	echo "exec_prerun=$OPTARG" >> $TEMPLATE
+      ;;
+    A)
+	echo "exec_postrun=$OPTARG" >> $TEMPLATE
+      ;;
     \?)
       echo "Invalid option: -$OPTARG" >&2
       ;;
@@ -303,9 +309,10 @@ done
 
 
 ########## MAIN
-parse_cmdline $@
-check_mode_order
 gen_template
+parse_cmdline "$@"
+finish_template
+check_mode_order
 
 echo "Generating $OUTFILE"
 cp -f $TEMPLATE $OUTFILE
diff --git a/tools/plot/fio2gnuplot.py b/tools/plot/fio2gnuplot.py
index ef32ee0..03ef0dd 100755
--- a/tools/plot/fio2gnuplot.py
+++ b/tools/plot/fio2gnuplot.py
@@ -91,17 +91,26 @@ def compute_temp_file(fio_data_file,disk_perf):
 		files.append(open(file))
 		pos = len(files) - 1
 		tmp_filename = "gnuplot_temp_file.%d" % pos
-		temp_outfile.append(open(tmp_filename,'w'))
+		gnuplot_file=open(tmp_filename,'w')
+		temp_outfile.append(gnuplot_file)
+		gnuplot_file.write("#Temporary file based on file %s\n" % file)
 		disk_perf.append([])
 
 	shall_break = False
 	while True:
 		current_line=[]
+		nb_empty_files=0
+		nb_files=len(files)
 		for file in files:
 			s=file.readline().replace(',',' ').split()
 			if not s:
+				nb_empty_files+=1
+				s="-1, 0, 0, 0'".replace(',',' ').split()
+
+			if (nb_empty_files == nb_files):
 				shall_break=True
 				break;
+
 			current_line.append(s);
 
 		if shall_break == True:
@@ -117,14 +126,17 @@ def compute_temp_file(fio_data_file,disk_perf):
 
 			# We ignore the first 500msec as it doesn't seems to be part of the real benchmark
 			# Time < 500 usually reports BW=0 breaking the min computing
-			if ((int(time)) > 500):
+			if (((int(time)) > 500) or (int(time)==-1)):
 				disk_perf[index].append(int(perf))
-				perfs.append(perf)
+				perfs.append("%s %s"% (time, perf))
 				index = index + 1
 
 		# If we reach this point, it means that all the traces are coherent
 		for p in enumerate(perfs):
-			temp_outfile[p[0]].write("%s %.2f %s\n" % (p[0], float(float(time)/1000), p[1]))
+			perf_time,perf = p[1].split()
+			if (perf_time != "-1"):
+				temp_outfile[p[0]].write("%s %.2f %s\n" % (p[0], float(float(perf_time)/1000), perf))
+
 
 	for file in files:
 		file.close()
diff --git a/tools/plot/graph2D.gpm b/tools/plot/graph2D.gpm
index 2d0d30a..efc7ac2 100644
--- a/tools/plot/graph2D.gpm
+++ b/tools/plot/graph2D.gpm
@@ -8,7 +8,7 @@ set output '$3.png'
 
 #Preparing Axes
 #set logscale x
-set ytics axis out
+set ytics axis out auto 
 #set data style lines
 set key top left reverse
 set xlabel "Time (Seconds)"
