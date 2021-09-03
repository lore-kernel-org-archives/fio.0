Return-Path: <prvs=873f0fbe3=Niklas.Cassel@wdc.com>
From: Niklas Cassel <Niklas.Cassel@wdc.com>
Subject: [PATCH v2 02/11] manpage: fix definition of prio and prioclass
 options
Date: Fri, 3 Sep 2021 15:20:21 +0000
Message-ID: <20210903152012.18035-3-Niklas.Cassel@wdc.com>
References: <20210903152012.18035-1-Niklas.Cassel@wdc.com>
In-Reply-To: <20210903152012.18035-1-Niklas.Cassel@wdc.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: "axboe@kernel.dk" <axboe@kernel.dk>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>, Damien Le Moal <Damien.LeMoal@wdc.com>, Niklas Cassel <Niklas.Cassel@wdc.com>
List-ID: <fio@vger.kernel.org>

From: Damien Le Moal <damien.lemoal@wdc.com>

Remove the reference to the hipri_percentage option in the definition of
the prio and prioclass options as hipri_percentage controls the use of
RWF_HIPRI flag which triggers I/O completion polling, which is unrelated
with I/O priority (polling and I/O priority can be used together). This
change is done in both fio man page and HOWTO document.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
---
 HOWTO | 6 ++----
 fio.1 | 6 ++----
 2 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/HOWTO b/HOWTO
index a2cf20f6..96b680dd 100644
--- a/HOWTO
+++ b/HOWTO
@@ -2974,14 +2974,12 @@ Threads, processes and job synchronization
 	between 0 and 7, with 0 being the highest.  See man
 	:manpage:`ionice(1)`. Refer to an appropriate manpage for other operating
 	systems since meaning of priority may differ. For per-command priority
-	setting, see I/O engine specific `cmdprio_percentage` and `hipri_percenta=
ge`
-	options.
+	setting, see I/O engine specific `cmdprio_percentage` option.
=20
 .. option:: prioclass=3Dint
=20
 	Set the I/O priority class. See man :manpage:`ionice(1)`. For per-command
-	priority setting, see I/O engine specific `cmdprio_percentage` and
-	`hipri_percentage` options.
+	priority setting, see I/O engine specific `cmdprio_percentage` option.
=20
 .. option:: cpus_allowed=3Dstr
=20
diff --git a/fio.1 b/fio.1
index 25d9f545..87ca8e73 100644
--- a/fio.1
+++ b/fio.1
@@ -2693,13 +2693,11 @@ Set the I/O priority value of this job. Linux limit=
s us to a positive value
 between 0 and 7, with 0 being the highest. See man
 \fBionice\fR\|(1). Refer to an appropriate manpage for other operating
 systems since meaning of priority may differ. For per-command priority
-setting, see I/O engine specific `cmdprio_percentage` and `hipri_percentag=
e`
-options.
+setting, see the I/O engine specific `cmdprio_percentage` option.
 .TP
 .BI prioclass \fR=3D\fPint
 Set the I/O priority class. See man \fBionice\fR\|(1). For per-command
-priority setting, see I/O engine specific `cmdprio_percentage` and `hipri_=
percent`
-options.
+priority setting, see the I/O engine specific `cmdprio_percentage` option.
 .TP
 .BI cpus_allowed \fR=3D\fPstr
 Controls the same options as \fBcpumask\fR, but accepts a textual
--=20
2.31.1

