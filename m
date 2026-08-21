Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E7C8380FC6
	for <fio@vger.kernel.org>; Fri, 21 Aug 2026 12:00:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787313616; cv=none; b=gKVTifsx4Xeps9BvVScNp982tKxTZILeO4dvk1EyJthayxjZ9qaOccRahtvE8Dj6HiifGJIGjlXu8ZAwm2mYfUH2G6kQZEUREmp/U5uzModVp/UnANSp3uvb8ePnMmSyABjpEyFFw3Or+TzBAro2DtdgUKw9qmsrD1w2OrMoqrs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787313616; c=relaxed/simple;
	bh=cN6oFY2E/wyGpIoQFXy00W4HDo6x67cis1tL04VNDZI=;
	h=Subject:From:To:Date:Message-Id; b=FD1uLcDSGcb2pjRSSXfVxYXwClu4P3qMkirgY5iF7MuG2ckCW0Oweldf6L8LKfXLY3doUxDw6+lHtNBR28R2eTc2RJjd5J/DuqdKntgE1e4Cll8Q+NadzWXEpo+bjDBZ/f6poKLOJdh6NLqYzSCmTHkU4MxJ/bmZ+0NuqdOFKPg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=fail smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=JxnW6ExR; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="JxnW6ExR"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Message-Id:Date:To:From:Subject:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=k5Vxg9bGdf3NiZwUxyQVjickPXPcRjteP+OogIQipTI=; b=JxnW6ExRcos0dm2zLFWXgJtmkf
	e/PRElbFwQ152zXGQe8Ixcgshkudwf0rV7BgwHr8bNW17r7P8fs4gCRLyj2TagQFmbAY4NA9No6WL
	PHOlnsC29zunIuaxKeOkDjFvh23ICbZ1UFLg6qtdGqQw/boKNezdvMTrbqkZPZ0SzU621RIQhmmxM
	bzZbhE3Z5Qw7CLaY5BeLh2wkZJVvEfUW+jBtBpAHPzh2Muwa55MCC3pOVLyxKPuH3hXpgEWNKo0lv
	cBoti1T6HJeoNadeOK9FI1elj/hacSJkWHiKIrTcjGuavdrP0TeK4Gs8qFDxJbeGrKq1eOi3x1Dhu
	zWQT2nUg==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by casper.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wxNun-0000000HO2j-1MEn
	for fio@vger.kernel.org;
	Fri, 21 Aug 2026 12:00:06 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id E38211BC0161; Fri, 21 Aug 2026 06:00:01 -0600 (MDT)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
User-Agent: mail (GNU Mailutils 3.17)
Date: Fri, 21 Aug 2026 06:00:01 -0600
Message-Id: <20260821120001.E38211BC0161@kernel.dk>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>

The following changes since commit b27fdbac98125f24c7e78ae439245c6989a4a718:

  fio: move example job file to examples directory (2026-08-18 12:24:18 -0400)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to a9f011b10a4b1795c6c340cef24b0b4a441570b5:

  t/io_uring_cmd.py: test new bsg features (2026-08-20 18:25:48 +0000)

----------------------------------------------------------------
Jungwon Lee (5):
      engines/io_uring: drop unused write_opcode assignment on bsg path
      engines/io_uring: drop bsg status parsing from event
      engines/io_uring: add cdb_len option for bsg cmd_type
      engines/io_uring: support write_mode=verify for bsg cmd_type
      engines/io_uring: add read_mode=prefetch for bsg cmd_type

Kurt Miller (1):
      libnfs only requires gnutls on Linux Modify configure to only require gnutls on Linux when libnfs is >= 6.

Vincent Fu (3):
      Merge branch 'gnutls.configure' of https://github.com/bsdkurt/fio
      Merge branch 'bsg-update' of https://github.com/ljw8161/fio
      t/io_uring_cmd.py: test new bsg features

 HOWTO.rst          |  50 ++++++++++-
 configure          |   4 +-
 engines/bsg.c      | 200 ++++++++++++++++++++++++++++++++++++-----
 engines/bsg.h      |  43 ++++++++-
 engines/io_uring.c | 159 +++++++++++++++++++++++++++++---
 fio.1              |  51 ++++++++++-
 t/io_uring_cmd.py  | 260 +++++++++++++++++++++++++++++++++++++++++++++++++++--
 7 files changed, 715 insertions(+), 52 deletions(-)

---

Diff of recent changes:

diff --git a/HOWTO.rst b/HOWTO.rst
index 162115d0..410be6d3 100644
--- a/HOWTO.rst
+++ b/HOWTO.rst
@@ -2598,6 +2598,16 @@ with the caveat that when used on the command line, they must come after the
 	Specifies the type of uring passthrough command to be used. Supported
 	values are nvme and bsg. Default is nvme.
 
+.. option:: cdb_len=int : [io_uring_cmd]
+
+	SCSI CDB length used for bsg :option:`cmd_type`. Supported values are
+	0, 10, 16, and 32. Default is 0 (auto): the smallest CDB whose LBA and
+	transfer-length fields fit the request is chosen, escalating from
+	READ(10)/WRITE(10) to READ(16)/WRITE(16) as needed, mirroring the sg
+	engine. Ignored when cmd_type=nvme. When an explicit length is set, a
+	request whose LBA or transfer length exceeds the field capacity of the
+	chosen CDB fails with -EINVAL rather than falling back to a larger CDB.
+
 .. option:: hipri
 
    [io_uring] [io_uring_cmd] [xnvme]
@@ -3079,7 +3089,11 @@ with the caveat that when used on the command line, they must come after the
                         Use Write Zeroes commands for write operations
 
                 **verify**
-                        Use Verify commands for write operations
+                        Use Verify commands for write operations. Supported for
+                        both nvme and bsg cmd_type. For bsg, the SCSI VERIFY(10)/
+                        (16)/(32) opcode is selected by :option:`cdb_len` and the
+                        data comparison behavior by :option:`verify_bytchk`;
+                        :option:`writefua` is not supported in this mode.
 
                 **zone_append**
                         Use zone append commands for write operations. Requires zonemode=zbd
