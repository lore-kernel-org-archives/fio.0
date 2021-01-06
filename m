Return-Path: <prvs=6334d1505=dmitry.fomichev@wdc.com>
From: Dmitry Fomichev <dmitry.fomichev@wdc.com>
Subject: [PATCH v3 38/38] t/zbd: avoid looping on invalid command line options
Date: Thu,  7 Jan 2021 06:57:39 +0900
Message-Id: <20210106215739.264524-39-dmitry.fomichev@wdc.com>
In-Reply-To: <20210106215739.264524-1-dmitry.fomichev@wdc.com>
References: <20210106215739.264524-1-dmitry.fomichev@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: Jens Axboe <axboe@kernel.dk>, fio@vger.kernel.org, Aravind Ramesh <aravind.ramesh@wdc.com>, Bart Van Assche <bvanassche@acm.org>, Naohiro Aota <naohiro.aota@wdc.com>, Niklas Cassel <niklas.cassel@wdc.com>
Cc: Damien Le Moal <damien.lemoal@wdc.com>, Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>, Dmitry Fomichev <dmitry.fomichev@wdc.com>
List-ID: <fio@vger.kernel.org>

t/zbd/test-zbd-support loops indefinitely if an unrecognized option
is specified in the command line. Add a switch case to display usage
and exit the script.

Signed-off-by: Dmitry Fomichev <dmitry.fomichev@wdc.com>
---
 t/zbd/test-zbd-support | 1 +
 1 file changed, 1 insertion(+)

diff --git a/t/zbd/test-zbd-support b/t/zbd/test-zbd-support
index 05c00900..1658dc25 100755
--- a/t/zbd/test-zbd-support
+++ b/t/zbd/test-zbd-support
@@ -1178,6 +1178,7 @@ while [ "${1#-}" != "$1" ]; do
     -q) quit_on_err=1; shift;;
     -z) zbd_debug=1; shift;;
     --) shift; break;;
+     *) usage; exit 1;;
   esac
 done
 
-- 
2.28.0


