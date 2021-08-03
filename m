Return-Path: <ankit.kumar@samsung.com>
From: Ankit Kumar <ankit.kumar@samsung.com>
Subject: [PATCH 1/2] Add missing documentation for job_max_open_zones.
Date: Tue,  3 Aug 2021 15:58:35 +0530
Message-Id: <1627986516-4814-2-git-send-email-ankit.kumar@samsung.com>
In-Reply-To: <1627986516-4814-1-git-send-email-ankit.kumar@samsung.com>
Content-Type: text/plain; charset="utf-8"
References: <1627986516-4814-1-git-send-email-ankit.kumar@samsung.com>
	<CGME20210803111237epcas5p3793e7b1dbb19ccad4841e5ba69ee1bb8@epcas5p3.samsung.com>
To: axboe@kernel.dk
Cc: fio@vger.kernel.org, krish.reddy@samsung.com, prakash.v@samsung.com, Ankit Kumar <ankit.kumar@samsung.com>
List-ID: <fio@vger.kernel.org>

---
 HOWTO | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/HOWTO b/HOWTO
index 59c7f1f..d4e620d 100644
--- a/HOWTO
+++ b/HOWTO
@@ -1055,6 +1055,11 @@ Target file/device
 	number of open zones is defined as the number of zones to which write
 	commands are issued.
 
+.. option:: job_max_open_zones=int
+
+	Limit on the number of simultaneously opened zones per single
+	thread/process.
+
 .. option:: zone_reset_threshold=float
 
 	A number between zero and one that indicates the ratio of logical
-- 
1.8.3.1


