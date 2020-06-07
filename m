Return-Path: <bart.vanassche@gmail.com>
Return-Path: <bart.vanassche@gmail.com>
From: Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 1/5] .travis.yml: Move shell code out of .travis.yml
Date: Sun,  7 Jun 2020 12:11:00 -0700
Message-Id: <20200607191104.17550-2-bvanassche@acm.org>
In-Reply-To: <20200607191104.17550-1-bvanassche@acm.org>
References: <20200607191104.17550-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org, Sitsofe Wheeler <sitsofe@yahoo.com>, Vincent Fu <vincent.fu@wdc.com>, Bart Van Assche <bvanassche@acm.org>
List-ID: <fio@vger.kernel.org>

Shell code in a .travis.yml file is hard to test. Make it easy to run the
shell code locally and to verify that code with shellcheck by moving the
shell code into separate files.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 .travis.yml          | 28 +++-------------------------
 ci/travis-build.sh   | 16 ++++++++++++++++
 ci/travis-install.sh | 31 +++++++++++++++++++++++++++++++
 3 files changed, 50 insertions(+), 25 deletions(-)
 create mode 100755 ci/travis-build.sh
 create mode 100755 ci/travis-install.sh

diff --git a/.travis.yml b/.travis.yml
index eba16baa2d03..b64f0a958bbc 100644
--- a/.travis.yml
+++ b/.travis.yml
@@ -39,29 +39,7 @@ matrix:
       arch: arm64
 
 before_install:
-  - EXTRA_CFLAGS="-Werror"
-  - if [[ "$TRAVIS_OS_NAME" == "linux" ]]; then
-        pkgs=(libaio-dev libcunit1 libcunit1-dev libgoogle-perftools4 libibverbs-dev libiscsi-dev libnuma-dev librbd-dev librdmacm-dev libz-dev);
-        if [[ "$BUILD_ARCH" == "x86" ]]; then
-            pkgs=("${pkgs[@]/%/:i386}");
-            pkgs+=(gcc-multilib python3-scipy);
-            EXTRA_CFLAGS="${EXTRA_CFLAGS} -m32";
-        else
-            pkgs+=(glusterfs-common python3-scipy);
-        fi;
-        sudo apt-get -qq update;
-        sudo apt-get install --no-install-recommends -qq -y "${pkgs[@]}";
-    fi;
-  - if [[ "$TRAVIS_OS_NAME" == "osx" ]]; then
-        brew update;
-        brew install cunit;
-        pip3 install scipy;
-    fi;
+  - ci/travis-install.sh
+
 script:
-  - ./configure --extra-cflags="${EXTRA_CFLAGS}" && make
-  - make test
-  - if [[ "$TRAVIS_CPU_ARCH" == "arm64" ]]; then
-        sudo python3 t/run-fio-tests.py --skip 6 1007 1008 --debug -p 1010:"--skip 15 16 17 18 19 20";
-    else
-        sudo python3 t/run-fio-tests.py --skip 6 1007 1008 --debug;
-    fi;
+  - ci/travis-build.sh
diff --git a/ci/travis-build.sh b/ci/travis-build.sh
new file mode 100755
index 000000000000..fff9c088b35f
--- /dev/null
+++ b/ci/travis-build.sh
@@ -0,0 +1,16 @@
+#!/bin/bash
+
+EXTRA_CFLAGS="-Werror"
+
+if [[ "$BUILD_ARCH" == "x86" ]]; then
+    EXTRA_CFLAGS="${EXTRA_CFLAGS} -m32"
+fi
+
+./configure --extra-cflags="${EXTRA_CFLAGS}" &&
+    make &&
+    make test &&
+    if [[ "$TRAVIS_CPU_ARCH" == "arm64" ]]; then
+	sudo python3 t/run-fio-tests.py --skip 6 1007 1008 --debug -p 1010:"--skip 15 16 17 18 19 20"
+    else
+	sudo python3 t/run-fio-tests.py --skip 6 1007 1008 --debug
+    fi
diff --git a/ci/travis-install.sh b/ci/travis-install.sh
new file mode 100755
index 000000000000..096347ec662a
--- /dev/null
+++ b/ci/travis-install.sh
@@ -0,0 +1,31 @@
+#!/bin/bash
+
+case "$TRAVIS_OS_NAME" in
+    "linux")
+	pkgs=(
+	    libaio-dev
+	    libcunit1
+	    libcunit1-dev
+	    libgoogle-perftools4
+	    libibverbs-dev
+	    libiscsi-dev
+	    libnuma-dev
+	    librbd-dev
+	    librdmacm-dev
+	    libz-dev
+	)
+	if [[ "$BUILD_ARCH" == "x86" ]]; then
+	    pkgs=("${pkgs[@]/%/:i386}")
+	    pkgs+=(gcc-multilib python3-scipy)
+	else
+	    pkgs+=(glusterfs-common python3-scipy)
+	fi
+	sudo apt-get -qq update
+	sudo apt-get install --no-install-recommends -qq -y "${pkgs[@]}"
+	;;
+    "osx")
+	brew update
+	brew install cunit
+	pip3 install scipy
+	;;
+esac

