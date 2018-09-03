Return-Path: <fio-owner@vger.kernel.org>
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:24657 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725955AbeICMVs (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 3 Sep 2018 08:21:48 -0400
From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH v2] zbd: Fix test scripts
Date: Mon,  3 Sep 2018 17:02:47 +0900
Message-Id: <20180903080247.10517-1-damien.lemoal@wdc.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: Bart Van Assche <bvanassche@acm.org>

Fix handling of the path to the test-zbd-support script to avoid an
error when the tests are run directly when in fio/t/zbd using the
command "./run-against...".

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
Changes from v1:
* Use a scriptdir variable as suggested by Bart.

 t/zbd/run-tests-against-regular-nullb | 4 +++-
 t/zbd/run-tests-against-zoned-nullb   | 4 +++-
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/t/zbd/run-tests-against-regular-nullb b/t/zbd/run-tests-against-regular-nullb
index 133c7c41..d33e1c80 100755
--- a/t/zbd/run-tests-against-regular-nullb
+++ b/t/zbd/run-tests-against-regular-nullb
@@ -4,6 +4,8 @@
 #
 # This file is released under the GPL.
 
+scriptdir="$(cd "$(dirname "$0")" && pwd)"
+
 for d in /sys/kernel/config/nullb/*; do [ -d "$d" ] && rmdir "$d"; done
 modprobe -r null_blk
 modprobe null_blk nr_devices=0 || return $?
@@ -22,4 +24,4 @@ modprobe null_blk nr_devices=0 &&
     echo 1 > memory_backed &&
     echo 1 > power
 
-"$(dirname "$0")"/test-zbd-support "$@" /dev/nullb0
+${scriptdir}/test-zbd-support "$@" /dev/nullb0
diff --git a/t/zbd/run-tests-against-zoned-nullb b/t/zbd/run-tests-against-zoned-nullb
index 7d9eb439..1a8e3be4 100755
--- a/t/zbd/run-tests-against-zoned-nullb
+++ b/t/zbd/run-tests-against-zoned-nullb
@@ -4,6 +4,8 @@
 #
 # This file is released under the GPL.
 
+scriptdir="$(cd "$(dirname "$0")" && pwd)"
+
 for d in /sys/kernel/config/nullb/*; do [ -d "$d" ] && rmdir "$d"; done
 modprobe -r null_blk
 modprobe null_blk nr_devices=0 || return $?
@@ -24,4 +26,4 @@ modprobe null_blk nr_devices=0 &&
     echo 1 > memory_backed &&
     echo 1 > power
 
-"$(dirname "$0")"/test-zbd-support "$@" /dev/nullb0
+${scriptdir}/test-zbd-support "$@" /dev/nullb0
-- 
2.17.1


