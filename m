Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:48320 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752153AbeESMAD (ORCPT <rfc822;fio@vger.kernel.org>);
        Sat, 19 May 2018 08:00:03 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1fK0Wo-0004Hf-Od
        for fio@vger.kernel.org; Sat, 19 May 2018 12:00:02 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20180519120001.C6A422C00AC@kernel.dk>
Date: Sat, 19 May 2018 06:00:01 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 5eac3b00238b450ac0679121a76f1e566ca8f468:

  make fio scripts python3-ready (2018-05-16 11:17:55 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 12223a35ac7d975d7c2950c664d8caf7f9c065bf:

  Merge branch 'sg-verify2' of https://github.com/vincentkfu/fio (2018-05-18 13:34:36 -0600)

----------------------------------------------------------------
Jens Axboe (1):
      Merge branch 'sg-verify2' of https://github.com/vincentkfu/fio

Vincent Fu (2):
      engines/sg: add support for WRITE AND VERIFY, WRITE SAME
      docs: add documentation for sg ioengine WRITE SAME, WRITE AND VERIFY command support

 HOWTO        | 20 ++++++++++++++++++++
 engines/sg.c | 62 ++++++++++++++++++++++++++++++++++++++++++++++++++++--------
 fio.1        | 27 ++++++++++++++++++++++++++
 3 files changed, 101 insertions(+), 8 deletions(-)

---

Diff of recent changes:

diff --git a/HOWTO b/HOWTO
index d200700..7680f9c 100644
--- a/HOWTO
+++ b/HOWTO
@@ -2079,6 +2079,26 @@ with the caveat that when used on the command line, they must come after the
 	With writefua option set to 1, write operations include
 	the force unit access (fua) flag. Default is 0.
 
+.. option:: sg_write_mode=str : [sg]
+	Specify the type of write commands to issue. This option can take three values:
+
+	**write**
+		This is the default where write opcodes are issued as usual.
+	**verify**
+		Issue WRITE AND VERIFY commands. The BYTCHK bit is set to 0. This
+		directs the device to carry out a medium verification with no data
+		comparison. The writefua option is ignored with this selection.
+	**same**
+		Issue WRITE SAME commands. This transfers a single block to the device
+		and writes this same block of data to a contiguous sequence of LBAs
+		beginning at the specified offset. fio's block size parameter specifies
+		the amount of data written with each command. However, the amount of data
+		actually transferred to the device is equal to the device's block
+		(sector) size. For a device with 512 byte sectors, blocksize=8k will
+		write 16 sectors with each command. fio will still generate 8k of data
+		for each command but only the first 512 bytes will be used and
+		transferred to the device. The writefua option is ignored with this
+		selection.
 
 I/O depth
 ~~~~~~~~~
diff --git a/engines/sg.c b/engines/sg.c
index d4848bc..06cd194 100644
--- a/engines/sg.c
+++ b/engines/sg.c
@@ -15,11 +15,17 @@
 
 #ifdef FIO_HAVE_SGIO
 
+enum {
+	FIO_SG_WRITE		= 1,
+	FIO_SG_WRITE_VERIFY	= 2,
+	FIO_SG_WRITE_SAME	= 3
+};
 
 struct sg_options {
 	void *pad;
 	unsigned int readfua;
 	unsigned int writefua;
+	unsigned int write_mode;
 };
 
 static struct fio_option options[] = {
@@ -44,6 +50,30 @@ static struct fio_option options[] = {
 		.group	= FIO_OPT_G_SG,
 	},
 	{
+		.name	= "sg_write_mode",
+		.lname	= "specify sg write mode",
+		.type	= FIO_OPT_STR,
+		.off1	= offsetof(struct sg_options, write_mode),
+		.help	= "Specify SCSI WRITE mode",
+		.def	= "write",
+		.posval = {
+			  { .ival = "write",
+			    .oval = FIO_SG_WRITE,
+			    .help = "Issue standard SCSI WRITE commands",
+			  },
+			  { .ival = "verify",
+			    .oval = FIO_SG_WRITE_VERIFY,
+			    .help = "Issue SCSI WRITE AND VERIFY commands",
+			  },
+			  { .ival = "same",
+			    .oval = FIO_SG_WRITE_SAME,
+			    .help = "Issue SCSI WRITE SAME commands",
+			  },
+		},
+		.category = FIO_OPT_C_ENGINE,
+		.group	= FIO_OPT_G_SG,
+	},
+	{
 		.name	= NULL,
 	},
 };
@@ -329,14 +359,30 @@ static int fio_sgio_prep(struct thread_data *td, struct io_u *io_u)
 		sgio_hdr_init(sd, hdr, io_u, 1);
 
 		hdr->dxfer_direction = SG_DXFER_TO_DEV;
-		if (lba < MAX_10B_LBA)
-			hdr->cmdp[0] = 0x2a; // write(10)
-		else
-			hdr->cmdp[0] = 0x8a; // write(16)
-
-		if (o->writefua)
-			hdr->cmdp[1] |= 0x08;
-
+		switch(o->write_mode) {
+		case FIO_SG_WRITE:
+			if (lba < MAX_10B_LBA)
+				hdr->cmdp[0] = 0x2a; // write(10)
+			else
+				hdr->cmdp[0] = 0x8a; // write(16)
+			if (o->writefua)
+				hdr->cmdp[1] |= 0x08;
+			break;
+		case FIO_SG_WRITE_VERIFY:
+			if (lba < MAX_10B_LBA)
+				hdr->cmdp[0] = 0x2e; // write and verify(10)
+			else
+				hdr->cmdp[0] = 0x8e; // write and verify(16)
+			break;
+			// BYTCHK is disabled by virtue of the memset in sgio_hdr_init
+		case FIO_SG_WRITE_SAME:
+			hdr->dxfer_len = sd->bs;
+			if (lba < MAX_10B_LBA)
+				hdr->cmdp[0] = 0x41; // write same(10)
+			else
+				hdr->cmdp[0] = 0x93; // write same(16)
+			break;
+		};
 	} else {
 		sgio_hdr_init(sd, hdr, io_u, 0);
 		hdr->dxfer_direction = SG_DXFER_NONE;
diff --git a/fio.1 b/fio.1
index 7d5d8be..ce3585a 100644
--- a/fio.1
+++ b/fio.1
@@ -1828,6 +1828,33 @@ unit access (fua) flag. Default: 0.
 .BI (sg)writefua \fR=\fPbool
 With writefua option set to 1, write operations include the force
 unit access (fua) flag. Default: 0.
+.TP
+.BI (sg)sg_write_mode \fR=\fPstr
+Specify the type of write commands to issue. This option can take three
+values:
+.RS
+.RS
+.TP
+.B write (default)
+Write opcodes are issued as usual
+.TP
+.B verify
+Issue WRITE AND VERIFY commands. The BYTCHK bit is set to 0. This
+directs the device to carry out a medium verification with no data
+comparison. The writefua option is ignored with this selection.
+.TP
+.B same
+Issue WRITE SAME commands. This transfers a single block to the device
+and writes this same block of data to a contiguous sequence of LBAs
+beginning at the specified offset. fio's block size parameter
+specifies the amount of data written with each command. However, the
+amount of data actually transferred to the device is equal to the
+device's block (sector) size. For a device with 512 byte sectors,
+blocksize=8k will write 16 sectors with each command. fio will still
+generate 8k of data for each command butonly the first 512 bytes will
+be used and transferred to the device. The writefua option is ignored
+with this selection.
+
 .SS "I/O depth"
 .TP
 .BI iodepth \fR=\fPint
