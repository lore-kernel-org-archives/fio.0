Return-Path: <ankit.kumar@samsung.com>
From: Ankit Kumar <ankit.kumar@samsung.com>
Subject: [PATCH 1/2] HOWTO: Add missing documentation for job_max_open_zones
Date: Wed,  4 Aug 2021 16:53:07 +0530
Message-Id: <20210804112308.28062-2-ankit.kumar@samsung.com>
In-Reply-To: <20210804112308.28062-1-ankit.kumar@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
References: <20210804112308.28062-1-ankit.kumar@samsung.com>
	<CGME20210804112707epcas5p1b0bc0d3e4e85bcff47d4021359151a32@epcas5p1.samsung.com>
To: axboe@kernel.dk
Cc: fio@vger.kernel.org, krish.reddy@samsung.com, prakash.v@samsung.com, Ankit Kumar <ankit.kumar@samsung.com>
List-ID: <fio@vger.kernel.org>

Signed-off-by: Ankit Kumar <ankit.kumar@samsung.com>
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


