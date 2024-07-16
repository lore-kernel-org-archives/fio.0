Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A11E143891
	for <fio@vger.kernel.org>; Tue, 16 Jul 2024 12:00:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721131213; cv=none; b=hHksXfzcLYeFhr3H3e+Z0bUUhRzfmIvEu+yf5Fvia+BxVjmFP6be1HsKDQumHj5khy9UDEssP6Y+kPDdMB7O5h0Xr2tj0gMHs3CAWYJHkR8ID59wv/F2G72sGa3IIaNq+tM4qv7ceLhusK+caXbLR50KUo+njHoQyn04LPEzvcg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721131213; c=relaxed/simple;
	bh=4ULYO3rwtUqFBvpqNufXI100i1AQkTdK0BC3k2Mu1/g=;
	h=Subject:From:To:Message-Id:Date; b=ASwL0kaTuzI8+yVZHA9oB2xBxLv/xxk4wBOBenehzuBs4+7+V1VsO3BwPqqGlI9KFA4mqGKMBD5lvDo+yYFqbbrmTZDA4yKhA/7+cGQv9ciZCwMMAWijrFCuht0sZrSXnoqsOVbmgs/Ydz+dGAsYh9liouCJdfGGoUoyyAeK2gQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=fail smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=PKZqH3us; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="PKZqH3us"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=Date:Message-Id:To:From:Subject:Sender
	:Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=fRIVTZ1HqO85vxd6M8MVHbGWv4MuDfjAog+AWfDwEvw=; b=PKZqH3us4oJfwRqwgP0aCUfbon
	P+h/wgxymNPVRcQ3x92vbVGcJBKLwZQ0pxvRba5G9dmg8b57amKVROwSXDqS/R3xD54phLK95U8qn
	0NwsfSeIz+eDks3VAzFMuATH9mu2HRHcvt8euIHBdqRSc9MWx3VvVDA10POMrynSpHA/4HF++zWar
	KHQgLcHvQeBnb2yR+sM4XJKWFfeugO8pC/7eF0xlrpSOfYPAH5Hp7BI4mudOP4SuCRIuVm9x7pvDo
	ds/i7wIjHWzf9eCZPWU0NY8BVZzPZenj5jXzubTa6wx4SEIrglH4S4IOtJ7f+vQe6nAL+KPvFolst
	G1Az6ttQ==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by desiato.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sTgqj-0000000222D-3OGv
	for fio@vger.kernel.org;
	Tue, 16 Jul 2024 12:00:06 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id 987C21BC017E; Tue, 16 Jul 2024 06:00:01 -0600 (MDT)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20240716120001.987C21BC017E@kernel.dk>
Date: Tue, 16 Jul 2024 06:00:01 -0600 (MDT)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>

