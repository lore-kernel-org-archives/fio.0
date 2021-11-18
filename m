Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE7D8C433F5
	for <fio@archiver.kernel.org>; Thu, 18 Nov 2021 05:27:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BFC2C61B29
	for <fio@archiver.kernel.org>; Thu, 18 Nov 2021 05:27:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243098AbhKRFag (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 18 Nov 2021 00:30:36 -0500
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:4835 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242431AbhKRFad (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 18 Nov 2021 00:30:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1637213254; x=1668749254;
  h=from:to:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=PE2Oww00SQkh1foAMBOWY/ELILKig0uaIihAgsk5vJ0=;
  b=AFelf09+trFtm8OBL9rOg5WoctFtA6ZkjIYyHrgQeudt8x0Y7ubsh9Xr
   2NwDqF1s2BL73chvQzqukN643+o7Ln6POEEZyNQ69r/JCBYMY6CNr48D4
   hMqfRIVNwsuPZPwTxK3yHLu+NBChUzaKcauVHNmP5ws6EPnYnN7A1zV0j
   vgXxQRGS3Yu0NNGBg14yFE0UHmHxnXTIZg8dkYH6ghZWtV929zKRFEcqt
   YkMTyqwRCSdcYs4Wy1Bigc2VDwQzECpcDIdLw1AhmKApSlaybSzrAXAle
   IEocGeeOk8vwzLVw2rupQKnQSyKWr/qM/x7iWk/Q8Cw5BG8KK/MZ77KOa
   g==;
X-IronPort-AV: E=Sophos;i="5.87,243,1631548800"; 
   d="scan'208";a="186924180"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 18 Nov 2021 13:27:32 +0800
IronPort-SDR: EvNjHjTnhBp6oYBzyLHXSWBh721ZFLDFbrqWQyFxbPskD7qd0rQraZCzwIeZ3Xx7+sGSOIHlUX
 yMh4G47X2MKaPDRkSj3/EbbPLFJlP9bfez1JcJA/fLbuV+cXH5inhBppFts4yrjBZTGRV0Rw5P
 duvTvj9DyV+UKW+AkJ6EvfjVw+Dyx98R2pIJYjV8O4tQ8jsyQBuTXesuwomr6NYYP662EHGdRw
 9DqczDx4HQvhthsAmnRgClR7TZ4WODbS+P6vm5pnfAg8yVYCUnjjxgz5VJZkb1ZIdP98Fk/YtY
 wwmC53KM6xaCdoM7SknikY10
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2021 21:02:33 -0800
IronPort-SDR: S8VbrXI7oHDx4dVyrXqHrRrtey3fkocP8Byu8M4VUdVtB0U4sK1S+bXiN3LKeboB+YztrvMpbt
 H1leIg0YD9NwMsuB0KPhkBP6l7SgCo4Blb4m28HzJiw/ThuOHPHlpjb3cTJvrLu/chCZx/dGPk
 I3qCcqFCnU2kxoZ4rsGXZ7TnRc1lnqHUsZiZQVr/R8/FeJ9tF9qILNGtcNGWEFAO/Gh19cFtvk
 VhGbkYXsthWi8sgKvlYgpcxMOT1QmSz+sgtV14pkSQb0+NymfUOLTCCIkwlO5vBeUmppvZ9DAc
 zvg=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2021 21:27:32 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4HvpGD2SFrz1RtVn
        for <fio@vger.kernel.org>; Wed, 17 Nov 2021 21:27:32 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:mime-version
        :x-mailer:message-id:date:subject:to:from; s=dkim; t=1637213251;
         x=1639805252; bh=PE2Oww00SQkh1foAMBOWY/ELILKig0uaIihAgsk5vJ0=; b=
        QKW6Q1khjsYvGJSe+bwBisn9lcxNmET9ITIvcKGHag5/M381ualhMj7DIvIN7NOM
        6M8kKI89lqMT2u8/glzzXpVaFfMKqZ+okS2CqY70U3SDUW/442CzoJ3mQnGC1WoR
        tBG1cPvu7q4tKfyGpGmGxehE5WtE020YZNqXoK1QX13nlQZHEkINE61OlQg7sbp9
        yYXLfC7ePsOr5gZe0oWZoGYKHDKFo4W3lFLAI+jA9titO5mKwlMQ2ELZIhiruvYA
        j4LlLvXRbMTCuPmBnSnzTWMUmFfzdlU6aX+MJ/AtgqyNq4WabGhQBpx+bvoCSDcF
        AjG0qzCh0eYSACioMbvNFQ==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id cz81tYIUzymA for <fio@vger.kernel.org>;
        Wed, 17 Nov 2021 21:27:31 -0800 (PST)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4HvpGC1dqfz1RtVl;
        Wed, 17 Nov 2021 21:27:31 -0800 (PST)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH v2] fio: Introduce the log_entries option
Date:   Thu, 18 Nov 2021 14:27:29 +0900
Message-Id: <20211118052729.132423-1-damien.lemoal@opensource.wdc.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

When iops, latency, or bw logging options are used, fio will by default
log information for any I/O that completes. The initial number of I/O
log entries is 1024, as defined by (DEF_LOG_ENTRIES). When all log
entries are used, new log entries are dynamically allocated by
get_new_log(). This dynamic log entry allocation can negatively impact
time-related statistics such as the I/O tail latencies (e.g. 99.9
percentile completion latency) as growing the logs causes a temporary
I/O stall (IO quiesce), which disturbs the workload steady state. The
effect of this is especially noticeable with workloads using IO
priorities: the tail latencies of high priority I/Os increase if the
IO log needs to be grown.

For example, running the following fio command on a SATA disk
supporting NCQ priority:

fio --name=3Dprio-randread --filename=3D/dev/sdg \
    --random_generator=3Dtausworthe64 --ioscheduler=3Dnone \
    --write_lat_log=3Drandread.log --log_prio=3D1 --rw=3Drandread --bs=3D=
128k \
    --ioengine=3Dlibaio --iodepth=3D32 --direct=3D1 --cmdprio_class=3D1 \
    --cmdprio_percentage=3D30 --runtime=3D900

(128KB random read workload at QD=3D32 and 30% of commands issued with a
high priority), with an inital number of log entries equal to the
default of 1024, depending on the machine memory state, the completion
latency statistics may show imprecise percentiles such as shown below.

high prio (30.75%) clat percentiles (msec):
 |  1.00th=3D[   14],  5.00th=3D[   17], 10.00th=3D[   20], 20.00th=3D[  =
 23],
 | 30.00th=3D[   27], 40.00th=3D[   32], 50.00th=3D[   40], 60.00th=3D[  =
 53],
 | 70.00th=3D[   71], 80.00th=3D[  104], 90.00th=3D[  169], 95.00th=3D[  =
243],
 | 99.00th=3D[  514], 99.50th=3D[  676], 99.90th=3D[ 1485], 99.95th=3D[ 1=
502],
 | 99.99th=3D[ 1552]
low prio (69.25%) clat percentiles (msec):
 |  1.00th=3D[   16],  5.00th=3D[   24], 10.00th=3D[   37], 20.00th=3D[  =
 68],
 | 30.00th=3D[  105], 40.00th=3D[  146], 50.00th=3D[  199], 60.00th=3D[  =
255],
 | 70.00th=3D[  330], 80.00th=3D[  439], 90.00th=3D[  592], 95.00th=3D[  =
718],
 | 99.00th=3D[  885], 99.50th=3D[  986], 99.90th=3D[ 1469], 99.95th=3D[ 1=
536],
 | 99.99th=3D[ 1586]

All completion latency percentiles above the 99.90th percentile are
similar for the high and low priority commands, which is not consistent
with the drive expected execution of prioritized read commands.

To solve this issue and get more precise latency statistics, this patch
introduces the new "log_entries" option to allow specifying a larger
initial number of IO log entries to avoid run-time allocation.
This option value defaults to DEF_LOG_ENTRIES and its maximum value is
MAX_LOG_ENTRIES to be consistent with get_new_log() allocation. Also
simplify get_new_log() by using calloc() instead of malloc, thus
removing the need for the local variable new_size.

Adding the "--log_entries=3D65536" option to the previous command line
example, the completion latency results obtained are more stable:

high prio (30.72%) clat percentiles (msec):
 |  1.00th=3D[   15],  5.00th=3D[   17], 10.00th=3D[   19], 20.00th=3D[  =
 22],
 | 30.00th=3D[   24], 40.00th=3D[   27], 50.00th=3D[   32], 60.00th=3D[  =
 36],
 | 70.00th=3D[   46], 80.00th=3D[   57], 90.00th=3D[   81], 95.00th=3D[  =
105],
 | 99.00th=3D[  161], 99.50th=3D[  188], 99.90th=3D[  271], 99.95th=3D[  =
275],
 | 99.99th=3D[  363]
low prio (69.28%) clat percentiles (msec):
 |  1.00th=3D[   16],  5.00th=3D[   27], 10.00th=3D[   43], 20.00th=3D[  =
 80],
 | 30.00th=3D[  123], 40.00th=3D[  176], 50.00th=3D[  236], 60.00th=3D[  =
313],
 | 70.00th=3D[  401], 80.00th=3D[  506], 90.00th=3D[  634], 95.00th=3D[  =
718],
 | 99.00th=3D[  844], 99.50th=3D[  885], 99.90th=3D[  953], 99.95th=3D[  =
995],
 | 99.99th=3D[ 1053]

All completion percentiles clearly now show shorter latencies for high
priority commands, as expected. The 99.99th percentile for low priority
commands is also improved compared to the previous case as the
measurements are not impacted by the log dynamic allocation.

Suggested-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Reviewed-by: Niklas Cassel <niklas.cassel@wdc.com>
---
Changes from v1:
* Fixed typos in commit message
* Added reviewed-by tag from Niklas

 HOWTO            | 12 ++++++++++++
 cconv.c          |  2 ++
 fio.1            | 11 +++++++++++
 options.c        | 12 ++++++++++++
 server.h         |  2 +-
 stat.c           | 12 +++++-------
 thread_options.h |  2 ++
 7 files changed, 45 insertions(+), 8 deletions(-)

diff --git a/HOWTO b/HOWTO
index 196bca6c..a3b3acfe 100644
--- a/HOWTO
+++ b/HOWTO
@@ -3537,6 +3537,18 @@ Measurements and reporting
 	:option:`write_bw_log` for details about the filename format and `Log
 	File Formats`_ for how data is structured within the file.
=20
+.. option:: log_entries=3Dint
+
+	By default, fio will log an entry in the iops, latency, or bw log for
+	every I/O that completes. The initial number of I/O log entries is 1024=
.
+	When the log entries are all used, new log entries are dynamically
+	allocated.  This dynamic log entry allocation may negatively impact
+	time-related statistics such as I/O tail latencies (e.g. 99.9th percent=
ile
+	completion latency). This option allows specifying a larger initial
+	number of log entries to avoid run-time allocations of new log entries,
+	resulting in more precise time-related I/O statistics.
+	Also see :option:`log_avg_msec`. Defaults to 1024.
+
 .. option:: log_avg_msec=3Dint
=20
 	By default, fio will log an entry in the iops, latency, or bw log for e=
very
diff --git a/cconv.c b/cconv.c
index 2104308c..4f8d27eb 100644
--- a/cconv.c
+++ b/cconv.c
@@ -187,6 +187,7 @@ void convert_thread_options_to_cpu(struct thread_opti=
ons *o,
 	o->rand_repeatable =3D le32_to_cpu(top->rand_repeatable);
 	o->allrand_repeatable =3D le32_to_cpu(top->allrand_repeatable);
 	o->rand_seed =3D le64_to_cpu(top->rand_seed);
+	o->log_entries =3D le32_to_cpu(top->log_entries);
 	o->log_avg_msec =3D le32_to_cpu(top->log_avg_msec);
 	o->log_hist_msec =3D le32_to_cpu(top->log_hist_msec);
 	o->log_hist_coarseness =3D le32_to_cpu(top->log_hist_coarseness);
@@ -416,6 +417,7 @@ void convert_thread_options_to_net(struct thread_opti=
ons_pack *top,
 	top->rand_repeatable =3D cpu_to_le32(o->rand_repeatable);
 	top->allrand_repeatable =3D cpu_to_le32(o->allrand_repeatable);
 	top->rand_seed =3D __cpu_to_le64(o->rand_seed);
+	top->log_entries =3D cpu_to_le32(o->log_entries);
 	top->log_avg_msec =3D cpu_to_le32(o->log_avg_msec);
 	top->log_max =3D cpu_to_le32(o->log_max);
 	top->log_offset =3D cpu_to_le32(o->log_offset);
diff --git a/fio.1 b/fio.1
index e3c3feae..a6469541 100644
--- a/fio.1
+++ b/fio.1
@@ -3243,6 +3243,17 @@ logging (see \fBlog_avg_msec\fR) has been enabled.=
 See
 \fBwrite_bw_log\fR for details about the filename format and \fBLOG
 FILE FORMATS\fR for how data is structured within the file.
 .TP
+.BI log_entries \fR=3D\fPint
+By default, fio will log an entry in the iops, latency, or bw log for
+every I/O that completes. The initial number of I/O log entries is 1024.
+When the log entries are all used, new log entries are dynamically
+allocated.  This dynamic log entry allocation may negatively impact
+time-related statistics such as I/O tail latencies (e.g. 99.9th percenti=
le
+completion latency). This option allows specifying a larger initial
+number of log entries to avoid run-time allocation of new log entries,
+resulting in more precise time-related I/O statistics.
+Also see \fBlog_avg_msec\fR as well. Defaults to 1024.
+.TP
 .BI log_avg_msec \fR=3D\fPint
 By default, fio will log an entry in the iops, latency, or bw log for ev=
ery
 I/O that completes. When writing to the disk log, that can quickly grow =
to a
diff --git a/options.c b/options.c
index 460cf4ff..102bcf56 100644
--- a/options.c
+++ b/options.c
@@ -4244,6 +4244,18 @@ struct fio_option fio_options[FIO_MAX_OPTS] =3D {
 		.category =3D FIO_OPT_C_LOG,
 		.group	=3D FIO_OPT_G_INVALID,
 	},
+	{
+		.name	=3D "log_entries",
+		.lname	=3D "Log entries",
+		.type	=3D FIO_OPT_INT,
+		.off1	=3D offsetof(struct thread_options, log_entries),
+		.help	=3D "Initial number of entries in a job IO log",
+		.def	=3D __fio_stringify(DEF_LOG_ENTRIES),
+		.minval	=3D DEF_LOG_ENTRIES,
+		.maxval	=3D MAX_LOG_ENTRIES,
+		.category =3D FIO_OPT_C_LOG,
+		.group	=3D FIO_OPT_G_INVALID,
+	},
 	{
 		.name	=3D "log_avg_msec",
 		.lname	=3D "Log averaging (msec)",
diff --git a/server.h b/server.h
index 44b8da12..25b6bbdc 100644
--- a/server.h
+++ b/server.h
@@ -48,7 +48,7 @@ struct fio_net_cmd_reply {
 };
=20
 enum {
-	FIO_SERVER_VER			=3D 94,
+	FIO_SERVER_VER			=3D 95,
=20
 	FIO_SERVER_MAX_FRAGMENT_PDU	=3D 1024,
 	FIO_SERVER_MAX_CMD_MB		=3D 2048,
diff --git a/stat.c b/stat.c
index cd35b114..e0dc99b6 100644
--- a/stat.c
+++ b/stat.c
@@ -2688,27 +2688,25 @@ static inline void add_stat_sample(struct io_stat=
 *is, unsigned long long data)
  */
 static struct io_logs *get_new_log(struct io_log *iolog)
 {
-	size_t new_size, new_samples;
+	size_t new_samples;
 	struct io_logs *cur_log;
=20
 	/*
 	 * Cap the size at MAX_LOG_ENTRIES, so we don't keep doubling
 	 * forever
 	 */
-	if (!iolog->cur_log_max)
-		new_samples =3D DEF_LOG_ENTRIES;
-	else {
+	if (!iolog->cur_log_max) {
+		new_samples =3D iolog->td->o.log_entries;
+	} else {
 		new_samples =3D iolog->cur_log_max * 2;
 		if (new_samples > MAX_LOG_ENTRIES)
 			new_samples =3D MAX_LOG_ENTRIES;
 	}
=20
-	new_size =3D new_samples * log_entry_sz(iolog);
-
 	cur_log =3D smalloc(sizeof(*cur_log));
 	if (cur_log) {
 		INIT_FLIST_HEAD(&cur_log->list);
-		cur_log->log =3D malloc(new_size);
+		cur_log->log =3D calloc(new_samples, log_entry_sz(iolog));
 		if (cur_log->log) {
 			cur_log->nr_samples =3D 0;
 			cur_log->max_samples =3D new_samples;
diff --git a/thread_options.h b/thread_options.h
index 6e1a2cdd..8f4c8a59 100644
--- a/thread_options.h
+++ b/thread_options.h
@@ -377,6 +377,7 @@ struct thread_options {
 	fio_fp64_t zrt;
 	fio_fp64_t zrf;
=20
+	unsigned int log_entries;
 	unsigned int log_prio;
 };
=20
@@ -683,6 +684,7 @@ struct thread_options_pack {
 	int32_t max_open_zones;
 	uint32_t ignore_zone_limits;
=20
+	uint32_t log_entries;
 	uint32_t log_prio;
 } __attribute__((packed));
=20
--=20
2.31.1