@@ -3090,6 +3104,40 @@ with the caveat that when used on the command line, they must come after the
         entries with no percentage specified.
         Example: ``write/60:zeroes/30:uncor/10`` or ``write/50:zeroes/:uncor/``
 
+.. option:: verify_bytchk=int : [io_uring_cmd]
+
+        BYTCHK field for the SCSI VERIFY command issued when
+        :option:`write_mode` is ``verify`` and :option:`cmd_type` is ``bsg``.
+        Only valid with write_mode=verify. Defaults to 0.
+
+                **0**
+                        Medium verification only; no data is transferred to
+                        the device.
+
+                **1**
+                        The device compares the full transfer against the data
+                        stored on the medium, byte by byte.
+
+                **3**
+                        The device compares a single block against every block
+                        in the range. Only one block is transferred.
+
+.. option:: read_mode=str : [io_uring_cmd]
+
+        Specifies the type of read operation. Only supported with
+        cmd_type=bsg. Defaults to 'read'.
+
+                **read**
+                        Use Read commands for read operations
+
+                **prefetch**
+                        Use SCSI Pre-Fetch commands, which pull the requested
+                        blocks from the medium into the device read cache
+                        without transferring data to the host. Useful for
+                        cache-warming and prefetch-overhead benchmarks. The
+                        Pre-Fetch(10)/(16) opcode is selected by :option:`cdb_len`.
+                        :option:`readfua` is not supported in this mode.
+
 .. option:: verify_mode=str : [io_uring_cmd]
 
         Specifies the type of command to be used in the verification phase.  Defaults to 'read'.
diff --git a/configure b/configure
index 804db167..2ab83371 100755
--- a/configure
+++ b/configure
@@ -2400,9 +2400,9 @@ if test "$libnfs" != "no" ; then
     libnfs_cflags=$(pkg-config --cflags libnfs)
     libnfs_libs=$(pkg-config --libs libnfs)
 
-    # libnfs >= 6.0.0 requires gnutls for TLS support
+    # libnfs >= 6.0.0 on Linux requires gnutls for TLS support
     libnfs_version=$(pkg-config --modversion libnfs 2>/dev/null)
-    if test -n "$libnfs_version" ; then
+    if test -n "$libnfs_version" -a "$targetos" = "Linux" ; then
       libnfs_major=$(echo $libnfs_version | cut -d. -f1)
       if test "$libnfs_major" -ge 6 ; then
         if $(pkg-config gnutls > /dev/null 2>&1); then
