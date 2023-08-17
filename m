Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6EFBBC27C7A
	for <fio@archiver.kernel.org>; Thu, 17 Aug 2023 12:00:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350612AbjHQMAY (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 17 Aug 2023 08:00:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350578AbjHQMAN (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 17 Aug 2023 08:00:13 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E1302112
        for <fio@vger.kernel.org>; Thu, 17 Aug 2023 05:00:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Date:Message-Id:To:From:Subject:Sender:
        Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=6xasRojUy2koFrHZgfwyNJ4fBCXt8fYWAqstsk40trQ=; b=LD/S6AyK3mjCoOoQ4JicUUKjV0
        aFUii4oPuJsbDT/caqMyAaca9QpkUNcuvXAUWGP+zfxHOCTZQn4WfBC+Egk3Ef51Zg7FweOcF5xEo
        xQwux7a23Dsbo8g0nHBzQWtj7LjOHOE1R8xTHVL46TbB4W/A66VBpKfNMB6x7UnKGabAJbWf+GDHF
        nLJIdbiGS1HAVmPiwl9aWmWrS6ctG1ydr47NgvcQEhaHPncz1pAMaKMoWiiQfdJKn1bpZ/6Q0Ym5o
        /I3bp315OZILM2EnuJqvWsDGYx0XQ09f+UGaXw1g23wP8pIcnr+8OdsUujqyluUb+kRJaRjwM4+UL
        WnqIyQYQ==;
Received: from [96.43.243.2] (helo=kernel.dk)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1qWbfa-0036aC-Pa
        for fio@vger.kernel.org; Thu, 17 Aug 2023 12:00:07 +0000
Received: by kernel.dk (Postfix, from userid 1000)
        id 2C7AE1BC0183; Thu, 17 Aug 2023 06:00:02 -0600 (MDT)
Subject: Recent changes (master)
From:   Jens Axboe <axboe@kernel.dk>
To:     <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20230817120002.2C7AE1BC0183@kernel.dk>
Date:   Thu, 17 Aug 2023 06:00:02 -0600 (MDT)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The following changes since commit 6795954bde09c8697e0accb865b4f438d62c601f:

  engines/io_uring: fix leak of 'ld' in error path (2023-08-14 19:59:20 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to b311162c37a2867873e1222ce6b5f38c88be4d80:

  examples: add example and fiograph for protection information options (2023-08-16 09:34:46 -0400)

----------------------------------------------------------------
Ankit Kumar (1):
      examples: add example and fiograph for protection information options

 examples/uring-cmd-pi-ext.fio |  31 +++++++++++++++++++++++++++++++
 examples/uring-cmd-pi-ext.png | Bin 0 -> 81014 bytes
 examples/uring-cmd-pi-sb.fio  |  32 ++++++++++++++++++++++++++++++++
 examples/uring-cmd-pi-sb.png  | Bin 0 -> 87357 bytes
 tools/fiograph/fiograph.conf  |   2 +-
 5 files changed, 64 insertions(+), 1 deletion(-)
 create mode 100644 examples/uring-cmd-pi-ext.fio
 create mode 100644 examples/uring-cmd-pi-ext.png
 create mode 100644 examples/uring-cmd-pi-sb.fio
 create mode 100644 examples/uring-cmd-pi-sb.png

---

Diff of recent changes:

diff --git a/examples/uring-cmd-pi-ext.fio b/examples/uring-cmd-pi-ext.fio
new file mode 100644
index 00000000..e22ec062
--- /dev/null
+++ b/examples/uring-cmd-pi-ext.fio
@@ -0,0 +1,31 @@
+# Protection information test with io_uring_cmd I/O engine for nvme-ns generic
+# character device.
+#
+# This requires nvme device to be formatted with extended LBA data size and
+# protection information enabled. This can be done with nvme-cli utility.
+# Replace bs below with the correct extended LBA size.
+#
+# First we sequentially write to the device, without protection information
+# action being set. FIO will generate and send necessary protection
+# information data as per the protection information check option. Later on we
+# sequentially read and verify the device returned protection information data.
+#
+[global]
+filename=/dev/ng0n1
+ioengine=io_uring_cmd
+cmd_type=nvme
+size=1G
+iodepth=32
+bs=4160
+pi_act=0
+pi_chk=GUARD,APPTAG,REFTAG
+apptag=0x0888
+apptag_mask=0xFFFF
+thread=1
+stonewall=1
+
+[write]
+rw=write
+
+[read]
+rw=read
diff --git a/examples/uring-cmd-pi-ext.png b/examples/uring-cmd-pi-ext.png
new file mode 100644
index 00000000..a102fc1a
Binary files /dev/null and b/examples/uring-cmd-pi-ext.png differ
diff --git a/examples/uring-cmd-pi-sb.fio b/examples/uring-cmd-pi-sb.fio
new file mode 100644
index 00000000..b201a7ce
--- /dev/null
+++ b/examples/uring-cmd-pi-sb.fio
@@ -0,0 +1,32 @@
+# Protection information test with io_uring_cmd I/O engine for nvme-ns generic
+# character device.
+#
+# This requires nvme device to be formatted with separate metadata buffer and
+# protection information enabled. This can be done with nvme-cli utility.
+# Replace md_per_io_size as per the required metadata buffer size for each IO.
+#
+# First we sequentially write to the device, without protection information
+# action being set. FIO will generate and send necessary protection
+# information data as per the protection information check option. Later on we
+# sequentially read and verify the device returned protection information data.
+#
+[global]
+filename=/dev/ng0n1
+ioengine=io_uring_cmd
+cmd_type=nvme
+size=1G
+iodepth=32
+bs=4096
+md_per_io_size=64
+pi_act=0
+pi_chk=GUARD,APPTAG,REFTAG
+apptag=0x0888
+apptag_mask=0xFFFF
+thread=1
+stonewall=1
+
+[write]
+rw=write
+
+[read]
+rw=read
diff --git a/examples/uring-cmd-pi-sb.png b/examples/uring-cmd-pi-sb.png
new file mode 100644
index 00000000..dcdda8cd
Binary files /dev/null and b/examples/uring-cmd-pi-sb.png differ
diff --git a/tools/fiograph/fiograph.conf b/tools/fiograph/fiograph.conf
index 91c5fcfe..123c39ae 100644
--- a/tools/fiograph/fiograph.conf
+++ b/tools/fiograph/fiograph.conf
@@ -54,7 +54,7 @@ specific_options=ime_psync  ime_psyncv
 specific_options=hipri  cmdprio_percentage  cmdprio_class  cmdprio  cmdprio_bssplit  fixedbufs  registerfiles  sqthread_poll  sqthread_poll_cpu  nonvectored  uncached  nowait  force_async
 
 [ioengine_io_uring_cmd]
-specific_options=hipri  cmdprio_percentage  cmdprio_class  cmdprio  cmdprio_bssplit  fixedbufs  registerfiles  sqthread_poll  sqthread_poll_cpu  nonvectored  uncached  nowait  force_async  cmd_type
+specific_options=hipri  cmdprio_percentage  cmdprio_class  cmdprio  cmdprio_bssplit  fixedbufs  registerfiles  sqthread_poll  sqthread_poll_cpu  nonvectored  uncached  nowait  force_async  cmd_type  md_per_io_size  pi_act  pi_chk  apptag  apptag_mask
 
 [ioengine_libaio]
 specific_options=userspace_reap  cmdprio_percentage  cmdprio_class  cmdprio  cmdprio_bssplit  nowait
