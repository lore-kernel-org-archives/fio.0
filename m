Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CCCEC433F5
	for <fio@archiver.kernel.org>; Wed, 19 Jan 2022 13:00:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354521AbiASNAK (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 19 Jan 2022 08:00:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354518AbiASNAH (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 19 Jan 2022 08:00:07 -0500
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4F10C061574
        for <fio@vger.kernel.org>; Wed, 19 Jan 2022 05:00:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Date:Message-Id:To:From:Subject:Sender
        :Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=qZGNltY1J3i8i/U8zGJw9KBvN7vGVCf7NqprvrbGqg4=; b=BXld6kByjYE/mGgbuzut1feyVo
        ON5ZDc4iOjfdDFrX1ZR3u6xm3vk3/tJValoVld+8puEEijtZ6Etkh4ov1jNVKK+YbBQeQabAz+ZuG
        dst/VFPHX18QIR1kzT59JlCZj0/Tf3oQN98yfIhAYoDkEk9/cSirC/0yH01MvO3NJ0PI7l24u+K+X
        wslOe/0TH6T7Lijre9NPlHd7whlsON29WbltmhoseCO8Tn3DTZy2+iipG3wT9NSU8uON9pub1UIPZ
        V8oIbt7qr3pcxaMf0MZsJe5LVdN9yq76VvqDzYMKXb0VDyMEVxF82G47Zc2dgZeB99kH4VN0zlg9W
        UDRKqL8w==;
Received: from [207.135.234.126] (helo=kernel.dk)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nAAZI-0024vt-MI
        for fio@vger.kernel.org; Wed, 19 Jan 2022 13:00:05 +0000
Received: by kernel.dk (Postfix, from userid 1000)
        id C16581BC0165; Wed, 19 Jan 2022 06:00:01 -0700 (MST)
Subject: Recent changes (master)
From:   Jens Axboe <axboe@kernel.dk>
To:     <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20220119130001.C16581BC0165@kernel.dk>
Date:   Wed, 19 Jan 2022 06:00:01 -0700 (MST)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The following changes since commit ef37053efdfb8c3b8b6deef43c0969753e6adb44:

  init: do not create lat logs when not needed (2022-01-17 07:21:58 -0700)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 71efbed61dfb157dfa7fe550f500b53f9731e1cb:

  docs: documentation for sg WRITE STREAM(16) (2022-01-18 06:37:39 -0700)

----------------------------------------------------------------
Niklas Cassel (2):
      stat: remove duplicated code in show_mixed_ddir_status()
      stat: move unified=both mixed allocation and calculation to new helper

Vincent Fu (6):
      sg: add support for VERIFY command using write modes
      sg: add support for WRITE SAME(16) commands with NDOB flag set
      sg: improve sg_write_mode option names
      sg: add support for WRITE STREAM(16) commands
      sg: allow fio to open and close streams for WRITE STREAM(16) commands
      docs: documentation for sg WRITE STREAM(16)

 HOWTO                           |  36 +++++-
 engines/sg.c                    | 181 +++++++++++++++++++++++++++++--
 examples/sg_verify-fail.fio     |  48 ++++++++
 examples/sg_verify.fio          |  57 ++++++++++
 examples/sg_write_same_ndob.fio |  44 ++++++++
 fio.1                           |  47 +++++++-
 stat.c                          | 235 ++++++++--------------------------------
 7 files changed, 441 insertions(+), 207 deletions(-)
 create mode 100644 examples/sg_verify-fail.fio
 create mode 100644 examples/sg_verify.fio
 create mode 100644 examples/sg_write_same_ndob.fio

---

Diff of recent changes:

diff --git a/HOWTO b/HOWTO
index 2956e50d..f9e7c857 100644
--- a/HOWTO
+++ b/HOWTO
@@ -2496,11 +2496,13 @@ with the caveat that when used on the command line, they must come after the
 
 	**write**
 		This is the default where write opcodes are issued as usual.
-	**verify**
+	**write_and_verify**
 		Issue WRITE AND VERIFY commands. The BYTCHK bit is set to 0. This
 		directs the device to carry out a medium verification with no data
 		comparison. The writefua option is ignored with this selection.
-	**same**
+	**verify**
+		This option is deprecated. Use write_and_verify instead.
+	**write_same**
 		Issue WRITE SAME commands. This transfers a single block to the device
 		and writes this same block of data to a contiguous sequence of LBAs
 		beginning at the specified offset. fio's block size parameter specifies
@@ -2511,6 +2513,36 @@ with the caveat that when used on the command line, they must come after the
 		for each command but only the first 512 bytes will be used and
 		transferred to the device. The writefua option is ignored with this
 		selection.
+	**same**
+		This option is deprecated. Use write_same instead.
+	**write_same_ndob**
+		Issue WRITE SAME(16) commands as above but with the No Data Output
+		Buffer (NDOB) bit set. No data will be transferred to the device with
+		this bit set. Data written will be a pre-determined pattern such as
+		all zeroes.
+	**write_stream**
+		Issue WRITE STREAM(16) commands. Use the **stream_id** option to specify
+		the stream identifier.
+	**verify_bytchk_00**
+		Issue VERIFY commands with BYTCHK set to 00. This directs the
+		device to carry out a medium verification with no data comparison.
+	**verify_bytchk_01**
+		Issue VERIFY commands with BYTCHK set to 01. This directs the device to
+		compare the data on the device with the data transferred to the device.
+	**verify_bytchk_11**
+		Issue VERIFY commands with BYTCHK set to 11. This transfers a
+		single block to the device and compares the contents of this block with the
+		data on the device beginning at the specified offset. fio's block size
+		parameter specifies the total amount of data compared with this command.
+		However, only one block (sector) worth of data is transferred to the device.
+		This is similar to the WRITE SAME command except that data is compared instead
+		of written.
+
+.. option:: stream_id=int : [sg]
+
+	Set the stream identifier for WRITE STREAM commands. If this is set to 0 (which is not
+	a valid stream identifier) fio will open a stream and then close it when done. Default
+	is 0.
 
 .. option:: hipri : [sg]
 
diff --git a/engines/sg.c b/engines/sg.c
index 1c019384..72ee07ba 100644
--- a/engines/sg.c
+++ b/engines/sg.c
@@ -66,8 +66,13 @@
 
 enum {
 	FIO_SG_WRITE		= 1,
-	FIO_SG_WRITE_VERIFY	= 2,
-	FIO_SG_WRITE_SAME	= 3
+	FIO_SG_WRITE_VERIFY,
+	FIO_SG_WRITE_SAME,
+	FIO_SG_WRITE_SAME_NDOB,
+	FIO_SG_WRITE_STREAM,
+	FIO_SG_VERIFY_BYTCHK_00,
+	FIO_SG_VERIFY_BYTCHK_01,
+	FIO_SG_VERIFY_BYTCHK_11,
 };
 
 struct sg_options {
@@ -76,6 +81,7 @@ struct sg_options {
 	unsigned int readfua;
 	unsigned int writefua;
 	unsigned int write_mode;
+	uint16_t stream_id;
 };
 
 static struct fio_option options[] = {
@@ -120,18 +126,58 @@ static struct fio_option options[] = {
 			    .oval = FIO_SG_WRITE,
 			    .help = "Issue standard SCSI WRITE commands",
 			  },
-			  { .ival = "verify",
+			  { .ival = "write_and_verify",
 			    .oval = FIO_SG_WRITE_VERIFY,
 			    .help = "Issue SCSI WRITE AND VERIFY commands",
 			  },
-			  { .ival = "same",
+			  { .ival = "verify",
+			    .oval = FIO_SG_WRITE_VERIFY,
+			    .help = "Issue SCSI WRITE AND VERIFY commands. This "
+				    "option is deprecated. Use write_and_verify instead.",
+			  },
+			  { .ival = "write_same",
 			    .oval = FIO_SG_WRITE_SAME,
 			    .help = "Issue SCSI WRITE SAME commands",
 			  },
+			  { .ival = "same",
+			    .oval = FIO_SG_WRITE_SAME,
+			    .help = "Issue SCSI WRITE SAME commands. This "
+				    "option is deprecated. Use write_same instead.",
+			  },
+			  { .ival = "write_same_ndob",
+			    .oval = FIO_SG_WRITE_SAME_NDOB,
+			    .help = "Issue SCSI WRITE SAME(16) commands with NDOB flag set",
+			  },
+			  { .ival = "verify_bytchk_00",
+			    .oval = FIO_SG_VERIFY_BYTCHK_00,
+			    .help = "Issue SCSI VERIFY commands with BYTCHK set to 00",
+			  },
+			  { .ival = "verify_bytchk_01",
+			    .oval = FIO_SG_VERIFY_BYTCHK_01,
+			    .help = "Issue SCSI VERIFY commands with BYTCHK set to 01",
+			  },
+			  { .ival = "verify_bytchk_11",
+			    .oval = FIO_SG_VERIFY_BYTCHK_11,
+			    .help = "Issue SCSI VERIFY commands with BYTCHK set to 11",
+			  },
+			  { .ival = "write_stream",
+			    .oval = FIO_SG_WRITE_STREAM,
+			    .help = "Issue SCSI WRITE STREAM(16) commands",
+			  },
 		},
 		.category = FIO_OPT_C_ENGINE,
 		.group	= FIO_OPT_G_SG,
 	},
+	{
+		.name	= "stream_id",
+		.lname	= "stream id for WRITE STREAM(16) commands",
+		.type	= FIO_OPT_INT,
+		.off1	= offsetof(struct sg_options, stream_id),
+		.help	= "Stream ID for WRITE STREAM(16) commands",
+		.def	= "0",
+		.category = FIO_OPT_C_ENGINE,
+		.group	= FIO_OPT_G_SG,
+	},
 	{
 		.name	= NULL,
 	},
@@ -171,6 +217,11 @@ struct sgio_data {
 #endif
 };
 
+static inline uint16_t sgio_get_be16(uint8_t *buf)
+{
+	return be16_to_cpu(*((uint16_t *) buf));
+}
+
 static inline uint32_t sgio_get_be32(uint8_t *buf)
 {
 	return be32_to_cpu(*((uint32_t *) buf));
@@ -502,9 +553,9 @@ static enum fio_q_status fio_sgio_doio(struct thread_data *td,
 }
 
 static void fio_sgio_rw_lba(struct sg_io_hdr *hdr, unsigned long long lba,
-			    unsigned long long nr_blocks)
+			    unsigned long long nr_blocks, bool override16)
 {
-	if (lba < MAX_10B_LBA) {
+	if (lba < MAX_10B_LBA && !override16) {
 		sgio_set_be32((uint32_t) lba, &hdr->cmdp[2]);
 		sgio_set_be16((uint16_t) nr_blocks, &hdr->cmdp[7]);
 	} else {
@@ -545,7 +596,7 @@ static int fio_sgio_prep(struct thread_data *td, struct io_u *io_u)
 		if (o->readfua)
 			hdr->cmdp[1] |= 0x08;
 
-		fio_sgio_rw_lba(hdr, lba, nr_blocks);
+		fio_sgio_rw_lba(hdr, lba, nr_blocks, false);
 
 	} else if (io_u->ddir == DDIR_WRITE) {
 		sgio_hdr_init(sd, hdr, io_u, 1);
@@ -576,9 +627,46 @@ static int fio_sgio_prep(struct thread_data *td, struct io_u *io_u)
 			else
 				hdr->cmdp[0] = 0x93; // write same(16)
 			break;
+		case FIO_SG_WRITE_SAME_NDOB:
+			hdr->cmdp[0] = 0x93; // write same(16)
+			hdr->cmdp[1] |= 0x1; // no data output buffer
+			hdr->dxfer_len = 0;
+			break;
+		case FIO_SG_WRITE_STREAM:
+			hdr->cmdp[0] = 0x9a; // write stream (16)
+			if (o->writefua)
+				hdr->cmdp[1] |= 0x08;
+			sgio_set_be64(lba, &hdr->cmdp[2]);
+			sgio_set_be16((uint16_t) io_u->file->engine_pos, &hdr->cmdp[10]);
+			sgio_set_be16((uint16_t) nr_blocks, &hdr->cmdp[12]);
+			break;
+		case FIO_SG_VERIFY_BYTCHK_00:
+			if (lba < MAX_10B_LBA)
+				hdr->cmdp[0] = 0x2f; // VERIFY(10)
+			else
+				hdr->cmdp[0] = 0x8f; // VERIFY(16)
+			hdr->dxfer_len = 0;
+			break;
+		case FIO_SG_VERIFY_BYTCHK_01:
+			if (lba < MAX_10B_LBA)
+				hdr->cmdp[0] = 0x2f; // VERIFY(10)
+			else
+				hdr->cmdp[0] = 0x8f; // VERIFY(16)
+			hdr->cmdp[1] |= 0x02;		// BYTCHK = 01b
+			break;
+		case FIO_SG_VERIFY_BYTCHK_11:
+			if (lba < MAX_10B_LBA)
+				hdr->cmdp[0] = 0x2f; // VERIFY(10)
+			else
+				hdr->cmdp[0] = 0x8f; // VERIFY(16)
+			hdr->cmdp[1] |= 0x06;		// BYTCHK = 11b
+			hdr->dxfer_len = sd->bs;
+			break;
 		};
 
-		fio_sgio_rw_lba(hdr, lba, nr_blocks);
+		if (o->write_mode != FIO_SG_WRITE_STREAM)
+			fio_sgio_rw_lba(hdr, lba, nr_blocks,
+				o->write_mode == FIO_SG_WRITE_SAME_NDOB);
 
 	} else if (io_u->ddir == DDIR_TRIM) {
 		struct sgio_trim *st;
@@ -970,9 +1058,60 @@ static int fio_sgio_type_check(struct thread_data *td, struct fio_file *f)
 	return 0;
 }
 
+static int fio_sgio_stream_control(struct fio_file *f, bool open_stream, uint16_t *stream_id)
+{
+	struct sg_io_hdr hdr;
+	unsigned char cmd[16];
+	unsigned char sb[64];
+	unsigned char buf[8];
+	int ret;
+
+	memset(&hdr, 0, sizeof(hdr));
+	memset(cmd, 0, sizeof(cmd));
+	memset(sb, 0, sizeof(sb));
+	memset(buf, 0, sizeof(buf));
+
+	hdr.interface_id = 'S';
+	hdr.cmdp = cmd;
+	hdr.cmd_len = 16;
+	hdr.sbp = sb;
+	hdr.mx_sb_len = sizeof(sb);
+	hdr.timeout = SCSI_TIMEOUT_MS;
+	hdr.cmdp[0] = 0x9e;
+	hdr.dxfer_direction = SG_DXFER_FROM_DEV;
+	hdr.dxferp = buf;
+	hdr.dxfer_len = sizeof(buf);
+	sgio_set_be32(sizeof(buf), &hdr.cmdp[10]);
+
+	if (open_stream)
+		hdr.cmdp[1] = 0x34;
+	else {
+		hdr.cmdp[1] = 0x54;
+		sgio_set_be16(*stream_id, &hdr.cmdp[4]);
+	}
+
+	ret = ioctl(f->fd, SG_IO, &hdr);
+
+	if (ret < 0)
+		return ret;
+
+	if (hdr.info & SG_INFO_CHECK)
+		return 1;
+
+	if (open_stream) {
+		*stream_id = sgio_get_be16(&buf[4]);
+		dprint(FD_FILE, "sgio_stream_control: opened stream %u\n", (unsigned int) *stream_id);
+		assert(*stream_id != 0);
+	} else
+		dprint(FD_FILE, "sgio_stream_control: closed stream %u\n", (unsigned int) *stream_id);
+
+	return 0;
+}
+
 static int fio_sgio_open(struct thread_data *td, struct fio_file *f)
 {
 	struct sgio_data *sd = td->io_ops_data;
+	struct sg_options *o = td->eo;
 	int ret;
 
 	ret = generic_open_file(td, f);
@@ -984,9 +1123,33 @@ static int fio_sgio_open(struct thread_data *td, struct fio_file *f)
 		return ret;
 	}
 
+	if (o->write_mode == FIO_SG_WRITE_STREAM) {
+		if (o->stream_id)
+			f->engine_pos = o->stream_id;
+		else {
+			ret = fio_sgio_stream_control(f, true, (uint16_t *) &f->engine_pos);
+			if (ret)
+				return ret;
+		}
+	}
+
 	return 0;
 }
 
+int fio_sgio_close(struct thread_data *td, struct fio_file *f)
+{
+	struct sg_options *o = td->eo;
+	int ret;
+
+	if (!o->stream_id && o->write_mode == FIO_SG_WRITE_STREAM) {
+		ret = fio_sgio_stream_control(f, false, (uint16_t *) &f->engine_pos);
+		if (ret)
+			return ret;
+	}
+
+	return generic_close_file(td, f);
+}
+
 /*
  * Build an error string with details about the driver, host or scsi
  * error contained in the sg header Caller will use as necessary.
@@ -1261,7 +1424,7 @@ static struct ioengine_ops ioengine = {
 	.event		= fio_sgio_event,
 	.cleanup	= fio_sgio_cleanup,
 	.open_file	= fio_sgio_open,
-	.close_file	= generic_close_file,
+	.close_file	= fio_sgio_close,
 	.get_file_size	= fio_sgio_get_file_size,
 	.flags		= FIO_SYNCIO | FIO_RAWIO,
 	.options	= options,
diff --git a/examples/sg_verify-fail.fio b/examples/sg_verify-fail.fio
new file mode 100644
index 00000000..64feece3
--- /dev/null
+++ b/examples/sg_verify-fail.fio
@@ -0,0 +1,48 @@
+#
+# **********************************
+# * !!THIS IS A DESTRUCTIVE TEST!! *
+# * IF NOT CHANGED THIS TEST WILL  *
+# * DESTROY DATA ON /dev/sdb       *
+# **********************************
+#
+# Test SCSI VERIFY commands issued via the sg ioengine
+# The jobs with fail in the name should produce errors
+#
+# job			description
+# precon		precondition the device by writing with a known
+#			pattern
+# verify01		verify each block one at a time by comparing to known
+#			pattern
+# verify01-fail		verifying one too many blocks should produce a failure
+# verify11-one_ios	verify all 20 blocks by sending only 512 bytes
+# verify11-fail		verifying beyond the preconditioned region should
+#			produce a failure
+
+[global]
+filename=/dev/sdb
+buffer_pattern=0x01
+ioengine=sg
+rw=write
+bs=512
+number_ios=20
+stonewall
+
+[precon]
+
+[verify01]
+sg_write_mode=verify_bytchk_01
+number_ios=20
+
+[verify01-fail]
+sg_write_mode=verify_bytchk_01
+number_ios=21
+
+[verify11-one_ios]
+sg_write_mode=verify_bytchk_11
+number_ios=1
+bs=10240
+
+[verify11-fail]
+sg_write_mode=verify_bytchk_11
+number_ios=1
+bs=10752
diff --git a/examples/sg_verify.fio b/examples/sg_verify.fio
new file mode 100644
index 00000000..6db0dd0a
--- /dev/null
+++ b/examples/sg_verify.fio
@@ -0,0 +1,57 @@
+#
+# **********************************
+# * !!THIS IS A DESTRUCTIVE TEST!! *
+# * IF NOT CHANGED THIS TEST WILL  *
+# * DESTROY DATA ON /dev/sdb       *
+# **********************************
+#
+# Test SCSI VERIFY commands issued via the sg ioengine
+# All of the jobs below should complete without error
+#
+# job			description
+# precon		precondition the device by writing with a known
+#			pattern
+# verify00		verify written data on medium only
+# verify01		verify each block one at a time by comparing to known
+#			pattern
+# verify01-two_ios	verify same data but with only two VERIFY operations
+# verify11		verify each block one at a time
+# verify11-five_ios	verify data with five IOs, four blocks at a time,
+#			sending 512 bytes for each IO
+# verify11-one_ios	verify all 20 blocks by sending only 512 bytes
+#
+
+[global]
+filename=/dev/sdb
+buffer_pattern=0x01
+ioengine=sg
+rw=write
+bs=512
+number_ios=20
+stonewall
+
+[precon]
+
+[verify00]
+sg_write_mode=verify_bytchk_00
+
+[verify01]
+sg_write_mode=verify_bytchk_01
+
+[verify01-two_ios]
+sg_write_mode=verify_bytchk_01
+bs=5120
+number_ios=2
+
+[verify11]
+sg_write_mode=verify_bytchk_11
+
+[verify11-five_ios]
+sg_write_mode=verify_bytchk_11
+bs=2048
+number_ios=5
+
+[verify11-one_ios]
+sg_write_mode=verify_bytchk_11
+bs=10240
+number_ios=1
diff --git a/examples/sg_write_same_ndob.fio b/examples/sg_write_same_ndob.fio
new file mode 100644
index 00000000..fb047319
--- /dev/null
+++ b/examples/sg_write_same_ndob.fio
@@ -0,0 +1,44 @@
+#
+# **********************************
+# * !!THIS IS A DESTRUCTIVE TEST!! *
+# * IF NOT CHANGED THIS TEST WILL  *
+# * DESTROY DATA ON /dev/sdb       *
+# **********************************
+#
+# Test WRITE SAME commands with the NDOB flag set
+# issued via the sg ioengine
+# All of the jobs below should complete without error
+# except the last one
+#
+# job			description
+# precon		Precondition the device by writing 20 blocks with a
+# 			known pattern
+# write_same_ndob	Write 19 sectors of all zeroes with the NDOB flag set
+# verify-pass		Verify 19 blocks of all zeroes
+# verify-fail		Verify 20 blocks of all zeroes. This should fail.
+#
+
+[global]
+filename=/dev/sdb
+buffer_pattern=0x01
+ioengine=sg
+rw=write
+bs=512
+stonewall
+
+[precon]
+number_ios=20
+
+[write_same_ndob]
+sg_write_mode=write_same_ndob
+number_ios=19
+
+[verify-pass]
+sg_write_mode=verify_bytchk_01
+buffer_pattern=0x00
+number_ios=19
+
+[verify-fail]
+sg_write_mode=verify_bytchk_01
+buffer_pattern=0x00
+number_ios=20
diff --git a/fio.1 b/fio.1
index e0458c22..34aa874d 100644
--- a/fio.1
+++ b/fio.1
@@ -2284,7 +2284,7 @@ With writefua option set to 1, write operations include the force
 unit access (fua) flag. Default: 0.
 .TP
 .BI (sg)sg_write_mode \fR=\fPstr
-Specify the type of write commands to issue. This option can take three
+Specify the type of write commands to issue. This option can take multiple
 values:
 .RS
 .RS
@@ -2292,12 +2292,15 @@ values:
 .B write (default)
 Write opcodes are issued as usual
 .TP
+.B write_and_verify
+Issue WRITE AND VERIFY commands. The BYTCHK bit is set to 00b. This directs the
+device to carry out a medium verification with no data comparison for the data
+that was written. The writefua option is ignored with this selection.
+.TP
 .B verify
-Issue WRITE AND VERIFY commands. The BYTCHK bit is set to 0. This
-directs the device to carry out a medium verification with no data
-comparison. The writefua option is ignored with this selection.
+This option is deprecated. Use write_and_verify instead.
 .TP
-.B same
+.B write_same
 Issue WRITE SAME commands. This transfers a single block to the device
 and writes this same block of data to a contiguous sequence of LBAs
 beginning at the specified offset. fio's block size parameter
@@ -2308,9 +2311,43 @@ blocksize=8k will write 16 sectors with each command. fio will still
 generate 8k of data for each command butonly the first 512 bytes will
 be used and transferred to the device. The writefua option is ignored
 with this selection.
+.TP
+.B same
+This option is deprecated. Use write_same instead.
+.TP
+.B write_same_ndob
+Issue WRITE SAME(16) commands as above but with the No Data Output
+Buffer (NDOB) bit set. No data will be transferred to the device with
+this bit set. Data written will be a pre-determined pattern such as
+all zeroes.
+.TP
+.B write_stream
+Issue WRITE STREAM(16) commands. Use the stream_id option to specify
+the stream identifier.
+.TP
+.B verify_bytchk_00
+Issue VERIFY commands with BYTCHK set to 00. This directs the device to carry
+out a medium verification with no data comparison.
+.TP
+.B verify_bytchk_01
+Issue VERIFY commands with BYTCHK set to 01. This directs the device to
+compare the data on the device with the data transferred to the device.
+.TP
+.B verify_bytchk_11
+Issue VERIFY commands with BYTCHK set to 11. This transfers a single block to
+the device and compares the contents of this block with the data on the device
+beginning at the specified offset. fio's block size parameter specifies the
+total amount of data compared with this command. However, only one block
+(sector) worth of data is transferred to the device. This is similar to the
+WRITE SAME command except that data is compared instead of written.
 .RE
 .RE
 .TP
+.BI (sg)stream_id \fR=\fPint
+Set the stream identifier for WRITE STREAM commands. If this is set to 0 (which is not
+a valid stream identifier) fio will open a stream and then close it when done. Default
+is 0.
+.TP
 .BI (nbd)uri \fR=\fPstr
 Specify the NBD URI of the server to test.
 The string is a standard NBD URI (see
diff --git a/stat.c b/stat.c
index 36742a25..b08d2f25 100644
--- a/stat.c
+++ b/stat.c
@@ -462,173 +462,45 @@ static void display_lat(const char *name, unsigned long long min,
 	free(maxp);
 }
 
-static double convert_agg_kbytes_percent(struct group_run_stats *rs, int ddir, int mean)
+static struct thread_stat *gen_mixed_ddir_stats_from_ts(struct thread_stat *ts)
 {
-	double p_of_agg = 100.0;
-	if (rs && rs->agg[ddir] > 1024) {
-		p_of_agg = mean * 100.0 / (double) (rs->agg[ddir] / 1024.0);
-
-		if (p_of_agg > 100.0)
-			p_of_agg = 100.0;
-	}
-	return p_of_agg;
-}
-
-static void show_mixed_ddir_status(struct group_run_stats *rs,
-				   struct thread_stat *ts,
-				   struct buf_output *out)
-{
-	unsigned long runt;
-	unsigned long long min, max, bw, iops;
-	double mean, dev;
-	char *io_p, *bw_p, *bw_p_alt, *iops_p, *post_st = NULL;
 	struct thread_stat *ts_lcl;
-	int i2p;
-	int ddir = 0;
 
 	/*
 	 * Handle aggregation of Reads (ddir = 0), Writes (ddir = 1), and
-	 * Trims (ddir = 2) */
+	 * Trims (ddir = 2)
+	 */
 	ts_lcl = malloc(sizeof(struct thread_stat));
-	memset((void *)ts_lcl, 0, sizeof(struct thread_stat));
-	/* calculate mixed stats  */
-	ts_lcl->unified_rw_rep = UNIFIED_MIXED;
-	init_thread_stat_min_vals(ts_lcl);
-
-	sum_thread_stats(ts_lcl, ts);
-
-	assert(ddir_rw(ddir));
-
-	if (!ts_lcl->runtime[ddir]) {
-		free(ts_lcl);
-		return;
-	}
-
-	i2p = is_power_of_2(rs->kb_base);
-	runt = ts_lcl->runtime[ddir];
-
-	bw = (1000 * ts_lcl->io_bytes[ddir]) / runt;
-	io_p = num2str(ts_lcl->io_bytes[ddir], ts->sig_figs, 1, i2p, N2S_BYTE);
-	bw_p = num2str(bw, ts->sig_figs, 1, i2p, ts->unit_base);
-	bw_p_alt = num2str(bw, ts->sig_figs, 1, !i2p, ts->unit_base);
-
-	iops = (1000 * ts_lcl->total_io_u[ddir]) / runt;
-	iops_p = num2str(iops, ts->sig_figs, 1, 0, N2S_NONE);
-
-	log_buf(out, "  mixed: IOPS=%s, BW=%s (%s)(%s/%llumsec)%s\n",
-			iops_p, bw_p, bw_p_alt, io_p,
-			(unsigned long long) ts_lcl->runtime[ddir],
-			post_st ? : "");
-
-	free(post_st);
-	free(io_p);
-	free(bw_p);
-	free(bw_p_alt);
-	free(iops_p);
-
-	if (calc_lat(&ts_lcl->slat_stat[ddir], &min, &max, &mean, &dev))
-		display_lat("slat", min, max, mean, dev, out);
-	if (calc_lat(&ts_lcl->clat_stat[ddir], &min, &max, &mean, &dev))
-		display_lat("clat", min, max, mean, dev, out);
-	if (calc_lat(&ts_lcl->lat_stat[ddir], &min, &max, &mean, &dev))
-		display_lat(" lat", min, max, mean, dev, out);
-	if (calc_lat(&ts_lcl->clat_high_prio_stat[ddir], &min, &max, &mean, &dev)) {
-		display_lat(ts_lcl->lat_percentiles ? "high prio_lat" : "high prio_clat",
-				min, max, mean, dev, out);
-		if (calc_lat(&ts_lcl->clat_low_prio_stat[ddir], &min, &max, &mean, &dev))
-			display_lat(ts_lcl->lat_percentiles ? "low prio_lat" : "low prio_clat",
-					min, max, mean, dev, out);
-	}
-
-	if (ts->slat_percentiles && ts_lcl->slat_stat[ddir].samples > 0)
-		show_clat_percentiles(ts_lcl->io_u_plat[FIO_SLAT][ddir],
-				ts_lcl->slat_stat[ddir].samples,
-				ts->percentile_list,
-				ts->percentile_precision, "slat", out);
-	if (ts->clat_percentiles && ts_lcl->clat_stat[ddir].samples > 0)
-		show_clat_percentiles(ts_lcl->io_u_plat[FIO_CLAT][ddir],
-				ts_lcl->clat_stat[ddir].samples,
-				ts->percentile_list,
-				ts->percentile_precision, "clat", out);
-	if (ts->lat_percentiles && ts_lcl->lat_stat[ddir].samples > 0)
-		show_clat_percentiles(ts_lcl->io_u_plat[FIO_LAT][ddir],
-				ts_lcl->lat_stat[ddir].samples,
-				ts->percentile_list,
-				ts->percentile_precision, "lat", out);
-
-	if (ts->clat_percentiles || ts->lat_percentiles) {
-		const char *name = ts->lat_percentiles ? "lat" : "clat";
-		char prio_name[32];
-		uint64_t samples;
-
-		if (ts->lat_percentiles)
-			samples = ts_lcl->lat_stat[ddir].samples;
-		else
-			samples = ts_lcl->clat_stat[ddir].samples;
-
-		/* Only print if high and low priority stats were collected */
-		if (ts_lcl->clat_high_prio_stat[ddir].samples > 0 &&
-				ts_lcl->clat_low_prio_stat[ddir].samples > 0) {
-			sprintf(prio_name, "high prio (%.2f%%) %s",
-					100. * (double) ts_lcl->clat_high_prio_stat[ddir].samples / (double) samples,
-					name);
-			show_clat_percentiles(ts_lcl->io_u_plat_high_prio[ddir],
-					ts_lcl->clat_high_prio_stat[ddir].samples,
-					ts->percentile_list,
-					ts->percentile_precision, prio_name, out);
-
-			sprintf(prio_name, "low prio (%.2f%%) %s",
-					100. * (double) ts_lcl->clat_low_prio_stat[ddir].samples / (double) samples,
-					name);
-			show_clat_percentiles(ts_lcl->io_u_plat_low_prio[ddir],
-					ts_lcl->clat_low_prio_stat[ddir].samples,
-					ts->percentile_list,
-					ts->percentile_precision, prio_name, out);
-		}
+	if (!ts_lcl) {
+		log_err("fio: failed to allocate local thread stat\n");
+		return NULL;
 	}
 
-	if (calc_lat(&ts_lcl->bw_stat[ddir], &min, &max, &mean, &dev)) {
-		double p_of_agg = 100.0, fkb_base = (double)rs->kb_base;
-		const char *bw_str;
+	init_thread_stat(ts_lcl);
 
-		if ((rs->unit_base == 1) && i2p)
-			bw_str = "Kibit";
-		else if (rs->unit_base == 1)
-			bw_str = "kbit";
-		else if (i2p)
-			bw_str = "KiB";
-		else
-			bw_str = "kB";
+	/* calculate mixed stats  */
+	ts_lcl->unified_rw_rep = UNIFIED_MIXED;
+	ts_lcl->lat_percentiles = ts->lat_percentiles;
+	ts_lcl->clat_percentiles = ts->clat_percentiles;
+	ts_lcl->slat_percentiles = ts->slat_percentiles;
+	ts_lcl->percentile_precision = ts->percentile_precision;
+	memcpy(ts_lcl->percentile_list, ts->percentile_list, sizeof(ts->percentile_list));
 
-		p_of_agg = convert_agg_kbytes_percent(rs, ddir, mean);
+	sum_thread_stats(ts_lcl, ts);
 
-		if (rs->unit_base == 1) {
-			min *= 8.0;
-			max *= 8.0;
-			mean *= 8.0;
-			dev *= 8.0;
-		}
+	return ts_lcl;
+}
 
-		if (mean > fkb_base * fkb_base) {
-			min /= fkb_base;
-			max /= fkb_base;
-			mean /= fkb_base;
-			dev /= fkb_base;
-			bw_str = (rs->unit_base == 1 ? "Mibit" : "MiB");
-		}
+static double convert_agg_kbytes_percent(struct group_run_stats *rs, int ddir, int mean)
+{
+	double p_of_agg = 100.0;
+	if (rs && rs->agg[ddir] > 1024) {
+		p_of_agg = mean * 100.0 / (double) (rs->agg[ddir] / 1024.0);
 
-		log_buf(out, "   bw (%5s/s): min=%5llu, max=%5llu, per=%3.2f%%, "
-			"avg=%5.02f, stdev=%5.02f, samples=%" PRIu64 "\n",
-			bw_str, min, max, p_of_agg, mean, dev,
-			(&ts_lcl->bw_stat[ddir])->samples);
-	}
-	if (calc_lat(&ts_lcl->iops_stat[ddir], &min, &max, &mean, &dev)) {
-		log_buf(out, "   iops        : min=%5llu, max=%5llu, "
-			"avg=%5.02f, stdev=%5.02f, samples=%" PRIu64 "\n",
-			min, max, mean, dev, (&ts_lcl->iops_stat[ddir])->samples);
+		if (p_of_agg > 100.0)
+			p_of_agg = 100.0;
 	}
-
-	free(ts_lcl);
+	return p_of_agg;
 }
 
 static void show_ddir_status(struct group_run_stats *rs, struct thread_stat *ts,
@@ -797,6 +669,18 @@ static void show_ddir_status(struct group_run_stats *rs, struct thread_stat *ts,
 	}
 }
 
+static void show_mixed_ddir_status(struct group_run_stats *rs,
+				   struct thread_stat *ts,
+				   struct buf_output *out)
+{
+	struct thread_stat *ts_lcl = gen_mixed_ddir_stats_from_ts(ts);
+
+	if (ts_lcl)
+		show_ddir_status(rs, ts_lcl, DDIR_READ, out);
+
+	free(ts_lcl);
+}
+
 static bool show_lat(double *io_u_lat, int nr, const char **ranges,
 		     const char *msg, struct buf_output *out)
 {
@@ -1462,27 +1346,11 @@ static void show_mixed_ddir_status_terse(struct thread_stat *ts,
 				   struct group_run_stats *rs,
 				   int ver, struct buf_output *out)
 {
-	struct thread_stat *ts_lcl;
+	struct thread_stat *ts_lcl = gen_mixed_ddir_stats_from_ts(ts);
 
-	/*
-	 * Handle aggregation of Reads (ddir = 0), Writes (ddir = 1), and
-	 * Trims (ddir = 2)
-	 */
-	ts_lcl = malloc(sizeof(struct thread_stat));
-	memset((void *)ts_lcl, 0, sizeof(struct thread_stat));
-	/* calculate mixed stats  */
-	ts_lcl->unified_rw_rep = UNIFIED_MIXED;
-	init_thread_stat_min_vals(ts_lcl);
-	ts_lcl->lat_percentiles = ts->lat_percentiles;
-	ts_lcl->clat_percentiles = ts->clat_percentiles;
-	ts_lcl->slat_percentiles = ts->slat_percentiles;
-	ts_lcl->percentile_precision = ts->percentile_precision;
-	memcpy(ts_lcl->percentile_list, ts->percentile_list, sizeof(ts->percentile_list));
-	
-	sum_thread_stats(ts_lcl, ts);
+	if (ts_lcl)
+		show_ddir_status_terse(ts_lcl, rs, DDIR_READ, ver, out);
 
-	/* add the aggregated stats to json parent */
-	show_ddir_status_terse(ts_lcl, rs, DDIR_READ, ver, out);
 	free(ts_lcl);
 }
 
@@ -1660,27 +1528,12 @@ static void add_ddir_status_json(struct thread_stat *ts,
 static void add_mixed_ddir_status_json(struct thread_stat *ts,
 		struct group_run_stats *rs, struct json_object *parent)
 {
-	struct thread_stat *ts_lcl;
-
-	/*
-	 * Handle aggregation of Reads (ddir = 0), Writes (ddir = 1), and
-	 * Trims (ddir = 2)
-	 */
-	ts_lcl = malloc(sizeof(struct thread_stat));
-	memset((void *)ts_lcl, 0, sizeof(struct thread_stat));
-	/* calculate mixed stats  */
-	ts_lcl->unified_rw_rep = UNIFIED_MIXED;
-	init_thread_stat_min_vals(ts_lcl);
-	ts_lcl->lat_percentiles = ts->lat_percentiles;
-	ts_lcl->clat_percentiles = ts->clat_percentiles;
-	ts_lcl->slat_percentiles = ts->slat_percentiles;
-	ts_lcl->percentile_precision = ts->percentile_precision;
-	memcpy(ts_lcl->percentile_list, ts->percentile_list, sizeof(ts->percentile_list));
-
-	sum_thread_stats(ts_lcl, ts);
+	struct thread_stat *ts_lcl = gen_mixed_ddir_stats_from_ts(ts);
 
 	/* add the aggregated stats to json parent */
-	add_ddir_status_json(ts_lcl, rs, DDIR_READ, parent);
+	if (ts_lcl)
+		add_ddir_status_json(ts_lcl, rs, DDIR_READ, parent);
+
 	free(ts_lcl);
 }
 