The following changes since commit 2cb0841a1452f34a20ffe8fc1821b305f10b3f63:

  os/os-qnx: fix overwrite of 'errno' (2024-07-12 10:52:33 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 791f697320637fb39375ce4a80c287afaff8f395:

  t/nvmept_fdp: accommodate devices with many RUHS (2024-07-15 20:12:02 +0000)

----------------------------------------------------------------
Ankit Kumar (3):
      dataplacement: update ruh info initialization
      engines/io_uring: fdp allocate ruhs buffer as per actual
      engines/xnvme: allocate fdp ruhs buffer as per actual

Vincent Fu (1):
      t/nvmept_fdp: accommodate devices with many RUHS

 dataplacement.c    | 60 +++++++++++++++++++++++++++++++++++++++++++-----------
 engines/io_uring.c | 14 ++++++-------
 engines/xnvme.c    |  7 ++++---
 t/nvmept_fdp.py    | 18 +++++++++++-----
 4 files changed, 72 insertions(+), 27 deletions(-)

---

Diff of recent changes:

diff --git a/dataplacement.c b/dataplacement.c
index 8a4c8e64..ec1427c8 100644
--- a/dataplacement.c
+++ b/dataplacement.c
@@ -43,18 +43,19 @@ static int fdp_ruh_info(struct thread_data *td, struct fio_file *f,
 static int init_ruh_info(struct thread_data *td, struct fio_file *f)
 {
 	struct fio_ruhs_info *ruhs, *tmp;
+	uint32_t nr_ruhs;
 	int i, ret;
 
-	ruhs = scalloc(1, sizeof(*ruhs) + FDP_MAX_RUHS * sizeof(*ruhs->plis));
-	if (!ruhs)
-		return -ENOMEM;
-
 	/* set up the data structure used for FDP to work with the supplied stream IDs */
 	if (td->o.dp_type == FIO_DP_STREAMS) {
 		if (!td->o.dp_nr_ids) {
 			log_err("fio: stream IDs must be provided for dataplacement=streams\n");
 			return -EINVAL;
 		}
+		ruhs = scalloc(1, sizeof(*ruhs) + FDP_MAX_RUHS * sizeof(*ruhs->plis));
+		if (!ruhs)
+			return -ENOMEM;
+
 		ruhs->nr_ruhs = td->o.dp_nr_ids;
 		for (int i = 0; i < ruhs->nr_ruhs; i++)
 			ruhs->plis[i] = td->o.dp_ids[i];
@@ -63,6 +64,11 @@ static int init_ruh_info(struct thread_data *td, struct fio_file *f)
 		return 0;
 	}
 
+	/*
+	 * Since we don't know the actual number of ruhs. Only fetch the header.
+	 * We will reallocate this buffer and then fetch all the ruhs again.
+	 */
+	ruhs = calloc(1, sizeof(*ruhs));
 	ret = fdp_ruh_info(td, f, ruhs);
 	if (ret) {
 		log_info("fio: ruh info failed for %s (%d)\n",
@@ -70,19 +76,38 @@ static int init_ruh_info(struct thread_data *td, struct fio_file *f)
 		goto out;
 	}
 
-	if (ruhs->nr_ruhs > FDP_MAX_RUHS)
-		ruhs->nr_ruhs = FDP_MAX_RUHS;
+	nr_ruhs = ruhs->nr_ruhs;
+	ruhs = realloc(ruhs, sizeof(*ruhs) + nr_ruhs * sizeof(*ruhs->plis));
+	if (!ruhs) {
+		log_info("fio: ruhs buffer realloc failed for %s\n",
+			 f->file_name);
+		ret = -ENOMEM;
+		goto out;
+	}
 
-	if (td->o.dp_nr_ids == 0) {
-		f->ruhs_info = ruhs;
-		return 0;
+	ruhs->nr_ruhs = nr_ruhs;
+	ret = fdp_ruh_info(td, f, ruhs);
+	if (ret) {
+		log_info("fio: ruh info failed for %s (%d)\n",
+			 f->file_name, -ret);
+		goto out;
 	}
 
-	for (i = 0; i < td->o.dp_nr_ids; i++) {
-		if (td->o.dp_ids[i] >= ruhs->nr_ruhs) {
+	if (td->o.dp_nr_ids == 0) {
+		if (ruhs->nr_ruhs > FDP_MAX_RUHS)
+			ruhs->nr_ruhs = FDP_MAX_RUHS;
+	} else {
+		if (td->o.dp_nr_ids > FDP_MAX_RUHS) {
 			ret = -EINVAL;
 			goto out;
 		}
+		for (i = 0; i < td->o.dp_nr_ids; i++) {
+			if (td->o.dp_ids[i] >= ruhs->nr_ruhs) {
+				ret = -EINVAL;
+				goto out;
+			}
+		}
+		ruhs->nr_ruhs = td->o.dp_nr_ids;
 	}
 
 	tmp = scalloc(1, sizeof(*tmp) + ruhs->nr_ruhs * sizeof(*tmp->plis));
@@ -91,12 +116,23 @@ static int init_ruh_info(struct thread_data *td, struct fio_file *f)
 		goto out;
 	}
 
+	if (td->o.dp_nr_ids == 0) {
+		for (i = 0; i < ruhs->nr_ruhs; i++)
+			tmp->plis[i] = ruhs->plis[i];
+
+		tmp->nr_ruhs = ruhs->nr_ruhs;
+		f->ruhs_info = tmp;
+		free(ruhs);
+
+		return 0;
+	}
+
 	tmp->nr_ruhs = td->o.dp_nr_ids;
 	for (i = 0; i < td->o.dp_nr_ids; i++)
 		tmp->plis[i] = ruhs->plis[td->o.dp_ids[i]];
 	f->ruhs_info = tmp;
 out:
-	sfree(ruhs);
+	free(ruhs);
 	return ret;
 }
 
diff --git a/engines/io_uring.c b/engines/io_uring.c
index 7e083010..334c77b9 100644
--- a/engines/io_uring.c
+++ b/engines/io_uring.c
@@ -1533,10 +1533,12 @@ static int fio_ioring_cmd_fetch_ruhs(struct thread_data *td, struct fio_file *f,
 				     struct fio_ruhs_info *fruhs_info)
 {
 	struct nvme_fdp_ruh_status *ruhs;
-	int bytes, ret, i;
+	int bytes, nr_ruhs, ret, i;
 
-	bytes = sizeof(*ruhs) + FDP_MAX_RUHS * sizeof(struct nvme_fdp_ruh_status_desc);
-	ruhs = scalloc(1, bytes);
+	nr_ruhs = fruhs_info->nr_ruhs;
+	bytes = sizeof(*ruhs) + fruhs_info->nr_ruhs * sizeof(struct nvme_fdp_ruh_status_desc);
+
+	ruhs = calloc(1, bytes);
 	if (!ruhs)
 		return -ENOMEM;
 
@@ -1545,12 +1547,10 @@ static int fio_ioring_cmd_fetch_ruhs(struct thread_data *td, struct fio_file *f,
 		goto free;
 
 	fruhs_info->nr_ruhs = le16_to_cpu(ruhs->nruhsd);
-	if (fruhs_info->nr_ruhs > FDP_MAX_RUHS)
-		fruhs_info->nr_ruhs = FDP_MAX_RUHS;
-	for (i = 0; i < fruhs_info->nr_ruhs; i++)
+	for (i = 0; i < nr_ruhs; i++)
 		fruhs_info->plis[i] = le16_to_cpu(ruhs->ruhss[i].pid);
 free:
-	sfree(ruhs);
+	free(ruhs);
 	return ret;
 }
 
diff --git a/engines/xnvme.c b/engines/xnvme.c
index 6ba4aa46..5f1af78d 100644
--- a/engines/xnvme.c
+++ b/engines/xnvme.c
@@ -1253,7 +1253,7 @@ static int xnvme_fioe_fetch_ruhs(struct thread_data *td, struct fio_file *f,
 	struct xnvme_dev *dev;
 	struct xnvme_spec_ruhs *ruhs;
 	struct xnvme_cmd_ctx ctx;
-	uint32_t ruhs_nbytes;
+	uint32_t ruhs_nbytes, nr_ruhs;
 	uint32_t nsid;
 	int err = 0, err_lock;
 
@@ -1276,7 +1276,8 @@ static int xnvme_fioe_fetch_ruhs(struct thread_data *td, struct fio_file *f,
 		goto exit;
 	}
 
-	ruhs_nbytes = sizeof(*ruhs) + (FDP_MAX_RUHS * sizeof(struct xnvme_spec_ruhs_desc));
+	nr_ruhs = fruhs_info->nr_ruhs;
+	ruhs_nbytes = sizeof(*ruhs) + (fruhs_info->nr_ruhs * sizeof(struct xnvme_spec_ruhs_desc));
 	ruhs = xnvme_buf_alloc(dev, ruhs_nbytes);
 	if (!ruhs) {
 		err = -errno;
@@ -1296,7 +1297,7 @@ static int xnvme_fioe_fetch_ruhs(struct thread_data *td, struct fio_file *f,
 	}
 
 	fruhs_info->nr_ruhs = ruhs->nruhsd;
-	for (uint32_t idx = 0; idx < fruhs_info->nr_ruhs; ++idx) {
+	for (uint32_t idx = 0; idx < nr_ruhs; ++idx) {
 		fruhs_info->plis[idx] = le16_to_cpu(ruhs->desc[idx].pi);
 	}
 
diff --git a/t/nvmept_fdp.py b/t/nvmept_fdp.py
index 1739e8fc..31a54a1e 100755
--- a/t/nvmept_fdp.py
+++ b/t/nvmept_fdp.py
@@ -36,6 +36,10 @@ from pathlib import Path
 from fiotestlib import FioJobCmdTest, run_fio_tests
 from fiotestcommon import SUCCESS_NONZERO
 
+# This needs to match FIO_MAX_DP_IDS and DP_MAX_SCHEME_ENTRIES in
+# dataplacement.h
+FIO_MAX_DP_IDS = 128
+DP_MAX_SCHEME_ENTRIES = 32
 
 class FDPTest(FioJobCmdTest):
     """
@@ -133,7 +137,7 @@ class FDPMultiplePLIDTest(FDPTest):
                     'maxplid': FIO_FDP_NUMBER_PLIDS-1,
                     # parameters for 400, 401 tests
                     'hole_size': 64*1024,
-                    'nios_for_scheme': FIO_FDP_NUMBER_PLIDS//2,
+                    'nios_for_scheme': min(FIO_FDP_NUMBER_PLIDS//2, DP_MAX_SCHEME_ENTRIES),
                 }
         if 'number_ios' in self.fio_opts and isinstance(self.fio_opts['number_ios'], str):
             self.fio_opts['number_ios'] = eval(self.fio_opts['number_ios'].format(**mapping))
@@ -212,9 +216,10 @@ class FDPMultiplePLIDTest(FDPTest):
         """
         ruamw = [FIO_FDP_MAX_RUAMW] * FIO_FDP_NUMBER_PLIDS
 
-        remainder = int(self.fio_opts['number_ios'] % len(plid_list))
-        whole = int((self.fio_opts['number_ios'] - remainder) / len(plid_list))
-        logging.debug("PLIDs in the list should receive %d writes; %d PLIDs will receive one extra",
+        number_ios = self.fio_opts['number_ios'] % (len(plid_list)*FIO_FDP_MAX_RUAMW)
+        remainder = int(number_ios % len(plid_list))
+        whole = int((number_ios - remainder) / len(plid_list))
+        logging.debug("PLIDs in the list should show they have received %d writes; %d PLIDs will receive one extra",
                       whole, remainder)
 
         for plid in plid_list:
@@ -225,6 +230,9 @@ class FDPMultiplePLIDTest(FDPTest):
         logging.debug("Expected ruamw values: %s", str(ruamw))
 
         for idx, ruhs in enumerate(fdp_status['ruhss']):
+            if idx >= FIO_FDP_NUMBER_PLIDS:
+                break
+
             if ruhs['ruamw'] != ruamw[idx]:
                 logging.error("RUAMW mismatch with idx %d, pid %d, expected %d, observed %d", idx,
                               ruhs['pid'], ruamw[idx], ruhs['ruamw'])
@@ -1053,7 +1061,7 @@ def main():
         test['fio_opts']['filename'] = args.dut
 
     fdp_status = get_fdp_status(args.dut)
-    FIO_FDP_NUMBER_PLIDS = fdp_status['nruhsd']
+    FIO_FDP_NUMBER_PLIDS = min(fdp_status['nruhsd'], 128)
     update_all_ruhs(args.dut)
     FIO_FDP_MAX_RUAMW = check_all_ruhs(args.dut)
     if not FIO_FDP_MAX_RUAMW:
