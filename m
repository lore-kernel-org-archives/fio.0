Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF53C367
	for <fio@vger.kernel.org>; Fri,  8 Mar 2024 13:00:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709902819; cv=none; b=DM1cuwzD0eXufET+hJ8VYLJYTvHx6hNX8yXkc4X5uIDGhwEz/mg7fW1w9E3uzmJv/6tKiqjdhRXOnW8VPfM0GrnekpMkyLCEXBqF2qwOSZ97jAlpiyQuc5/AGceWTBgtPrYjel94nKOaog98CdiyYG1uF14CU15kYu9tmIAhwH4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709902819; c=relaxed/simple;
	bh=iUYj98K6ouKSiyq/hhaskuQ+iGsB15yNTRhqMPWrNAQ=;
	h=Subject:From:To:Message-Id:Date; b=eigSyJOAXTIKMN6LeoPbFLvLR1mHG2kWFGdUycWFPQl8BH74+uittV42my7LCuWWzrioIgY2qTeQXmX2j1xPWIcgwU4w9FT1W7X3OKxLqfPhRfTqqtPuPfiBxqB5zuokKUnUlCALEUIPIaF+M+I/pAkhb6ImiEwv4lE99NcOpZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=fail smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=jTBfeHjb; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="jTBfeHjb"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Date:Message-Id:To:From:Subject:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=ImGerN4m9ZVUPTiPD5JEFTIXdi42UO5eukQuKsGRkyk=; b=jTBfeHjbawDVHdyS9SUZPvmWCC
	nSM8fUuoKEMDHX0gTK48D63TuAwkI2N9s4DwY6b4DFzi3jAMu65iBAa86F9GQeOBMmVJLtKLyvuIn
	CCEju4Vb+762gSnpPSkRQ0coBu+8vnAMWTOU2qvqFpeRxjjzvKgvP/IIc2eZD/zqczx2/KOFl5h6P
	EASI5u45uCpIT0iEjX/a4tAJljFKcL+5FDKy4jXpc8rWceSHvSOPohDgwOFYU2cBZ5agPkwk2h7rE
	GEJ+fw7PJ2K+FNlmhWDl+aym0ewb1waQEdgmfSRDOIPPY9/NdKRUtleXRancoAdXPty0b/ugncGPm
	MEEqNSdg==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by casper.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1riZpb-0000000BXTz-45SV
	for fio@vger.kernel.org;
	Fri, 08 Mar 2024 13:00:12 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id C225B1BC012F; Fri,  8 Mar 2024 06:00:01 -0700 (MST)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20240308130001.C225B1BC012F@kernel.dk>
Date: Fri,  8 Mar 2024 06:00:01 -0700 (MST)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>

The following changes since commit 9b699fb150bbed56939d317ffc004b3bf19f098f:

  Doc: Make note of using bsrange with ':' (2024-03-05 10:54:36 -0500)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to b140fc5e484638a467480e369485b91290288d58:

  t/nvmept_pi: add support for xNVMe ioengine (2024-03-07 19:36:30 +0000)

----------------------------------------------------------------
Vincent Fu (6):
      examples: update plot for cmdprio-bssplit
      examples: add plots for xNVMe examples
      examples: add fiograph plot for uring-cmd-trim-multi-range
      examples: add fiograph plots for netio_vsock examples
      t/nvmept_pi: drop JSON output for error cases
      t/nvmept_pi: add support for xNVMe ioengine

 examples/cmdprio-bssplit.png            | Bin 45606 -> 134359 bytes
 examples/netio_vsock.png                | Bin 0 -> 46920 bytes
 examples/netio_vsock_receiver.png       | Bin 0 -> 34879 bytes
 examples/netio_vsock_sender.png         | Bin 0 -> 35539 bytes
 examples/uring-cmd-trim-multi-range.png | Bin 0 -> 67853 bytes
 examples/xnvme-fdp.png                  | Bin 0 -> 53284 bytes
 examples/xnvme-pi.png                   | Bin 0 -> 76492 bytes
 t/nvmept_pi.py                          |  18 +++++++++++-------
 8 files changed, 11 insertions(+), 7 deletions(-)
 create mode 100644 examples/netio_vsock.png
 create mode 100644 examples/netio_vsock_receiver.png
 create mode 100644 examples/netio_vsock_sender.png
 create mode 100644 examples/uring-cmd-trim-multi-range.png
 create mode 100644 examples/xnvme-fdp.png
 create mode 100644 examples/xnvme-pi.png

---

Diff of recent changes:

