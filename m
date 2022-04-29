Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46E42C433EF
	for <fio@archiver.kernel.org>; Fri, 29 Apr 2022 00:47:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349528AbiD2Au5 (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 28 Apr 2022 20:50:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350209AbiD2Au4 (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 28 Apr 2022 20:50:56 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3E76888D2
        for <fio@vger.kernel.org>; Thu, 28 Apr 2022 17:47:39 -0700 (PDT)
Received: from integral2.. (unknown [180.246.147.8])
        by gnuweeb.org (Postfix) with ESMTPSA id E41A67E78A;
        Fri, 29 Apr 2022 00:47:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1651193259;
        bh=z+9UpDRA5FI7IPkPMXcwOyDs/hwWgGskKHbuzYv6cFs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DFHajOomFaAeqy4h4ZZiOc8Siwkpv1iL1Mcez3AGS0nANMxfiFbToRxBf47oXz+ea
         n3pzAm4bC81LU7eu2vVE8LmgYytdFe0P89yhymr1PAgOqtGBm0WisQd9rHAU3ONLL1
         hRMZo8C1I8bqTcm5AvIW8S+VPK0zbLdrFjmpY081RakH1VbZ9iglP4ieDNXl8yDLNZ
         B+dZthBkMBauBkE1DDIEjiDL/4lRto/GpcuUSE6EFbZnoz1l/EOXJsw0xQgGb6Xu2b
         /5rC6o22AWm+hzw0me57+VoLIWUuTb/izGCdR9JVeKu0oc1KALUj7hpIpt0ox8U73O
         lQZG/Ok3itdWA==
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>,
        Niklas Cassel <Niklas.Cassel@wdc.com>,
        fio Mailing List <fio@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>
Subject: [PATCH v1 8/8] client: Add ENOMEM handling on `malloc()`, `calloc()` and `strdup()` calls
Date:   Fri, 29 Apr 2022 07:47:05 +0700
Message-Id: <20220429004705.260034-9-ammarfaizi2@gnuweeb.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220429004705.260034-1-ammarfaizi2@gnuweeb.org>
References: <20220429004705.260034-1-ammarfaizi2@gnuweeb.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

From: Ammar Faizi <ammarfaizi2@gnuweeb.org>

Avoid a NULL pointer dereference bug. There are many places that don't
handle the ENOMEM case. Add it.

Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---
 client.c | 107 +++++++++++++++++++++++++++++++++++++++++++++----------
 1 file changed, 89 insertions(+), 18 deletions(-)

diff --git a/client.c b/client.c
index c93c90eb..da292334 100644
--- a/client.c
+++ b/client.c
@@ -376,8 +376,11 @@ static struct fio_client *get_new_client(void)
 {
 	struct fio_client *client;
 
-	client = malloc(sizeof(*client));
-	memset(client, 0, sizeof(*client));
+	client = calloc(1, sizeof(*client));
+	if (!client) {
+		log_err("fio: cannot allocate client in %s\n", __func__);
+		return NULL;
+	}
 
 	INIT_FLIST_HEAD(&client->list);
 	INIT_FLIST_HEAD(&client->hash_list);
@@ -397,6 +400,8 @@ struct fio_client *fio_client_add_explicit(struct client_ops *ops,
 	struct fio_client *client;
 
 	client = get_new_client();
+	if (!client)
+		return NULL;
 
 	if (type == Fio_client_socket)
 		client->is_sock = true;
@@ -473,6 +478,8 @@ int fio_client_add(struct client_ops *ops, const char *hostname, void **cookie)
 	}
 
 	client = get_new_client();
+	if (!client)
+		return -ENOMEM;
 
 	if (fio_server_parse_string(hostname, &client->hostname,
 					&client->is_sock, &client->port,
@@ -695,6 +702,10 @@ static int send_client_cmd_line(struct fio_client *client)
 	dprint(FD_NET, "client: send cmdline %d\n", client->argc);
 
 	lens = malloc(client->argc * sizeof(unsigned int));
+	if (!lens) {
+		log_err("fio: cannot allocate lens in %s\n", __func__);
+		return -ENOMEM;
+	}
 
 	/*
 	 * Find out how much mem we need
@@ -708,8 +719,13 @@ static int send_client_cmd_line(struct fio_client *client)
 	 * We need one cmd_line_pdu, and argc number of cmd_single_line_pdu
 	 */
 	mem += sizeof(*clp) + (client->argc * sizeof(*cslp));
-
 	pdu = malloc(mem);
+	if (!pdu) {
+		log_err("fio: cannot allocate mem in %s\n", __func__);
+		ret = -ENOMEM;
+		goto out_free_lens;
+	}
+
 	clp = pdu;
 	offset = sizeof(*clp);
 
@@ -722,11 +738,12 @@ static int send_client_cmd_line(struct fio_client *client)
 		offset += sizeof(*cslp) + arg_len;
 	}
 
-	free(lens);
 	clp->lines = cpu_to_le16(client->argc);
 	clp->client_type = __cpu_to_le16(client->type);
 	ret = fio_net_send_cmd(client->fd, FIO_NET_CMD_JOBLINE, pdu, mem, NULL, NULL);
 	free(pdu);
+out_free_lens:
+	free(lens);
 	return ret;
 }
 
@@ -800,8 +817,12 @@ static int __fio_client_send_remote_ini(struct fio_client *client,
 	dprint(FD_NET, "send remote ini %s to %s\n", filename, client->hostname);
 
 	p_size = sizeof(*pdu) + strlen(filename) + 1;
-	pdu = malloc(p_size);
-	memset(pdu, 0, p_size);
+	pdu = calloc(1, p_size);
+	if (!pdu) {
+		log_err("fio: cannot allocate pdu in %s\n", __func__);
+		return -ENOMEM;
+	}
+
 	pdu->name_len = strlen(filename);
 	strcpy((char *) pdu->file, filename);
 	pdu->client_type = cpu_to_le16((uint16_t) client->type);
@@ -839,8 +860,7 @@ static int __fio_client_send_local_ini(struct fio_client *client,
 	if (fstat(fd, &sb) < 0) {
 		ret = -errno;
 		log_err("fio: job file stat: %s\n", strerror(errno));
-		close(fd);
-		return ret;
+		goto out_close_fd;
 	}
 
 	/*
@@ -849,15 +869,20 @@ static int __fio_client_send_local_ini(struct fio_client *client,
 	sb.st_size += OPT_LEN_MAX;
 	p_size = sb.st_size + sizeof(*pdu);
 	pdu = malloc(p_size);
+	if (!pdu) {
+		log_err("fio: cannot allocate pdu in %s\n", __func__);
+		ret = -ENOMEM;
+		goto out_close_fd;
+	}
 	buf = pdu->buf;
 
 	len = sb.st_size;
 	p = buf;
-	if (read_ini_data(fd, p, len)) {
+	ret = read_ini_data(fd, p, len);
+	if (ret) {
 		log_err("fio: failed reading job file %s\n", filename);
-		close(fd);
-		free(pdu);
-		return 1;
+		ret = -ret;
+		goto out_free_pdu;
 	}
 
 	pdu->buf_len = __cpu_to_le32(sb.st_size);
@@ -865,7 +890,11 @@ static int __fio_client_send_local_ini(struct fio_client *client,
 
 	client->sent_job = true;
 	ret = fio_net_send_cmd(client->fd, FIO_NET_CMD_JOB, pdu, p_size, NULL, NULL);
+
+out_free_pdu:
 	free(pdu);
+
+out_close_fd:
 	close(fd);
 	return ret;
 }
@@ -1171,11 +1200,30 @@ static void handle_job_opt(struct fio_client *client, struct fio_net_cmd *cmd)
 	} else if (client->opt_lists) {
 		struct flist_head *opt_list = &client->opt_lists[pdu->groupid];
 		struct print_option *p;
+		char *v;
 
 		p = malloc(sizeof(*p));
+		if (!p)
+			return;
+
 		p->name = strdup((const char *)pdu->name);
-		p->value = pdu->value[0] ? strdup((const char *)pdu->value) :
-			NULL;
+		if (!p->name) {
+			free(p);
+			return;
+		}
+
+		if (pdu->value[0]) {
+			v = strdup((const char *)pdu->value);
+			if (!v) {
+				free(p->name);
+				free(p);
+				return;
+			}
+		} else {
+			v = NULL;
+		}
+
+		p->value = v;
 		flist_add_tail(&p->list, opt_list);
 	}
 }
@@ -1512,6 +1560,14 @@ static void handle_probe(struct fio_client *client, struct fio_net_cmd *cmd)
 	const char *os, *arch;
 	char bit[16];
 
+	if (!client->name) {
+		client->name = strdup((char *) probe->hostname);
+		if (!client->name) {
+			log_err("fio: cannot allocate client->name in %s\n", __func__);
+			return;
+		}
+	}
+
 	os = fio_get_os_string(probe->os);
 	if (!os)
 		os = "unknown";
@@ -1528,9 +1584,6 @@ static void handle_probe(struct fio_client *client, struct fio_net_cmd *cmd)
 			probe->hostname, probe->bigendian, bit, os, arch,
 			probe->fio_version, (unsigned long) probe->flags);
 	}
-
-	if (!client->name)
-		client->name = strdup((char *) probe->hostname);
 }
 
 static void handle_start(struct fio_client *client, struct fio_net_cmd *cmd)
@@ -1613,6 +1666,10 @@ static struct cmd_iolog_pdu *convert_iolog_gz(struct fio_net_cmd *cmd,
 	else
 		total = nr_samples * __log_entry_sz(le32_to_cpu(pdu->log_offset));
 	ret = malloc(total + sizeof(*pdu));
+	if (!ret) {
+		log_err("fio: cannot allocate ret in %s\n", __func__);
+		return NULL;
+	}
 	ret->nr_samples = nr_samples;
 
 	memcpy(ret, pdu, sizeof(*pdu));
@@ -1745,13 +1802,17 @@ static void sendfile_reply(int fd, struct cmd_sendfile_reply *rep,
 static int fio_send_file(struct fio_client *client, struct cmd_sendfile *pdu,
 			 uint64_t tag)
 {
-	struct cmd_sendfile_reply *rep;
+	struct cmd_sendfile_reply *rep, *tmp;
 	struct stat sb;
 	size_t size;
 	int fd;
 
 	size = sizeof(*rep);
 	rep = malloc(size);
+	if (!rep) {
+		log_err("fio: cannot allocate rep in %s\n", __func__);
+		return 1;
+	}
 
 	if (stat((char *)pdu->path, &sb) < 0) {
 fail:
@@ -1956,6 +2017,10 @@ int fio_clients_send_trigger(const char *cmd)
 		client = flist_entry(entry, struct fio_client, list);
 
 		pdu = malloc(sizeof(*pdu) + slen);
+		if (!pdu) {
+			log_err("fio: cannot allocate pdu in %s\n", __func__);
+			return 1;
+		}
 		pdu->len = cpu_to_le16((uint16_t) slen);
 		if (slen)
 			memcpy(pdu->cmd, cmd, slen);
@@ -1980,6 +2045,10 @@ static void request_client_etas(struct client_ops *ops)
 	dprint(FD_NET, "client: request eta (%d)\n", nr_clients);
 
 	eta = calloc(1, sizeof(*eta) + __THREAD_RUNSTR_SZ(REAL_MAX_JOBS));
+	if (!eta) {
+		log_err("fio: cannot allocate eta in %s\n", __func__);
+		return;
+	}
 	eta->pending = nr_clients;
 
 	flist_for_each(entry, &client_list) {
@@ -2107,6 +2176,8 @@ int fio_handle_clients(struct client_ops *ops)
 	fio_gettime(&eta_ts, NULL);
 
 	pfds = malloc(nr_clients * sizeof(struct pollfd));
+	if (!pfds)
+		return -ENOMEM;
 
 	init_thread_stat(&client_ts);
 	init_group_run_stat(&client_gs);
-- 
Ammar Faizi

