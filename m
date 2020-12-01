Return-Path: <krish.reddy@samsung.com>
From: Krishna Kanth Reddy <krish.reddy@samsung.com>
Subject: [PATCH 7/9] Example configuration for simple copy command
Date: Tue,  1 Dec 2020 17:10:32 +0530
Message-Id: <20201201114034.8307-8-krish.reddy@samsung.com>
In-Reply-To: <20201201114034.8307-1-krish.reddy@samsung.com>
Content-Type: text/plain; charset="utf-8"
References: <20201201114034.8307-1-krish.reddy@samsung.com>
	<CGME20201201114107epcas5p4694adc6b50a123a06a06411393395636@epcas5p4.samsung.com>
To: axboe@kernel.dk
Cc: fio@vger.kernel.org, Ankit Kumar <ankit.kumar@samsung.com>, Krishna Kanth Reddy <krish.reddy@samsung.com>
List-ID: <fio@vger.kernel.org>

From: Ankit Kumar <ankit.kumar@samsung.com>

Signed-off-by: Krishna Kanth Reddy <krish.reddy@samsung.com>
---
 examples/fio-copy.fio | 32 ++++++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)
 create mode 100644 examples/fio-copy.fio

diff --git a/examples/fio-copy.fio b/examples/fio-copy.fio
new file mode 100644
index 00000000..02078147
--- /dev/null
+++ b/examples/fio-copy.fio
@@ -0,0 +1,32 @@
+[global]
+threads=1
+filename=fio-copy
+size=128m
+
+[writer]
+rw=write
+bs=128k
+numjobs=1
+offset=0
+buffer_pattern=0xdeadbeef
+
+[copier]
+new_group
+wait_for=writer
+rw=copy
+bs=16k
+offset=0
+dest_offset=256m
+num_range=8
+numjobs=1
+ioengine=sctl
+
+[reader]
+new_group
+wait_for=copier
+rw=read
+offset=256m
+bs=128k
+numjobs=1
+verify=pattern
+verify_pattern=0xdeadbeef
-- 
2.17.1


