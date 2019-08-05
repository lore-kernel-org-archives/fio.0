Return-Path: <rebecca@bsdio.com>
From: Rebecca Cran <rebecca@bsdio.com>
Subject: [PATCH] Add tests from t/ to the Windows installer
Date: Mon,  5 Aug 2019 13:11:00 -0700
Message-Id: <20190805201100.4575-1-rebecca@bsdio.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, Vincent Fu <vincentfu@gmail.com>
Cc: Rebecca Cran <rebecca@bsdio.com>
List-ID: <fio@vger.kernel.org>

---
 os/windows/install.wxs | 34 ++++++++++++++++++++++++++++++++++
 1 file changed, 34 insertions(+)

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
-- 
2.21.0


