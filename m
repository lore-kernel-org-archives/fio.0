Return-Path: <prvs=79210697c=Niklas.Cassel@wdc.com>
From: Niklas Cassel <Niklas.Cassel@wdc.com>
Subject: [PATCH v3 5/5] t/zbd: update test case 42
Date: Mon, 14 Jun 2021 13:49:05 +0000
Message-ID: <20210614134851.158700-6-Niklas.Cassel@wdc.com>
References: <20210614134851.158700-1-Niklas.Cassel@wdc.com>
In-Reply-To: <20210614134851.158700-1-Niklas.Cassel@wdc.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: "axboe@kernel.dk" <axboe@kernel.dk>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>, Damien Le Moal <Damien.LeMoal@wdc.com>, Niklas Cassel <Niklas.Cassel@wdc.com>
List-ID: <fio@vger.kernel.org>

From: Niklas Cassel <niklas.cassel@wdc.com>

Update test case 42 to grep for the new string printed by fio when
--zonesize=3D0 is supplied.

Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
---
 t/zbd/test-zbd-support | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/t/zbd/test-zbd-support b/t/zbd/test-zbd-support
index a684f988..57e6d05e 100755
--- a/t/zbd/test-zbd-support
+++ b/t/zbd/test-zbd-support
@@ -922,7 +922,7 @@ test41() {
 test42() {
     require_regular_block_dev || return $SKIP_TESTCASE
     read_one_block --zonemode=3Dzbd --zonesize=3D0 |
-	grep -q 'Specifying the zone size is mandatory for regular block devices =
with --zonemode=3Dzbd'
+	grep -q 'Specifying the zone size is mandatory for regular file/block dev=
ice with --zonemode=3Dzbd'
 }
=20
 # Check whether fio handles --zonesize=3D1 correctly for regular block dev=
ices.
--=20
2.25.1

