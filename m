Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A751F1CD15
	for <fio@vger.kernel.org>; Fri, 24 Jan 2025 13:00:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737723612; cv=none; b=Ps1nxCPe8bp0fibw18bjnubrd3LGlVyW3BSTG8+AiajjGpyafyyP2WyoGEpF33xI/3uftyjS+L2Lnfa+dRgIh6ebBr9FMT9DbKMaEZbdl5sVjJv+IgPuFCvoSrjXV6TJjKLwOl47ibf9IbEMwETdv5dNB84dsSozuFvvHVsYBr8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737723612; c=relaxed/simple;
	bh=1a/NuwHiVmtMdoeCR50bkF6rFzIsx0lXOPOeP4ULdGo=;
	h=Subject:From:To:Message-Id:Date; b=jQlNt3QMp9o3ILtni0s2QihUoLagbBuQDLf2fyNSMnEOPpfZzC9kqlm0pOA8rvmQ5tjGTHqGIjyL2S6/tTwfihgpXbIz543WMomNe3VVcFiwbfTCTEdmZITZssOR1qg7wLpd88Rue83uNp4Qt8FKKdAkJZUPrpEmw9GqvBT6Ahg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=fail smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=eM7fC1In; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="eM7fC1In"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Date:Message-Id:To:From:Subject:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=BKw5nVH/paRbi4pDDekpV/nFj9t/J7qEinAxhxJVeVE=; b=eM7fC1InSngCXtqEUkISlkkN6r
	F5gfC0F4i04usZoPulYU7+9GVKG3OUOH+KPcPzBvuCpvvwsFAt6U7hNV5pS0dp91Wsw5pUYY0/29G
	qCEy8vd/XxXu2IatqE3c/+sQ78BviInsRCEmrOfKecyBFiWgPfKfnJcG7nhDaCqdTbUvSaiBCE0FG
	drHXsp09EEBj88KOn4Q5TyalKmrboRwjstdV+vmsMEJtDxNaqIrdTK4KhBKgSiUqzURrDbDF5ql3R
	rSJOhxtfGiDu3w8vk8/tY343nkQiWOlL0zpeSTyX3vm2bLrIW/XWyXfGKoNA2VLm7CpJxHniCZUcD
	S+sOUZHA==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by casper.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tbJI5-0000000FoRk-0AfO
	for fio@vger.kernel.org;
	Fri, 24 Jan 2025 13:00:05 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id E643E1BC0178; Fri, 24 Jan 2025 06:00:01 -0700 (MST)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20250124130001.E643E1BC0178@kernel.dk>
Date: Fri, 24 Jan 2025 06:00:01 -0700 (MST)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>

The following changes since commit 0f754a3af30fe6f308ce1c0f95bf1a6f99b3177a:

  t/zbd: add test case to confirm no max_open_zones limit check (2025-01-22 11:08:37 -0500)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 46559adef82f7d0a0712ac31b20d98fa6b0bd7af:

  t/run-fio-tests: add client/server test script (2025-01-23 12:57:42 -0500)

----------------------------------------------------------------
Vincent Fu (7):
      client: rename job_opt_object to global_opt_object
      json: allow empty string values
      client: separate global options from multiple servers
      t/fiotestlib: improve JSON decoding
      ci: install kill binary for Debian platforms
      t/client-server: basic client/server test script
      t/run-fio-tests: add client/server test script

 ci/actions-install.sh               |   1 +
 client.c                            |  42 ++-
 client.h                            |   1 +
 json.c                              |   3 -
 t/client_server.py                  | 505 ++++++++++++++++++++++++++++++++++++
 t/client_server/test01.fio          |  14 +
 t/client_server/test04-noglobal.fio |  20 ++
 t/client_server/test07-slat.fio     |   7 +
 t/client_server/test08-clat.fio     |   7 +
 t/client_server/test09-lat.fio      |   7 +
 t/client_server/test10-noclat.fio   |   7 +
 t/client_server/test11-alllat.fio   |   9 +
 t/fiotestlib.py                     |  17 +-
 t/run-fio-tests.py                  |   8 +
 14 files changed, 628 insertions(+), 20 deletions(-)
 create mode 100755 t/client_server.py
 create mode 100644 t/client_server/test01.fio
 create mode 100644 t/client_server/test04-noglobal.fio
 create mode 100644 t/client_server/test07-slat.fio
 create mode 100644 t/client_server/test08-clat.fio
 create mode 100644 t/client_server/test09-lat.fio
 create mode 100644 t/client_server/test10-noclat.fio
 create mode 100644 t/client_server/test11-alllat.fio

