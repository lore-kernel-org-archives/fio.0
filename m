Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:46365 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933342AbcAUNAD (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 21 Jan 2016 08:00:03 -0500
Received: from [216.160.245.99] (helo=kernel.dk)
	by bombadil.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1aMEqI-0003Lc-Kj
	for fio@vger.kernel.org; Thu, 21 Jan 2016 13:00:02 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20160121130001.D406C2C00D8@kernel.dk>
Date: Thu, 21 Jan 2016 06:00:01 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 543e2e9d2ebdd26449a3f07934b87c8e1ff35033:

  Fix issue with termination before io_size has been reached (2016-01-14 14:44:23 -0700)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to e3dae3b77f1a7285afd5a0ada6960eeb4a21e9a8:

  Fio 2.5 (2016-01-20 22:00:17 -0700)

----------------------------------------------------------------
Jens Axboe (7):
      client: drain text output when exiting
      client: fix non-text command leak
      init: increment stat count if parent == default thread
      Fio 2.4
      init: fix compile for FIO_INC_DEBUG not being set
      mutex: fix double unlock in fio_mutex_down_timeout()
      Fio 2.5

 FIO-VERSION-GEN        |  2 +-
 client.c               | 24 +++++++++++++++++++++++-
 init.c                 |  4 +++-
 mutex.c                |  1 +
 os/windows/install.wxs |  2 +-
 server.c               | 27 ++++++++++++++++++---------
 server.h               |  2 +-
 7 files changed, 48 insertions(+), 14 deletions(-)

---

Diff of recent changes:

diff --git a/FIO-VERSION-GEN b/FIO-VERSION-GEN
index 3253034..ba75978 100755
--- a/FIO-VERSION-GEN
+++ b/FIO-VERSION-GEN
@@ -1,7 +1,7 @@
 #!/bin/sh
 
 GVF=FIO-VERSION-FILE
-DEF_VER=fio-2.3
+DEF_VER=fio-2.5
 
 LF='
 '
diff --git a/client.c b/client.c
index 6c2a1ef..2541f46 100644
--- a/client.c
+++ b/client.c
@@ -33,6 +33,8 @@ static void handle_text(struct fio_client *client, struct fio_net_cmd *cmd);
 static void handle_stop(struct fio_client *client, struct fio_net_cmd *cmd);
 static void handle_start(struct fio_client *client, struct fio_net_cmd *cmd);
 
+static void convert_text(struct fio_net_cmd *cmd);
+
 struct client_ops fio_client_ops = {
 	.text		= handle_text,
 	.disk_util	= handle_du,
@@ -215,12 +217,32 @@ static int fio_client_dec_jobs_eta(struct client_eta *eta, client_eta_op eta_fn)
 	return 1;
 }
 
+static void fio_drain_client_text(struct fio_client *client)
+{
+	do {
+		struct fio_net_cmd *cmd;
+
+		cmd = fio_net_recv_cmd(client->fd, false);
+		if (!cmd)
+			break;
+
+		if (cmd->opcode == FIO_NET_CMD_TEXT) {
+			convert_text(cmd);
+			client->ops->text(client, cmd);
+		}
+
+		free(cmd);
+	} while (1);
+}
+
 static void remove_client(struct fio_client *client)
 {
 	assert(client->refs);
 
 	dprint(FD_NET, "client: removed <%s>\n", client->hostname);
 
+	fio_drain_client_text(client);
+
 	if (!flist_empty(&client->list))
 		flist_del_init(&client->list);
 
@@ -1526,7 +1548,7 @@ int fio_handle_client(struct fio_client *client)
 
 	dprint(FD_NET, "client: handle %s\n", client->hostname);
 
-	cmd = fio_net_recv_cmd(client->fd);
+	cmd = fio_net_recv_cmd(client->fd, true);
 	if (!cmd)
 		return 0;
 
diff --git a/init.c b/init.c
index 77cf9f2..5ee4082 100644
--- a/init.c
+++ b/init.c
@@ -493,7 +493,7 @@ static struct thread_data *get_new_job(int global, struct thread_data *parent,
 	if (jobname)
 		td->o.name = strdup(jobname);
 
-	if (!parent->o.group_reporting)
+	if (!parent->o.group_reporting || parent == &def_thread)
 		stat_number++;
 
 	set_cmd_options(td);
@@ -1860,6 +1860,7 @@ static int fill_def_thread(void)
 
 static void show_debug_categories(void)
 {
+#ifdef FIO_INC_DEBUG
 	struct debug_level *dl = &debug_levels[0];
 	int curlen, first = 1;
 
@@ -1885,6 +1886,7 @@ static void show_debug_categories(void)
 		first = 0;
 	}
 	printf("\n");
+#endif
 }
 
 static void usage(const char *name)
diff --git a/mutex.c b/mutex.c
index a48e37d..16107dd 100644
--- a/mutex.c
+++ b/mutex.c
@@ -136,6 +136,7 @@ int fio_mutex_down_timeout(struct fio_mutex *mutex, unsigned int msecs)
 	if (!ret) {
 		mutex->value--;
 		pthread_mutex_unlock(&mutex->lock);
+		return 0;
 	}
 
 	pthread_mutex_unlock(&mutex->lock);
diff --git a/os/windows/install.wxs b/os/windows/install.wxs
index 299ca9b..c024fb7 100755
--- a/os/windows/install.wxs
+++ b/os/windows/install.wxs
@@ -10,7 +10,7 @@
 	<Product Id="*"
 	  Codepage="1252" Language="1033"
 	  Manufacturer="fio" Name="fio"
-	  UpgradeCode="2338A332-5511-43CF-B9BD-5C60496CCFCC" Version="2.3">
+	  UpgradeCode="2338A332-5511-43CF-B9BD-5C60496CCFCC" Version="2.5">
 		<Package
 		  Description="Flexible IO Tester"
 		  InstallerVersion="301" Keywords="Installer,MSI,Database"
diff --git a/server.c b/server.c
index a593a73..f6f3441 100644
--- a/server.c
+++ b/server.c
@@ -262,10 +262,17 @@ static int fio_send_data(int sk, const void *p, unsigned int len)
 	return fio_sendv_data(sk, &iov, 1);
 }
 
-static int fio_recv_data(int sk, void *p, unsigned int len)
+static int fio_recv_data(int sk, void *p, unsigned int len, bool wait)
 {
+	int flags;
+
+	if (wait)
+		flags = MSG_WAITALL;
+	else
+		flags = MSG_DONTWAIT;
+
 	do {
-		int ret = recv(sk, p, len, MSG_WAITALL);
+		int ret = recv(sk, p, len, flags);
 
 		if (ret > 0) {
 			len -= ret;
@@ -275,9 +282,11 @@ static int fio_recv_data(int sk, void *p, unsigned int len)
 			continue;
 		} else if (!ret)
 			break;
-		else if (errno == EAGAIN || errno == EINTR)
-			continue;
-		else
+		else if (errno == EAGAIN || errno == EINTR) {
+			if (wait)
+				continue;
+			break;
+		} else
 			break;
 	} while (!exit_backend);
 
@@ -326,7 +335,7 @@ static int verify_convert_cmd(struct fio_net_cmd *cmd)
 /*
  * Read (and defragment, if necessary) incoming commands
  */
-struct fio_net_cmd *fio_net_recv_cmd(int sk)
+struct fio_net_cmd *fio_net_recv_cmd(int sk, bool wait)
 {
 	struct fio_net_cmd cmd, *tmp, *cmdret = NULL;
 	size_t cmd_size = 0, pdu_offset = 0;
@@ -335,7 +344,7 @@ struct fio_net_cmd *fio_net_recv_cmd(int sk)
 	void *pdu = NULL;
 
 	do {
-		ret = fio_recv_data(sk, &cmd, sizeof(cmd));
+		ret = fio_recv_data(sk, &cmd, sizeof(cmd), wait);
 		if (ret)
 			break;
 
@@ -379,7 +388,7 @@ struct fio_net_cmd *fio_net_recv_cmd(int sk)
 
 		/* There's payload, get it */
 		pdu = (void *) cmdret->payload + pdu_offset;
-		ret = fio_recv_data(sk, pdu, cmd.pdu_len);
+		ret = fio_recv_data(sk, pdu, cmd.pdu_len, wait);
 		if (ret)
 			break;
 
@@ -1209,7 +1218,7 @@ static int handle_connection(struct sk_out *sk_out)
 		if (ret < 0)
 			break;
 
-		cmd = fio_net_recv_cmd(sk_out->sk);
+		cmd = fio_net_recv_cmd(sk_out->sk, true);
 		if (!cmd) {
 			ret = -1;
 			break;
diff --git a/server.h b/server.h
index 12c7275..05f98e5 100644
--- a/server.h
+++ b/server.h
@@ -213,7 +213,7 @@ extern void fio_server_send_du(void);
 extern void fio_server_send_job_options(struct flist_head *, unsigned int);
 extern int fio_server_get_verify_state(const char *, int, void **, int *);
 
-extern struct fio_net_cmd *fio_net_recv_cmd(int sk);
+extern struct fio_net_cmd *fio_net_recv_cmd(int sk, bool wait);
 
 extern int fio_send_iolog(struct thread_data *, struct io_log *, const char *);
 extern void fio_server_send_add_job(struct thread_data *);
