Return-Path: <rebecca@bluestop.org>
From: Rebecca Cran <rebecca@bluestop.org>
Subject: [PATCH] Windows: update download URL and add missing examples
Date: Tue,  4 Sep 2018 18:14:23 -0600
Message-Id: <20180905001423.8412-1-rebecca@bluestop.org>
To: fio@vger.kernel.org
Cc: axboe@kernel.dk, Rebecca Cran <rebecca@bluestop.org>
List-ID: <fio@vger.kernel.org>

---
 os/windows/examples.wxs | 90 ++++++++++++++++++++++++++++++++++++-----
 os/windows/install.wxs  |  2 +-
 2 files changed, 82 insertions(+), 10 deletions(-)

diff --git a/os/windows/examples.wxs b/os/windows/examples.wxs
index cc2ff5c8..e8580d91 100755
--- a/os/windows/examples.wxs
+++ b/os/windows/examples.wxs
@@ -3,16 +3,22 @@
     <Fragment>
         <DirectoryRef Id="examples">
                 <Component>
-                    <File Source="..\..\examples\1mbs_clients.fio" />
+                  <File Source="..\..\examples\1mbs_clients.fio" />
                 </Component>
                 <Component>
-                    <File Source="..\..\examples\aio-read.fio" />
+                  <File Source="..\..\examples\aio-read.fio" />
                 </Component>
                 <Component>
-                    <File Source="..\..\examples\backwards-read.fio" />
+                  <File Source="..\..\examples\backwards-read.fio" />
                 </Component>
                 <Component>
-                    <File Source="..\..\examples\basic-verify.fio" />
+                  <File Source="..\..\examples\basic-verify.fio" />
+                </Component>
+                <Component>
+                  <File Source="..\..\examples\butterfly.fio" />
+                </Component>
+                <Component>
+                  <File Source="..\..\examples\cpp_null.fio" />
                 </Component>
                 <Component>
                   <File Source="..\..\examples\cpuio.fio" />
@@ -21,7 +27,7 @@
                   <File Source="..\..\examples\dev-dax.fio" />
                 </Component>
                 <Component>
-                    <File Source="..\..\examples\disk-zone-profile.fio" />
+                  <File Source="..\..\examples\disk-zone-profile.fio" />
                 </Component>
                 <Component>
                   <File Source="..\..\examples\e4defrag.fio" />
@@ -35,6 +41,27 @@
                 <Component>
                   <File Source="..\..\examples\falloc.fio" />
                 </Component>
+                <Component>
+                  <File Source="..\..\examples\filecreate-ioengine.fio" />
+                </Component>
+                <Component>
+                  <File Source="..\..\examples\fio-rand-read.job" />
+                </Component>
+                <Component>
+                  <File Source="..\..\examples\fio-rand-RW.job" />
+                </Component>
+                <Component>
+                  <File Source="..\..\examples\fio-rand-write.job" />
+                </Component>
+                <Component>
+                  <File Source="..\..\examples\fio-seq-read.job" />
+                </Component>
+                <Component>
+                  <File Source="..\..\examples\fio-seq-RW.job" />
+                </Component>
+                <Component>
+                  <File Source="..\..\examples\fio-seq-write.job" />
+                </Component>
                 <Component>
                   <File Source="..\..\examples\fixed-rate-submission.fio" />
                 </Component>
@@ -42,7 +69,10 @@
                   <File Source="..\..\examples\flow.fio" />
                 </Component>
                 <Component>
-                    <File Source="..\..\examples\fsx.fio" />
+                  <File Source="..\..\examples\fsx.fio" />
+                </Component>
+                <Component>
+                  <File Source="..\..\examples\ftruncate.fio" />
                 </Component>
                 <Component>
                   <File Source="..\..\examples\fusion-aw-sync.fio" />
@@ -51,7 +81,25 @@
                   <File Source="..\..\examples\gfapi.fio" />
                 </Component>
                 <Component>
-                    <File Source="..\..\examples\iometer-file-access-server.fio" />
+                  <File Source="..\..\examples\gpudirect-rdmaio-client.fio" />
+                </Component>
+                <Component>
+                  <File Source="..\..\examples\gpudirect-rdmaio-server.fio" />
+                </Component>
+                <Component>
+                  <File Source="..\..\examples\http-s3.fio" />
+                </Component>
+                <Component>
+                  <File Source="..\..\examples\http-swift.fio" />
+                </Component>
+                <Component>
+                  <File Source="..\..\examples\http-webdav.fio" />
+                </Component>
+                <Component>
+                  <File Source="..\..\examples\ime.fio" />
+                </Component>
+                <Component>
+                  <File Source="..\..\examples\iometer-file-access-server.fio" />
                 </Component>
                 <Component>
                   <File Source="..\..\examples\jesd219.fio" />