---

Diff of recent changes:

diff --git a/ci/actions-install.sh b/ci/actions-install.sh
index 5a32ec91..ad352317 100755
--- a/ci/actions-install.sh
+++ b/ci/actions-install.sh
@@ -89,6 +89,7 @@ DPKGCFG
             bison
             build-essential
             flex
+            procps
             zlib1g-dev
         )
     fi
diff --git a/client.c b/client.c
index d6d54663..923b092e 100644
--- a/client.c
+++ b/client.c
@@ -61,7 +61,8 @@ int sum_stat_clients;
 static int sum_stat_nr;
 static struct buf_output allclients;
 static struct json_object *root = NULL;
-static struct json_object *job_opt_object = NULL;
+static struct json_object *global_opt_object = NULL;
+static struct json_array *global_opt_array = NULL;
 static struct json_array *clients_array = NULL;
 static struct json_array *du_array = NULL;
 
@@ -189,8 +190,13 @@ static void fio_client_json_init(void)
 	json_object_add_value_int(root, "timestamp", time_p);
 	json_object_add_value_string(root, "time", time_buf);
 
-	job_opt_object = json_create_object();
-	json_object_add_value_object(root, "global options", job_opt_object);
+	if (nr_clients == 1) {
+		global_opt_object = json_create_object();
+		json_object_add_value_object(root, "global options", global_opt_object);
+	} else {
+		global_opt_array = json_create_array();
+		json_object_add_value_array(root, "global options", global_opt_array);
+	}
 	clients_array = json_create_array();
 	json_object_add_value_array(root, "client_stats", clients_array);
 	du_array = json_create_array();
@@ -215,7 +221,8 @@ static void fio_client_json_fini(void)
 
 	json_free_object(root);
 	root = NULL;
-	job_opt_object = NULL;
+	global_opt_object = NULL;
+	global_opt_array = NULL;
 	clients_array = NULL;
 	du_array = NULL;
 }
@@ -1116,11 +1123,13 @@ static void handle_ts(struct fio_client *client, struct fio_net_cmd *cmd)
 		opt_list = &client->opt_lists[p->ts.thread_number - 1];
 
 	tsobj = show_thread_status(&p->ts, &p->rs, opt_list, &client->buf);
-	client->did_stat = true;
 	if (tsobj) {
 		json_object_add_client_info(tsobj, client);
 		json_array_add_value_object(clients_array, tsobj);
+		if (!client->did_stat && client->global_opts)
+			json_array_add_value_object(global_opt_array, client->global_opts);
 	}
+	client->did_stat = true;
 
 	if (sum_stat_clients <= 1)
 		return;