diff --git a/examples/cmdprio-bssplit.png b/examples/cmdprio-bssplit.png
index a0bb3ff4..83a5570b 100644
Binary files a/examples/cmdprio-bssplit.png and b/examples/cmdprio-bssplit.png differ
diff --git a/examples/netio_vsock.png b/examples/netio_vsock.png
new file mode 100644
index 00000000..01aadde5
Binary files /dev/null and b/examples/netio_vsock.png differ
diff --git a/examples/netio_vsock_receiver.png b/examples/netio_vsock_receiver.png
new file mode 100644
index 00000000..524a7a1c
Binary files /dev/null and b/examples/netio_vsock_receiver.png differ
diff --git a/examples/netio_vsock_sender.png b/examples/netio_vsock_sender.png
new file mode 100644
index 00000000..75802aaf
Binary files /dev/null and b/examples/netio_vsock_sender.png differ
diff --git a/examples/uring-cmd-trim-multi-range.png b/examples/uring-cmd-trim-multi-range.png
new file mode 100644
index 00000000..c3ffd546
Binary files /dev/null and b/examples/uring-cmd-trim-multi-range.png differ
diff --git a/examples/xnvme-fdp.png b/examples/xnvme-fdp.png
new file mode 100644
index 00000000..7f802741
Binary files /dev/null and b/examples/xnvme-fdp.png differ
diff --git a/examples/xnvme-pi.png b/examples/xnvme-pi.png
new file mode 100644
index 00000000..def7e680
Binary files /dev/null and b/examples/xnvme-pi.png differ
diff --git a/t/nvmept_pi.py b/t/nvmept_pi.py
index 5de77c9d..df7c0b9f 100755
--- a/t/nvmept_pi.py
+++ b/t/nvmept_pi.py
@@ -43,13 +43,11 @@ class DifDixTest(FioJobCmdTest):
 
         fio_args = [
             "--name=nvmept_pi",
-            "--ioengine=io_uring_cmd",
-            "--cmd_type=nvme",
+            f"--ioengine={self.fio_opts['ioengine']}",
             f"--filename={self.fio_opts['filename']}",
             f"--rw={self.fio_opts['rw']}",
             f"--bsrange={self.fio_opts['bsrange']}",
             f"--output={self.filenames['output']}",
-            f"--output-format={self.fio_opts['output-format']}",
             f"--md_per_io_size={self.fio_opts['md_per_io_size']}",
             f"--pi_act={self.fio_opts['pi_act']}",
             f"--pi_chk={self.fio_opts['pi_chk']}",
@@ -58,11 +56,18 @@ class DifDixTest(FioJobCmdTest):
         ]
         for opt in ['fixedbufs', 'nonvectored', 'force_async', 'registerfiles',
                     'sqthread_poll', 'sqthread_poll_cpu', 'hipri', 'nowait',
-                    'time_based', 'runtime', 'verify', 'io_size', 'offset', 'number_ios']:
+                    'time_based', 'runtime', 'verify', 'io_size', 'offset', 'number_ios',
+                    'output-format']:
             if opt in self.fio_opts:
                 option = f"--{opt}={self.fio_opts[opt]}"
                 fio_args.append(option)
 
+        if self.fio_opts['ioengine'] == 'io_uring_cmd':
+            fio_args.append('--cmd_type=nvme')
+        elif self.fio_opts['ioengine'] == 'xnvme':
+            fio_args.append('--thread=1')
+            fio_args.append('--xnvme_async=io_uring_cmd')
+
         super().setup(fio_args)
 
 
@@ -622,7 +627,6 @@ TEST_LIST = [
         "fio_opts": {
             "rw": 'read',
             "number_ios": NUMBER_IOS,
-            "output-format": "json",
             "pi_act": 0,
             "apptag": "0x8888",
             "apptag_mask": "0x0FFF",
@@ -639,7 +643,6 @@ TEST_LIST = [
         "fio_opts": {
             "rw": 'read',
             "number_ios": NUMBER_IOS,
-            "output-format": "json",
             "pi_act": 0,
             "apptag": "0x8888",
             "apptag_mask": "0x0FFF",
@@ -660,7 +663,6 @@ TEST_LIST = [
         "fio_opts": {
             "rw": 'read',
             "number_ios": NUMBER_IOS,
-            "output-format": "json",
             "pi_act": 0,
             "apptag": "0x8888",
             "apptag_mask": "0x0FFF",
@@ -689,6 +691,7 @@ def parse_args():
                         '(e.g., /dev/ng0n1). WARNING: THIS IS A DESTRUCTIVE TEST', required=True)
     parser.add_argument('-l', '--lbaf', nargs='+', type=int,
                         help='list of lba formats to test')
+    parser.add_argument('-i', '--ioengine', default='io_uring_cmd')
     args = parser.parse_args()
 
     return args
@@ -909,6 +912,7 @@ def main():
 
     for test in TEST_LIST:
         test['fio_opts']['filename'] = args.dut
+        test['fio_opts']['ioengine'] = args.ioengine
 
     test_env = {
               'fio_path': fio_path,
