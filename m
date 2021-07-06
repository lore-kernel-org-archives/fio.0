Return-Path: <prvs=81407a9e8=damien.lemoal@wdc.com>
From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH 02/11] manpage: fix definition of prio and prioclass options
Date: Tue,  6 Jul 2021 09:17:34 +0900
Message-Id: <20210706001743.10818-3-damien.lemoal@wdc.com>
In-Reply-To: <20210706001743.10818-1-damien.lemoal@wdc.com>
References: <20210706001743.10818-1-damien.lemoal@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: Bart Van Assche <bvanassche@acm.org>
List-ID: <fio@vger.kernel.org>

Remove the reference to the hipri_percentage option in the definition of
the prio and prioclass options as hipri_percentage controls the use of
RWF_HIPRI flag which triggers I/O completion polling, which is unrelated
with I/O priority (polling and I/O priority can be used together).

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 fio.1 | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/fio.1 b/fio.1
index 1101a75d..d9a3593e 100644
--- a/fio.1
+++ b/fio.1
@@ -2624,13 +2624,11 @@ Set the I/O priority value of this job. Linux limits us to a positive value
 between 0 and 7, with 0 being the highest. See man
 \fBionice\fR\|(1). Refer to an appropriate manpage for other operating
 systems since meaning of priority may differ. For per-command priority
-setting, see I/O engine specific `cmdprio_percentage` and `hipri_percentage`
-options.
+setting, see the I/O engine specific `cmdprio_percentage` option.
 .TP
 .BI prioclass \fR=\fPint
 Set the I/O priority class. See man \fBionice\fR\|(1). For per-command
-priority setting, see I/O engine specific `cmdprio_percentage` and `hipri_percent`
-options.
+priority setting, see the I/O engine specific `cmdprio_percentage` option.
 .TP
 .BI cpus_allowed \fR=\fPstr
 Controls the same options as \fBcpumask\fR, but accepts a textual
-- 
2.31.1


