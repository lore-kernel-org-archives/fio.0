Return-Path: <ankit.kumar@samsung.com>
From: Ankit Kumar <ankit.kumar@samsung.com>
Subject: [PATCH 1/2] HOWTO: Add missing documentation for job_max_open_zones
Date: Wed,  4 Aug 2021 14:54:49 +0530
Message-Id: <20210804092450.28782-2-ankit.kumar@samsung.com>
In-Reply-To: <20210804092450.28782-1-ankit.kumar@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
References: <20210804092450.28782-1-ankit.kumar@samsung.com>
	<CGME20210804092852epcas5p2bf4990e1b1b9a2e9d02c8520b3998818@epcas5p2.samsung.com>
To: axboe@kernel.dk
Cc: fio@vger.kernel.org, krish.reddy@samsung.com, prakash.v@samsung.com, Ankit Kumar <ankit.kumar@samsung.com>
List-ID: <fio@vger.kernel.org>

---
 HOWTO | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/HOWTO b/HOWTO
index 59c7f1ff..d4e620de 100644
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
2.30.0-rc0


