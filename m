Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67C3FC54EBD
	for <fio@archiver.kernel.org>; Thu, 12 Jan 2023 13:02:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232545AbjALNC6 (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 12 Jan 2023 08:02:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232554AbjALNC3 (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 12 Jan 2023 08:02:29 -0500
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 382F654734
        for <fio@vger.kernel.org>; Thu, 12 Jan 2023 05:00:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Date:Message-Id:To:From:Subject:Sender
        :Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=8qTJO21XNzvnsxyNwJjaGZYQGaS5folhzhSCcergHfc=; b=L94DfCpoJoBsauR/Rw33KK2y7R
        16xjl98BftDF4d2YCR6cTAVwKdPD/jQpGJLhKExDk0pQLKK9WyLGPbzWGXdgJD6GBUen7UK/ylkon
        4UcCEU5tpGr4A7oDZQ/Gx7IPwc76NV31JBvTrs4ScZA3/zyb7PVKok2OBYXnPtLANf9+Nr28dB5zz
        ByGXgGRPODAlTE3UCyrQxSGl3sW33U/qMfykIY1KD5idciafUR7gsM/igOT2bHJyiIqNrf85eLPuv
        Yo4mcYDa7MUW/sFNeFpn5y7wqZ9rOFiM4yg/5TutlyPZFXAr/Ee/RHzluTk4kAXWLJkSH+XmV1D+M
        nSXU6+KQ==;
Received: from [207.135.234.126] (helo=kernel.dk)
        by desiato.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1pFxBV-003zoI-2W
        for fio@vger.kernel.org;
        Thu, 12 Jan 2023 12:59:58 +0000
Received: by kernel.dk (Postfix, from userid 1000)
        id 573791BC016B; Thu, 12 Jan 2023 06:00:02 -0700 (MST)
Subject: Recent changes (master)
From:   Jens Axboe <axboe@kernel.dk>
To:     <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20230112130002.573791BC016B@kernel.dk>
Date:   Thu, 12 Jan 2023 06:00:02 -0700 (MST)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The following changes since commit c945074c0336fb1720acead38e578d4dd7f29921:

  engines/xnvme: add support for picking mem backend (2022-12-22 08:50:03 -0500)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 44834c57f944074684c1b58604cc44199cf5e633:

  examples: add missing fiograph diagram for sg_write_same_ndob.fio (2023-01-11 15:22:40 -0500)

----------------------------------------------------------------
Ankit Kumar (1):
      doc: clarify the usage of rw_sequencer

Vincent Fu (1):
      examples: add missing fiograph diagram for sg_write_same_ndob.fio

 HOWTO.rst                       |  35 ++++++++++++++++++++++++------
 examples/sg_write_same_ndob.png | Bin 0 -> 97793 bytes
 fio.1                           |  47 +++++++++++++++++++++++++++++++++++-----
 3 files changed, 69 insertions(+), 13 deletions(-)
 create mode 100644 examples/sg_write_same_ndob.png

---

Diff of recent changes:

diff --git a/HOWTO.rst b/HOWTO.rst
index 0a48a453..17caaf5d 100644
--- a/HOWTO.rst
+++ b/HOWTO.rst
@@ -1176,13 +1176,34 @@ I/O type
 			Generate the same offset.
 
 	``sequential`` is only useful for random I/O, where fio would normally
-	generate a new random offset for every I/O. If you append e.g. 8 to randread,
-	you would get a new random offset for every 8 I/Os. The result would be a
-	seek for only every 8 I/Os, instead of for every I/O. Use ``rw=randread:8``
-	to specify that. As sequential I/O is already sequential, setting
-	``sequential`` for that would not result in any differences.  ``identical``
-	behaves in a similar fashion, except it sends the same offset 8 number of
-	times before generating a new offset.
+	generate a new random offset for every I/O. If you append e.g. 8 to
+	randread, i.e. ``rw=randread:8`` you would get a new random offset for
+	every 8 I/Os. The result would be a sequence of 8 sequential offsets
+	with a random starting point. However this behavior may change if a
+	sequential I/O reaches end of the file. As sequential I/O is already
+	sequential, setting ``sequential`` for that would not result in any
+	difference. ``identical`` behaves in a similar fashion, except it sends
+	the same offset 8 number of times before generating a new offset.
+
+	Example #1::
+
+		rw=randread:8
+		rw_sequencer=sequential
+		bs=4k
+
+	The generated sequence of offsets will look like this:
+	4k, 8k, 12k, 16k, 20k, 24k, 28k, 32k, 92k, 96k, 100k, 104k, 108k,
+	112k, 116k, 120k, 48k, 52k ...
+
+	Example #2::
+
+		rw=randread:8
+		rw_sequencer=identical
+		bs=4k
+
+	The generated sequence of offsets will look like this:
+	4k, 4k, 4k, 4k, 4k, 4k, 4k, 4k, 92k, 92k, 92k, 92k, 92k, 92k, 92k, 92k,
+	48k, 48k, 48k ...
 
 .. option:: unified_rw_reporting=str
 
diff --git a/examples/sg_write_same_ndob.png b/examples/sg_write_same_ndob.png
new file mode 100644
index 00000000..8b76fc6c
Binary files /dev/null and b/examples/sg_write_same_ndob.png differ
diff --git a/fio.1 b/fio.1
index eb87533f..527b3d46 100644
--- a/fio.1
+++ b/fio.1
@@ -952,12 +952,47 @@ Generate the same offset.
 .P
 \fBsequential\fR is only useful for random I/O, where fio would normally
 generate a new random offset for every I/O. If you append e.g. 8 to randread,
-you would get a new random offset for every 8 I/Os. The result would be a
-seek for only every 8 I/Os, instead of for every I/O. Use `rw=randread:8'
-to specify that. As sequential I/O is already sequential, setting
-\fBsequential\fR for that would not result in any differences. \fBidentical\fR
-behaves in a similar fashion, except it sends the same offset 8 number of
-times before generating a new offset.
+i.e. `rw=randread:8' you would get a new random offset for every 8 I/Os. The
+result would be a sequence of 8 sequential offsets with a random starting
+point.  However this behavior may change if a sequential I/O reaches end of the
+file. As sequential I/O is already sequential, setting \fBsequential\fR for
+that would not result in any difference. \fBidentical\fR behaves in a similar
+fashion, except it sends the same offset 8 number of times before generating a
+new offset.
+.P
+.P
+Example #1:
+.RS
+.P
+.PD 0
+rw=randread:8
+.P
+rw_sequencer=sequential
+.P
+bs=4k
+.PD
+.RE
+.P
+The generated sequence of offsets will look like this:
+4k, 8k, 12k, 16k, 20k, 24k, 28k, 32k, 92k, 96k, 100k, 104k, 108k, 112k, 116k,
+120k, 48k, 52k ...
+.P
+.P
+Example #2:
+.RS
+.P
+.PD 0
+rw=randread:8
+.P
+rw_sequencer=identical
+.P
+bs=4k
+.PD
+.RE
+.P
+The generated sequence of offsets will look like this:
+4k, 4k, 4k, 4k, 4k, 4k, 4k, 4k, 92k, 92k, 92k, 92k, 92k, 92k, 92k, 92k, 48k,
+48k, 48k ...
 .RE
 .TP
 .BI unified_rw_reporting \fR=\fPstr