@@ -62,14 +110,17 @@
                 <Component>
                   <File Source="..\..\examples\libhdfs.fio" />
                 </Component>
+                <Component>
+                  <File Source="..\..\examples\libpmem.fio" />
+                </Component>
                 <Component>
                   <File Source="..\..\examples\mtd.fio" />
                 </Component>
                 <Component>
-                    <File Source="..\..\examples\netio.fio" />
+                  <File Source="..\..\examples\netio.fio" />
                 </Component>
                 <Component>
-                    <File Source="..\..\examples\netio_multicast.fio" />
+                  <File Source="..\..\examples\netio_multicast.fio" />
                 </Component>
                 <Component>
                   <File Source="..\..\examples\null.fio" />
@@ -83,6 +134,9 @@
                 <Component>
                   <File Source="..\..\examples\poisson-rate-submission.fio" />
                 </Component>
+                <Component>
+                  <File Source="..\..\examples\rados.fio" />
+                </Component>
                 <Component>
                   <File Source="..\..\examples\rand-zones.fio" />
                 </Component>
@@ -124,6 +178,8 @@
             <ComponentRef Id="aio_read.fio" />
             <ComponentRef Id="backwards_read.fio" />
             <ComponentRef Id="basic_verify.fio" />
+            <ComponentRef Id="butterfly.fio"/>
+            <ComponentRef Id="cpp_null.fio"/>
             <ComponentRef Id="cpuio.fio" />
             <ComponentRef Id="dev_dax.fio" />
             <ComponentRef Id="disk_zone_profile.fio" />
@@ -131,15 +187,30 @@
             <ComponentRef Id="e4defrag2.fio" />
             <ComponentRef Id="enospc_pressure.fio" />
             <ComponentRef Id="falloc.fio" />
+            <ComponentRef Id="filecreate_ioengine.fio"/>
+            <ComponentRef Id="fio_rand_read.job"/>
+            <ComponentRef Id="fio_rand_RW.job"/>
+            <ComponentRef Id="fio_rand_write.job"/>
+            <ComponentRef Id="fio_seq_read.job"/>
+            <ComponentRef Id="fio_seq_RW.job"/>
+            <ComponentRef Id="fio_seq_write.job"/>
             <ComponentRef Id="fixed_rate_submission.fio" />
             <ComponentRef Id="flow.fio" />
             <ComponentRef Id="fsx.fio" />
+            <ComponentRef Id="ftruncate.fio"/>
             <ComponentRef Id="fusion_aw_sync.fio" />
             <ComponentRef Id="gfapi.fio" />
+            <ComponentRef Id="gpudirect_rdmaio_client.fio"/>
+            <ComponentRef Id="gpudirect_rdmaio_server.fio"/>
+            <ComponentRef Id="http_s3.fio"/>
+            <ComponentRef Id="http_swift.fio"/>
+            <ComponentRef Id="http_webdav.fio"/>
+            <ComponentRef Id="ime.fio"/>
             <ComponentRef Id="iometer_file_access_server.fio" />
             <ComponentRef Id="jesd219.fio" />
             <ComponentRef Id="latency_profile.fio" />
             <ComponentRef Id="libhdfs.fio" />
+            <ComponentRef Id="libpmem.fio"/>
             <ComponentRef Id="mtd.fio" />
             <ComponentRef Id="netio.fio" />
             <ComponentRef Id="netio_multicast.fio" />
@@ -147,6 +218,7 @@
             <ComponentRef Id="numa.fio" />
             <ComponentRef Id="pmemblk.fio" />
             <ComponentRef Id="poisson_rate_submission.fio" />
+            <ComponentRef Id="rados.fio"/>
             <ComponentRef Id="rand_zones.fio" />
             <ComponentRef Id="rbd.fio" />
             <ComponentRef Id="rdmaio_client.fio" />
diff --git a/os/windows/install.wxs b/os/windows/install.wxs
index 73b28103..97d88e9f 100755
--- a/os/windows/install.wxs
+++ b/os/windows/install.wxs
@@ -61,7 +61,7 @@
 	<Property Id="ARPURLINFOABOUT" Value="http://git.kernel.dk/cgit/fio/" />
 	<Property Id='ARPCONTACT'>fio@vger.kernel.org</Property>
 	<Property Id='ARPHELPLINK'>http://www.spinics.net/lists/fio/</Property>
-	<Property Id='ARPURLUPDATEINFO'>http://bluestop.org/fio/</Property>
+	<Property Id='ARPURLUPDATEINFO'>https://bluestop.org/fio/</Property>
 
 	<WixVariable Id="WixUILicenseRtf" Value="eula.rtf" />
 
-- 
2.17.0


