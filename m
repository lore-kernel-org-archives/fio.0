Return-Path: <vincentfu@gmail.com>
Return-Path: <vincentfu@gmail.com>
From: vincentfu@gmail.com
Subject: [PATCH 2/2] options: catch division by zero in setting CPU affinity
Date: Tue, 19 Feb 2019 16:44:08 -0500
Message-Id: <20190219214408.14207-3-vincentfu@gmail.com>
In-Reply-To: <20190219214408.14207-1-vincentfu@gmail.com>
References: <20190219214408.14207-1-vincentfu@gmail.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Vincent Fu <vincent.fu@wdc.com>
List-ID: <fio@vger.kernel.org>

From: Vincent Fu <vincent.fu@wdc.com>

Catch a division by zero and abort with a helpful message instead of a
signal 8 floating point error.
---
 options.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/options.c b/options.c
index 6d832354..95086074 100644
--- a/options.c
+++ b/options.c
@@ -493,6 +493,9 @@ int fio_cpus_split(os_cpu_mask_t *mask, unsigned int cpu_index)
 	const long max_cpu = cpus_online();
 
 	cpus_in_mask = fio_cpu_count(mask);
+	if (!cpus_in_mask)
+		return 0;
+
 	cpu_index = cpu_index % cpus_in_mask;
 
 	index = 0;
-- 
2.17.1


