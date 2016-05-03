Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:52409 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755436AbcECMAF (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 3 May 2016 08:00:05 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
	by merlin.infradead.org with esmtpsa (Exim 4.85_2 #1 (Red Hat Linux))
	id 1axYzj-0003Rm-Nv
	for fio@vger.kernel.org; Tue, 03 May 2016 12:00:04 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20160503120001.A66022C00AA@kernel.dk>
Date: Tue,  3 May 2016 06:00:01 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit fe8d0f4c54f0c308c9a02a4e3c2f5084e8bf5461:

  Fio 2.9 (2016-04-28 16:23:10 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 08a2cbf64720d9371ea4649b1bdc00257916a326:

  Update RBD documentation (2016-05-02 08:25:16 -0600)

----------------------------------------------------------------
Jens Axboe (1):
      Update RBD documentation

Tianqing (1):
      rbd: add clustername option

 HOWTO         |  9 +++++++++
 engines/rbd.c | 30 +++++++++++++++++++++++++++++-
 fio.1         |  7 ++++++-
 3 files changed, 44 insertions(+), 2 deletions(-)

---

Diff of recent changes:

diff --git a/HOWTO b/HOWTO
index 2be1648..1f523d3 100644
--- a/HOWTO
+++ b/HOWTO
@@ -1888,6 +1888,15 @@ be the starting port number since fio will use a range of ports.
 		1 	  : allocate space immidietly inside defragment event,
 			    and free right after event
 
+[rbd] clustername=str	Specifies the name of the Ceph cluster.
+[rbd] rbdname=str	Specifies the name of the RBD.
+[rbd] pool=str		Specifies the naem of the Ceph pool containing RBD.
+[rbd] clientname=str	Specifies the username (without the 'client.' prefix)
+			used to access the Ceph cluster. If the clustername is
+			specified, the clientmae shall be the full type.id
+			string. If no type. prefix is given, fio will add
+			'client.' by default.
+
 [mtd] skip_bad=bool	Skip operations against known bad blocks.
 
 [libhdfs] hdfsdirectory	libhdfs will create chunk in this HDFS directory
diff --git a/engines/rbd.c b/engines/rbd.c
index 8252d27..87ed360 100644
--- a/engines/rbd.c
+++ b/engines/rbd.c
@@ -27,6 +27,7 @@ struct rbd_data {
 
 struct rbd_options {
 	void *pad;
+	char *cluster_name;
 	char *rbd_name;
 	char *pool_name;
 	char *client_name;
@@ -34,6 +35,15 @@ struct rbd_options {
 };
 
 static struct fio_option options[] = {
+        {
+		.name		= "clustername",
+		.lname		= "ceph cluster name",
+		.type		= FIO_OPT_STR_STORE,
+		.help		= "Cluster name for ceph",
+		.off1		= offsetof(struct rbd_options, cluster_name),
+		.category	= FIO_OPT_C_ENGINE,
+		.group		= FIO_OPT_G_RBD,
+        },
 	{
 		.name		= "rbdname",
 		.lname		= "rbd engine rbdname",
@@ -112,7 +122,25 @@ static int _fio_rbd_connect(struct thread_data *td)
 	struct rbd_options *o = td->eo;
 	int r;
 
-	r = rados_create(&rbd->cluster, o->client_name);
+	if (o->cluster_name) {
+		char *client_name = NULL; 
+
+		/*
+		 * If we specify cluser name, the rados_creat2
+		 * will not assume 'client.'. name is considered
+		 * as a full type.id namestr
+		 */
+		if (!index(o->client_name, '.')) {
+			client_name = calloc(1, strlen("client.") +
+						strlen(o->client_name) + 1);
+			strcat(client_name, "client.");
+			o->client_name = strcat(client_name, o->client_name);
+		}
+		r = rados_create2(&rbd->cluster, o->cluster_name,
+					o->client_name, 0);
+	} else
+		r = rados_create(&rbd->cluster, o->client_name);
+	
 	if (r < 0) {
 		log_err("rados_create failed.\n");
 		goto failed_early;
diff --git a/fio.1 b/fio.1
index e502dfe..73fdee6 100644
--- a/fio.1
+++ b/fio.1
@@ -1772,6 +1772,9 @@ Preallocate donor's file on init
 .BI 1:
 allocate space immediately inside defragment event, and free right after event
 .RE
+.TP 
+.BI (rbd)clustername \fR=\fPstr
+Specifies the name of the ceph cluster.
 .TP
 .BI (rbd)rbdname \fR=\fPstr
 Specifies the name of the RBD.
@@ -1780,7 +1783,9 @@ Specifies the name of the RBD.
 Specifies the name of the Ceph pool containing the RBD.
 .TP
 .BI (rbd)clientname \fR=\fPstr
-Specifies the username (without the 'client.' prefix) used to access the Ceph cluster.
+Specifies the username (without the 'client.' prefix) used to access the Ceph
+cluster. If the clustername is specified, the clientname shall be the full
+type.id string. If no type. prefix is given, fio will add 'client.' by default.
 .TP
 .BI (mtd)skipbad \fR=\fPbool
 Skip operations against known bad blocks.
