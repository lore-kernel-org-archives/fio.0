Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1936214F9F
	for <fio@vger.kernel.org>; Fri,  3 Nov 2023 12:00:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="SvAG2t7e"
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B514CD43
	for <fio@vger.kernel.org>; Fri,  3 Nov 2023 05:00:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=Date:Message-Id:To:From:Subject:Sender
	:Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=nY/ZC3PVGTKbNfCiArTrgO3Kr2aXLbhNyOfsOtqdZFQ=; b=SvAG2t7ew83+cv78fDJg5lmVbX
	9syTV60tB0zf6FqBIH03wusycd+LvvrVk06EHzaXfaIG5LbQjhQtJfT5f43W2n2dH4ieUv9SIGrBn
	b0342fNwHDZVSb6pC1thnUdoyVVSYkawLVtlDQDrUXH3C7ySbSoIIWZzQWZurnFrUO/SZhROsNUuA
	8IKDfvqEg5T+Z3c/qhFikKJxahxKk1HSHd2f0kQRLpIGIiZXeuq/6prwMmqi4nw9IGucZYTCFi4+/
	QdZZ3HwltjmgZcQvIfLkiJMd4GnNWZGPJafvejXaiWZMLkh1ObYxHiQ6Uye+628ZhCGo049rjmPVu
	k26Rq0yw==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by desiato.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
	id 1qysqM-007Ynr-1W
	for fio@vger.kernel.org;
	Fri, 03 Nov 2023 12:00:07 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id E30F31BC0180; Fri,  3 Nov 2023 06:00:01 -0600 (MDT)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20231103120001.E30F31BC0180@kernel.dk>
Date: Fri,  3 Nov 2023 06:00:01 -0600 (MDT)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>

The following changes since commit 95f4d3f054464e997ae1067dc7f4f8ec3f896ccc:

  Merge branch 'pi-perf' of https://github.com/ankit-sam/fio (2023-10-31 09:27:15 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 48cf0c63e5b867c8953f25deaa02466bf94a2eed:

  engines/xnvme: fix fdp support for userspace drivers (2023-11-02 06:08:13 -0600)

----------------------------------------------------------------
Ankit Kumar (1):
      engines/xnvme: fix fdp support for userspace drivers

 engines/xnvme.c        |  2 +-
 examples/xnvme-fdp.fio | 20 ++++++++++++++++++++
 2 files changed, 21 insertions(+), 1 deletion(-)

---

Diff of recent changes:

diff --git a/engines/xnvme.c b/engines/xnvme.c
index ce7b2bdd..b7824013 100644
--- a/engines/xnvme.c
+++ b/engines/xnvme.c
@@ -964,7 +964,7 @@ static int xnvme_fioe_fetch_ruhs(struct thread_data *td, struct fio_file *f,
 	uint32_t nsid;
 	int err = 0, err_lock;
 
-	if (f->filetype != FIO_TYPE_CHAR) {
+	if (f->filetype != FIO_TYPE_CHAR && f->filetype != FIO_TYPE_FILE) {
 		log_err("ioeng->fdp_ruhs(): ignoring filetype: %d\n", f->filetype);
 		return -EINVAL;
 	}
diff --git a/examples/xnvme-fdp.fio b/examples/xnvme-fdp.fio
index 86fbe0d3..c50959f1 100644
--- a/examples/xnvme-fdp.fio
+++ b/examples/xnvme-fdp.fio
@@ -16,6 +16,26 @@
 ;   --xnvme_sync=nvme \
 ;   --filename=/dev/ng0n1
 ;
+; # Use the xNVMe io-engine engine with SPDK backend, note that you have to set the Namespace-id
+; fio examples/xnvme-fdp.fio \
+;   --section=default \
+;   --ioengine=xnvme \
+;   --xnvme_dev_nsid=1 \
+;   --filename=0000\\:01\\:00.0
+;
+; NOTE: The URI encoded in the filename above, the ":" must be escaped.
+;
+; On the command-line using two "\\":
+;
+; --filename=0000\\:01\\:00.0
+;
+; Within a fio-script using a single "\":
+;
+; filename=0000\:01\:00.0
+;
+; NOTE: If you want to override the default bs, iodepth, and workload, then
+; invoke it as:
+;
 ; FIO_BS="512" FIO_RW="read" FIO_IODEPTH=16 fio examples/xnvme-fdp.fio \
 ;   --section=override --ioengine=xnvme --xnvme_sync=nvme --filename=/dev/ng0n1
 ;
