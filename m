Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: kusumi.tomohiro@gmail.com
Subject: [PATCH 2/7] Add missing trailing \n in log_err/info()
Date: Tue,  3 Jan 2017 23:40:06 +0900
Message-Id: <1483454411-14535-2-git-send-email-tkusumi@tuxera.com>
In-Reply-To: <1483454411-14535-1-git-send-email-tkusumi@tuxera.com>
References: <1483454411-14535-1-git-send-email-tkusumi@tuxera.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

From: Tomohiro Kusumi <tkusumi@tuxera.com>

Callers need trailing \n in case of fwrite(3) (if not syslog(3)).

These are the ones that seem to need trailing \n not followed
by another log function call as consequence.

Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
---
 backend.c          | 2 +-
 client.c           | 2 +-
 engines/e4defrag.c | 2 +-
 engines/net.c      | 2 +-
 engines/rdma.c     | 6 +++---
 iolog.c            | 2 +-
 server.c           | 2 +-
 7 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/backend.c b/backend.c
index c8c6de6..a46101c 100644
--- a/backend.c
+++ b/backend.c
@@ -2063,7 +2063,7 @@ static bool check_mount_writes(struct thread_data *td)
 
 	return false;
 mounted:
-	log_err("fio: %s appears mounted, and 'allow_mounted_write' isn't set. Aborting.", f->file_name);
+	log_err("fio: %s appears mounted, and 'allow_mounted_write' isn't set. Aborting.\n", f->file_name);
 	return true;
 }
 
diff --git a/client.c b/client.c
index 1b4d3d7..7934661 100644
--- a/client.c
+++ b/client.c
@@ -1322,7 +1322,7 @@ static int fio_client_handle_iolog(struct fio_client *client,
 	log_pathname = malloc(10 + strlen((char *)pdu->name) +
 			strlen(client->hostname));
 	if (!log_pathname) {
-		log_err("fio: memory allocation of unique pathname failed");
+		log_err("fio: memory allocation of unique pathname failed\n");
 		return -1;
 	}
 	/* generate a unique pathname for the log file using hostname */
diff --git a/engines/e4defrag.c b/engines/e4defrag.c
index e53636e..1e4996f 100644
--- a/engines/e4defrag.c
+++ b/engines/e4defrag.c
@@ -95,7 +95,7 @@ static int fio_e4defrag_init(struct thread_data *td)
 	ed->donor_fd = open(donor_name, O_CREAT|O_WRONLY, 0644);
 	if (ed->donor_fd < 0) {
 		td_verror(td, errno, "io_queue_init");
-		log_err("Can't open donor file %s err:%d", donor_name, ed->donor_fd);
+		log_err("Can't open donor file %s err:%d\n", donor_name, ed->donor_fd);
 		free(ed);
 		return 1;
 	}
diff --git a/engines/net.c b/engines/net.c
index 5f1401c..3bdd5cd 100644
--- a/engines/net.c
+++ b/engines/net.c
@@ -1218,7 +1218,7 @@ static int fio_netio_setup_listen_inet(struct thread_data *td, short port)
 			return 1;
 		}
 		if (is_ipv6(o)) {
-			log_err("fio: IPv6 not supported for multicast network IO");
+			log_err("fio: IPv6 not supported for multicast network IO\n");
 			close(fd);
 			return 1;
 		}
diff --git a/engines/rdma.c b/engines/rdma.c
index fbe8434..10e60dc 100644
--- a/engines/rdma.c
+++ b/engines/rdma.c
@@ -881,7 +881,7 @@ static int fio_rdmaio_connect(struct thread_data *td, struct fio_file *f)
 	rd->send_buf.nr = htonl(td->o.iodepth);
 
 	if (ibv_post_send(rd->qp, &rd->sq_wr, &bad_wr) != 0) {
-		log_err("fio: ibv_post_send fail: %m");
+		log_err("fio: ibv_post_send fail: %m\n");
 		return 1;
 	}
 
@@ -932,7 +932,7 @@ static int fio_rdmaio_accept(struct thread_data *td, struct fio_file *f)
 	ret = rdma_poll_wait(td, IBV_WC_RECV) < 0;
 
 	if (ibv_post_send(rd->qp, &rd->sq_wr, &bad_wr) != 0) {
-		log_err("fio: ibv_post_send fail: %m");
+		log_err("fio: ibv_post_send fail: %m\n");
 		return 1;
 	}
 
@@ -965,7 +965,7 @@ static int fio_rdmaio_close_file(struct thread_data *td, struct fio_file *f)
 				     || (rd->rdma_protocol ==
 					 FIO_RDMA_MEM_READ))) {
 		if (ibv_post_send(rd->qp, &rd->sq_wr, &bad_wr) != 0) {
-			log_err("fio: ibv_post_send fail: %m");
+			log_err("fio: ibv_post_send fail: %m\n");
 			return 1;
 		}
 
diff --git a/iolog.c b/iolog.c
index 9393890..25d8dd0 100644
--- a/iolog.c
+++ b/iolog.c
@@ -422,7 +422,7 @@ static int read_iolog2(struct thread_data *td, FILE *f)
 				continue;
 			}
 		} else {
-			log_err("bad iolog2: %s", p);
+			log_err("bad iolog2: %s\n", p);
 			continue;
 		}
 
diff --git a/server.c b/server.c
index b7ebd63..6d5d4ea 100644
--- a/server.c
+++ b/server.c
@@ -2538,7 +2538,7 @@ int fio_start_server(char *pidfile)
 
 	pid = fork();
 	if (pid < 0) {
-		log_err("fio: failed server fork: %s", strerror(errno));
+		log_err("fio: failed server fork: %s\n", strerror(errno));
 		free(pidfile);
 		return -1;
 	} else if (pid) {
-- 
2.5.5


