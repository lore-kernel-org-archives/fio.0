Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:34410 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725775AbgE2MAY (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 29 May 2020 08:00:24 -0400
Received: from [65.144.74.35] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jedgU-0004lf-8p
        for fio@vger.kernel.org; Fri, 29 May 2020 12:00:22 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20200529120002.4D1621BC0CCA@kernel.dk>
Date: Fri, 29 May 2020 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit c96b385b6e0c78478697713e6da9174fba2432d3:

  t/zbd: make the test script easier to terminate (2020-05-25 18:21:45 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to dacac3b936092aa73e29257fefcb7bf5658ec7cb:

  Merge branch 'python3-testing' of https://github.com/vincentkfu/fio (2020-05-28 13:27:15 -0600)

----------------------------------------------------------------
Jens Axboe (2):
      Merge branch 'testing' of https://github.com/vincentkfu/fio
      Merge branch 'python3-testing' of https://github.com/vincentkfu/fio

Shin'ichiro Kawasaki (2):
      pshared: Add mutex_init_pshared_with_type()
      zbd: Fix compilation error on BSD

Vincent Fu (5):
      appveyor: use on_finish section to upload artifacts
      t/run-fio-tests: pass-through arguments to test scripts
      .travis: enable arm64 architecture builds
      testing: change two test scripts to refer to python3
      travis: install python3 scipy for Linux and macOS tests

 .appveyor.yml          |  6 +++---
 .travis.yml            | 26 ++++++++++++++++++--------
 pshared.c              | 15 ++++++++++++++-
 pshared.h              |  1 +
 t/run-fio-tests.py     | 27 ++++++++++++++++++---------
 t/steadystate_tests.py |  3 +--
 t/strided.py           |  3 +--
 zbd.c                  | 22 +++++++---------------
 8 files changed, 63 insertions(+), 40 deletions(-)

---

Diff of recent changes:

diff --git a/.appveyor.yml b/.appveyor.yml
index e2351be7..70c337f8 100644
--- a/.appveyor.yml
+++ b/.appveyor.yml
@@ -26,10 +26,10 @@ after_build:
 test_script:
   - 'bash.exe -lc "cd \"${APPVEYOR_BUILD_FOLDER}\" && file.exe fio.exe && make.exe test'
   - 'bash.exe -lc "cd \"${APPVEYOR_BUILD_FOLDER}\" && [ -f fio.exe ] && python.exe t/run-fio-tests.py --artifact-root test-artifacts --debug'
-  - 'bash.exe -lc "cd \"${APPVEYOR_BUILD_FOLDER}\" && [ -d test-artifacts ] && 7z a -t7z test-artifacts.7z test-artifacts -xr!foo.0.0 -xr!latency.?.0 -xr!fio_jsonplus_clat2csv.test'
 
 artifacts:
   - path: os\windows\*.msi
     name: msi
-  - path: test-artifacts.7z
-    name: test-artifacts
+
+on_finish:
+  - 'bash.exe -lc "cd \"${APPVEYOR_BUILD_FOLDER}\" && [ -d test-artifacts ] && 7z a -t7z test-artifacts.7z test-artifacts -xr!foo.0.0 -xr!latency.?.0 -xr!fio_jsonplus_clat2csv.test && appveyor PushArtifact test-artifacts.7z'
diff --git a/.travis.yml b/.travis.yml
index 77c31b77..eba16baa 100644
--- a/.travis.yml
+++ b/.travis.yml
@@ -5,6 +5,9 @@ os:
 compiler:
   - clang
   - gcc
+arch:
+  - amd64
+  - arm64
 env:
   matrix:
     - BUILD_ARCH="x86"
@@ -17,28 +20,34 @@ matrix:
     - os: osx
       compiler: clang # Workaround travis setting CC=["clang", "gcc"]
       env: BUILD_ARCH="x86_64"
+      arch: amd64
     # Latest xcode image (needs periodic updating)
     - os: osx
       compiler: clang
       osx_image: xcode11.2
       env: BUILD_ARCH="x86_64"
+      arch: amd64
   exclude:
     - os: osx
       compiler: gcc
-  exclude:
     - os: linux
       compiler: clang
+      arch: amd64
       env: BUILD_ARCH="x86" # Only do the gcc x86 build to reduce clutter
+    - os: linux
+      env: BUILD_ARCH="x86"
+      arch: arm64
+
 before_install:
   - EXTRA_CFLAGS="-Werror"
   - if [[ "$TRAVIS_OS_NAME" == "linux" ]]; then
         pkgs=(libaio-dev libcunit1 libcunit1-dev libgoogle-perftools4 libibverbs-dev libiscsi-dev libnuma-dev librbd-dev librdmacm-dev libz-dev);
         if [[ "$BUILD_ARCH" == "x86" ]]; then
             pkgs=("${pkgs[@]/%/:i386}");
-            pkgs+=(gcc-multilib python-scipy);
+            pkgs+=(gcc-multilib python3-scipy);
             EXTRA_CFLAGS="${EXTRA_CFLAGS} -m32";
         else
-            pkgs+=(glusterfs-common python-scipy);
+            pkgs+=(glusterfs-common python3-scipy);
         fi;
         sudo apt-get -qq update;
         sudo apt-get install --no-install-recommends -qq -y "${pkgs[@]}";
@@ -46,12 +55,13 @@ before_install:
   - if [[ "$TRAVIS_OS_NAME" == "osx" ]]; then
         brew update;
         brew install cunit;
-        if [[ "$TRAVIS_OSX_IMAGE" == "xcode11.2" ]]; then
-            pip3 install scipy;
-        fi;
-        pip install scipy;
+        pip3 install scipy;
     fi;
 script:
   - ./configure --extra-cflags="${EXTRA_CFLAGS}" && make
   - make test
-  - sudo python3 t/run-fio-tests.py --skip 6 1007 1008 --debug
+  - if [[ "$TRAVIS_CPU_ARCH" == "arm64" ]]; then
+        sudo python3 t/run-fio-tests.py --skip 6 1007 1008 --debug -p 1010:"--skip 15 16 17 18 19 20";
+    else
+        sudo python3 t/run-fio-tests.py --skip 6 1007 1008 --debug;
+    fi;
diff --git a/pshared.c b/pshared.c
index 21192556..791faf95 100644
--- a/pshared.c
+++ b/pshared.c
@@ -39,7 +39,7 @@ int cond_init_pshared(pthread_cond_t *cond)
 	return 0;
 }
 
-int mutex_init_pshared(pthread_mutex_t *mutex)
+int mutex_init_pshared_with_type(pthread_mutex_t *mutex, int type)
 {
 	pthread_mutexattr_t mattr;
 	int ret;
@@ -60,6 +60,14 @@ int mutex_init_pshared(pthread_mutex_t *mutex)
 		return ret;
 	}
 #endif
+	if (type) {
+		ret = pthread_mutexattr_settype(&mattr, type);
+		if (ret) {
+			log_err("pthread_mutexattr_settype: %s\n",
+				strerror(ret));
+			return ret;
+		}
+	}
 	ret = pthread_mutex_init(mutex, &mattr);
 	if (ret) {
 		log_err("pthread_mutex_init: %s\n", strerror(ret));
@@ -69,6 +77,11 @@ int mutex_init_pshared(pthread_mutex_t *mutex)
 	return 0;
 }
 
+int mutex_init_pshared(pthread_mutex_t *mutex)
+{
+	return mutex_init_pshared_with_type(mutex, 0);
+}
+
 int mutex_cond_init_pshared(pthread_mutex_t *mutex, pthread_cond_t *cond)
 {
 	int ret;
diff --git a/pshared.h b/pshared.h
index a58df6fe..f33be462 100644
--- a/pshared.h
+++ b/pshared.h
@@ -3,6 +3,7 @@
 
 #include <pthread.h>
 
+extern int mutex_init_pshared_with_type(pthread_mutex_t *, int);
 extern int mutex_init_pshared(pthread_mutex_t *);
 extern int cond_init_pshared(pthread_cond_t *);
 extern int mutex_cond_init_pshared(pthread_mutex_t *, pthread_cond_t *);
diff --git a/t/run-fio-tests.py b/t/run-fio-tests.py
index 763e0103..e7063d3e 100755
--- a/t/run-fio-tests.py
+++ b/t/run-fio-tests.py
@@ -122,10 +122,7 @@ class FioExeTest(FioTest):
     def run(self):
         """Execute the binary or script described by this instance."""
 
-        if self.parameters:
-            command = [self.exe_path] + self.parameters
-        else:
-            command = [self.exe_path]
+        command = [self.exe_path] + self.parameters
         command_file = open(self.command_file, "w+")
         command_file.write("%s\n" % command)
         command_file.close()
@@ -797,6 +794,8 @@ def parse_args():
                         help='provide debug output')
     parser.add_argument('-k', '--skip-req', action='store_true',
                         help='skip requirements checking')
+    parser.add_argument('-p', '--pass-through', action='append',
+                        help='pass-through an argument to an executable test')
     args = parser.parse_args()
 
     return args
@@ -811,6 +810,17 @@ def main():
     else:
         logging.basicConfig(level=logging.INFO)
 
+    pass_through = {}
+    if args.pass_through:
+        for arg in args.pass_through:
+            if not ':' in arg:
+                print("Invalid --pass-through argument '%s'" % arg)
+                print("Syntax for --pass-through is TESTNUMBER:ARGUMENT")
+                return
+            split = arg.split(":",1)
+            pass_through[int(split[0])] = split[1]
+        logging.debug("Pass-through arguments: %s" % pass_through)
+
     if args.fio_root:
         fio_root = args.fio_root
     else:
@@ -874,13 +884,12 @@ def main():
             if config['parameters']:
                 parameters = [p.format(fio_path=fio_path) for p in config['parameters']]
             else:
-                parameters = None
+                parameters = []
             if Path(exe_path).suffix == '.py' and platform.system() == "Windows":
-                if parameters:
-                    parameters.insert(0, exe_path)
-                else:
-                    parameters = [exe_path]
+                parameters.insert(0, exe_path)
                 exe_path = "python.exe"
+            if config['test_id'] in pass_through:
+                parameters += pass_through[config['test_id']].split()
             test = config['test_class'](exe_path, parameters,
                                         config['success'])
         else:
diff --git a/t/steadystate_tests.py b/t/steadystate_tests.py
index e99b655c..e8bd768c 100755
--- a/t/steadystate_tests.py
+++ b/t/steadystate_tests.py
@@ -1,5 +1,4 @@
-#!/usr/bin/env python
-# Note: this script is python2 and python3 compatible.
+#!/usr/bin/env python3
 #
 # steadystate_tests.py
 #
diff --git a/t/strided.py b/t/strided.py
index 6d34be8a..45e6f148 100755
--- a/t/strided.py
+++ b/t/strided.py
@@ -1,5 +1,4 @@
-#!/usr/bin/python
-# Note: this script is python2 and python3 compatible.
+#!/usr/bin/env python3
 #
 # strided.py
 #
diff --git a/zbd.c b/zbd.c
index 72352db0..a7572c9a 100644
--- a/zbd.c
+++ b/zbd.c
@@ -19,6 +19,7 @@
 #include "oslib/asprintf.h"
 #include "smalloc.h"
 #include "verify.h"
+#include "pshared.h"
 #include "zbd.h"
 
 /**
@@ -353,7 +354,6 @@ static int init_zone_info(struct thread_data *td, struct fio_file *f)
 	struct fio_zone_info *p;
 	uint64_t zone_size = td->o.zone_size;
 	struct zoned_block_device_info *zbd_info = NULL;
-	pthread_mutexattr_t attr;
 	int i;
 
 	if (zone_size == 0) {
@@ -374,14 +374,12 @@ static int init_zone_info(struct thread_data *td, struct fio_file *f)
 	if (!zbd_info)
 		return -ENOMEM;
 
-	pthread_mutexattr_init(&attr);
-	pthread_mutexattr_setpshared(&attr, true);
-	pthread_mutex_init(&zbd_info->mutex, &attr);
-	pthread_mutexattr_settype(&attr, PTHREAD_MUTEX_RECURSIVE);
+	mutex_init_pshared(&zbd_info->mutex);
 	zbd_info->refcount = 1;
 	p = &zbd_info->zone_info[0];
 	for (i = 0; i < nr_zones; i++, p++) {
-		pthread_mutex_init(&p->mutex, &attr);
+		mutex_init_pshared_with_type(&p->mutex,
+					     PTHREAD_MUTEX_RECURSIVE);
 		p->start = i * zone_size;
 		p->wp = p->start + zone_size;
 		p->type = ZBD_ZONE_TYPE_SWR;
@@ -395,7 +393,6 @@ static int init_zone_info(struct thread_data *td, struct fio_file *f)
 	f->zbd_info->zone_size_log2 = is_power_of_2(zone_size) ?
 		ilog2(zone_size) : 0;
 	f->zbd_info->nr_zones = nr_zones;
-	pthread_mutexattr_destroy(&attr);
 	return 0;
 }
 
@@ -415,12 +412,8 @@ static int parse_zone_info(struct thread_data *td, struct fio_file *f)
 	struct fio_zone_info *p;
 	uint64_t zone_size, offset;
 	struct zoned_block_device_info *zbd_info = NULL;
-	pthread_mutexattr_t attr;
 	int i, j, ret = 0;
 
-	pthread_mutexattr_init(&attr);
-	pthread_mutexattr_setpshared(&attr, true);
-
 	zones = calloc(ZBD_REPORT_MAX_ZONES, sizeof(struct zbd_zone));
 	if (!zones)
 		goto out;
@@ -454,14 +447,14 @@ static int parse_zone_info(struct thread_data *td, struct fio_file *f)
 	ret = -ENOMEM;
 	if (!zbd_info)
 		goto out;
-	pthread_mutex_init(&zbd_info->mutex, &attr);
-	pthread_mutexattr_settype(&attr, PTHREAD_MUTEX_RECURSIVE);
+	mutex_init_pshared(&zbd_info->mutex);
 	zbd_info->refcount = 1;
 	p = &zbd_info->zone_info[0];
 	for (offset = 0, j = 0; j < nr_zones;) {
 		z = &zones[0];
 		for (i = 0; i < nrz; i++, j++, z++, p++) {
-			pthread_mutex_init(&p->mutex, &attr);
+			mutex_init_pshared_with_type(&p->mutex,
+						     PTHREAD_MUTEX_RECURSIVE);
 			p->start = z->start;
 			switch (z->cond) {
 			case ZBD_ZONE_COND_NOT_WP:
@@ -512,7 +505,6 @@ static int parse_zone_info(struct thread_data *td, struct fio_file *f)
 out:
 	sfree(zbd_info);
 	free(zones);
-	pthread_mutexattr_destroy(&attr);
 	return ret;
 }
 

