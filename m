Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2C99C7619A
	for <fio@archiver.kernel.org>; Wed, 22 Mar 2023 12:00:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230320AbjCVMAS (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 22 Mar 2023 08:00:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230341AbjCVMAQ (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 22 Mar 2023 08:00:16 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 652F7570BA
        for <fio@vger.kernel.org>; Wed, 22 Mar 2023 05:00:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Date:Message-Id:To:From:Subject:Sender
        :Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=wDTi4WqdmfzKeaLwPYLFFG6Tqx9ZT1RAiXdTEyGSHNI=; b=iWhfNroBMubdILSL0sxhqe9N2I
        hPdjpljEGHtW7frlKvoT/Domg6EerRr7axG6jOa+S+NFYHI7XZvaA4NuiF8cEgs78L8GpPfF5N/W9
        5+O32PZHCcWSV4G6NM4REQaMqSQamV9PQYiW246rPpn9a8pR4hPhHfoUJm6NT0kNGs8dZWYHdjkAh
        y97SW64QkyyxZZkxZ149fTx1xZYEky3ebSRjQD9iwK0A3Zx1ssC9Z5K84Zn9DxtQqjb+JscVn7srh
        gI+ALZHWoXVrPkLTaau7xyvUIIoIbO1fY3BCOEieWKKF12g0DtcGqPkt1zTmWmxn36dbfIfoYrxJc
        M/VcJG9w==;
Received: from [96.43.243.2] (helo=kernel.dk)
        by desiato.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1pex8Q-004Y3N-0k
        for fio@vger.kernel.org;
        Wed, 22 Mar 2023 12:00:06 +0000
Received: by kernel.dk (Postfix, from userid 1000)
        id 0B0141BC0170; Wed, 22 Mar 2023 06:00:02 -0600 (MDT)
Subject: Recent changes (master)
From:   Jens Axboe <axboe@kernel.dk>
To:     <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20230322120002.0B0141BC0170@kernel.dk>
Date:   Wed, 22 Mar 2023 06:00:02 -0600 (MDT)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The following changes since commit 51bbb1a120c96ae7b93d058c7ce418962b202515:

  docs: clean up steadystate options (2023-03-20 13:57:47 -0400)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 2fa0ab21c5726d8242a820ff688de019cc4d2fe2:

  engines/nvme: cast __u64 to unsigned long long for printing (2023-03-21 08:40:14 -0600)

----------------------------------------------------------------
Jens Axboe (2):
      engines/io_uring: use correct type for fio_nvme_get_info()
      engines/nvme: cast __u64 to unsigned long long for printing

 engines/io_uring.c | 4 ++--
 engines/nvme.c     | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

---

Diff of recent changes:

diff --git a/engines/io_uring.c b/engines/io_uring.c
index 5393758a..54fdf7f3 100644
--- a/engines/io_uring.c
+++ b/engines/io_uring.c
@@ -1148,7 +1148,7 @@ static int fio_ioring_cmd_open_file(struct thread_data *td, struct fio_file *f)
 	if (o->cmd_type == FIO_URING_CMD_NVME) {
 		struct nvme_data *data = NULL;
 		unsigned int nsid, lba_size = 0;
-		unsigned long long nlba = 0;
+		__u64 nlba = 0;
 		int ret;
 
 		/* Store the namespace-id and lba size. */
@@ -1214,7 +1214,7 @@ static int fio_ioring_cmd_get_file_size(struct thread_data *td,
 	if (o->cmd_type == FIO_URING_CMD_NVME) {
 		struct nvme_data *data = NULL;
 		unsigned int nsid, lba_size = 0;
-		unsigned long long nlba = 0;
+		__u64 nlba = 0;
 		int ret;
 
 		ret = fio_nvme_get_info(f, &nsid, &lba_size, &nlba);
diff --git a/engines/nvme.c b/engines/nvme.c
index da18eba9..3f6b64a8 100644
--- a/engines/nvme.c
+++ b/engines/nvme.c
@@ -241,7 +241,7 @@ int fio_nvme_report_zones(struct thread_data *td, struct fio_file *f,
 				break;
 			default:
 				log_err("%s: invalid type for zone at offset %llu.\n",
-					f->file_name, desc->zslba);
+					f->file_name, (unsigned long long) desc->zslba);
 				ret = -EIO;
 				goto out;
 			}
