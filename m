Return-Path: <prvs=60314b82c=aravind.ramesh@wdc.com>
From: Aravind Ramesh <aravind.ramesh@wdc.com>
Subject: [PATCH] flow: fix hang with flow control and zoned block devices
Date: Mon,  7 Dec 2020 10:30:45 +0000
Message-Id: <20201207103045.3433366-1-aravind.ramesh@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: axboe@kernel.dk, fio@vger.kernel.org, shinichiro.kawasaki@wdc.com
Cc: Aravind Ramesh <Aravind.Ramesh@wdc.com>, Aravind Ramesh <aravind.ramesh@wdc.com>
List-ID: <fio@vger.kernel.org>

From: Aravind Ramesh <Aravind.Ramesh@wdc.com>

When flow control is specified between 2 or more threads executing a workload
with zonemode=zbd and flow_sleep is not specified by the user (default to zero),
then a job A can lock a zone Z with the flow ratio exceeded, resulting in the
job to not issue the IO until other jobs IOs balance the flow ratio.
Since job A will wait with the Zone Z locked, other jobs will deadlock waiting
for this zone lock if their workload resulted in this zone Z being chosen
as an IO target.

Executing io_u_quiesce() when the flow ratio is exceeded solves this potential
deadlock as job A will wait for the flow ratio to balance without holding the
zone A lock. To preserve the behavior for regular block devices and to avoid
extra overhead, io_u_quiesce() only needs to be executed when the workload
specifies zonedmode=zbd.

Signed-off-by: Aravind Ramesh <aravind.ramesh@wdc.com>
Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 flow.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/flow.c b/flow.c
index ea6b0ec9..c64bb3b2 100644
--- a/flow.c
+++ b/flow.c
@@ -37,6 +37,8 @@ int flow_threshold_exceeded(struct thread_data *td)
 		if (td->o.flow_sleep) {
 			io_u_quiesce(td);
 			usleep(td->o.flow_sleep);
+		} else if (td->o.zone_mode == ZONE_MODE_ZBD) {
+			io_u_quiesce(td);
 		}
 
 		return 1;
-- 
2.25.1