@@ -1171,12 +1180,31 @@ static void handle_job_opt(struct fio_client *client, struct fio_net_cmd *cmd)
 	pdu->groupid = le32_to_cpu(pdu->groupid);
 
 	if (pdu->global) {
-		if (!job_opt_object)
+		struct json_object *global_opts;
+
+		if (!global_opt_object && !global_opt_array)
 			return;
 
-		json_object_add_value_string(job_opt_object,
+		/*
+		 * If we have only one server connection, add it to the single
+		 * global option dictionary. When we have connections to
+		 * multiple servers, add the global option to the
+		 * server-specific dictionary.
+		 */
+		if (global_opt_object) {
+			global_opts = global_opt_object;
+		} else {
+			if (!client->global_opts) {
+				client->global_opts = json_create_object();
+				json_object_add_client_info(client->global_opts, client);
+			}
+			global_opts = client->global_opts;
+		}
+
+		json_object_add_value_string(global_opts,
 					     (const char *)pdu->name,
 					     (const char *)pdu->value);
+		return;
 	} else if (client->opt_lists) {
 		struct flist_head *opt_list = &client->opt_lists[pdu->groupid];
 		struct print_option *p;
diff --git a/client.h b/client.h
index d77b6076..11fc661a 100644
--- a/client.h
+++ b/client.h
@@ -42,6 +42,7 @@ struct fio_client {
 	char *name;
 
 	struct flist_head *opt_lists;
+	struct json_object *global_opts;
 
 	int state;
 
diff --git a/json.c b/json.c
index cd3d5d74..6375b3c2 100644
--- a/json.c
+++ b/json.c
@@ -56,9 +56,6 @@ static char *strdup_escape(const char *str)
 	char *p, *ret;
 	int escapes;
 
-	if (!strlen(str))
-		return NULL;
-
 	escapes = 0;
 	while ((input = strpbrk(input, "\\\"")) != NULL) {
 		escapes++;
diff --git a/t/client_server.py b/t/client_server.py
new file mode 100755
index 00000000..88f5297f
--- /dev/null
+++ b/t/client_server.py
@@ -0,0 +1,505 @@
+#!/usr/bin/env python3
+"""
+# client_server.py
+#
+# Test fio's client/server mode.
+#
+# USAGE
+# see python3 client_server.py --help
+#
+# EXAMPLES
+# python3 t/client_server.py
+# python3 t/client_server.py -f ./fio
+#
+# REQUIREMENTS
+# Python 3.6
+#
+# This will start fio server instances listening on the interfaces below and
+# will break if any ports are already occupied.
+#
+#
+"""
+import os
+import sys
+import time
+import locale
+import logging
+import argparse
+import tempfile
+import subprocess
+import configparser
+from pathlib import Path
+from fiotestlib import FioJobCmdTest, run_fio_tests
+
+
+SERVER_LIST = [
+            ",8765",
+            ",8766",
+            ",8767",
+            ",8768",
+        ]
+
+PIDFILE_LIST = []
+
+class ClientServerTest(FioJobCmdTest):
+    """
+    Client/sever test class.
+    """
+
+    def setup(self, parameters):
+        """Setup a test."""
+
+        fio_args = [
+            f"--output={self.filenames['output']}",
+            f"--output-format={self.fio_opts['output-format']}",
+        ]
+        for server in self.fio_opts['servers']:
+            option = f"--client={server['client']}"
+            fio_args.append(option)
+            fio_args.append(server['jobfile'])
+
+        super().setup(fio_args)
+
+
+
+class ClientServerTestGlobalSingle(ClientServerTest):
+    """
+    Client/sever test class.
+    One server connection only.
+    The job file may or may not have a global section.
+    """
+
+    def check_result(self):
+        super().check_result()
+
+        config = configparser.ConfigParser(allow_no_value=True)
+        config.read(self.fio_opts['servers'][0]['jobfile'])
+
+        if not config.has_section('global'):
+            if len(self.json_data['global options']) > 0:
+                self.failure_reason = f"{self.failure_reason} non-empty 'global options' dictionary found with no global section in job file."
+                self.passed = False
+            return
+
+        if len(self.json_data['global options']) == 0:
+            self.failure_reason = f"{self.failure_reason} empty 'global options' dictionary found with no global section in job file."
+            self.passed = False
+
+        # Now make sure job file global section matches 'global options'
+        # in JSON output
+        job_file_global = dict(config['global'])
+        for key, value in job_file_global.items():
+            if value is None:
+                job_file_global[key] = ""
+        if job_file_global != self.json_data['global options']:
+            self.failure_reason = f"{self.failure_reason} 'global options' dictionary does not match global section in job file."
+            self.passed = False
+
+
+class ClientServerTestGlobalMultiple(ClientServerTest):
+    """
+    Client/sever test class.
+    Multiple server connections.
+    Job files may or may not have a global section.
+    """
+
+    def check_result(self):
+        super().check_result()
+
+        #
+        # For each job file, check if it has a global section
+        # If so, make sure the 'global options' array has
+        # as element for it.
+        # At the end, make sure the total number of elements matches the number
+        # of job files with global sections.
+        #
+
+        global_sections = 0
+        for server in self.fio_opts['servers']:
+            config = configparser.ConfigParser(allow_no_value=True)
+            config.read(server['jobfile'])
+
+            if not config.has_section('global'):
+                continue
+
+            global_sections += 1
+
+            # this can only parse one server spec format
+            [hostname, port] = server['client'].split(',')
+
+            match = None
+            for global_opts in self.json_data['global options']:
+                if 'hostname' not in global_opts:
+                    continue
+                if 'port' not in global_opts:
+                    continue
+                if global_opts['hostname'] == hostname and int(global_opts['port']) == int(port):
+                    match = global_opts
+                    break
+
+            if not match:
+                self.failure_reason = f"{self.failure_reason} matching 'global options' element not found for {hostname}, {port}."
+                self.passed = False
+                continue
+
+            del match['hostname']
+            del match['port']
+
+            # Now make sure job file global section matches 'global options'
+            # in JSON output
+            job_file_global = dict(config['global'])
+            for key, value in job_file_global.items():
+                if value is None:
+                    job_file_global[key] = ""
+            if job_file_global != match:
+                self.failure_reason += " 'global options' dictionary does not match global section in job file."
+                self.passed = False
+            else:
+                logging.debug("Job file global section matches 'global options' array element %s", server['client'])
+
+        if global_sections != len(self.json_data['global options']):
+            self.failure_reason = f"{self.failure_reason} mismatched number of elements in 'global options' array."
+            self.passed = False
+        else:
+            logging.debug("%d elements in global options array as expected", global_sections)
+
+
+class ClientServerTestAllClientsLat(ClientServerTest):
+    """
+    Client/sever test class.
+    Make sure the "All clients" job has latency percentile data.
+    Assumes that a job named 'test' is run with no global section.
+    Only check read data.
+    """
+
+    def check_result(self):
+        super().check_result()
+
+        config = configparser.ConfigParser(allow_no_value=True)
+        config.read(self.fio_opts['servers'][0]['jobfile'])
+
+        lats = { 'clat': True, 'lat': False, 'slat': False }
+        for key in lats:
+            opt = f"{key}_percentiles"
+            if opt in config.options('test'):
+                lats[key] = config.getboolean('test', opt)
+                logging.debug("%s set to %s", opt, lats[key])
+
+        all_clients = None
+        client_stats = self.json_data['client_stats']
+        for client in client_stats:
+            if client['jobname'] == "All clients":
+                all_clients = client
+                break
+
+        if not all_clients:
+            self.failure_reason = f"{self.failure_reason} Could not find 'All clients' output"
+            self.passed = False
+
+        for key, value in lats.items():
+            if value:
+                if 'percentile' not in all_clients['read'][f"{key}_ns"]:
+                    self.failure_reason += f" {key} percentiles not found"
+                    self.passed = False
+                    break
+
+                logging.debug("%s percentiles found as expected", key)
+            else:
+                if 'percentile' in all_clients['read'][f"{key}_ns"]:
+                    self.failure_reason += f" {key} percentiles found unexpectedly"
+                    self.passed = False
+                    break
+
+                logging.debug("%s percentiles appropriately not found", key)
+
+
+
+TEST_LIST = [
+    {   # Smoke test
+        "test_id": 1,
+        "fio_opts": {
+            "output-format": "json",
+            "servers": [
+                    {
+                        "client" : 0, # index into the SERVER_LIST array
+                        "jobfile": "test01.fio",
+                    },
+                ]
+            },
+        "test_class": ClientServerTest,
+    },
+    {   # try another client
+        "test_id": 2,
+        "fio_opts": {
+            "output-format": "json",
+            "servers": [
+                    {
+                        "client" : 1,
+                        "jobfile": "test01.fio",
+                    },
+                ]
+            },
+        "test_class": ClientServerTest,
+    },
+    {   # single client global section
+        "test_id": 3,
+        "fio_opts": {
+            "output-format": "json",
+            "servers": [
+                    {
+                        "client" : 2,
+                        "jobfile": "test01.fio",
+                    },
+                ]
+            },
+        "test_class": ClientServerTestGlobalSingle,
+    },
+    {   # single client no global section
+        "test_id": 4,
+        "fio_opts": {
+            "output-format": "json",
+            "servers": [
+                    {
+                        "client" : 3,
+                        "jobfile": "test04-noglobal.fio",
+                    },
+                ]
+            },
+        "test_class": ClientServerTestGlobalSingle,
+    },
+    {   # multiple clients, some with global, some without
+        "test_id": 5,
+        "fio_opts": {
+            "output-format": "json",
+            "servers": [
+                    {
+                        "client" : 0,
+                        "jobfile": "test04-noglobal.fio",
+                    },
+                    {
+                        "client" : 1,
+                        "jobfile": "test01.fio",
+                    },
+                    {
+                        "client" : 2,
+                        "jobfile": "test04-noglobal.fio",
+                    },
+                    {
+                        "client" : 3,
+                        "jobfile": "test01.fio",
+                    },
+                ]
+            },
+        "test_class": ClientServerTestGlobalMultiple,
+    },
+    {   # multiple clients, all with global sections
+        "test_id": 6,
+        "fio_opts": {
+            "output-format": "json",
+            "servers": [
+                    {
+                        "client" : 0,
+                        "jobfile": "test01.fio",
+                    },
+                    {
+                        "client" : 1,
+                        "jobfile": "test01.fio",
+                    },
+                    {
+                        "client" : 2,
+                        "jobfile": "test01.fio",
+                    },
+                    {
+                        "client" : 3,
+                        "jobfile": "test01.fio",
+                    },
+                ]
+            },
+        "test_class": ClientServerTestGlobalMultiple,
+    },
+    {   # Enable submission latency
+        "test_id": 7,
+        "fio_opts": {
+            "output-format": "json",
+            "servers": [
+                    {
+                        "client" : 0,
+                        "jobfile": "test07-slat.fio",
+                    },
+                    {
+                        "client" : 1,
+                        "jobfile": "test07-slat.fio",
+                    },
+                ]
+            },
+        "test_class": ClientServerTestAllClientsLat,
+    },
+    {   # Enable completion latency
+        "test_id": 8,
+        "fio_opts": {
+            "output-format": "json",
+            "servers": [
+                    {
+                        "client" : 0,
+                        "jobfile": "test08-clat.fio",
+                    },
+                    {
+                        "client" : 1,
+                        "jobfile": "test08-clat.fio",
+                    },
+                ]
+            },
+        "test_class": ClientServerTestAllClientsLat,
+    },
+    {   # Enable total latency
+        "test_id": 9,
+        "fio_opts": {
+            "output-format": "json",
+            "servers": [
+                    {
+                        "client" : 0,
+                        "jobfile": "test09-lat.fio",
+                    },
+                    {
+                        "client" : 1,
+                        "jobfile": "test09-lat.fio",
+                    },
+                ]
+            },
+        "test_class": ClientServerTestAllClientsLat,
+    },
+    {   # Disable completion latency
+        "test_id": 10,
+        "fio_opts": {
+            "output-format": "json",
+            "servers": [
+                    {
+                        "client" : 0,
+                        "jobfile": "test10-noclat.fio",
+                    },
+                    {
+                        "client" : 1,
+                        "jobfile": "test10-noclat.fio",
+                    },
+                ]
+            },
+        "test_class": ClientServerTestAllClientsLat,
+    },
+    {   # Enable submission, completion, total latency
+        "test_id": 11,
+        "fio_opts": {
+            "output-format": "json",
+            "servers": [
+                    {
+                        "client" : 0,
+                        "jobfile": "test11-alllat.fio",
+                    },
+                    {
+                        "client" : 1,
+                        "jobfile": "test11-alllat.fio",
+                    },
+                ]
+            },
+        "test_class": ClientServerTestAllClientsLat,
+    },
+]
+
+
+def parse_args():
+    """Parse command-line arguments."""
+
+    parser = argparse.ArgumentParser()
+    parser.add_argument('-d', '--debug', help='Enable debug messages', action='store_true')
+    parser.add_argument('-f', '--fio', help='path to file executable (e.g., ./fio)')
+    parser.add_argument('-a', '--artifact-root', help='artifact root directory')
+    parser.add_argument('-s', '--skip', nargs='+', type=int,
+                        help='list of test(s) to skip')
+    parser.add_argument('-o', '--run-only', nargs='+', type=int,
+                        help='list of test(s) to run, skipping all others')
+    args = parser.parse_args()
+
+    return args
+
+
+def start_servers(fio_path, servers=SERVER_LIST):
+    """Start servers for our tests."""
+
+    for server in servers:
+        tmpfile = tempfile.mktemp()
+        cmd = [fio_path, f"--server={server}", f"--daemonize={tmpfile}"]
+        cmd_result = subprocess.run(cmd, capture_output=True, check=False,
+                                   encoding=locale.getpreferredencoding())
+        if cmd_result.returncode != 0:
+            logging.error("Unable to start server on %s: %s", server, cmd_result.stderr)
+            return False
+
+        logging.debug("Started server %s", server)
+        PIDFILE_LIST.append(tmpfile)
+
+    return True
+
+
+def stop_servers(pidfiles=PIDFILE_LIST):
+    """Stop running fio server invocations."""
+
+    for pidfile in pidfiles:
+        with open(pidfile, "r", encoding=locale.getpreferredencoding()) as file:
+            pid = file.read().strip()
+
+        cmd = ["kill", f"{pid}"]
+        cmd_result = subprocess.run(cmd, capture_output=True, check=False,
+                                   encoding=locale.getpreferredencoding())
+        if cmd_result.returncode != 0:
+            logging.error("Unable to kill server with PID %s: %s", pid, cmd_result.stderr)
+            return False
+        logging.debug("Sent stop signal to PID %s", pid)
+
+    return True
+
+
+def main():
+    """Run tests for fio's client/server mode."""
+
+    args = parse_args()
+
+    if args.debug:
+        logging.basicConfig(level=logging.DEBUG)
+    else:
+        logging.basicConfig(level=logging.INFO)
+
+    artifact_root = args.artifact_root if args.artifact_root else \
+        f"client_server-test-{time.strftime('%Y%m%d-%H%M%S')}"
+    os.mkdir(artifact_root)
+    print(f"Artifact directory is {artifact_root}")
+
+    if args.fio:
+        fio_path = str(Path(args.fio).absolute())
+    else:
+        fio_path = os.path.join(os.path.dirname(__file__), '../fio')
+    print(f"fio path is {fio_path}")
+
+    if not start_servers(fio_path):
+        sys.exit(1)
+    print("Servers started")
+
+    job_path = os.path.join(os.path.dirname(__file__), "client_server")
+    for test in TEST_LIST:
+        opts = test['fio_opts']
+        for server in opts['servers']:
+            server['client'] = SERVER_LIST[server['client']]
+            server['jobfile'] = os.path.join(job_path, server['jobfile'])
+
+    test_env = {
+              'fio_path': fio_path,
+              'fio_root': str(Path(__file__).absolute().parent.parent),
+              'artifact_root': artifact_root,
+              'basename': 'client_server',
+              }
+
+    _, failed, _ = run_fio_tests(TEST_LIST, test_env, args)
+
+    stop_servers()
+    sys.exit(failed)
+
+if __name__ == '__main__':
+    main()
diff --git a/t/client_server/test01.fio b/t/client_server/test01.fio
new file mode 100644
index 00000000..98927f56
--- /dev/null
+++ b/t/client_server/test01.fio
@@ -0,0 +1,14 @@
+[global]
+ioengine=null
+time_based
+runtime=3s
+filesize=1T
+
+[test1]
+description=test1
+
+[test2]
+description=test2
+
+[test3]
+description=test3
diff --git a/t/client_server/test04-noglobal.fio b/t/client_server/test04-noglobal.fio
new file mode 100644
index 00000000..1353f889
--- /dev/null
+++ b/t/client_server/test04-noglobal.fio
@@ -0,0 +1,20 @@
+[test1]
+description=test1
+ioengine=null
+time_based
+runtime=3s
+filesize=1T
+
+[test2]
+description=test2
+ioengine=null
+time_based
+runtime=3s
+filesize=1T
+
+[test3]
+description=test3
+ioengine=null
+time_based
+runtime=3s
+filesize=1T
diff --git a/t/client_server/test07-slat.fio b/t/client_server/test07-slat.fio
new file mode 100644
index 00000000..595c66b3
--- /dev/null
+++ b/t/client_server/test07-slat.fio
@@ -0,0 +1,7 @@
+[test]
+ioengine=null
+iodepth=2
+filesize=1T
+time_based
+runtime=3s
+slat_percentiles=1
diff --git a/t/client_server/test08-clat.fio b/t/client_server/test08-clat.fio
new file mode 100644
index 00000000..ef6ea512
--- /dev/null
+++ b/t/client_server/test08-clat.fio
@@ -0,0 +1,7 @@
+[test]
+ioengine=null
+iodepth=2
+filesize=1T
+time_based
+runtime=3s
+clat_percentiles=1
diff --git a/t/client_server/test09-lat.fio b/t/client_server/test09-lat.fio
new file mode 100644
index 00000000..87ef9093
--- /dev/null
+++ b/t/client_server/test09-lat.fio
@@ -0,0 +1,7 @@
+[test]
+ioengine=null
+iodepth=2
+filesize=1T
+time_based
+runtime=3s
+lat_percentiles=1
diff --git a/t/client_server/test10-noclat.fio b/t/client_server/test10-noclat.fio
new file mode 100644
index 00000000..a27213e6
--- /dev/null
+++ b/t/client_server/test10-noclat.fio
@@ -0,0 +1,7 @@
+[test]
+ioengine=null
+iodepth=2
+filesize=1T
+time_based
+runtime=3s
+clat_percentiles=0
diff --git a/t/client_server/test11-alllat.fio b/t/client_server/test11-alllat.fio
new file mode 100644
index 00000000..3404c2db
--- /dev/null
+++ b/t/client_server/test11-alllat.fio
@@ -0,0 +1,9 @@
+[test]
+ioengine=null
+iodepth=2
+filesize=1T
+time_based
+runtime=3s
+slat_percentiles=1
+clat_percentiles=1
+lat_percentiles=1
diff --git a/t/fiotestlib.py b/t/fiotestlib.py
index 466e482d..61adca14 100755
--- a/t/fiotestlib.py
+++ b/t/fiotestlib.py
@@ -322,19 +322,16 @@ class FioJobCmdTest(FioExeTest):
         #
         # Sometimes fio informational messages are included at the top of the
         # JSON output, especially under Windows. Try to decode output as JSON
-        # data, lopping off up to the first four lines
+        # data, skipping everything until the first {
         #
         lines = file_data.splitlines()
-        for i in range(5):
-            file_data = '\n'.join(lines[i:])
-            try:
-                self.json_data = json.loads(file_data)
-            except json.JSONDecodeError:
-                continue
-            else:
-                return True
+        file_data = '\n'.join(lines[lines.index("{"):])
+        try:
+            self.json_data = json.loads(file_data)
+        except json.JSONDecodeError:
+            return False
 
-        return False
+        return True
 
     @staticmethod
     def check_empty(job):
diff --git a/t/run-fio-tests.py b/t/run-fio-tests.py
index 384b6871..4ab670de 100755
--- a/t/run-fio-tests.py
+++ b/t/run-fio-tests.py
@@ -1081,6 +1081,14 @@ TEST_LIST = [
         'success':          SUCCESS_DEFAULT,
         'requirements':     [Requirements.linux, Requirements.nvmecdev],
     },
+    {
+        'test_id':          1016,
+        'test_class':       FioExeTest,
+        'exe':              't/client_server.py',
+        'parameters':       ['-f', '{fio_path}'],
+        'success':          SUCCESS_DEFAULT,
+        'requirements':     [Requirements.linux],
+    },
 ]
 
 
