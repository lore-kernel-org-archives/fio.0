Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDEEB30328
	for <fio@vger.kernel.org>; Sat, 16 Dec 2023 13:00:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="OMcY6/mJ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Date:Message-Id:To:From:Subject:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=U80khMD/JQeLFLRqTnRP0nx/hacaVe5vOI9K+tJgBCs=; b=OMcY6/mJmMJ5+FAKHZNsAgKUYO
	dQKdpxKPd4cxQkETSfyIxYQwLYOGmsjM7HJTnpDffg27t3olYUDf5t41OzEG72lvOLvqdeyiQxDdl
	/S4SBgfYHAcri1Dsvu9s3l0lOgVv3+m2Z4VB0/iKZuDo2uNr04SrFEJ25+ZDgK6yTloWu2r0zf+Db
	bzZBajeIpUV8sw23V+DRckMedW8CTi6NG0DpUlJCyrMvrgU73ys9hXesHp23zTdYeXSUWxeUYDlM0
	/y1dCynS/BKB8aSWcuvbNEKIypQsPso4zLZ4dvYGEgy+CsBvjtLmZTx2N39PR5dIj+HH8x4b3Ore7
	QVbZ58jg==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1rEUGy-00A5pb-Pl
	for fio@vger.kernel.org; Sat, 16 Dec 2023 13:00:06 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id A0E6B1BC0143; Sat, 16 Dec 2023 06:00:01 -0700 (MST)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20231216130001.A0E6B1BC0143@kernel.dk>
Date: Sat, 16 Dec 2023 06:00:01 -0700 (MST)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>

The following changes since commit 4e472f8806571ea5799bc898e44609697ba0e140:

  Merge branch 'master' of https://github.com/preichl/fio (2023-12-14 14:15:34 -0700)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to c77fe6859b6ef937a6ca900c1fab009175d721f8:

  engines/http: use proper error value (2023-12-15 13:17:13 -0700)

----------------------------------------------------------------
Jens Axboe (2):
      Merge branch 'master' of https://github.com/preichl/fio
      engines/http: use proper error value

Pavel Reichl (3):
      engines/rdma: remove dead code
      client/server: remove dead code
      engines/http: Drop unused varible

 engines/http.c | 3 +--
 engines/rdma.c | 1 -
 server.c       | 1 -
 3 files changed, 1 insertion(+), 4 deletions(-)

---

Diff of recent changes:

diff --git a/engines/http.c b/engines/http.c
index 83cfe8bb..99f4e119 100644
--- a/engines/http.c
+++ b/engines/http.c
@@ -640,7 +640,6 @@ static enum fio_q_status fio_http_queue(struct thread_data *td,
 	char url[1024];
 	long status;
 	CURLcode res;
-	int r = -1;
 
 	fio_ro_check(td, io_u);
 	memset(&_curl_stream, 0, sizeof(_curl_stream));
@@ -712,7 +711,7 @@ static enum fio_q_status fio_http_queue(struct thread_data *td,
 	log_err("WARNING: Only DDIR_READ/DDIR_WRITE/DDIR_TRIM are supported!\n");
 
 err:
-	io_u->error = r;
+	io_u->error = EIO;
 	td_verror(td, io_u->error, "transfer");
 out:
 	curl_slist_free_all(slist);
diff --git a/engines/rdma.c b/engines/rdma.c
index ebdbcb1c..07336f3b 100644
--- a/engines/rdma.c
+++ b/engines/rdma.c
@@ -276,7 +276,6 @@ static int cq_event_handler(struct thread_data *td, enum ibv_wc_opcode opcode)
 	int i;
 
 	while ((ret = ibv_poll_cq(rd->cq, 1, &wc)) == 1) {
-		ret = 0;
 		compevnum++;
 
 		if (wc.status) {
diff --git a/server.c b/server.c
index 06eac584..b9f0e2ac 100644
--- a/server.c
+++ b/server.c
@@ -1883,7 +1883,6 @@ void fio_server_send_ts(struct thread_stat *ts, struct group_run_stats *rs)
 
 		offset = (char *)extended_buf_wp - (char *)extended_buf;
 		ptr->ts.ss_bw_data_offset = cpu_to_le64(offset);
-		extended_buf_wp = ss_bw + (int) ts->ss_dur;
 	}
 
 	fio_net_queue_cmd(FIO_NET_CMD_TS, extended_buf, extended_buf_size, NULL, SK_F_COPY);
