Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF1D1E810D6
	for <fio@archiver.kernel.org>; Wed, 27 Sep 2023 12:00:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230143AbjI0MAO (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 27 Sep 2023 08:00:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229901AbjI0MAN (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 27 Sep 2023 08:00:13 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12E9BBE
        for <fio@vger.kernel.org>; Wed, 27 Sep 2023 05:00:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Date:Message-Id:To:From:Subject:Sender
        :Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=JlhlUDjTYV0CIgkMr90Wqd+47wswH7VOJYdF2tIbUtk=; b=PENqsVGIvzTMHEdZZCXnu5k4BS
        QZxd76VlZHWNN5s6nIxRvnKkqgpw9WOkmyBWd1JGoq5798q0JRdoAVNXFVZAf5cjFKvdzNT3/BD+3
        MkgzDPzebX9bDWA8sLVtzLMSvxcrRM5lPGSiQnyUGmOJ9VzIT5H1HR9iGo168XriG4NyQlOrf2TB9
        N1anXzgpt+lurIN6ZEdF5Ao1Hz1RJrQv8lFbuVCC4FELsdLvFXaSvpQpCdve6bphR7AhhTnECKzwL
        5PLo0iXmILgMAkNtAAfssQ5Qx0mepwAFP9B3f3NK9F8D8JuFOuBRDe93wnNTckWfE5ZdUuqzdEofA
        E7rExpbw==;
Received: from [96.43.243.2] (helo=kernel.dk)
        by desiato.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1qlTD5-003qkO-0O
        for fio@vger.kernel.org;
        Wed, 27 Sep 2023 12:00:09 +0000
Received: by kernel.dk (Postfix, from userid 1000)
        id 9093D1BC0185; Wed, 27 Sep 2023 06:00:01 -0600 (MDT)
Subject: Recent changes (master)
From:   Jens Axboe <axboe@kernel.dk>
To:     <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20230927120001.9093D1BC0185@kernel.dk>
Date:   Wed, 27 Sep 2023 06:00:01 -0600 (MDT)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The following changes since commit a142e0df6c1483a76d92ff7f9d8c07242af9910e:

  Merge branch 'fio_client_server_doc_fix' of https://github.com/pcpartpicker/fio (2023-09-20 07:41:17 -0400)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 996ac91f54844e63ef43092472fc1f7610567b67:

  t/zbd: set mq-deadline scheduler to device-mapper destination devices (2023-09-26 09:00:13 -0400)

----------------------------------------------------------------
Shin'ichiro Kawasaki (1):
      t/zbd: set mq-deadline scheduler to device-mapper destination devices

 t/zbd/functions        | 11 +++++++++
 t/zbd/test-zbd-support | 61 +++++++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 71 insertions(+), 1 deletion(-)

---

Diff of recent changes:

diff --git a/t/zbd/functions b/t/zbd/functions
index 4faa45a9..028df404 100644
--- a/t/zbd/functions
+++ b/t/zbd/functions
@@ -27,6 +27,17 @@ blkzone_reports_capacity() {
 		"${blkzone}" report -c 1 -o 0 "${dev}" | grep -q 'cap '
 }
 
+has_command() {
+	local cmd="${1}"
+
+	cmd_path=$(type -p "${cmd}" 2>/dev/null)
+	if [ -z "${cmd_path}" ]; then
+		echo "${cmd} is not available"
+		return 1
+	fi
+	return 0
+}
+
 # Whether or not $1 (/dev/...) is a NVME ZNS device.
 is_nvme_zns() {
 	local s
diff --git a/t/zbd/test-zbd-support b/t/zbd/test-zbd-support
index c8f3eb61..0436d319 100755
--- a/t/zbd/test-zbd-support
+++ b/t/zbd/test-zbd-support
@@ -46,6 +46,55 @@ ioengine() {
 	fi
 }
 
+get_dev_path_by_id() {
+	for d in /sys/block/* /sys/block/*/*; do
+		if [[ ! -r "${d}/dev" ]]; then
+			continue
+		fi
+		if [[ "${1}" == "$(<"${d}/dev")" ]]; then
+			echo "/dev/${d##*/}"
+			return 0
+		fi
+	done
+	return 1
+}
+
+dm_destination_dev_set_io_scheduler() {
+	local dev=$1 sched=$2
+	local dest_dev_id dest_dev path
+
+	has_command dmsetup || return 1
+
+	while read -r dest_dev_id; do
+		if ! dest_dev=$(get_dev_path_by_id "${dest_dev_id}"); then
+			continue
+		fi
+		path=${dest_dev/dev/sys\/block}/queue/scheduler
+		if [[ ! -w ${path} ]]; then
+			echo "Can not set scheduler of device mapper destination: ${dest_dev}"
+			continue
+		fi
+		echo "${2}" > "${path}"
+	done < <(dmsetup table "$(<"/sys/block/$dev/dm/name")" |
+			 sed -n  's/.* \([0-9]*:[0-9]*\).*/\1/p')
+}
+
+dev_has_dm_map() {
+	local dev=${1} target_type=${2}
+	local dm_name
+
+	has_command dmsetup || return 1
+
+	dm_name=$(<"/sys/block/$dev/dm/name")
+	if ! dmsetup status "${dm_name}" | grep -qe "${target_type}"; then
+		return 1
+	fi
+	if dmsetup status "${dm_name}" | grep -v "${target_type}"; then
+		return 1
+	fi
+	return 0
+}
+
 set_io_scheduler() {
     local dev=$1 sched=$2
 
@@ -62,7 +111,17 @@ set_io_scheduler() {
 	esac
     fi
 
-    echo "$sched" >"/sys/block/$dev/queue/scheduler"
+    if [ -w "/sys/block/$dev/queue/scheduler" ]; then
+	echo "$sched" >"/sys/block/$dev/queue/scheduler"
+    elif [ -r  "/sys/block/$dev/dm/name" ] &&
+		 ( dev_has_dm_map "$dev" linear ||
+		   dev_has_dm_map "$dev" flakey ||
+		   dev_has_dm_map "$dev" crypt ); then
+	dm_destination_dev_set_io_scheduler "$dev" "$sched"
+    else
+	echo "can not set io scheduler"
+	exit 1
+    fi
 }
 
 check_read() {
