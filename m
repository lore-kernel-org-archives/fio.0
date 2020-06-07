Return-Path: <bart.vanassche@gmail.com>
Return-Path: <bart.vanassche@gmail.com>
From: Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 3/5] ci/travis-install.sh, MacOS: Install the Python 'six' package
Date: Sun,  7 Jun 2020 12:11:02 -0700
Message-Id: <20200607191104.17550-4-bvanassche@acm.org>
In-Reply-To: <20200607191104.17550-1-bvanassche@acm.org>
References: <20200607191104.17550-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org, Sitsofe Wheeler <sitsofe@yahoo.com>, Vincent Fu <vincent.fu@wdc.com>, Bart Van Assche <bvanassche@acm.org>
List-ID: <fio@vger.kernel.org>

From: Vincent Fu <vincent.fu@wdc.com>

Signed-off-by: Vincent Fu <vincent.fu@wdc.com>
[bvanassche: edited commit message / only retained "pip install six" command /
 changed 'pip' into 'pip3']
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 ci/travis-install.sh | 1 +
 1 file changed, 1 insertion(+)

diff --git a/ci/travis-install.sh b/ci/travis-install.sh
index 8a4f40e57a3a..232ab6b10c3c 100755
--- a/ci/travis-install.sh
+++ b/ci/travis-install.sh
@@ -35,6 +35,7 @@ case "$TRAVIS_OS_NAME" in
 	brew update >/dev/null 2>&1
 	brew install cunit
 	pip3 install scipy
+	pip3 install six
 	;;
 esac
 

