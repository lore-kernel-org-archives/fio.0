Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:59180 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726092AbfHFMAJ (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 6 Aug 2019 08:00:09 -0400
Received: from [65.144.74.35] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.92 #3 (Red Hat Linux))
        id 1huy8N-0002I4-Uv
        for fio@vger.kernel.org; Tue, 06 Aug 2019 12:00:08 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20190806120001.D0D702C0099@kernel.dk>
Date: Tue,  6 Aug 2019 06:00:01 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit acd44dec8cfa476d91dc1695df64f249e52d06e3:

  nbd: Remove copy and paste error in example (2019-08-03 09:51:44 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to c1f6f32ea74316df1e8707eba4fb95ab14fae6f7:

  Add tests from t/ to the Windows installer (2019-08-05 14:45:50 -0600)

----------------------------------------------------------------
Rebecca Cran (1):
      Add tests from t/ to the Windows installer

 os/windows/install.wxs | 34 ++++++++++++++++++++++++++++++++++
 1 file changed, 34 insertions(+)

---

Diff of recent changes:

diff --git a/os/windows/install.wxs b/os/windows/install.wxs
index 97d88e9f..dcb8c92c 100755
--- a/os/windows/install.wxs
+++ b/os/windows/install.wxs
@@ -43,6 +43,32 @@
 							<File Id="MORAL_LICENSE" Name="MORAL-LICENSE.txt" Source="..\..\MORAL-LICENSE"/>
 						</Component>
 						<Directory Id="examples" Name="examples"/>
+						<Directory Id="tests" Name="tests">
+							<Component>
+								<File Source="../../t/fio-genzipf.exe"/>
+							</Component>
+							<Component>
+								<File Source="../../t/fio-dedupe.exe"/>
+							</Component>
+							<Component>
+								<File Source="../../t/stest.exe"/>
+							</Component>
+							<Component>
+								<File Source="../../t/ieee754.exe"/>
+							</Component>
+							<Component>
+								<File Source="../../t/axmap.exe"/>
+							</Component>
+							<Component>
+								<File Source="../../t/lfsr-test.exe"/>
+							</Component>
+							<Component>
+								<File Source="../../t/gen-rand.exe"/>
+							</Component>
+							<Component>
+								<File Source="../../t/fio-verify-state.exe"/>
+							</Component>
+						</Directory>
 					</Directory>
 				</Directory>
 			</Directory>
@@ -56,6 +82,14 @@
 		<ComponentRef Id="COPYING"/>
 		<ComponentRef Id="MORAL_LICENSE"/>
 		<ComponentGroupRef Id="examples"/>
+		<ComponentRef Id="fio_genzipf.exe"/>
+		<ComponentRef Id="fio_dedupe.exe"/>
+		<ComponentRef Id="stest.exe"/>
+		<ComponentRef Id="ieee754.exe"/>
+		<ComponentRef Id="axmap.exe"/>
+		<ComponentRef Id="lfsr_test.exe"/>
+		<ComponentRef Id="gen_rand.exe"/>
+		<ComponentRef Id="fio_verify_state.exe"/>
 	</Feature>
 
 	<Property Id="ARPURLINFOABOUT" Value="http://git.kernel.dk/cgit/fio/" />

