Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E340815855C
	for <fio@vger.kernel.org>; Fri,  4 Oct 2024 12:00:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728043212; cv=none; b=deeFioGJhcIacoGMnCrAmXaQpNrF2YPA0mbfr1bC9NVT72ti09nE34jXK4VUllZEd1LL4SbHR+Vm5CitJ1v599d157O/bxH+wRpWHAQTae+mBcw7IOUQvKsmHxiPQMbUDrR2ZSq1U+6Bw7+o1kG7pntClFJQQDdW2s9qWaFjh5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728043212; c=relaxed/simple;
	bh=rCW723Qf6e7lATWCR2MHgP9XmZqSB3IUMe1wAWbm+k0=;
	h=Subject:From:To:Message-Id:Date; b=gZEogKN7DB78EJNuF07/dSzfsLrBnOe3Ogn3PLkoPkywcqugrtJICutDuRHpyY/wNSlbXP17B/PjfV7x6rO7lCp/XLC0y00YBK9V4tYFXyI3+puuh1TYzHGYasQNIiO5rwdseOqNfto7FAWb0nHRm0Nw92fZfc6n59+c9GX5ziQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=fail smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=aUqOm1T7; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="aUqOm1T7"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Date:Message-Id:To:From:Subject:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=RvASzUHwgPdi1IoiIrA40P1XAc1urW1rXjotO5vW9k8=; b=aUqOm1T751QsUYngv7nJjoUlsk
	eJ+qbgf3lFQ5Fb+GFghae0yGKZ7TGoZknwKoFL+ebwPKITpCG87XK4K67hNUVkitFi9mh9jUaKFeG
	yz+/PZ7Rt95WyYWgTG4iNsUHl9X7o85sIqEanLHa46UY2l0lgjeAD5pCHVN8CaN+DujC/mCjYJ9Nl
	GMbeJckAF3YR/U3zo+4j1pCcqTTs5OB0/i5w9VdFiUqIoIkfG3WRIhjMVv0Ulu7LSR8oSYHCuLG77
	xN38kxu9tFCE4Gz/ruTm9+ZGfvp5u8kKURAsIWCToYxbn2WqL/+ZOeGWSaHtLa2evD8gudfLgwe+K
	StK5/zJQ==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by casper.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1swgya-0000000AKvE-2q6L
	for fio@vger.kernel.org;
	Fri, 04 Oct 2024 12:00:05 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id 256C81BC0168; Fri,  4 Oct 2024 06:00:02 -0600 (MDT)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20241004120002.256C81BC0168@kernel.dk>
Date: Fri,  4 Oct 2024 06:00:02 -0600 (MDT)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>

The following changes since commit 92245726b7f608a7e6e294222e68821b4dcc38ea:

  docs: addtions to client/server section (2024-10-02 17:15:40 -0400)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to cd56c0af6f3e1ec3cad49ab0d0c002f2c7de3f90:

  docs: mention unsupported configuration (2024-10-03 20:39:38 +0000)

----------------------------------------------------------------
Vincent Fu (2):
      client/server: enable "All clients" latency percentiles
      docs: mention unsupported configuration

 HOWTO.rst | 11 ++++++++++-
 client.c  | 10 ++++++++++
 fio.1     | 10 +++++++++-
 3 files changed, 29 insertions(+), 2 deletions(-)

---

Diff of recent changes:

diff --git a/HOWTO.rst b/HOWTO.rst
index ac59ddcd..2a57f60a 100644
--- a/HOWTO.rst
+++ b/HOWTO.rst
@@ -4128,6 +4128,11 @@ Measurements and reporting
 	`job_start`. For these properties, the values for the first job are
 	recorded for the group.
 
+        Also, options like :option:`percentile_list` and
+        :option:`unified_rw_reporting` should be consistent among the jobs in a
+        reporting group. Having options like these vary across the jobs in a
+        reporting group is an unsupported configuration.
+
 .. option:: new_group
 
 	Start a new reporting group. See: :option:`group_reporting`.  If not given,
@@ -5391,4 +5396,8 @@ Terse output in client/server mode will differ slightly from what is produced
 when fio is run in stand-alone mode. See the terse output section for details.
 
 Also, if one fio invocation runs workloads on multiple servers, fio will
-provide at the end an aggregate summary report for all workloads.
+provide at the end an aggregate summary report for all workloads. This
+aggregate summary report assumes that options affecting reporting like
+:option:`unified_rw_reporting` and :option:`percentile_list` are identical
+across all the jobs summarized. Having different values for these options is an
+unsupported configuration.
diff --git a/client.c b/client.c
index 5964faba..d6d54663 100644
--- a/client.c
+++ b/client.c
@@ -1128,6 +1128,16 @@ static void handle_ts(struct fio_client *client, struct fio_net_cmd *cmd)
 	sum_thread_stats(&client_ts, &p->ts);
 	sum_group_stats(&client_gs, &p->rs);
 
+	if (!client_ts.members) {
+		/* Arbitrarily use the percentile toggles and percentile list
+		 * from the first thread_stat that comes our way */
+		client_ts.slat_percentiles = p->ts.slat_percentiles;
+		client_ts.clat_percentiles = p->ts.clat_percentiles;
+		client_ts.lat_percentiles = p->ts.lat_percentiles;
+
+		for (int i = 0; i < FIO_IO_U_LIST_MAX_LEN; i++)
+			client_ts.percentile_list[i] = p->ts.percentile_list[i];
+	}
 	client_ts.members++;
 	client_ts.thread_number = p->ts.thread_number;
 	client_ts.groupid = p->ts.groupid;
diff --git a/fio.1 b/fio.1
index cce80894..53fb7849 100644
--- a/fio.1
+++ b/fio.1
@@ -3844,6 +3844,10 @@ have a natural group-level equivalent. Examples include \fBkb_base\fR,
 \fBunit_base\fR, \fBsig_figs\fR, \fBthread_number\fR, \fBpid\fR, and
 \fBjob_start\fR. For these properties, the values for the first job are
 recorded for the group.
+.P
+Also, options like \fBpercentile_list\fR and \fBunified_rw_reporting\fR should
+be consistent among the jobs in a reporting group. Having options like these
+vary across the jobs in a reporting group is an unsupported configuration.
 .RE
 .TP
 .BI new_group
@@ -5148,7 +5152,11 @@ Terse output in client/server mode will differ slightly from what is produced
 when fio is run in stand-alone mode. See the terse output section for details.
 .P
 Also, if one fio invocation runs workloads on multiple servers, fio will
-provide at the end an aggregate summary report for all workloads.
+provide at the end an aggregate summary report for all workloads. This
+aggregate summary report assumes that options affecting reporting like
+\fBunified_rw_reporting\fR and \fBpercentile_list\fR are identical across all
+the jobs summarized. Having different values for these options is an
+unsupported configuration.
 .SH AUTHORS
 .B fio
 was written by Jens Axboe <axboe@kernel.dk>.
