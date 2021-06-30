Return-Path: <fio-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234301AbhF3MCi (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 30 Jun 2021 08:02:38 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC798C061756
        for <fio@vger.kernel.org>; Wed, 30 Jun 2021 05:00:09 -0700 (PDT)
Received: from [65.144.74.35] (helo=kernel.dk)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1lyYsw-00D9nd-7k
        for fio@vger.kernel.org; Wed, 30 Jun 2021 12:00:06 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20210630120002.9FCFD1BC0106@kernel.dk>
Date: Wed, 30 Jun 2021 06:00:02 -0600 (MDT)
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit d3dacdc61dfe878fda0c363084c4330492e38b2b:

  Merge branch 'pkg_config_1' of https://github.com/kusumi/fio (2021-06-20 10:44:49 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to ea51055cbb2fcbca3935e25c78e8b6d358ca2b3f:

  zbd: ensure that global max open zones limit is respected (2021-06-29 07:43:30 -0600)

----------------------------------------------------------------
Erwan Velu (2):
      tools: Adding fiograph
      examples: Avoid duplicated items

Jens Axboe (1):
      Merge branch 'evelu-fiog' of https://github.com/ErwanAliasr1/fio

Niklas Cassel (3):
      zbd: create a local zbdi variable for f->zbd_info
      zbd: allow an unlimited global max open zones limit
      zbd: ensure that global max open zones limit is respected

 examples/1mbs_clients.png               | Bin 0 -> 121336 bytes
 examples/aio-read.png                   | Bin 0 -> 76819 bytes
 examples/backwards-read.png             | Bin 0 -> 31100 bytes
 examples/basic-verify.png               | Bin 0 -> 35952 bytes
 examples/butterfly.png                  | Bin 0 -> 35393 bytes
 examples/cpp_null.png                   | Bin 0 -> 34346 bytes
 examples/cpuio.png                      | Bin 0 -> 52593 bytes
 examples/cross-stripe-verify.png        | Bin 0 -> 54366 bytes
 examples/dev-dax.png                    | Bin 0 -> 93539 bytes
 examples/dfs.png                        | Bin 0 -> 187461 bytes
 examples/disk-zone-profile.png          | Bin 0 -> 37313 bytes
 examples/e4defrag.png                   | Bin 0 -> 97107 bytes
 examples/e4defrag2.fio                  |   2 +-
 examples/e4defrag2.png                  | Bin 0 -> 222226 bytes
 examples/enospc-pressure.png            | Bin 0 -> 150373 bytes
 examples/exitwhat.png                   | Bin 0 -> 111627 bytes
 examples/falloc.png                     | Bin 0 -> 129273 bytes
 examples/filecreate-ioengine.png        | Bin 0 -> 59636 bytes
 examples/filedelete-ioengine.png        | Bin 0 -> 33042 bytes
 examples/filestat-ioengine.png          | Bin 0 -> 52330 bytes
 examples/fio-rand-RW.png                | Bin 0 -> 47406 bytes
 examples/fio-rand-read.png              | Bin 0 -> 36614 bytes
 examples/fio-rand-write.png             | Bin 0 -> 38608 bytes
 examples/fio-seq-RW.png                 | Bin 0 -> 48279 bytes
 examples/fio-seq-read.png               | Bin 0 -> 37851 bytes
 examples/fio-seq-write.png              | Bin 0 -> 42756 bytes
 examples/fixed-rate-submission.png      | Bin 0 -> 41703 bytes
 examples/flow.png                       | Bin 0 -> 63860 bytes
 examples/fsx.png                        | Bin 0 -> 37310 bytes
 examples/ftruncate.png                  | Bin 0 -> 56594 bytes
 examples/gfapi.png                      | Bin 0 -> 46875 bytes
 examples/gpudirect-rdmaio-client.png    | Bin 0 -> 50659 bytes
 examples/gpudirect-rdmaio-server.png    | Bin 0 -> 37805 bytes
 examples/http-s3.png                    | Bin 0 -> 108929 bytes
 examples/http-swift.png                 | Bin 0 -> 113698 bytes
 examples/http-webdav.png                | Bin 0 -> 86857 bytes
 examples/ime.png                        | Bin 0 -> 193722 bytes
 examples/iometer-file-access-server.png | Bin 0 -> 44797 bytes
 examples/jesd219.png                    | Bin 0 -> 64846 bytes
 examples/latency-profile.png            | Bin 0 -> 44487 bytes
 examples/libcufile-cufile.png           | Bin 0 -> 160611 bytes
 examples/libcufile-posix.png            | Bin 0 -> 164649 bytes
 examples/libhdfs.png                    | Bin 0 -> 32812 bytes
 examples/libiscsi.png                   | Bin 0 -> 31649 bytes
 examples/libpmem.png                    | Bin 0 -> 119668 bytes
 examples/librpma_apm-client.png         | Bin 0 -> 53792 bytes
 examples/librpma_apm-server.png         | Bin 0 -> 42611 bytes
 examples/librpma_gpspm-client.png       | Bin 0 -> 56398 bytes
 examples/librpma_gpspm-server.png       | Bin 0 -> 53793 bytes
 examples/libzbc-rand-write.png          | Bin 0 -> 48503 bytes
 examples/libzbc-seq-read.png            | Bin 0 -> 47229 bytes
 examples/mtd.fio                        |   4 +-
 examples/mtd.png                        | Bin 0 -> 79866 bytes
 examples/nbd.png                        | Bin 0 -> 88667 bytes
 examples/netio.png                      | Bin 0 -> 50944 bytes
 examples/netio_multicast.png            | Bin 0 -> 74921 bytes
 examples/nfs.png                        | Bin 0 -> 84808 bytes
 examples/null.png                       | Bin 0 -> 30223 bytes
 examples/numa.png                       | Bin 0 -> 66068 bytes
 examples/pmemblk.fio                    |   2 +-
 examples/pmemblk.png                    | Bin 0 -> 107529 bytes
 examples/poisson-rate-submission.png    | Bin 0 -> 41057 bytes
 examples/rados.png                      | Bin 0 -> 39665 bytes
 examples/rand-zones.png                 | Bin 0 -> 38297 bytes
 examples/rbd.png                        | Bin 0 -> 37191 bytes
 examples/rdmaio-client.png              | Bin 0 -> 44671 bytes
 examples/rdmaio-server.png              | Bin 0 -> 31860 bytes
 examples/ssd-steadystate.png            | Bin 0 -> 71772 bytes
 examples/ssd-test.png                   | Bin 0 -> 99835 bytes
 examples/steadystate.png                | Bin 0 -> 64580 bytes
 examples/surface-scan.png               | Bin 0 -> 72042 bytes
 examples/test.png                       | Bin 0 -> 30141 bytes
 examples/tiobench-example.png           | Bin 0 -> 71939 bytes
 examples/waitfor.png                    | Bin 0 -> 94577 bytes
 examples/zbd-rand-write.png             | Bin 0 -> 53018 bytes
 examples/zbd-seq-read.png               | Bin 0 -> 50185 bytes
 examples/zipf.png                       | Bin 0 -> 33276 bytes
 tools/fiograph/fiograph.conf            | 102 +++++++++++
 tools/fiograph/fiograph.py              | 305 ++++++++++++++++++++++++++++++++
 zbd.c                                   | 111 +++++++-----
 zbd.h                                   |   3 +-
 81 files changed, 484 insertions(+), 45 deletions(-)
 create mode 100644 examples/1mbs_clients.png
 create mode 100644 examples/aio-read.png
 create mode 100644 examples/backwards-read.png
 create mode 100644 examples/basic-verify.png
 create mode 100644 examples/butterfly.png
 create mode 100644 examples/cpp_null.png
 create mode 100644 examples/cpuio.png
 create mode 100644 examples/cross-stripe-verify.png
 create mode 100644 examples/dev-dax.png
 create mode 100644 examples/dfs.png
 create mode 100644 examples/disk-zone-profile.png
 create mode 100644 examples/e4defrag.png
 create mode 100644 examples/e4defrag2.png
 create mode 100644 examples/enospc-pressure.png
 create mode 100644 examples/exitwhat.png
 create mode 100644 examples/falloc.png
 create mode 100644 examples/filecreate-ioengine.png
 create mode 100644 examples/filedelete-ioengine.png
 create mode 100644 examples/filestat-ioengine.png
 create mode 100644 examples/fio-rand-RW.png
 create mode 100644 examples/fio-rand-read.png
 create mode 100644 examples/fio-rand-write.png
 create mode 100644 examples/fio-seq-RW.png
 create mode 100644 examples/fio-seq-read.png
 create mode 100644 examples/fio-seq-write.png
 create mode 100644 examples/fixed-rate-submission.png
 create mode 100644 examples/flow.png
 create mode 100644 examples/fsx.png
 create mode 100644 examples/ftruncate.png
 create mode 100644 examples/gfapi.png
 create mode 100644 examples/gpudirect-rdmaio-client.png
 create mode 100644 examples/gpudirect-rdmaio-server.png
 create mode 100644 examples/http-s3.png
 create mode 100644 examples/http-swift.png
 create mode 100644 examples/http-webdav.png
 create mode 100644 examples/ime.png
 create mode 100644 examples/iometer-file-access-server.png
 create mode 100644 examples/jesd219.png
 create mode 100644 examples/latency-profile.png
 create mode 100644 examples/libcufile-cufile.png
 create mode 100644 examples/libcufile-posix.png
 create mode 100644 examples/libhdfs.png
 create mode 100644 examples/libiscsi.png
 create mode 100644 examples/libpmem.png
 create mode 100644 examples/librpma_apm-client.png
 create mode 100644 examples/librpma_apm-server.png
 create mode 100644 examples/librpma_gpspm-client.png
 create mode 100644 examples/librpma_gpspm-server.png
 create mode 100644 examples/libzbc-rand-write.png
 create mode 100644 examples/libzbc-seq-read.png
 create mode 100644 examples/mtd.png
 create mode 100644 examples/nbd.png
 create mode 100644 examples/netio.png
 create mode 100644 examples/netio_multicast.png
 create mode 100644 examples/nfs.png
 create mode 100644 examples/null.png
 create mode 100644 examples/numa.png
 create mode 100644 examples/pmemblk.png
 create mode 100644 examples/poisson-rate-submission.png
 create mode 100644 examples/rados.png
 create mode 100644 examples/rand-zones.png
 create mode 100644 examples/rbd.png
 create mode 100644 examples/rdmaio-client.png
 create mode 100644 examples/rdmaio-server.png
 create mode 100644 examples/ssd-steadystate.png
 create mode 100644 examples/ssd-test.png
 create mode 100644 examples/steadystate.png
 create mode 100644 examples/surface-scan.png
 create mode 100644 examples/test.png
 create mode 100644 examples/tiobench-example.png
 create mode 100644 examples/waitfor.png
 create mode 100644 examples/zbd-rand-write.png
 create mode 100644 examples/zbd-seq-read.png
 create mode 100644 examples/zipf.png
 create mode 100644 tools/fiograph/fiograph.conf
 create mode 100755 tools/fiograph/fiograph.py

---

Diff of recent changes:

diff --git a/examples/1mbs_clients.png b/examples/1mbs_clients.png
new file mode 100644
index 00000000..3f972dc6
Binary files /dev/null and b/examples/1mbs_clients.png differ
diff --git a/examples/aio-read.png b/examples/aio-read.png
new file mode 100644
index 00000000..e0c020a5
Binary files /dev/null and b/examples/aio-read.png differ
diff --git a/examples/backwards-read.png b/examples/backwards-read.png
new file mode 100644
index 00000000..81dc9208
Binary files /dev/null and b/examples/backwards-read.png differ
diff --git a/examples/basic-verify.png b/examples/basic-verify.png
new file mode 100644
index 00000000..98f73020
Binary files /dev/null and b/examples/basic-verify.png differ
diff --git a/examples/butterfly.png b/examples/butterfly.png
new file mode 100644
index 00000000..2c566512
Binary files /dev/null and b/examples/butterfly.png differ
diff --git a/examples/cpp_null.png b/examples/cpp_null.png
new file mode 100644
index 00000000..5303ac2a
Binary files /dev/null and b/examples/cpp_null.png differ
diff --git a/examples/cpuio.png b/examples/cpuio.png
new file mode 100644
index 00000000..02938dbb
Binary files /dev/null and b/examples/cpuio.png differ
diff --git a/examples/cross-stripe-verify.png b/examples/cross-stripe-verify.png
new file mode 100644
index 00000000..90aa630f
Binary files /dev/null and b/examples/cross-stripe-verify.png differ
diff --git a/examples/dev-dax.png b/examples/dev-dax.png
new file mode 100644
index 00000000..2463bca3
Binary files /dev/null and b/examples/dev-dax.png differ
diff --git a/examples/dfs.png b/examples/dfs.png
new file mode 100644
index 00000000..049ccaec
Binary files /dev/null and b/examples/dfs.png differ
diff --git a/examples/disk-zone-profile.png b/examples/disk-zone-profile.png
new file mode 100644
index 00000000..5f7b24c9
Binary files /dev/null and b/examples/disk-zone-profile.png differ
diff --git a/examples/e4defrag.png b/examples/e4defrag.png
new file mode 100644
index 00000000..00a7fefd
Binary files /dev/null and b/examples/e4defrag.png differ
diff --git a/examples/e4defrag2.fio b/examples/e4defrag2.fio
index 2d4e1a87..86554ef7 100644
--- a/examples/e4defrag2.fio
+++ b/examples/e4defrag2.fio
@@ -48,7 +48,7 @@ donorname=file.def
 
 ########
 # Run random e4defrag and various aio workers in parallel
-[e4defrag-fuzzer-4k]
+[e4defrag-fuzzer-4k-bis]
 stonewall
 continue_on_error=all
 inplace=1
diff --git a/examples/e4defrag2.png b/examples/e4defrag2.png
new file mode 100644
index 00000000..8a128e95
Binary files /dev/null and b/examples/e4defrag2.png differ
diff --git a/examples/enospc-pressure.png b/examples/enospc-pressure.png
new file mode 100644
index 00000000..da28b7c0
Binary files /dev/null and b/examples/enospc-pressure.png differ
diff --git a/examples/exitwhat.png b/examples/exitwhat.png
new file mode 100644
index 00000000..9fc1883f
Binary files /dev/null and b/examples/exitwhat.png differ
diff --git a/examples/falloc.png b/examples/falloc.png
new file mode 100644
index 00000000..886be22e
Binary files /dev/null and b/examples/falloc.png differ
diff --git a/examples/filecreate-ioengine.png b/examples/filecreate-ioengine.png
new file mode 100644
index 00000000..45d11da3
Binary files /dev/null and b/examples/filecreate-ioengine.png differ
diff --git a/examples/filedelete-ioengine.png b/examples/filedelete-ioengine.png
new file mode 100644
index 00000000..3512ab71
Binary files /dev/null and b/examples/filedelete-ioengine.png differ
diff --git a/examples/filestat-ioengine.png b/examples/filestat-ioengine.png
new file mode 100644
index 00000000..bed59ab9
Binary files /dev/null and b/examples/filestat-ioengine.png differ
diff --git a/examples/fio-rand-RW.png b/examples/fio-rand-RW.png
new file mode 100644
index 00000000..aa4b0998
Binary files /dev/null and b/examples/fio-rand-RW.png differ
diff --git a/examples/fio-rand-read.png b/examples/fio-rand-read.png
new file mode 100644
index 00000000..d45664a4
Binary files /dev/null and b/examples/fio-rand-read.png differ
diff --git a/examples/fio-rand-write.png b/examples/fio-rand-write.png
new file mode 100644
index 00000000..10e068bc
Binary files /dev/null and b/examples/fio-rand-write.png differ
diff --git a/examples/fio-seq-RW.png b/examples/fio-seq-RW.png
new file mode 100644
index 00000000..a2be35ec
Binary files /dev/null and b/examples/fio-seq-RW.png differ
diff --git a/examples/fio-seq-read.png b/examples/fio-seq-read.png
new file mode 100644
index 00000000..cf8f2978
Binary files /dev/null and b/examples/fio-seq-read.png differ
diff --git a/examples/fio-seq-write.png b/examples/fio-seq-write.png
new file mode 100644
index 00000000..8db12092
Binary files /dev/null and b/examples/fio-seq-write.png differ
diff --git a/examples/fixed-rate-submission.png b/examples/fixed-rate-submission.png
new file mode 100644
index 00000000..86ca9b3e
Binary files /dev/null and b/examples/fixed-rate-submission.png differ
diff --git a/examples/flow.png b/examples/flow.png
new file mode 100644
index 00000000..26a3d34c
Binary files /dev/null and b/examples/flow.png differ
diff --git a/examples/fsx.png b/examples/fsx.png
new file mode 100644
index 00000000..b4e13c80
Binary files /dev/null and b/examples/fsx.png differ
diff --git a/examples/ftruncate.png b/examples/ftruncate.png
new file mode 100644
index 00000000..b98895f6
Binary files /dev/null and b/examples/ftruncate.png differ
diff --git a/examples/gfapi.png b/examples/gfapi.png
new file mode 100644
index 00000000..acc6a6ae
Binary files /dev/null and b/examples/gfapi.png differ
diff --git a/examples/gpudirect-rdmaio-client.png b/examples/gpudirect-rdmaio-client.png
new file mode 100644
index 00000000..eac79858
Binary files /dev/null and b/examples/gpudirect-rdmaio-client.png differ
diff --git a/examples/gpudirect-rdmaio-server.png b/examples/gpudirect-rdmaio-server.png
new file mode 100644
index 00000000..e043d7c0
Binary files /dev/null and b/examples/gpudirect-rdmaio-server.png differ
diff --git a/examples/http-s3.png b/examples/http-s3.png
new file mode 100644
index 00000000..2021e85e
Binary files /dev/null and b/examples/http-s3.png differ
diff --git a/examples/http-swift.png b/examples/http-swift.png
new file mode 100644
index 00000000..9928fb16
Binary files /dev/null and b/examples/http-swift.png differ
diff --git a/examples/http-webdav.png b/examples/http-webdav.png
new file mode 100644
index 00000000..c37c3de5
Binary files /dev/null and b/examples/http-webdav.png differ
diff --git a/examples/ime.png b/examples/ime.png
new file mode 100644
index 00000000..f636f5e7
Binary files /dev/null and b/examples/ime.png differ
diff --git a/examples/iometer-file-access-server.png b/examples/iometer-file-access-server.png
new file mode 100644
index 00000000..e3124554
Binary files /dev/null and b/examples/iometer-file-access-server.png differ
diff --git a/examples/jesd219.png b/examples/jesd219.png
new file mode 100644
index 00000000..73b5a124
Binary files /dev/null and b/examples/jesd219.png differ
diff --git a/examples/latency-profile.png b/examples/latency-profile.png
new file mode 100644
index 00000000..50650df8
Binary files /dev/null and b/examples/latency-profile.png differ
diff --git a/examples/libcufile-cufile.png b/examples/libcufile-cufile.png
new file mode 100644
index 00000000..f3758e5d
Binary files /dev/null and b/examples/libcufile-cufile.png differ
diff --git a/examples/libcufile-posix.png b/examples/libcufile-posix.png
new file mode 100644
index 00000000..7818feb4
Binary files /dev/null and b/examples/libcufile-posix.png differ
diff --git a/examples/libhdfs.png b/examples/libhdfs.png
new file mode 100644
index 00000000..e774c911
Binary files /dev/null and b/examples/libhdfs.png differ
diff --git a/examples/libiscsi.png b/examples/libiscsi.png
new file mode 100644
index 00000000..d0006cc0
Binary files /dev/null and b/examples/libiscsi.png differ
diff --git a/examples/libpmem.png b/examples/libpmem.png
new file mode 100644
index 00000000..8a9a1432
Binary files /dev/null and b/examples/libpmem.png differ
diff --git a/examples/librpma_apm-client.png b/examples/librpma_apm-client.png
new file mode 100644
index 00000000..2fe02cdf
Binary files /dev/null and b/examples/librpma_apm-client.png differ
diff --git a/examples/librpma_apm-server.png b/examples/librpma_apm-server.png
new file mode 100644
index 00000000..f78ae02e
Binary files /dev/null and b/examples/librpma_apm-server.png differ
diff --git a/examples/librpma_gpspm-client.png b/examples/librpma_gpspm-client.png
new file mode 100644
index 00000000..0c975a27
Binary files /dev/null and b/examples/librpma_gpspm-client.png differ
diff --git a/examples/librpma_gpspm-server.png b/examples/librpma_gpspm-server.png
new file mode 100644
index 00000000..56124533
Binary files /dev/null and b/examples/librpma_gpspm-server.png differ
diff --git a/examples/libzbc-rand-write.png b/examples/libzbc-rand-write.png
new file mode 100644
index 00000000..1d277412
Binary files /dev/null and b/examples/libzbc-rand-write.png differ
diff --git a/examples/libzbc-seq-read.png b/examples/libzbc-seq-read.png
new file mode 100644
index 00000000..5a532228
Binary files /dev/null and b/examples/libzbc-seq-read.png differ
diff --git a/examples/mtd.fio b/examples/mtd.fio
index e5dcea4c..0a7f2bae 100644
--- a/examples/mtd.fio
+++ b/examples/mtd.fio
@@ -6,7 +6,7 @@ ignore_error=,EIO
 blocksize=512,512,16384
 skip_bad=1
 
-[write]
+[trim]
 stonewall
 rw=trim
 
@@ -14,7 +14,7 @@ rw=trim
 stonewall
 rw=write
 
-[write]
+[trimwrite]
 stonewall
 block_error_percentiles=1
 rw=trimwrite
diff --git a/examples/mtd.png b/examples/mtd.png
new file mode 100644
index 00000000..8cb3692e
Binary files /dev/null and b/examples/mtd.png differ
diff --git a/examples/nbd.png b/examples/nbd.png
new file mode 100644
index 00000000..e3bcf610
Binary files /dev/null and b/examples/nbd.png differ
diff --git a/examples/netio.png b/examples/netio.png
new file mode 100644
index 00000000..81afd41d
Binary files /dev/null and b/examples/netio.png differ
diff --git a/examples/netio_multicast.png b/examples/netio_multicast.png
new file mode 100644
index 00000000..f07ab4b7
Binary files /dev/null and b/examples/netio_multicast.png differ
diff --git a/examples/nfs.png b/examples/nfs.png
new file mode 100644
index 00000000..29dbca0d
Binary files /dev/null and b/examples/nfs.png differ
diff --git a/examples/null.png b/examples/null.png
new file mode 100644
index 00000000..052671db
Binary files /dev/null and b/examples/null.png differ
diff --git a/examples/numa.png b/examples/numa.png
new file mode 100644
index 00000000..1ef45759
Binary files /dev/null and b/examples/numa.png differ
diff --git a/examples/pmemblk.fio b/examples/pmemblk.fio
index f8131741..59bb2a8a 100644
--- a/examples/pmemblk.fio
+++ b/examples/pmemblk.fio
@@ -55,7 +55,7 @@ unlink=0
 # size, this is not required.
 #
 filename=/pmem0/fio-test,4096,1024
-filename=/pmem1/fio-test,4096,1024
+#filename=/pmem1/fio-test,4096,1024
 
 [pmemblk-write]
 rw=randwrite
diff --git a/examples/pmemblk.png b/examples/pmemblk.png
new file mode 100644
index 00000000..250e254b
Binary files /dev/null and b/examples/pmemblk.png differ
diff --git a/examples/poisson-rate-submission.png b/examples/poisson-rate-submission.png
new file mode 100644
index 00000000..739c2560
Binary files /dev/null and b/examples/poisson-rate-submission.png differ
diff --git a/examples/rados.png b/examples/rados.png
new file mode 100644
index 00000000..91bd61a0
Binary files /dev/null and b/examples/rados.png differ
diff --git a/examples/rand-zones.png b/examples/rand-zones.png
new file mode 100644
index 00000000..13cbfb47
Binary files /dev/null and b/examples/rand-zones.png differ
diff --git a/examples/rbd.png b/examples/rbd.png
new file mode 100644
index 00000000..f1186139
Binary files /dev/null and b/examples/rbd.png differ
diff --git a/examples/rdmaio-client.png b/examples/rdmaio-client.png
new file mode 100644
index 00000000..4e4bc289
Binary files /dev/null and b/examples/rdmaio-client.png differ
diff --git a/examples/rdmaio-server.png b/examples/rdmaio-server.png
new file mode 100644
index 00000000..fc344725
Binary files /dev/null and b/examples/rdmaio-server.png differ
diff --git a/examples/ssd-steadystate.png b/examples/ssd-steadystate.png
new file mode 100644
index 00000000..eb27f8a4
Binary files /dev/null and b/examples/ssd-steadystate.png differ
diff --git a/examples/ssd-test.png b/examples/ssd-test.png
new file mode 100644
index 00000000..a92ed153
Binary files /dev/null and b/examples/ssd-test.png differ
diff --git a/examples/steadystate.png b/examples/steadystate.png
new file mode 100644
index 00000000..4bb90484
Binary files /dev/null and b/examples/steadystate.png differ
diff --git a/examples/surface-scan.png b/examples/surface-scan.png
new file mode 100644
index 00000000..00573808
Binary files /dev/null and b/examples/surface-scan.png differ
diff --git a/examples/test.png b/examples/test.png
new file mode 100644
index 00000000..6be50029
Binary files /dev/null and b/examples/test.png differ
diff --git a/examples/tiobench-example.png b/examples/tiobench-example.png
new file mode 100644
index 00000000..14410326
Binary files /dev/null and b/examples/tiobench-example.png differ
diff --git a/examples/waitfor.png b/examples/waitfor.png
new file mode 100644
index 00000000..64e4bf94
Binary files /dev/null and b/examples/waitfor.png differ
diff --git a/examples/zbd-rand-write.png b/examples/zbd-rand-write.png
new file mode 100644
index 00000000..d58721be
Binary files /dev/null and b/examples/zbd-rand-write.png differ
diff --git a/examples/zbd-seq-read.png b/examples/zbd-seq-read.png
new file mode 100644
index 00000000..b81a08c4
Binary files /dev/null and b/examples/zbd-seq-read.png differ
diff --git a/examples/zipf.png b/examples/zipf.png
new file mode 100644
index 00000000..cb2a9816
Binary files /dev/null and b/examples/zipf.png differ
diff --git a/tools/fiograph/fiograph.conf b/tools/fiograph/fiograph.conf
new file mode 100644
index 00000000..7b851e19
--- /dev/null
+++ b/tools/fiograph/fiograph.conf
@@ -0,0 +1,102 @@
+[fio_jobs]
+header=<<B><font color="{}"> {} </font></B> >
+header_color=black
+text_color=darkgreen
+shape=box
+shape_color=blue
+style=rounded
+title_style=<<table border='0' cellborder='0' cellspacing='1'> <tr> <td align='center'> <b> {} </b> </td> </tr>
+item_style=<tr> <td align = "left"> <font color="{}" > {} </font> </td> </tr>
+cluster_style=filled
+cluster_color=gainsboro
+
+[exec_prerun]
+text_color=red
+
+[exec_postrun]
+text_color=red
+
+[numjobs]
+text_color=red
+style=<font color="{}" > x {} </font>
+
+[ioengine]
+text_color=darkblue
+specific_options_color=darkblue
+
+# definitions of engine's specific options
+
+[ioengine_cpuio]
+specific_options=cpuload cpumode cpuchunks exit_on_io_done
+
+[ioengine_dfs]
+specific_options=pool  cont  chunk_size  object_class  svcl
+
+[ioengine_e4defrag]
+specific_options=donorname  inplace
+
+[ioengine_filestat]
+specific_options=stat_type
+
+[ioengine_single-instance]
+specific_options=volume  brick
+
+[ioengine_http]
+specific_options=https  http_host  http_user  http_pass  http_s3_key  http_s3_keyid  http_swift_auth_token  http_s3_region  http_mode  http_verbose
+
+[ioengine_ime_aio]
+specific_options=ime_psync  ime_psyncv
+
+[ioengine_io_uring]
+specific_options=hipri  cmdprio_percentage  cmdprio_percentage  fixedbufs  registerfiles  sqthread_poll  sqthread_poll_cpu  nonvectored  uncached  nowait  force_async
+
+[ioengine_libaio]
+specific_options=userspace_reap  cmdprio_percentage  cmdprio_percentage  nowait
+
+[ioengine_libcufile]
+specific_options=gpu_dev_ids  cuda_io
+
+[ioengine_libhdfs]
+specific_options=namenode  hostname  port  hdfsdirectory  chunk_size  single_instance  hdfs_use_direct
+
+[ioengine_libiscsi]
+specific_options=initiator
+
+[ioengine_librpma_apm_server]
+specific_options=librpma_apm_client
+
+[ioengine_busy_wait_polling]
+specific_options=serverip  port  direct_write_to_pmem
+
+[ioengine_librpma_gpspm_server]
+specific_options=librpma_gpspm_client
+
+[ioengine_mmap]
+specific_options=thp
+
+[ioengine_mtd]
+specific_options=skip_bad
+
+[ioengine_nbd]
+specific_options=uri
+
+[ioengine_net]
+specific_options=hostname  port  protocol  nodelay  listen  pingpong  interface  ttl  window_size  mss  netsplice
+
+[ioengine_nfs]
+specific_options=nfs_url
+
+[ioengine_rados]
+specific_options=clustername  pool  clientname  busy_poll  touch_objects
+
+[ioengine_rbd]
+specific_options=clustername  rbdname  pool  clientname  busy_poll
+
+[ioengine_rdma]
+specific_options=hostname  bindname  port  verb
+
+[ioengine_sg]
+specific_options=hipri  readfua  writefua  sg_write_mode  sg
+
+[ioengine_pvsync2]
+specific_options=hipri  hipri_percentage  uncached  nowait  sync  psync  vsync  pvsync
diff --git a/tools/fiograph/fiograph.py b/tools/fiograph/fiograph.py
new file mode 100755
index 00000000..7695c964
--- /dev/null
+++ b/tools/fiograph/fiograph.py
@@ -0,0 +1,305 @@
+#!/usr/bin/env python3
+from graphviz import Digraph
+import argparse
+import configparser
+import os
+
+config_file = None
+fio_file = None
+
+
+def get_section_option(section_name, option_name, default=None):
+    global fio_file
+    if fio_file.has_option(section_name, option_name):
+        return fio_file[section_name][option_name]
+    return default
+
+
+def get_config_option(section_name, option_name, default=None):
+    global config_file
+    if config_file.has_option(section_name, option_name):
+        return config_file[section_name][option_name]
+    return default
+
+
+def get_header_color(keyword='fio_jobs', default_color='black'):
+    return get_config_option(keyword, 'header_color', default_color)
+
+
+def get_shape_color(keyword='fio_jobs', default_color='black'):
+    return get_config_option(keyword, 'shape_color', default_color)
+
+
+def get_text_color(keyword='fio_jobs', default_color='black'):
+    return get_config_option(keyword, 'text_color', default_color)
+
+
+def get_cluster_color(keyword='fio_jobs', default_color='gray92'):
+    return get_config_option(keyword, 'cluster_color', default_color)
+
+
+def get_header(keyword='fio_jobs'):
+    return get_config_option(keyword, 'header')
+
+
+def get_shape(keyword='fio_jobs'):
+    return get_config_option(keyword, 'shape', 'box')
+
+
+def get_style(keyword='fio_jobs'):
+    return get_config_option(keyword, 'style', 'rounded')
+
+
+def get_cluster_style(keyword='fio_jobs'):
+    return get_config_option(keyword, 'cluster_style', 'filled')
+
+
+def get_specific_options(engine):
+    if not engine:
+        return ''
+    return get_config_option('ioengine_{}'.format(engine), 'specific_options', '').split(' ')
+
+
+def render_option(section, label, display, option, color_override=None):
+    # These options are already shown with graphical helpers, no need to report them directly
+    skip_list = ['size', 'stonewall', 'runtime', 'time_based',
+                 'numjobs', 'wait_for', 'wait_for_previous']
+    # If the option doesn't exist or if a special handling is already done
+    # don't render it, just return the current state
+    if option in skip_list or option not in section:
+        return label, display
+    display = option
+    if section[option]:
+        display = '{} = {}'.format(display, section[option])
+
+    # Adding jobs's options into the box, darkgreen is the default color
+    if color_override:
+        color = color_override
+    else:
+        color = get_text_color(option, get_text_color('fio_jobs', 'darkgreen'))
+    label += get_config_option('fio_jobs',
+                               'item_style').format(color, display)
+    return label, display
+
+
+def render_options(fio_file, section_name):
+    """Render all options of a section."""
+    display = section_name
+    section = fio_file[section_name]
+
+    # Add a multiplier to the section_name if numjobs is set
+    numjobs = int(get_section_option(section_name, 'numjobs', '1'))
+    if numjobs > 1:
+        display = display + \
+            get_style('numjobs').format(
+                get_text_color('numjobs'), numjobs)
+
+    # Header of the box
+    label = get_config_option('fio_jobs', 'title_style').format(display)
+
+    # Let's parse all the options of the current fio thread
+    # Some needs to be printed on top or bottom of the job to ease the read
+    to_early_print = ['exec_prerun', 'ioengine']
+    to_late_print = ['exec_postrun']
+
+    # Let's print the options on top of the box
+    for early_print in to_early_print:
+        label, display = render_option(
+            section, label, display, early_print)
+
+    current_io_engine = get_section_option(
+        section_name, 'ioengine', None)
+    if current_io_engine:
+        # Let's print all specifics options for this engine
+        for specific_option in sorted(get_specific_options(current_io_engine)):
+            label, display = render_option(
+                section, label, display, specific_option, get_config_option('ioengine', 'specific_options_color'))
+
+    # Let's print generic options sorted by name
+    for option in sorted(section):
+        if option in to_early_print or option in to_late_print or option in get_specific_options(current_io_engine):
+            continue
+        label, display = render_option(section, label, display, option)
+
+    # let's print options on the bottom of the box
+    for late_print in to_late_print:
+        label, display = render_option(
+            section, label, display, late_print)
+
+    # End of the box content
+    label += '</table>>'
+    return label
+
+
+def render_section(current_graph, fio_file, section_name, label):
+    """Render the section."""
+    attr = None
+    section = fio_file[section_name]
+
+    # Let's render the box associated to a job
+    current_graph.node(section_name, label,
+                       shape=get_shape(),
+                       color=get_shape_color(),
+                       style=get_style())
+
+    # Let's report the duration of the jobs with a self-loop arrow
+    if 'runtime' in section and 'time_based' in section:
+        attr = 'runtime={}'.format(section['runtime'])
+    elif 'size' in section:
+        attr = 'size={}'.format(section['size'])
+    if attr:
+        current_graph.edge(section_name, section_name, attr)
+
+
+def create_sub_graph(name):
+    """Return a new graph."""
+    # We need to put 'cluster' in the name to ensure graphviz consider it as a cluster
+    cluster_name = 'cluster_' + name
+    # Unset the main graph labels to avoid a recopy in each subgraph
+    attr = {}
+    attr['label'] = ''
+    new_graph = Digraph(name=cluster_name, graph_attr=attr)
+    new_graph.attr(style=get_cluster_style(),
+                   color=get_cluster_color())
+    return new_graph
+
+
+def create_legend():
+    """Return a legend."""
+    html_table = "<<table border='0' cellborder='1' cellspacing='0' cellpadding='4'>"
+    html_table += '<tr><td COLSPAN="2"><b>Legend</b></td></tr>'
+    legend_item = '<tr> <td>{}</td> <td><font color="{}">{}</font></td></tr>"'
+    legend_bgcolor_item = '<tr><td>{}</td><td BGCOLOR="{}"></td></tr>'
+    html_table += legend_item.format('numjobs',
+                                     get_text_color('numjobs'), 'x numjobs')
+    html_table += legend_item.format('generic option',
+                                     get_text_color(), 'generic option')
+    html_table += legend_item.format('ioengine option',
+                                     get_text_color('ioengine'), 'ioengine option')
+    html_table += legend_bgcolor_item.format('job', get_shape_color())
+    html_table += legend_bgcolor_item.format(
+        'execution group', get_cluster_color())
+    html_table += '</table>>'
+    legend = Digraph('html_table')
+    legend.node('legend', shape='none', label=html_table)
+    return legend
+
+
+def fio_to_graphviz(filename, format):
+    """Compute the graphviz graph from the fio file."""
+
+    # Let's read the fio file
+    global fio_file
+    fio_file = configparser.RawConfigParser(
+        allow_no_value=True,
+        default_section="global",
+        inline_comment_prefixes="'#', ';'")
+    fio_file.read(filename)
+
+    # Prepare the main graph object
+    # Let's define the header of the document
+    attrs = {}
+    attrs['labelloc'] = 't'
+    attrs['label'] = get_header().format(
+        get_header_color(), os.path.basename(filename))
+    main_graph = Digraph(engine='dot', graph_attr=attrs, format=format)
+
+    # Let's add a legend
+    main_graph.subgraph(create_legend())
+
+    # By default all jobs are run in parallel and depends on "global"
+    depends_on = fio_file.default_section
+
+    # The previous section is by default the global section
+    previous_section = fio_file.default_section
+
+    current_graph = main_graph
+
+    # The first job will be a new execution group
+    new_execution_group = True
+
+    # Let's interate on all sections to create links between them
+    for section_name in fio_file.sections():
+        # The current section
+        section = fio_file[section_name]
+
+        # If the current section is waiting the previous job
+        if ('stonewall' or 'wait_for_previous') in section:
+            # let's remember what was the previous job we depend on
+            depends_on = previous_section
+            new_execution_group = True
+        elif 'wait_for' in section:
+            # This sections depends on a named section pointed by wait_for
+            depends_on = section['wait_for']
+            new_execution_group = True
+
+        if new_execution_group:
+            # Let's link the current graph with the main one
+            main_graph.subgraph(current_graph)
+            # Let's create a new graph to represent all the incoming jobs running at the same time
+            current_graph = create_sub_graph(section_name)
+
+        # Let's render the current section in its execution group
+        render_section(current_graph, fio_file, section_name,
+                       render_options(fio_file, section_name))
+
+        # Let's trace the link between this job and the one it depends on
+        # If we depend on 'global', we can avoid doing adding an arrow as we don't want to see 'global'
+        if depends_on != fio_file.default_section:
+            current_graph.edge(depends_on, section_name)
+
+        # The current section become the parent of the next one
+        previous_section = section_name
+
+        # We are by default in the same execution group
+        new_execution_group = False
+
+    # The last subgraph isn't rendered yet
+    main_graph.subgraph(current_graph)
+
+    # Let's return the main graphviz object
+    return main_graph
+
+
+def setup_commandline():
+    "Prepare the command line."
+    parser = argparse.ArgumentParser()
+    parser.add_argument('--file', action='store',
+                        type=str,
+                        required=True,
+                        help='the fio file to graph')
+    parser.add_argument('--output', action='store',
+                        type=str,
+                        help='the output filename')
+    parser.add_argument('--format', action='store',
+                        type=str,
+                        default='png',
+                        help='the output format')
+    parser.add_argument('--view', action='store_true',
+                        default=False,
+                        help='view the graph')
+    parser.add_argument('--keep', action='store_true',
+                        default=False,
+                        help='keep the graphviz script file')
+    parser.add_argument('--config', action='store',
+                        type=str,
+                        default='fiograph.conf',
+                        help='the configuration filename')
+    args = parser.parse_args()
+    return args
+
+
+def main():
+    global config_file
+    args = setup_commandline()
+    output_file = args.file
+    if args.output is None:
+        output_file = output_file.replace('.fio', '')
+    config_file = configparser.RawConfigParser(allow_no_value=True)
+    config_file.read(args.config)
+    fio_to_graphviz(args.file, args.format).render(output_file, view=args.view)
+    if not args.keep:
+        os.remove(output_file)
+
+
+main()
diff --git a/zbd.c b/zbd.c
index 8e99eb95..04c68dea 100644
--- a/zbd.c
+++ b/zbd.c
@@ -636,8 +636,12 @@ static int zbd_set_max_open_zones(struct thread_data *td, struct fio_file *f)
 
 out:
 	/* Ensure that the limit is not larger than FIO's internal limit */
-	zbd->max_open_zones = min_not_zero(zbd->max_open_zones,
-					   (uint32_t) ZBD_MAX_OPEN_ZONES);
+	if (zbd->max_open_zones > ZBD_MAX_OPEN_ZONES) {
+		td_verror(td, EINVAL, "'max_open_zones' value is too large");
+		log_err("'max_open_zones' value is larger than %u\n", ZBD_MAX_OPEN_ZONES);
+		return -EINVAL;
+	}
+
 	dprint(FD_ZBD, "%s: using max open zones limit: %"PRIu32"\n",
 	       f->file_name, zbd->max_open_zones);
 
@@ -827,11 +831,25 @@ int zbd_setup_files(struct thread_data *td)
 			log_err("Different 'max_open_zones' values\n");
 			return 1;
 		}
