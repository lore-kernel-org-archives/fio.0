Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ee0-f49.google.com ([74.125.83.49]:57965 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752140AbaEAPIN (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 1 May 2014 11:08:13 -0400
Received: by mail-ee0-f49.google.com with SMTP id e53so2330110eek.8
        for <fio@vger.kernel.org>; Thu, 01 May 2014 08:08:12 -0700 (PDT)
From: Daniel Gollub <daniel.gollub@gmail.com>
Subject: [PATCH] Avoid buildenv conditional in thread_option struct
Date: Thu,  1 May 2014 17:07:49 +0200
Message-Id: <1398956869-22489-1-git-send-email-daniel.gollub@gmail.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org
Cc: Daniel Gollub <daniel.gollub@gmail.com>

Managed to run into issues with an external ioengine
which got build with CONFIG_LIBNUMA not defined. Fio
itself got build with CONFIG_LIBNUMA this resulted
in different struct members offsets in the two different
ELF objects. Causing crashes due to invalidate offsets
inside the thread_data structure (e.g. td->io_ops->data).

Ideally all structs which might be used by external
ioengines should be independent of buildenv conditionals
like CONFIG_LIBNUMA or others.

Removed the CONFIG_LIBNUMA in thread_options.h and replaced
the libnuma specific "struct bitmask" members with strings
which hold the option's input value. This should also make
the marshaling/demarshaling in cconv.c easier.
(Note: the NUMA bits are not handled in cconv.c at the
moment. And not part of the thread_options_packed struct)

Signed-off-by: Daniel Gollub <daniel.gollub@gmail.com>
---
 backend.c        |   16 +++++++++++++---
 options.c        |   15 +++++++++++----
 thread_options.h |    6 ++----
 3 files changed, 26 insertions(+), 11 deletions(-)

diff --git a/backend.c b/backend.c
index e0f8aa7..9deef28 100644
--- a/backend.c
+++ b/backend.c
@@ -1339,6 +1339,7 @@ static void *thread_main(void *data)
 #ifdef CONFIG_LIBNUMA
 	/* numa node setup */
 	if (o->numa_cpumask_set || o->numa_memmask_set) {
+		struct bitmask *mask;
 		int ret;
 
 		if (numa_available() < 0) {
@@ -1347,7 +1348,9 @@ static void *thread_main(void *data)
 		}
 
 		if (o->numa_cpumask_set) {
-			ret = numa_run_on_node_mask(o->numa_cpunodesmask);
+			mask = numa_parse_nodestring(o->numa_cpunodes);
+			ret = numa_run_on_node_mask(mask);
+			numa_free_nodemask(mask);
 			if (ret == -1) {
 				td_verror(td, errno, \
 					"numa_run_on_node_mask failed\n");
@@ -1357,12 +1360,16 @@ static void *thread_main(void *data)
 
 		if (o->numa_memmask_set) {
 
+			mask = NULL;
+			if (o->numa_memnodes)
+				mask = numa_parse_nodestring(o->numa_memnodes);
+
 			switch (o->numa_mem_mode) {
 			case MPOL_INTERLEAVE:
-				numa_set_interleave_mask(o->numa_memnodesmask);
+				numa_set_interleave_mask(mask);
 				break;
 			case MPOL_BIND:
-				numa_set_membind(o->numa_memnodesmask);
+				numa_set_membind(mask);
 				break;
 			case MPOL_LOCAL:
 				numa_set_localalloc();
@@ -1375,6 +1382,9 @@ static void *thread_main(void *data)
 				break;
 			}
 
+			if (mask)
+				numa_free_nodemask(mask);
+
 		}
 	}
 #endif
diff --git a/options.c b/options.c
index 163c5fc..9dcb255 100644
--- a/options.c
+++ b/options.c
@@ -554,6 +554,7 @@ static int str_verify_cpus_allowed_cb(void *data, const char *input)
 static int str_numa_cpunodes_cb(void *data, char *input)
 {
 	struct thread_data *td = data;
+	struct bitmask *verify_bitmask;
 
 	if (parse_dryrun())
 		return 0;
@@ -563,13 +564,15 @@ static int str_numa_cpunodes_cb(void *data, char *input)
 	 * numa_allocate_nodemask(), so it should be freed by
 	 * numa_free_nodemask().
 	 */
-	td->o.numa_cpunodesmask = numa_parse_nodestring(input);
-	if (td->o.numa_cpunodesmask == NULL) {
+	verify_bitmask = numa_parse_nodestring(input);
+	if (verify_bitmask == NULL) {
 		log_err("fio: numa_parse_nodestring failed\n");
 		td_verror(td, 1, "str_numa_cpunodes_cb");
 		return 1;
 	}
+	numa_free_nodemask(verify_bitmask);
 
+	td->o.numa_cpunodes = strdup(input);
 	td->o.numa_cpumask_set = 1;
 	return 0;
 }
@@ -581,6 +584,7 @@ static int str_numa_mpol_cb(void *data, char *input)
 		{ "default", "prefer", "bind", "interleave", "local", NULL };
 	int i;
 	char *nodelist;
+	struct bitmask *verify_bitmask;
 
 	if (parse_dryrun())
 		return 0;
@@ -660,12 +664,15 @@ static int str_numa_mpol_cb(void *data, char *input)
 		break;
 	case MPOL_INTERLEAVE:
 	case MPOL_BIND:
-		td->o.numa_memnodesmask = numa_parse_nodestring(nodelist);
-		if (td->o.numa_memnodesmask == NULL) {
+		verify_bitmask = numa_parse_nodestring(nodelist);
+		if (verify_bitmask == NULL) {
 			log_err("fio: numa_parse_nodestring failed\n");
 			td_verror(td, 1, "str_numa_memnodes_cb");
 			return 1;
 		}
+		td->o.numa_memnodes = strdup(nodelist);
+		numa_free_nodemask(verify_bitmask);
+                
 		break;
 	case MPOL_LOCAL:
 	case MPOL_DEFAULT:
diff --git a/thread_options.h b/thread_options.h
index 41b6e54..57d84db 100644
--- a/thread_options.h
+++ b/thread_options.h
@@ -158,14 +158,12 @@ struct thread_options {
 	os_cpu_mask_t verify_cpumask;
 	unsigned int verify_cpumask_set;
 	unsigned int cpus_allowed_policy;
-#ifdef CONFIG_LIBNUMA
-	struct bitmask *numa_cpunodesmask;
+	char *numa_cpunodes;
 	unsigned int numa_cpumask_set;
 	unsigned short numa_mem_mode;
 	unsigned int numa_mem_prefer_node;
-	struct bitmask *numa_memnodesmask;
+	char *numa_memnodes;
 	unsigned int numa_memmask_set;
-#endif
 	unsigned int iolog;
 	unsigned int rwmixcycle;
 	unsigned int rwmix[DDIR_RWDIR_CNT];
-- 
1.7.10.4

