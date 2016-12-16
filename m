Return-Path: <dave.jiang@intel.com>
Subject: [PATCH] fio: add additional support for dev-dax ioengine
From: Dave Jiang <dave.jiang@intel.com>
Date: Fri, 16 Dec 2016 15:59:06 -0700
Message-ID: <148192914644.212226.6107445930190025121.stgit@djiang5-desk3.ch.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: axboe@kernel.dk
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

Fixup options.c to add the dev-dax to ioengine list. Update fio.1 and
HOWTO as well. Also adding example fio job file.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 HOWTO                |    3 +++
 examples/dev-dax.fio |   45 +++++++++++++++++++++++++++++++++++++++++++++
 fio.1                |    3 +++
 options.c            |    5 +++++
 4 files changed, 56 insertions(+)
 create mode 100644 examples/dev-dax.fio

diff --git a/HOWTO b/HOWTO
index 3f8acee..b0f92cf 100644
--- a/HOWTO
+++ b/HOWTO
@@ -819,6 +819,9 @@ ioengine=str	Defines how the job issues io to the file. The following
 			pmemblk	Read and write through the NVML libpmemblk
 				interface.
 
+			dev-dax Read and write through a DAX device exposed
+				from persistent memory.
+
 			external Prefix to specify loading an external
 				IO engine object file. Append the engine
 				filename, eg ioengine=external:/tmp/foo.o
diff --git a/examples/dev-dax.fio b/examples/dev-dax.fio
new file mode 100644
index 0000000..d9f430e
--- /dev/null
+++ b/examples/dev-dax.fio
@@ -0,0 +1,45 @@
+[global]
+bs=2m
+ioengine=dev-dax
+norandommap
+time_based=1
+runtime=30
+group_reporting
+disable_lat=1
+disable_slat=1
+disable_clat=1
+clat_percentiles=0
+cpus_allowed_policy=split
+
+# For the dev-dax engine:
+#
+#   IOs always complete immediately
+#   IOs are always direct
+#
+iodepth=1
+direct=0
+thread=1
+numjobs=16
+#
+# The dev-dax engine does IO to DAX device that are special character
+# devices exported by the kernel (e.g. /dev/dax0.0). The device is
+# opened normally and then the region is accessible via mmap. We do
+# not use the O_DIRECT flag because the device is naturally direct
+# access. The O_DIRECT flags will result in failure. The engine
+# access the underlying NVDIMM directly once the mmapping is setup.
+#
+# Check the alignment requirement of your DAX device. Currently the default
+# should be 2M. Blocksize (bs) should meet alignment requirement.
+#
+# An example of creating a dev dax device node from pmem:
+# ndctl create-namespace --reconfig=namespace0.0 --mode=dax --force
+#
+filename=/dev/dax0.0
+
+[dev-dax-write]
+rw=randwrite
+stonewall
+
+[dev-dax-read]
+rw=randread
+stonewall
diff --git a/fio.1 b/fio.1
index 48c2060..baef382 100644
--- a/fio.1
+++ b/fio.1
@@ -722,6 +722,9 @@ constraint.
 .TP
 .B pmemblk
 Read and write through the NVML libpmemblk interface.
+.TP
+.B dev-dax
+Read and write through a DAX device exposed from persistent memory.
 .RE
 .P
 .RE
diff --git a/options.c b/options.c
index 3c9adfb..72c001b 100644
--- a/options.c
+++ b/options.c
@@ -1698,6 +1698,11 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 			  },
 
 #endif
+#ifdef CONFIG_LINUX_DEVDAX
+			  { .ival = "dev-dax",
+			    .help = "DAX Device based IO engine",
+			  },
+#endif
 			  { .ival = "external",
 			    .help = "Load external engine (append name)",
 			  },