diff --git a/engines/bsg.c b/engines/bsg.c
index 916dc242..f0c9f6f0 100644
--- a/engines/bsg.c
+++ b/engines/bsg.c
@@ -90,41 +90,90 @@ int fio_bsg_uring_cmd_get_file_size(struct thread_data *td, struct fio_file *f)
 }
 
 void fio_bsg_uring_cmd_init(struct bsg_uring_cmd *cmd, struct bsg_cmd *bc,
-			    struct io_u *io_u, int dxfer_dir)
+			    struct io_u *io_u, int dxfer_dir,
+			    unsigned int cdb_len)
 {
 	memset(cmd, 0, sizeof(*cmd));
 	memset(bc->cdb, 0, sizeof(bc->cdb));
 
 	cmd->request = (uint64_t)(uintptr_t) bc->cdb;
-	cmd->request_len = sizeof(bc->cdb);
+	cmd->request_len = cdb_len;
 	cmd->response = (uint64_t)(uintptr_t) bc->sb;
 	cmd->max_response_len = sizeof(bc->sb);
 
 	if (dxfer_dir == SG_DXFER_TO_DEV) {
 		cmd->dout_xferp = (uint64_t)(uintptr_t) io_u->xfer_buf;
 		cmd->dout_xfer_len = io_u->xfer_buflen;
-	} else {
+	} else if (dxfer_dir == SG_DXFER_FROM_DEV) {
 		cmd->din_xferp = (uint64_t)(uintptr_t) io_u->xfer_buf;
 		cmd->din_xfer_len = io_u->xfer_buflen;
 	}
 }
 
 static int fio_bsg_uring_cmd_rw_lba(struct bsg_cmd *bc, unsigned long long lba,
-				    unsigned long long nlb)
+				    unsigned long long nlb,
+				    unsigned int cdb_len)
 {
-	if (lba > MAX_10CDB_LBA || nlb > MAX_10CDB_NLB) {
-		log_err("offset or nlb is larger than the "
-			"maximum value of a field within CDB (10)\n");
+	switch (cdb_len) {
+	case 10:
+		if (lba > MAX_10CDB_LBA || nlb > MAX_10CDB_NLB) {
+			log_err("offset or nlb is larger than the "
+				"maximum value of a field within CDB (10)\n");
+			return -EINVAL;
+		}
+		sgio_set_be32((uint32_t) lba, &bc->cdb[2]);
+		sgio_set_be16((uint16_t) nlb, &bc->cdb[7]);
+		return 0;
+	case 16:
+		if (lba > MAX_16CDB_LBA || nlb > MAX_16CDB_NLB) {
+			log_err("offset or nlb is larger than the "
+				"maximum value of a field within CDB (16)\n");
+			return -EINVAL;
+		}
+		sgio_set_be64((uint64_t) lba, &bc->cdb[2]);
+		sgio_set_be32((uint32_t) nlb, &bc->cdb[10]);
+		return 0;
+	case 32:
+		if (lba > MAX_32CDB_LBA || nlb > MAX_32CDB_NLB) {
+			log_err("offset or nlb is larger than the "
+				"maximum value of a field within CDB (32)\n");
+			return -EINVAL;
+		}
+		sgio_set_be64((uint64_t) lba, &bc->cdb[12]);
+		sgio_set_be32((uint32_t) nlb, &bc->cdb[28]);
+		return 0;
+	default:
+		log_err("unsupported CDB length: %u\n", cdb_len);
 		return -EINVAL;
 	}
-	sgio_set_be32((uint32_t) lba, &bc->cdb[2]);
-	sgio_set_be16((uint16_t) nlb, &bc->cdb[7]);
+}
 
-	return 0;
+static void fio_bsg_varlen_cdb_header(struct bsg_cmd *bc, uint16_t sa)
+{
+	bc->cdb[0] = bsg_cmd_varlen;
+	sgio_set_be16(sa, &bc->cdb[8]);
+	bc->cdb[7] = BSG_VARLEN_CDB_ADDITIONAL_LEN;
+}
+
+static void fio_bsg_set_verify_bytchk(struct bsg_cmd *bc, unsigned int cdb_len,
+				      unsigned int verify_bytchk)
+{
+	/*
+	 * BYTCHK occupies bits 2-1 of byte 1 for VERIFY(10)/(16) and byte 10
+	 * for the 32-byte variable-length VERIFY. BYTCHK=0 leaves the field
+	 * cleared (medium verification only).
+	 */
+	if (cdb_len == 32)
+		bc->cdb[10] |= verify_bytchk << 1;
+	else
+		bc->cdb[1] |= verify_bytchk << 1;
 }
 
 int fio_bsg_uring_cmd_prep(struct bsg_uring_cmd *cmd, struct io_u *io_u,
-			   struct bsg_cmd *bc, bool fua)
+			   struct bsg_cmd *bc, bool fua, unsigned int cdb_len,
+			   enum bsg_write_mode wmode,
+			   unsigned int verify_bytchk,
+			   enum bsg_read_mode rmode)
 {
 	struct bsg_data *data = FILE_ENG_DATA(io_u->file);
 	unsigned long long offset, nlb;
@@ -138,21 +187,115 @@ int fio_bsg_uring_cmd_prep(struct bsg_uring_cmd *cmd, struct io_u *io_u,
 	offset = io_u->offset / data->bs;
 	nlb = io_u->xfer_buflen / data->bs;
 
+	/*
+	 * cdb_len == 0 selects auto-escalation: pick the smallest CDB whose
+	 * LBA and transfer-length fields can hold this request, mirroring the
+	 * sg engine. READ(10)/WRITE(10) cover a 32-bit LBA and 16-bit length;
+	 * anything larger uses READ(16)/WRITE(16). The 32-byte CDB shares the
+	 * same 64-bit LBA / 32-bit length field widths as the 16-byte CDB, so
+	 * it is never reached by auto-escalation and remains opt-in only.
+	 */
+	if (cdb_len == 0) {
+		if (offset > MAX_10CDB_LBA || nlb > MAX_10CDB_NLB)
+			cdb_len = 16;
+		else
+			cdb_len = 10;
+	}
+
 	switch (io_u->ddir) {
 	case DDIR_READ:
-		fio_bsg_uring_cmd_init(cmd, bc, io_u, SG_DXFER_FROM_DEV);
-		bc->cdb[0] = bsg_cmd_read_10;
-		if (fua)
-			bc->cdb[1] |= 1 << 3;
+		if (rmode == BSG_READ_MODE_PREFETCH) {
+			/*
+			 * PREFETCH pulls the requested blocks from the medium
+			 * into the device read cache. No host data transfer.
+			 */
+			fio_bsg_uring_cmd_init(cmd, bc, io_u, SG_DXFER_NONE,
+					       cdb_len);
+			switch (cdb_len) {
+			case 10:
+				bc->cdb[0] = bsg_cmd_prefetch_10;
+				break;
+			case 16:
+				bc->cdb[0] = bsg_cmd_prefetch_16;
+				break;
+			}
+			break;
+		}
+		fio_bsg_uring_cmd_init(cmd, bc, io_u, SG_DXFER_FROM_DEV, cdb_len);
+		switch (cdb_len) {
+		case 10:
+			bc->cdb[0] = bsg_cmd_read_10;
+			if (fua)
+				bc->cdb[1] |= 1 << 3;
+			break;
+		case 16:
+			bc->cdb[0] = bsg_cmd_read_16;
+			if (fua)
+				bc->cdb[1] |= 1 << 3;
+			break;
+		case 32:
+			fio_bsg_varlen_cdb_header(bc, BSG_SA_READ_32);
+			if (fua)
+				bc->cdb[10] |= 1 << 3;
+			break;
+		}
 		break;
 	case DDIR_WRITE:
-		fio_bsg_uring_cmd_init(cmd, bc, io_u, SG_DXFER_TO_DEV);
-		bc->cdb[0] = bsg_cmd_write_10;
-		if (fua)
-			bc->cdb[1] |= 1 << 3;
+		if (wmode == BSG_WRITE_MODE_VERIFY) {
+			/*
+			 * VERIFY data direction depends on BYTCHK:
+			 *   0  medium verification only, no host data transfer
+			 *   1  compare the whole transfer against the medium
+			 *   3  compare a single block against the whole range
+			 * BYTCHK 1 and 3 send data to the device.
+			 */
+			int dxfer = verify_bytchk ? SG_DXFER_TO_DEV :
+						    SG_DXFER_NONE;
+
+			fio_bsg_uring_cmd_init(cmd, bc, io_u, dxfer, cdb_len);
+			switch (cdb_len) {
+			case 10:
+				bc->cdb[0] = bsg_cmd_verify_10;
+				break;
+			case 16:
+				bc->cdb[0] = bsg_cmd_verify_16;
+				break;
+			case 32:
+				fio_bsg_varlen_cdb_header(bc, BSG_SA_VERIFY_32);
+				break;
+			}
+			fio_bsg_set_verify_bytchk(bc, cdb_len, verify_bytchk);
+			/*
+			 * BYTCHK=3 compares one block against the entire
+			 * range, so only a single block is transferred while
+			 * the CDB still carries the full block count.
+			 */
+			if (verify_bytchk == 3)
+				cmd->dout_xfer_len = data->bs;
+			break;
+		}
+		fio_bsg_uring_cmd_init(cmd, bc, io_u, SG_DXFER_TO_DEV, cdb_len);
+		switch (cdb_len) {
+		case 10:
+			bc->cdb[0] = bsg_cmd_write_10;
+			if (fua)
+				bc->cdb[1] |= 1 << 3;
+			break;
+		case 16:
+			bc->cdb[0] = bsg_cmd_write_16;
+			if (fua)
+				bc->cdb[1] |= 1 << 3;
+			break;
+		case 32:
+			fio_bsg_varlen_cdb_header(bc, BSG_SA_WRITE_32);
+			if (fua)
+				bc->cdb[10] |= 1 << 3;
+			break;
+		}
 		break;
 	case DDIR_TRIM:
-		fio_bsg_uring_cmd_init(cmd, bc, io_u, SG_DXFER_TO_DEV);
+		/* UNMAP CDB has fixed 10-byte length regardless of cdb_len */
+		fio_bsg_uring_cmd_init(cmd, bc, io_u, SG_DXFER_TO_DEV, 10);
 		bc->cdb[0] = bsg_cmd_unmap;
 		data_len = sizeof(bc->unmap_param) / sizeof(bc->unmap_param[0]);
 		sgio_set_be16((uint16_t) data_len, &bc->cdb[7]);
@@ -164,12 +307,23 @@ int fio_bsg_uring_cmd_prep(struct bsg_uring_cmd *cmd, struct io_u *io_u,
 		cmd->dout_xfer_len = data_len;
 		return 0;
 	case DDIR_SYNC:
-		fio_bsg_uring_cmd_init(cmd, bc, io_u, SG_DXFER_NONE);
-		bc->cdb[0] = bsg_cmd_sync_cache_10;
+		/*
+		 * SYNCHRONIZE CACHE has 10-byte (0x35) and 16-byte (0x91)
+		 * CDB only; no 32-byte service action is defined by
+		 * SBC. When cdb_len=32 is requested, fall back to the
+		 * 16-byte CDB.
+		 */
+		if (cdb_len == 10) {
+			fio_bsg_uring_cmd_init(cmd, bc, io_u, SG_DXFER_NONE, 10);
+			bc->cdb[0] = bsg_cmd_sync_cache_10;
+		} else {
+			fio_bsg_uring_cmd_init(cmd, bc, io_u, SG_DXFER_NONE, 16);
+			bc->cdb[0] = bsg_cmd_sync_cache_16;
+		}
 		return 0;
 	default:
 		return -ENOTSUP;
 	}
 
-	return fio_bsg_uring_cmd_rw_lba(bc, offset, nlb);
+	return fio_bsg_uring_cmd_rw_lba(bc, offset, nlb, cdb_len);
 }
diff --git a/engines/bsg.h b/engines/bsg.h
index da64b999..725a391e 100644
--- a/engines/bsg.h
+++ b/engines/bsg.h
@@ -40,19 +40,55 @@ struct bsg_uring_cmd {
 #endif /* CONFIG_BSG_URING_CMD */
 
 #define MAX_SB 64
+#define MAX_CDB_LEN 32
+
 #define MAX_10CDB_LBA  0xFFFFFFFFULL
 #define MAX_10CDB_NLB  0xFFFFU
+#define MAX_16CDB_LBA  0xFFFFFFFFFFFFFFFFULL
+#define MAX_16CDB_NLB  0xFFFFFFFFU
+#define MAX_32CDB_LBA  MAX_16CDB_LBA
+#define MAX_32CDB_NLB  MAX_16CDB_NLB
+
+/* Variable-length CDB (opcode 0x7F) service actions for 32-byte CDBs */
+#define BSG_VARLEN_CDB_OPCODE		0x7F
+#define BSG_VARLEN_CDB_ADDITIONAL_LEN	0x18	/* 24 -> total 32 bytes */
+#define BSG_SA_READ_32			0x0009
+#define BSG_SA_WRITE_32			0x000B
+#define BSG_SA_VERIFY_32		0x000A
+
+/* SAM status byte returned in bits [0..7] of the BSG uring_cmd big_cqe[0] */
+#define BSG_STAT_CONDITION_MET         0x04
 
 enum bsg_io_opcode {
 	bsg_cmd_read_10			= 0x28,
+	bsg_cmd_read_16			= 0x88,
 	bsg_cmd_read_capacity_10	= 0x25,
 	bsg_cmd_sync_cache_10		= 0x35,
+	bsg_cmd_sync_cache_16		= 0x91,
 	bsg_cmd_unmap			= 0x42,
 	bsg_cmd_write_10		= 0x2A,
+	bsg_cmd_write_16		= 0x8A,
+	bsg_cmd_verify_10		= 0x2F,
+	bsg_cmd_verify_16		= 0x8F,
+	bsg_cmd_prefetch_10		= 0x34,
+	bsg_cmd_prefetch_16		= 0x90,
+	bsg_cmd_varlen			= BSG_VARLEN_CDB_OPCODE,
+};
+
+/* Which command mode to issue for DDIR_WRITE ddir. */
+enum bsg_write_mode {
+	BSG_WRITE_MODE_WRITE = 0,
+	BSG_WRITE_MODE_VERIFY,
+};
+
+/* Which command mode to issue for DDIR_READ ddir. */
+enum bsg_read_mode {
+	BSG_READ_MODE_READ = 0,
+	BSG_READ_MODE_PREFETCH,
 };
 
 struct bsg_cmd {
-	unsigned char cdb[16];
+	unsigned char cdb[MAX_CDB_LEN];
 	unsigned char sb[MAX_SB];
 	uint8_t unmap_param[24];
 };
@@ -67,6 +103,9 @@ int fio_bsg_uring_cmd_read_capacity(struct thread_data *td, unsigned int *bs,
 int fio_bsg_uring_cmd_get_file_size(struct thread_data *td, struct fio_file *f);
 
 int fio_bsg_uring_cmd_prep(struct bsg_uring_cmd *cmd, struct io_u *io_u,
-			   struct bsg_cmd *bc, bool fua);
+			   struct bsg_cmd *bc, bool fua, unsigned int cdb_len,
+			   enum bsg_write_mode wmode,
+			   unsigned int verify_bytchk,
+			   enum bsg_read_mode rmode);
 
 #endif /* FIO_BSG_H */
diff --git a/engines/io_uring.c b/engines/io_uring.c
index fd5475cc..f1e0527c 100644
--- a/engines/io_uring.c
+++ b/engines/io_uring.c
@@ -121,6 +121,11 @@ enum uring_cmd_verify_mode {
 	FIO_URING_CMD_VMODE_COMPARE,
 };
 
+enum uring_cmd_read_mode {
+	FIO_URING_CMD_RMODE_READ = 0,
+	FIO_URING_CMD_RMODE_PREFETCH,
+};
+
 struct io_sq_ring {
 	unsigned *head;
 	unsigned *tail;
@@ -185,6 +190,8 @@ struct ioring_data {
 	/* BSG */
 	struct bsg_cmd *bc;
 	bool fua[DDIR_RWDIR_CNT];
+	enum bsg_write_mode wmode;
+	enum bsg_read_mode rmode;
 };
 
 struct ioring_options {
@@ -214,6 +221,9 @@ struct ioring_options {
 	unsigned int prchk;
 	char *pi_chk;
 	enum uring_cmd_type cmd_type;
+	unsigned int cdb_len;
+	unsigned int verify_bytchk;
+	unsigned int read_mode;
 };
 
 static unsigned int enter_flags = IORING_ENTER_GETEVENTS;
@@ -528,6 +538,80 @@ static struct fio_option options[] = {
 		.category = FIO_OPT_C_ENGINE,
 		.group	= FIO_OPT_G_IOURING,
 	},
+	{
+		.name	= "cdb_len",
+		.lname	= "SCSI CDB length",
+		.type	= FIO_OPT_STR,
+		.off1	= offsetof(struct ioring_options, cdb_len),
+		.help	= "SCSI CDB length for bsg cmd_type (10, 16, or 32). "
+			  "0 (default) auto-escalates to the smallest CDB that "
+			  "fits the request's LBA and transfer length.",
+		.def	= "0",
+		.posval = {
+			  { .ival = "0",
+			    .oval = 0,
+			    .help = "auto-escalates to the smallest CDB",
+			  },
+			  { .ival = "10",
+			    .oval = 10,
+			    .help = "CDB length 10",
+			  },
+			  { .ival = "16",
+			    .oval = 16,
+			    .help = "CDB length 16",
+			  },
+			  { .ival = "32",
+			    .oval = 32,
+			    .help = "CDB length 32",
+			  },
+		},
+		.category = FIO_OPT_C_ENGINE,
+		.group	= FIO_OPT_G_IOURING,
+	},
+	{
+		.name	= "verify_bytchk",
+		.lname	= "SCSI VERIFY BYTCHK field",
+		.type	= FIO_OPT_STR,
+		.off1	= offsetof(struct ioring_options, verify_bytchk),
+		.help	= "BYTCHK field for write_mode=verify (bsg cmd_type only)",
+		.def	= "0",
+		.posval = {
+			  { .ival = "0",
+			    .oval = 0,
+			    .help = "Medium verify",
+			  },
+			  { .ival = "1",
+			    .oval = 1,
+			    .help = "Full compare",
+			  },
+			  { .ival = "3",
+			    .oval = 3,
+			    .help = "Single-block compare",
+			  },
+		},
+		.category = FIO_OPT_C_ENGINE,
+		.group	= FIO_OPT_G_IOURING,
+	},
+	{
+		.name	= "read_mode",
+		.lname	= "Read command type",
+		.type	= FIO_OPT_STR,
+		.off1	= offsetof(struct ioring_options, read_mode),
+		.help	= "Specify the read operation type (bsg cmd_type only)",
+		.def	= "read",
+		.posval = {
+			  { .ival = "read",
+			    .oval = FIO_URING_CMD_RMODE_READ,
+			    .help = "Use Read commands for read operations",
+			  },
+			  { .ival = "prefetch",
+			    .oval = FIO_URING_CMD_RMODE_PREFETCH,
+			    .help = "Use Pre-Fetch commands for read operations",
+			  },
+		},
+		.category = FIO_OPT_C_ENGINE,
+		.group	= FIO_OPT_G_IOURING,
+	},
 	CMDPRIO_OPTIONS(struct ioring_options, FIO_OPT_G_IOURING),
 	{
 		.name	= "md_per_io_size",
@@ -845,7 +929,10 @@ static int fio_ioring_cmd_prep(struct thread_data *td, struct io_u *io_u)
 		sqe->len = io_u->xfer_buflen;
 		cmd = (struct bsg_uring_cmd *)sqe->cmd;
 
-		return fio_bsg_uring_cmd_prep(cmd, io_u, &ld->bc[io_u->index], ld->fua[io_u->ddir]);
+		return fio_bsg_uring_cmd_prep(cmd, io_u, &ld->bc[io_u->index],
+					      ld->fua[io_u->ddir], o->cdb_len,
+					      ld->wmode, o->verify_bytchk,
+					      ld->rmode);
 	}
 }
 
@@ -930,16 +1017,18 @@ static struct io_u *fio_ioring_cmd_event(struct thread_data *td, int event)
 				io_u->error = ret;
 		}
 	} else if (o->cmd_type == FIO_URING_CMD_BSG) {
-		/*
-		 * For bsg uring cmd, the big_cqe[0] in cqe contains the packed
-		 * SCSI status, where bits 0-7 hold the device status and bits 16-23
-		 * contaion the host status
-		 */
-		ret = (cqe->big_cqe[0] >> 16) & 0xff;
-		if (ret)
-			io_u->error = -ret;
-		else
-			io_u->error = cqe->big_cqe[0] & 0xff;
+		ret = cqe->big_cqe[0];
+		if (ret) {
+			/*
+			* PRE-FETCH completes successfully with SCSI status
+			* CONDITION_MET rather than GOOD; don't treat it as an error.
+			*/
+			if (ld->rmode == BSG_READ_MODE_PREFETCH &&
+				io_u->ddir == DDIR_READ &&
+				(ret & 0xff) == BSG_STAT_CONDITION_MET)
+				ret &= ~0xff;
+			io_u->error = ret;
+		}
 	}
 
 ret:
@@ -1575,6 +1664,11 @@ static int fio_ioring_cmd_init(struct thread_data *td, struct ioring_data *ld)
 	}
 
 	if (o->cmd_type == FIO_URING_CMD_NVME) {
+		if (o->read_mode != FIO_URING_CMD_RMODE_READ) {
+			log_err("fio: read_mode is only supported with "
+				"cmd_type=bsg\n");
+			return 1;
+		}
 		if (td_write(td)) {
 			if (o->wmode_split_nr > 1) {
 				int i;
@@ -1622,13 +1716,50 @@ static int fio_ioring_cmd_init(struct thread_data *td, struct ioring_data *ld)
 		ld->bc = calloc(td->o.iodepth, sizeof(struct bsg_cmd));
 
 		if (td_write(td)) {
-			if (o->write_mode == FIO_URING_CMD_WMODE_WRITE) {
-				ld->write_opcode = bsg_cmd_write_10;
-			} else {
+			if (o->write_mode != FIO_URING_CMD_WMODE_WRITE &&
+			    o->write_mode != FIO_URING_CMD_WMODE_VERIFY) {
 				log_err("Not Support Write mode in BSG io_uring_cmd\n");
 				td_verror(td, EINVAL, "fio_ioring_cmd_init");
 				return 1;
 			}
+			if (o->write_mode == FIO_URING_CMD_WMODE_VERIFY &&
+			    o->writefua) {
+				log_err("writefua is not supported "
+					"with write_mode=verify for bsg\n");
+				td_verror(td, EINVAL, "fio_ioring_cmd_init");
+				return 1;
+			}
+			if (o->write_mode != FIO_URING_CMD_WMODE_VERIFY &&
+			    o->verify_bytchk != 0) {
+				log_err("verify_bytchk is only supported "
+					"with write_mode=verify for bsg\n");
+				td_verror(td, EINVAL, "fio_ioring_cmd_init");
+				return 1;
+			}
+			if (o->write_mode == FIO_URING_CMD_WMODE_VERIFY)
+				ld->wmode = BSG_WRITE_MODE_VERIFY;
+			else
+				ld->wmode = BSG_WRITE_MODE_WRITE;
+		}
+		if (td_read(td)) {
+			if (o->read_mode == FIO_URING_CMD_RMODE_PREFETCH &&
+			    o->readfua) {
+				log_err("readfua is not supported "
+					"with read_mode=prefetch for bsg\n");
+				td_verror(td, EINVAL, "fio_ioring_cmd_init");
+				return 1;
+			}
+			if (o->read_mode == FIO_URING_CMD_RMODE_PREFETCH &&
+			    o->cdb_len == 32) {
+				log_err("cdb_len=32 is not supported "
+					"with read_mode=prefetch for bsg\n");
+				td_verror(td, EINVAL, "fio_ioring_cmd_init");
+				return 1;
+			}
+			if (o->read_mode == FIO_URING_CMD_RMODE_PREFETCH)
+				ld->rmode = BSG_READ_MODE_PREFETCH;
+			else
+				ld->rmode = BSG_READ_MODE_READ;
 		}
 
 		if (o->readfua)
diff --git a/fio.1 b/fio.1
index 993762f2..915c8407 100644
--- a/fio.1
+++ b/fio.1
@@ -2381,6 +2381,15 @@ should be used for the polling thread.
 Specifies the type of uring passthrough command to be used. Supported
 values are nvme and bsg. Default is nvme.
 .TP
+.BI (io_uring_cmd)cdb_len \fR=\fPint
+SCSI CDB length used for bsg \fBcmd_type\fR. Supported values are 0, 10, 16,
+and 32. Default is 0 (auto): the smallest CDB whose LBA and
+transfer-length fields fit the request is chosen, escalating from
+READ(10)/WRITE(10) to READ(16)/WRITE(16) as needed, mirroring the sg
+engine. Ignored when cmd_type=nvme. When an explicit length is set, a
+request whose LBA or transfer length exceeds the field capacity of the
+chosen CDB fails with -EINVAL rather than falling back to a larger CDB.
+.TP
 .BI (libaio)userspace_reap
 Normally, with the libaio engine in use, fio will use the
 \fBio_getevents\fR\|(3) system call to reap newly returned events. With
@@ -2865,7 +2874,10 @@ Use Write Uncorrectable commands for write operations
 Use Write Zeroes commands for write operations
 .TP
 .B verify
-Use Verify commands for write operations
+Use Verify commands for write operations. Supported for both nvme and bsg
+cmd_type. For bsg, the SCSI VERIFY(10)/(16)/(32) opcode is selected by
+\fBcdb_len\fR and the data comparison behavior by \fBverify_bytchk\fR;
+\fBwritefua\fR is not supported in this mode.
 .TP
 .B zone_append
 Use Zone Append commands for write operations. Requires zonemode=zbd
@@ -2878,6 +2890,43 @@ percentage specified.
 Example: \fBwrite/60:zeroes/30:uncor/10\fR or \fBwrite/50:zeroes/:uncor/\fR
 .RE
 .TP
+.BI (io_uring_cmd)verify_bytchk \fR=\fPint
+BYTCHK field for the SCSI VERIFY command issued when \fBwrite_mode\fR is
+verify and \fBcmd_type\fR is bsg. Only valid with write_mode=verify.
+Defaults to 0.
+.RS
+.RS
+.TP
+.B 0
+Medium verification only; no data is transferred to the device.
+.TP
+.B 1
+The device compares the full transfer against the data stored on the medium,
+byte by byte.
+.TP
+.B 3
+The device compares a single block against every block in the range. Only one
+block is transferred.
+.RE
+.RE
+.TP
+.BI (io_uring_cmd)read_mode \fR=\fPstr
+Specifies the type of read operation. Only supported with cmd_type=bsg.
+Defaults to 'read'.
+.RS
+.RS
+.TP
+.B read
+Use Read commands for read operations
+.TP
+.B prefetch
+Use SCSI Pre-Fetch commands, which pull the requested blocks from the medium
+into the device read cache without transferring data to the host. Useful for
+cache-warming and prefetch-overhead benchmarks. The Pre-Fetch(10)/(16) opcode
+is selected by \fBcdb_len\fR. \fBreadfua\fR is not supported in this mode.
+.RE
+.RE
+.TP
 .BI (io_uring_cmd)verify_mode \fR=\fPstr
 Specifies the type of command to be used in the verification phase. Defaults to 'read'.
 .RS
diff --git a/t/io_uring_cmd.py b/t/io_uring_cmd.py
index a53f5627..a95ee806 100755
--- a/t/io_uring_cmd.py
+++ b/t/io_uring_cmd.py
@@ -1,15 +1,15 @@
 #!/usr/bin/env python3
-"""
+r"""
 # io_uring_cmd.py
 #
-# Test fio's io_uring_cmd ioengine with NVMe pass-through commands.
+# Test fio's io_uring_cmd ioengine.
 #
 # USAGE
 # see python3 io_uring_cmd.py --help
 #
 # EXAMPLES
 # python3 t/io_uring_cmd.py --dut /dev/ng0n1
-# python3 t/io_uring_cmd.py --dut /dev/ng1n1 -f ./fio
+# python3 t/io_uring_cmd.py --cmd_type=bsg --dut "/dev/bsg/6\:0\:0\:0"
 #
 # REQUIREMENTS
 # Python 3.6
@@ -21,12 +21,14 @@ import time
 import argparse
 from pathlib import Path
 from fiotestlib import FioJobCmdTest, run_fio_tests
+from fiotestcommon import SUCCESS_NONZERO, SUCCESS_DEFAULT
 
 
 class PassThruTest(FioJobCmdTest):
     """
-    NVMe pass-through test class. Check to make sure output for selected data
-    direction(s) is non-zero and that zero data appears for other directions.
+    io_uring_cmd pass-through test class. Check to make sure output for
+    selected data direction(s) is non-zero and that zero data appears for other
+    directions.
     """
 
     def setup(self, parameters):
@@ -47,7 +49,8 @@ class PassThruTest(FioJobCmdTest):
         for opt in ['fixedbufs', 'nonvectored', 'force_async', 'registerfiles',
                     'sqthread_poll', 'sqthread_poll_cpu', 'hipri', 'nowait',
                     'time_based', 'runtime', 'verify', 'io_size', 'readfua',
-                    'writefua', ]:
+                    'writefua', "cdb_len", "write_mode", "read_mode",
+                    "verify_bytchk", "buffer_pattern", "bs", "filesize", ]:
             if opt in self.fio_opts:
                 option = f"--{opt}={self.fio_opts[opt]}"
                 fio_args.append(option)
@@ -64,6 +67,12 @@ class PassThruTest(FioJobCmdTest):
         if not self.passed:
             return
 
+        if 'json' not in self.fio_opts['output-format']:
+            return
+
+        if self.success == SUCCESS_NONZERO:
+            return
+
         job = self.json_data['jobs'][0]
 
         if self.fio_opts['rw'] in ['read', 'randread']:
@@ -362,6 +371,236 @@ TEST_LIST = [
             },
         "test_class": PassThruTest,
     },
+
+#
+# These tests only work for cmd_type=bsg
+#
+
+    # cdb_len tests
+    {
+        "test_id": 100,
+        "cmd_types": ['bsg',],
+        "fio_opts": {
+            "rw": 'randrw',
+            "cdb_len": 0,
+            "timebased": 1,
+            "runtime": 3,
+            "output-format": "json",
+            },
+        "test_class": PassThruTest,
+    },
+    {
+        "test_id": 101,
+        "cmd_types": ['bsg',],
+        "fio_opts": {
+            "rw": 'randrw',
+            "cdb_len": 10,
+            "timebased": 1,
+            "runtime": 3,
+            "output-format": "json",
+            },
+        "test_class": PassThruTest,
+    },
+    {
+        "test_id": 102,
+        "cmd_types": ['bsg',],
+        "fio_opts": {
+            "rw": 'randrw',
+            "cdb_len": 16,
+            "timebased": 1,
+            "runtime": 3,
+            "output-format": "json",
+            },
+        "test_class": PassThruTest,
+    },
+    {
+        "test_id": 103,
+        "cmd_types": ['bsg',],
+        "fio_opts": {
+            "rw": 'randrw',
+            "cdb_len": 32,
+            "timebased": 1,
+            "runtime": 3,
+            "output-format": "json",
+            },
+        "test_class": PassThruTest,
+    },
+    {
+        "test_id": 104,
+        "cmd_types": ['bsg',],
+        "fio_opts": {
+            "rw": 'randrw',
+            "cdb_len": 99,
+            "timebased": 1,
+            "runtime": 3,
+            "output-format": "normal",
+            },
+        "success": SUCCESS_NONZERO,
+        "test_class": PassThruTest,
+    },
+
+    # write_mode=verify tests
+    # first precondition with a known pattern
+    # and then try to verify it
+    {
+        "test_id": 105,
+        "cmd_types": ['bsg',],
+        "fio_opts": {
+            "rw": 'write',
+            "filesize": "8M",
+            "buffer_pattern": '"98765432"',
+            "output-format": "json",
+            },
+        "test_class": PassThruTest,
+    },
+    {
+        "test_id": 106,
+        "cmd_types": ['bsg',],
+        "fio_opts": {
+            "rw": 'randwrite',
+            "filesize": "8M",
+            "write_mode": "verify",
+            "buffer_pattern": '"98765432"',
+            "verify_bytchk": 0,
+            "output-format": "json",
+            },
+        "test_class": PassThruTest,
+    },
+    {
+        "test_id": 107,
+        "cmd_types": ['bsg',],
+        "fio_opts": {
+            "rw": 'randwrite',
+            "filesize": "8M",
+            "write_mode": "verify",
+            "buffer_pattern": '"98765432"',
+            "verify_bytchk": 1,
+            "output-format": "json",
+            },
+        "test_class": PassThruTest,
+    },
+    {
+        "test_id": 108,
+        "cmd_types": ['bsg',],
+        "fio_opts": {
+            "rw": 'randwrite',
+            "bs": "8k",
+            "filesize": "8M",
+            "write_mode": "verify",
+            "buffer_pattern": '"98765432"',
+            "verify_bytchk": 3,
+            "output-format": "json",
+            },
+        "test_class": PassThruTest,
+    },
+    # The following two tests should fail because we are trying to verify
+    # device contents against randomly generated data
+    {
+        "test_id": 109,
+        "cmd_types": ['bsg',],
+        "fio_opts": {
+            "rw": 'write',
+            "filesize": "8M",
+            "write_mode": "verify",
+            "verify_bytchk": 1,
+            "output-format": "json",
+            },
+        "success": SUCCESS_NONZERO,
+        "test_class": PassThruTest,
+    },
+    {
+        "test_id": 110,
+        "cmd_types": ['bsg',],
+        "fio_opts": {
+            "rw": 'write',
+            "bs": "8k",
+            "filesize": "8M",
+            "write_mode": "verify",
+            "verify_bytchk": 3,
+            "output-format": "json",
+            },
+        "success": SUCCESS_NONZERO,
+        "test_class": PassThruTest,
+    },
+    # This test should because because we are specifying verify_bytchk with
+    # write_mode=write
+    {
+        "test_id": 111,
+        "cmd_types": ['bsg',],
+        "fio_opts": {
+            "rw": 'write',
+            "verify_bytchk": 1,
+            "filesize": "8M",
+            "buffer_pattern": '"98765432"',
+            "output-format": "json",
+            },
+        "success": SUCCESS_NONZERO,
+        "test_class": PassThruTest,
+    },
+    # This test should because because we are specifying writefua with
+    # write_mode=verify
+    {
+        "test_id": 112,
+        "cmd_types": ['bsg',],
+        "fio_opts": {
+            "rw": 'write',
+            "write_mode": "verify",
+            "verify_bytchk": 1,
+            "writefua": 1,
+            "filesize": "8M",
+            "buffer_pattern": '"98765432"',
+            "output-format": "json",
+            },
+        "success": SUCCESS_NONZERO,
+        "test_class": PassThruTest,
+    },
+
+    # read_mode=prefetch tests
+    {
+        "test_id": 113,
+        "cmd_types": ['bsg',],
+        "fio_opts": {
+            "rw": 'read',
+            "timebased": 1,
+            "runtime": 3,
+            "read_mode": "prefetch",
+            "output-format": "json",
+            },
+        "test_class": PassThruTest,
+    },
+    # This should fail because readfua does not work with with
+    # read_mode=prefetch
+    {
+        "test_id": 114,
+        "cmd_types": ['bsg',],
+        "fio_opts": {
+            "rw": 'read',
+            "timebased": 1,
+            "runtime": 3,
+            "read_mode": "prefetch",
+            "readfua": 1,
+            "output-format": "json",
+            },
+        "success": SUCCESS_NONZERO,
+        "test_class": PassThruTest,
+    },
+    # This should fail because cdb_len=32 does not work with with
+    # read_mode=prefetch
+    {
+        "test_id": 115,
+        "cmd_types": ['bsg',],
+        "fio_opts": {
+            "rw": 'read',
+            "timebased": 1,
+            "runtime": 3,
+            "read_mode": "prefetch",
+            "cdb_len": 32,
+            "output-format": "json",
+            },
+        "success": SUCCESS_NONZERO,
+        "test_class": PassThruTest,
+    },
+
 ]
 
 def parse_args():
@@ -374,8 +613,9 @@ def parse_args():
                         help='list of test(s) to skip')
     parser.add_argument('-o', '--run-only', nargs='+', type=int,
                         help='list of test(s) to run, skipping all others')
-    parser.add_argument('--dut', help='target NVMe character device to test '
-                        '(e.g., /dev/ng0n1). WARNING: THIS IS A DESTRUCTIVE TEST', required=True)
+    parser.add_argument('--dut', help='target device to test '
+                        r'(e.g., /dev/ng0n1, "/dev/bsg/6\:0\:0\:0"). '
+                        'WARNING: THIS IS A DESTRUCTIVE TEST', required=True)
     parser.add_argument('-c', '--cmd_type', help='cmd_type for io_uring_cmd',
                         default='nvme')
     args = parser.parse_args()
@@ -384,7 +624,7 @@ def parse_args():
 
 
 def main():
-    """Run tests using fio's io_uring_cmd ioengine to send NVMe pass through commands."""
+    """Run tests using fio's io_uring_cmd ioengine to send pass through commands."""
 
     args = parse_args()
 
@@ -402,6 +642,8 @@ def main():
     for test in TEST_LIST:
         test['fio_opts']['filename'] = args.dut
         test['fio_opts']['cmd_type'] = args.cmd_type
+        if 'cmd_types' in test and args.cmd_type not in test['cmd_types']:
+            test['force_skip'] = True
 
     test_env = {
               'fio_path': fio_path,
