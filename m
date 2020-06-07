Return-Path: <bart.vanassche@gmail.com>
Return-Path: <bart.vanassche@gmail.com>
From: Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 2/5] ci/travis-install.sh: Install python3-six package
Date: Sun,  7 Jun 2020 12:11:01 -0700
Message-Id: <20200607191104.17550-3-bvanassche@acm.org>
In-Reply-To: <20200607191104.17550-1-bvanassche@acm.org>
References: <20200607191104.17550-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org, Sitsofe Wheeler <sitsofe@yahoo.com>, Vincent Fu <vincent.fu@wdc.com>, Bart Van Assche <bvanassche@acm.org>
List-ID: <fio@vger.kernel.org>

Additionally, report the Python3 path and version.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 ci/travis-install.sh | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/ci/travis-install.sh b/ci/travis-install.sh
index 096347ec662a..8a4f40e57a3a 100755
--- a/ci/travis-install.sh
+++ b/ci/travis-install.sh
@@ -2,6 +2,7 @@
 
 case "$TRAVIS_OS_NAME" in
     "linux")
+	# Architecture-dependent packages.
 	pkgs=(
 	    libaio-dev
 	    libcunit1
@@ -16,16 +17,27 @@ case "$TRAVIS_OS_NAME" in
 	)
 	if [[ "$BUILD_ARCH" == "x86" ]]; then
 	    pkgs=("${pkgs[@]/%/:i386}")
-	    pkgs+=(gcc-multilib python3-scipy)
+	    pkgs+=(gcc-multilib)
 	else
-	    pkgs+=(glusterfs-common python3-scipy)
+	    pkgs+=(glusterfs-common)
 	fi
+	# Architecture-independent packages and packages for which we don't
+	# care about the architecture.
+	pkgs+=(
+	    python3
+	    python3-scipy
+	    python3-six
+	)
 	sudo apt-get -qq update
 	sudo apt-get install --no-install-recommends -qq -y "${pkgs[@]}"
 	;;
     "osx")
-	brew update
+	brew update >/dev/null 2>&1
 	brew install cunit
 	pip3 install scipy
 	;;
 esac
+
+echo "Python version: $(/usr/bin/python -V 2>&1)"
+echo "Python3 path: $(which python3 2>&1)"
+echo "Python3 version: $(python3 -V 2>&1)"

