Return-Path: <prvs=873f0fbe3=Niklas.Cassel@wdc.com>
From: Niklas Cassel <Niklas.Cassel@wdc.com>
Subject: [PATCH v2 03/11] tools: fiograph: do not overwrite input script file
Date: Fri, 3 Sep 2021 15:20:22 +0000
Message-ID: <20210903152012.18035-4-Niklas.Cassel@wdc.com>
References: <20210903152012.18035-1-Niklas.Cassel@wdc.com>
In-Reply-To: <20210903152012.18035-1-Niklas.Cassel@wdc.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: "axboe@kernel.dk" <axboe@kernel.dk>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>, Damien Le Moal <Damien.LeMoal@wdc.com>, Niklas Cassel <Niklas.Cassel@wdc.com>
List-ID: <fio@vger.kernel.org>

From: Damien Le Moal <damien.lemoal@wdc.com>

In fiograph.py, the setup_commandline() function mistakenly initializes
the output_file variable to the input fio script file, causing this file
to always be overwritten, even if an output file is specified using the
--output option. Fix this by properly initializing the output_file
variable using the --output option argument value. If an output file
name is not provided, the input script file name is used by default.

Also fix fiograph configuration file to remove the cmdprio_percentage
option repeated entry for io_uring and libaio.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
---
 tools/fiograph/fiograph.conf | 4 ++--
 tools/fiograph/fiograph.py   | 4 +++-
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/tools/fiograph/fiograph.conf b/tools/fiograph/fiograph.conf
index 5becc4d9..1957e11d 100644
--- a/tools/fiograph/fiograph.conf
+++ b/tools/fiograph/fiograph.conf
@@ -51,10 +51,10 @@ specific_options=3Dhttps  http_host  http_user  http_pa=
ss  http_s3_key  http_s3_ke
 specific_options=3Dime_psync  ime_psyncv
=20
 [ioengine_io_uring]
-specific_options=3Dhipri  cmdprio_percentage  cmdprio_percentage  fixedbuf=
s  registerfiles  sqthread_poll  sqthread_poll_cpu  nonvectored  uncached  =
nowait  force_async
+specific_options=3Dhipri  cmdprio_percentage  fixedbufs  registerfiles  sq=
thread_poll  sqthread_poll_cpu  nonvectored  uncached  nowait  force_async
=20
 [ioengine_libaio]
-specific_options=3Duserspace_reap  cmdprio_percentage  cmdprio_percentage =
 nowait
+specific_options=3Duserspace_reap  cmdprio_percentage  nowait
=20
 [ioengine_libcufile]
 specific_options=3Dgpu_dev_ids  cuda_io
diff --git a/tools/fiograph/fiograph.py b/tools/fiograph/fiograph.py
index 7695c964..b5669a2d 100755
--- a/tools/fiograph/fiograph.py
+++ b/tools/fiograph/fiograph.py
@@ -292,9 +292,11 @@ def setup_commandline():
 def main():
     global config_file
     args =3D setup_commandline()
-    output_file =3D args.file
     if args.output is None:
+        output_file =3D args.file
         output_file =3D output_file.replace('.fio', '')
+    else:
+        output_file =3D args.output
     config_file =3D configparser.RawConfigParser(allow_no_value=3DTrue)
     config_file.read(args.config)
     fio_to_graphviz(args.file, args.format).render(output_file, view=3Darg=
s.view)
--=20
2.31.1

