Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61DDEC0015E
	for <fio@archiver.kernel.org>; Tue,  1 Aug 2023 12:01:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231936AbjHAMBj (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 1 Aug 2023 08:01:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234424AbjHAMBS (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 1 Aug 2023 08:01:18 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD4462D62
        for <fio@vger.kernel.org>; Tue,  1 Aug 2023 05:00:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Date:Message-Id:To:From:Subject:Sender:
        Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=kzR95/YK7H+vwtrRp28m8lsLSBdBa+6b9KenON0rEr0=; b=mmbgEIzZ1cdlXGbFH059sD6HOq
        70lH4ebUFVDXH8eIjNC7N6oLIRU/ZBIbrIFQOb60l2EKz3iBgeOQ09pJC9FoHIG1/W7CUPq3xUrrh
        qC5BB7+TFcnUH1GqSSxSBhaBfDG7B+qCG6IV5I9JR/arkAXALQHA24oUB1Y+Fjck7MejEPBboDe5I
        GI5T4+2XzFVlNh47gknJAJ4KAFyQaqSkwia5hQaquwNqJgTuHtvSvSNlxw2snbNa8vJI3YcXkfCqa
        6UVXhMNvF6+1i005zPdT+fuTnYzpSjk1JZbbsOxkSXfveR0VNyQRFOJSBvQDohGedCBNIhDooK4bQ
        1DheSwxg==;
Received: from [96.43.243.2] (helo=kernel.dk)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1qQo2n-008Z0v-3P
        for fio@vger.kernel.org; Tue, 01 Aug 2023 12:00:05 +0000
Received: by kernel.dk (Postfix, from userid 1000)
        id D6CD71BC017F; Tue,  1 Aug 2023 06:00:01 -0600 (MDT)
Subject: Recent changes (master)
From:   Jens Axboe <axboe@kernel.dk>
To:     <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20230801120001.D6CD71BC017F@kernel.dk>
Date:   Tue,  1 Aug 2023 06:00:01 -0600 (MDT)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The following changes since commit 824912be19542f94264e485a25d37b55a9f68f0e:

  Revert "correctly free thread_data options at the topmost parent process" (2023-07-28 11:32:22 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 1660df6601e24a17dda9e12cbc901337fd5fd925:

  Merge branch 'master' of https://github.com/min22/fio (2023-07-31 15:03:37 -0600)

----------------------------------------------------------------
Denis Pronin (1):
      use 'const' where it is required

Jens Axboe (2):
      Merge branch 'improment/constness' of https://github.com/dpronin/fio
      Merge branch 'master' of https://github.com/min22/fio

Kookoo Gu (1):
      iolog.c: fix inaccurate clat when replay trace

 client.c | 10 +++++-----
 client.h |  8 ++++----
 iolog.c  | 14 +++++++-------
 3 files changed, 16 insertions(+), 16 deletions(-)

---

Diff of recent changes:

diff --git a/client.c b/client.c
index 7cd2ba66..c257036b 100644
--- a/client.c
+++ b/client.c
@@ -34,7 +34,7 @@ static void handle_start(struct fio_client *client, struct fio_net_cmd *cmd);
 static void convert_text(struct fio_net_cmd *cmd);
 static void client_display_thread_status(struct jobs_eta *je);
 
-struct client_ops fio_client_ops = {
+struct client_ops const fio_client_ops = {
 	.text		= handle_text,
 	.disk_util	= handle_du,
 	.thread_status	= handle_ts,
@@ -446,7 +446,7 @@ int fio_client_add_ini_file(void *cookie, const char *ini_file, bool remote)
 	return 0;
 }
 
-int fio_client_add(struct client_ops *ops, const char *hostname, void **cookie)
+int fio_client_add(struct client_ops const *ops, const char *hostname, void **cookie)
 {
 	struct fio_client *existing = *cookie;
 	struct fio_client *client;
@@ -1772,7 +1772,7 @@ fail:
 
 int fio_handle_client(struct fio_client *client)
 {
-	struct client_ops *ops = client->ops;
+	struct client_ops const *ops = client->ops;
 	struct fio_net_cmd *cmd;
 
 	dprint(FD_NET, "client: handle %s\n", client->hostname);
@@ -1957,7 +1957,7 @@ int fio_clients_send_trigger(const char *cmd)
 	return 0;
 }
 
-static void request_client_etas(struct client_ops *ops)
+static void request_client_etas(struct client_ops const *ops)
 {
 	struct fio_client *client;
 	struct flist_head *entry;
@@ -2089,7 +2089,7 @@ static int fio_check_clients_timed_out(void)
 	return ret;
 }
 
-int fio_handle_clients(struct client_ops *ops)
+int fio_handle_clients(struct client_ops const *ops)
 {
 	struct pollfd *pfds;
 	int i, ret = 0, retval = 0;
diff --git a/client.h b/client.h
index 8033325e..d77b6076 100644
--- a/client.h
+++ b/client.h
@@ -69,7 +69,7 @@ struct fio_client {
 	uint16_t argc;
 	char **argv;
 
-	struct client_ops *ops;
+	struct client_ops const *ops;
 	void *client_data;
 
 	struct client_file *files;
@@ -84,7 +84,7 @@ typedef void (client_eta_op)(struct jobs_eta *je);
 typedef void (client_timed_out_op)(struct fio_client *);
 typedef void (client_jobs_eta_op)(struct fio_client *client, struct jobs_eta *je);
 
-extern struct client_ops fio_client_ops;
+extern struct client_ops const fio_client_ops;
 
 struct client_ops {
 	client_cmd_op		*text;
@@ -128,8 +128,8 @@ extern int fio_start_client(struct fio_client *);
 extern int fio_start_all_clients(void);
 extern int fio_clients_send_ini(const char *);
 extern int fio_client_send_ini(struct fio_client *, const char *, bool);
-extern int fio_handle_clients(struct client_ops *);
-extern int fio_client_add(struct client_ops *, const char *, void **);
+extern int fio_handle_clients(struct client_ops const*);
+extern int fio_client_add(struct client_ops const*, const char *, void **);
 extern struct fio_client *fio_client_add_explicit(struct client_ops *, const char *, int, int);
 extern void fio_client_add_cmd_option(void *, const char *);
 extern int fio_client_add_ini_file(void *, const char *, bool);
diff --git a/iolog.c b/iolog.c
index cc2cbc65..97ba4396 100644
--- a/iolog.c
+++ b/iolog.c
@@ -82,8 +82,8 @@ static void iolog_delay(struct thread_data *td, unsigned long delay)
 {
 	uint64_t usec = utime_since_now(&td->last_issue);
 	unsigned long orig_delay = delay;
-	uint64_t this_delay;
 	struct timespec ts;
+	int ret = 0;
 
 	if (delay < td->time_offset) {
 		td->time_offset = 0;
@@ -97,13 +97,13 @@ static void iolog_delay(struct thread_data *td, unsigned long delay)
 	delay -= usec;
 
 	fio_gettime(&ts, NULL);
-	while (delay && !td->terminate) {
-		this_delay = delay;
-		if (this_delay > 500000)
-			this_delay = 500000;
 
-		usec_sleep(td, this_delay);
-		delay -= this_delay;
+	while (delay && !td->terminate) {
+		ret = io_u_queued_complete(td, 0);
+		if (ret < 0)
+			td_verror(td, -ret, "io_u_queued_complete");
+		if (utime_since_now(&ts) > delay)
+			break;
 	}
 
 	usec = utime_since_now(&ts);