-		if (zbd->max_open_zones > ZBD_MAX_OPEN_ZONES) {
-			log_err("'max_open_zones' value is limited by %u\n", ZBD_MAX_OPEN_ZONES);
+
+		/*
+		 * The per job max open zones limit cannot be used without a
+		 * global max open zones limit. (As the tracking of open zones
+		 * is disabled when there is no global max open zones limit.)
+		 */
+		if (td->o.job_max_open_zones && !zbd->max_open_zones) {
+			log_err("'job_max_open_zones' cannot be used without a global open zones limit\n");
 			return 1;
 		}
 
+		/*
+		 * zbd->max_open_zones is the global limit shared for all jobs
+		 * that target the same zoned block device. Force sync the per
+		 * thread global limit with the actual global limit. (The real
+		 * per thread/job limit is stored in td->o.job_max_open_zones).
+		 */
+		td->o.max_open_zones = zbd->max_open_zones;
+
 		for (zi = f->min_zone; zi < f->max_zone; zi++) {
 			z = &zbd->zone_info[zi];
 			if (z->cond != ZBD_ZONE_COND_IMP_OPEN &&
@@ -1093,6 +1111,8 @@ static bool is_zone_open(const struct thread_data *td, const struct fio_file *f,
 	struct zoned_block_device_info *zbdi = f->zbd_info;
 	int i;
 
+	/* This function should never be called when zbdi->max_open_zones == 0 */
+	assert(zbdi->max_open_zones);
 	assert(td->o.job_max_open_zones == 0 || td->num_open_zones <= td->o.job_max_open_zones);
 	assert(td->o.job_max_open_zones <= zbdi->max_open_zones);
 	assert(zbdi->num_open_zones <= zbdi->max_open_zones);
@@ -1114,6 +1134,7 @@ static bool zbd_open_zone(struct thread_data *td, const struct fio_file *f,
 			  uint32_t zone_idx)
 {
 	const uint32_t min_bs = td->o.min_bs[DDIR_WRITE];
+	struct zoned_block_device_info *zbdi = f->zbd_info;
 	struct fio_zone_info *z = get_zone(f, zone_idx);
 	bool res = true;
 
@@ -1127,7 +1148,15 @@ static bool zbd_open_zone(struct thread_data *td, const struct fio_file *f,
 	if (td->o.verify != VERIFY_NONE && zbd_zone_full(f, z, min_bs))
 		return false;
 
-	pthread_mutex_lock(&f->zbd_info->mutex);
+	/*
+	 * zbdi->max_open_zones == 0 means that there is no limit on the maximum
+	 * number of open zones. In this case, do no track open zones in
+	 * zbdi->open_zones array.
+	 */
+	if (!zbdi->max_open_zones)
+		return true;
+
+	pthread_mutex_lock(&zbdi->mutex);
 	if (is_zone_open(td, f, zone_idx)) {
 		/*
 		 * If the zone is already open and going to be full by writes
@@ -1142,16 +1171,16 @@ static bool zbd_open_zone(struct thread_data *td, const struct fio_file *f,
 	if (td->o.job_max_open_zones > 0 &&
 	    td->num_open_zones >= td->o.job_max_open_zones)
 		goto out;
-	if (f->zbd_info->num_open_zones >= f->zbd_info->max_open_zones)
+	if (zbdi->num_open_zones >= zbdi->max_open_zones)
 		goto out;
 	dprint(FD_ZBD, "%s: opening zone %d\n", f->file_name, zone_idx);
-	f->zbd_info->open_zones[f->zbd_info->num_open_zones++] = zone_idx;
+	zbdi->open_zones[zbdi->num_open_zones++] = zone_idx;
 	td->num_open_zones++;
 	z->open = 1;
 	res = true;
 
 out:
-	pthread_mutex_unlock(&f->zbd_info->mutex);
+	pthread_mutex_unlock(&zbdi->mutex);
 	return res;
 }
 
@@ -1175,6 +1204,7 @@ static struct fio_zone_info *zbd_convert_to_open_zone(struct thread_data *td,
 {
 	const uint32_t min_bs = td->o.min_bs[io_u->ddir];
 	struct fio_file *f = io_u->file;
+	struct zoned_block_device_info *zbdi = f->zbd_info;
 	struct fio_zone_info *z;
 	unsigned int open_zone_idx = -1;
 	uint32_t zone_idx, new_zone_idx;
@@ -1183,12 +1213,12 @@ static struct fio_zone_info *zbd_convert_to_open_zone(struct thread_data *td,
 
 	assert(is_valid_offset(f, io_u->offset));
 
-	if (td->o.max_open_zones || td->o.job_max_open_zones) {
+	if (zbdi->max_open_zones || td->o.job_max_open_zones) {
 		/*
-		 * This statement accesses f->zbd_info->open_zones[] on purpose
+		 * This statement accesses zbdi->open_zones[] on purpose
 		 * without locking.
 		 */
-		zone_idx = f->zbd_info->open_zones[pick_random_zone_idx(f, io_u)];
+		zone_idx = zbdi->open_zones[pick_random_zone_idx(f, io_u)];
 	} else {
 		zone_idx = zbd_zone_idx(f, io_u->offset);
 	}
@@ -1200,9 +1230,9 @@ static struct fio_zone_info *zbd_convert_to_open_zone(struct thread_data *td,
 	       __func__, f->file_name, zone_idx, io_u->offset, io_u->buflen);
 
 	/*
-	 * Since z->mutex is the outer lock and f->zbd_info->mutex the inner
+	 * Since z->mutex is the outer lock and zbdi->mutex the inner
 	 * lock it can happen that the state of the zone with index zone_idx
-	 * has changed after 'z' has been assigned and before f->zbd_info->mutex
+	 * has changed after 'z' has been assigned and before zbdi->mutex
 	 * has been obtained. Hence the loop.
 	 */
 	for (;;) {
@@ -1211,12 +1241,12 @@ static struct fio_zone_info *zbd_convert_to_open_zone(struct thread_data *td,
 		z = get_zone(f, zone_idx);
 		if (z->has_wp)
 			zone_lock(td, f, z);
-		pthread_mutex_lock(&f->zbd_info->mutex);
+		pthread_mutex_lock(&zbdi->mutex);
 		if (z->has_wp) {
 			if (z->cond != ZBD_ZONE_COND_OFFLINE &&
-			    td->o.max_open_zones == 0 && td->o.job_max_open_zones == 0)
+			    zbdi->max_open_zones == 0 && td->o.job_max_open_zones == 0)
 				goto examine_zone;
-			if (f->zbd_info->num_open_zones == 0) {
+			if (zbdi->num_open_zones == 0) {
 				dprint(FD_ZBD, "%s(%s): no zones are open\n",
 				       __func__, f->file_name);
 				goto open_other_zone;
@@ -1230,14 +1260,14 @@ static struct fio_zone_info *zbd_convert_to_open_zone(struct thread_data *td,
 		 */
 		open_zone_idx = pick_random_zone_idx(f, io_u);
 		assert(!open_zone_idx ||
-		       open_zone_idx < f->zbd_info->num_open_zones);
+		       open_zone_idx < zbdi->num_open_zones);
 		tmp_idx = open_zone_idx;
-		for (i = 0; i < f->zbd_info->num_open_zones; i++) {
+		for (i = 0; i < zbdi->num_open_zones; i++) {
 			uint32_t tmpz;
 
-			if (tmp_idx >= f->zbd_info->num_open_zones)
+			if (tmp_idx >= zbdi->num_open_zones)
 				tmp_idx = 0;
-			tmpz = f->zbd_info->open_zones[tmp_idx];
+			tmpz = zbdi->open_zones[tmp_idx];
 			if (f->min_zone <= tmpz && tmpz < f->max_zone) {
 				open_zone_idx = tmp_idx;
 				goto found_candidate_zone;
@@ -1248,39 +1278,39 @@ static struct fio_zone_info *zbd_convert_to_open_zone(struct thread_data *td,
 
 		dprint(FD_ZBD, "%s(%s): no candidate zone\n",
 			__func__, f->file_name);
-		pthread_mutex_unlock(&f->zbd_info->mutex);
+		pthread_mutex_unlock(&zbdi->mutex);
 		if (z->has_wp)
 			zone_unlock(z);
 		return NULL;
 
 found_candidate_zone:
-		new_zone_idx = f->zbd_info->open_zones[open_zone_idx];
+		new_zone_idx = zbdi->open_zones[open_zone_idx];
 		if (new_zone_idx == zone_idx)
 			break;
 		zone_idx = new_zone_idx;
-		pthread_mutex_unlock(&f->zbd_info->mutex);
+		pthread_mutex_unlock(&zbdi->mutex);
 		if (z->has_wp)
 			zone_unlock(z);
 	}
 
-	/* Both z->mutex and f->zbd_info->mutex are held. */
+	/* Both z->mutex and zbdi->mutex are held. */
 
 examine_zone:
 	if (z->wp + min_bs <= zbd_zone_capacity_end(z)) {
-		pthread_mutex_unlock(&f->zbd_info->mutex);
+		pthread_mutex_unlock(&zbdi->mutex);
 		goto out;
 	}
 
 open_other_zone:
 	/* Check if number of open zones reaches one of limits. */
 	wait_zone_close =
-		f->zbd_info->num_open_zones == f->max_zone - f->min_zone ||
-		(td->o.max_open_zones &&
-		 f->zbd_info->num_open_zones == td->o.max_open_zones) ||
+		zbdi->num_open_zones == f->max_zone - f->min_zone ||
+		(zbdi->max_open_zones &&
+		 zbdi->num_open_zones == zbdi->max_open_zones) ||
 		(td->o.job_max_open_zones &&
 		 td->num_open_zones == td->o.job_max_open_zones);
 
-	pthread_mutex_unlock(&f->zbd_info->mutex);
+	pthread_mutex_unlock(&zbdi->mutex);
 
 	/* Only z->mutex is held. */
 
@@ -1295,7 +1325,7 @@ open_other_zone:
 	}
 
 	/* Zone 'z' is full, so try to open a new zone. */
-	for (i = f->io_size / f->zbd_info->zone_size; i > 0; i--) {
+	for (i = f->io_size / zbdi->zone_size; i > 0; i--) {
 		zone_idx++;
 		if (z->has_wp)
 			zone_unlock(z);
@@ -1318,12 +1348,12 @@ open_other_zone:
 	/* Only z->mutex is held. */
 
 	/* Check whether the write fits in any of the already opened zones. */
-	pthread_mutex_lock(&f->zbd_info->mutex);
-	for (i = 0; i < f->zbd_info->num_open_zones; i++) {
-		zone_idx = f->zbd_info->open_zones[i];
+	pthread_mutex_lock(&zbdi->mutex);
+	for (i = 0; i < zbdi->num_open_zones; i++) {
+		zone_idx = zbdi->open_zones[i];
 		if (zone_idx < f->min_zone || zone_idx >= f->max_zone)
 			continue;
-		pthread_mutex_unlock(&f->zbd_info->mutex);
+		pthread_mutex_unlock(&zbdi->mutex);
 		zone_unlock(z);
 
 		z = get_zone(f, zone_idx);
@@ -1331,9 +1361,9 @@ open_other_zone:
 		zone_lock(td, f, z);
 		if (z->wp + min_bs <= zbd_zone_capacity_end(z))
 			goto out;
-		pthread_mutex_lock(&f->zbd_info->mutex);
+		pthread_mutex_lock(&zbdi->mutex);
 	}
-	pthread_mutex_unlock(&f->zbd_info->mutex);
+	pthread_mutex_unlock(&zbdi->mutex);
 	zone_unlock(z);
 	dprint(FD_ZBD, "%s(%s): did not open another zone\n", __func__,
 	       f->file_name);
@@ -1683,6 +1713,7 @@ enum fio_ddir zbd_adjust_ddir(struct thread_data *td, struct io_u *io_u,
 enum io_u_action zbd_adjust_block(struct thread_data *td, struct io_u *io_u)
 {
 	struct fio_file *f = io_u->file;
+	struct zoned_block_device_info *zbdi = f->zbd_info;
 	uint32_t zone_idx_b;
 	struct fio_zone_info *zb, *zl, *orig_zb;
 	uint32_t orig_len = io_u->buflen;
@@ -1690,7 +1721,7 @@ enum io_u_action zbd_adjust_block(struct thread_data *td, struct io_u *io_u)
 	uint64_t new_len;
 	int64_t range;
 
-	assert(f->zbd_info);
+	assert(zbdi);
 	assert(min_bs);
 	assert(is_valid_offset(f, io_u->offset));
 	assert(io_u->buflen);
@@ -1802,12 +1833,12 @@ enum io_u_action zbd_adjust_block(struct thread_data *td, struct io_u *io_u)
 		assert(io_u->offset + io_u->buflen <= zb->wp);
 		goto accept;
 	case DDIR_WRITE:
-		if (io_u->buflen > f->zbd_info->zone_size) {
+		if (io_u->buflen > zbdi->zone_size) {
 			td_verror(td, EINVAL, "I/O buflen exceeds zone size");
 			dprint(FD_IO,
 			       "%s: I/O buflen %llu exceeds zone size %llu\n",
 			       f->file_name, io_u->buflen,
-			       (unsigned long long) f->zbd_info->zone_size);
+			       (unsigned long long) zbdi->zone_size);
 			goto eof;
 		}
 		if (!zbd_open_zone(td, f, zone_idx_b)) {
@@ -1822,7 +1853,7 @@ enum io_u_action zbd_adjust_block(struct thread_data *td, struct io_u *io_u)
 		}
 		/* Check whether the zone reset threshold has been exceeded */
 		if (td->o.zrf.u.f) {
-			if (f->zbd_info->wp_sectors_with_data >=
+			if (zbdi->wp_sectors_with_data >=
 			    f->io_size * td->o.zrt.u.f &&
 			    zbd_dec_and_reset_write_cnt(td, f)) {
 				zb->reset_zone = 1;
diff --git a/zbd.h b/zbd.h
index 64534393..39dc45e3 100644
--- a/zbd.h
+++ b/zbd.h
@@ -50,7 +50,8 @@ struct fio_zone_info {
  * zoned_block_device_info - zoned block device characteristics
  * @model: Device model.
  * @max_open_zones: global limit on the number of simultaneously opened
- *	sequential write zones.
+ *	sequential write zones. A zero value means unlimited open zones,
+ *	and that open zones will not be tracked in the open_zones array.
  * @mutex: Protects the modifiable members in this structure (refcount and
  *		num_open_zones).
  * @zone_size: size of a single zone in bytes.

