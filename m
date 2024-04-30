Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 840BA205E14
	for <fio@vger.kernel.org>; Tue, 30 Apr 2024 10:30:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=68.232.143.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714473036; cv=none; b=iw9o44kxLZ506EPSeLF4kGJvYz40EyEONpIuetdYJsi+gKH/Ca4ptq2j+ucMFOCs6qWoNR8nUTNegh1vVooAHNC/BNWUf+qhMj0MNiVJLAxjneHkiBVK2VNhoLw6Vz9RbcJopdlJIX2rDvwQlSKFCM968ZOX9KawQfUfmlM7n/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714473036; c=relaxed/simple;
	bh=KuDKyBP3f7nQolom7hNJUYIQaYaBP4eeC6KbUuKieFk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lh4RD+2TT0fL9N7OUigxg9JcVt5hPXloIO5Q96U4fNXfrtiW/3erIfk1MLDVABy+GZG8FAjCBqeliG/AYWKmKRDbVjam+67q/7lABG5wCn88WP1SCjjSLD9DlhaU2Acls/gPMsUatm2lZHElL6I/Lmz1MQn1hIUlwsrpVFt6K1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=ivwBro5c; arc=none smtp.client-ip=68.232.143.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="ivwBro5c"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1714473034; x=1746009034;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=KuDKyBP3f7nQolom7hNJUYIQaYaBP4eeC6KbUuKieFk=;
  b=ivwBro5cgR2CH3sf+K8FmTo/eWnCLELwS9T3342cEhtBlS2W8RpRp+Ul
   0TpmhlQfMGSxGiYQdi/Vq3wGUNs8jwtaI8brsD3QnoF56yBUqt04mLojZ
   I5GdTrELAK4KwWrxXPGNfSHICy2cHa8mEaI3+QjodrIz01Hgw8AvXsEr2
   Xp/Cb3bEHHDvQXKoIILzQWFVNeiEOfQP0fxWYHwQvK4WxRofzcHLtReED
   lIPZ3hhXcWKtqS+Lg2KPyLm5Hx509FpP3f9bcOa2SN4QKA9dtnNEsbEux
   6vpQsNyu1QrRP788CQsEECdcAGiP/0ZaeYK/s4EcmzuCB9KidM+ncN+Dr
   g==;
X-CSE-ConnectionGUID: Uf+l+tvmQCmF0nQAq/HTvg==
X-CSE-MsgGUID: MET585GBQ3+n+Xm+6ilFfQ==
X-IronPort-AV: E=Sophos;i="6.07,241,1708358400"; 
   d="scan'208";a="15244719"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 30 Apr 2024 18:30:25 +0800
IronPort-SDR: n8PFz4Bhf5ojMuhc/9OmXdYmS7B9Nh00YPEAh3v+W7AzppzTQ4XSnWT93yoYnmqVseyCZ5cZva
 y7dcPdBFi+JdHDQPaKYTh0YkW3lXazd+QiL0bZuMI4HZ9KZsRct5jCSyyF1c4hf7fDa73WP1CA
 0iMfct6C2SnMl2OoGAYeJRZ8P77B0CaaWYs1MsXZtu+s22gQjVWI5fxKFxw4lWfeldqXS028+3
 Sx1id17QWM0FIfL+LU0lWOE7aoICd6XaEWnn79kvW1xdZjDaKXcGWbzsGSQ70lOCVisL9tLih4
 kM4=
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 30 Apr 2024 02:38:29 -0700
IronPort-SDR: ZJwSG9Xw9WlfGk4J/FyjH6ZHEBIqIoRKl4kzuDr0UVyJ4SVYnqAi7rZfFvd702WuZ+4IvE5wUv
 rAzhy/pVhU13+7jVCiLSes3VTjAo89xirBpI5hD6EQLV1xXP584j1oHAM7rVXEkCBrpEiwGs9w
 JoyZ1/rj2v+F5PAyqGOmKs/20HGLyOAXSf4TY/iqUu2+MLB2xX1XiLExfdCKOSFiy5vSsuM0dd
 2LdoQaqINMeUY9t4E2Bek/8kmFD0YD5qOH+IUkxGnmhyGjPs81taTyg98qX2KCBKYAfkXfuWM6
 ppw=
WDCIronportException: Internal
Received: from unknown (HELO shindev.ssa.fujisawa.hgst.com) ([10.149.66.30])
  by uls-op-cesaip02.wdc.com with ESMTP; 30 Apr 2024 03:30:26 -0700
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: fio@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	Vincent Fu <vincentfu@gmail.com>
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Dmitry Fomichev <Dmitry.Fomichev@wdc.com>,
	Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH 2/3] t/zbd: add test case to confirm verify_backlog=1 options
Date: Tue, 30 Apr 2024 19:30:21 +0900
Message-ID: <20240430103022.4136039-3-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103022.4136039-1-shinichiro.kawasaki@wdc.com>
References: <20240430103022.4136039-1-shinichiro.kawasaki@wdc.com>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The previous commit fixed the verify failure due to the zone reset with
the verify_backlog option. Add a test to confirm the fix.

Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 t/zbd/test-zbd-support | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/t/zbd/test-zbd-support b/t/zbd/test-zbd-support
index c27d2ad6..ef98835c 100755
--- a/t/zbd/test-zbd-support
+++ b/t/zbd/test-zbd-support
@@ -1593,6 +1593,18 @@ test68() {
 	[[ $(grep -c "WRITE:" "${logfile}.${test_number}") == 1 ]]
 }
 
+# Test rw=rw and verify_backlog=1 options do not cause verify failure
+test69() {
+	require_zbd || return "$SKIP_TESTCASE"
+
+	prep_write
+	run_fio --name=job --filename="$dev" --time_based --runtime=15s \
+		--rw=rw --offset=$((first_sequential_zone_sector * 512)) \
+		"$(ioengine "libaio")" --iodepth=32 --randrepeat=0 \
+		--verify=crc32 --verify_backlog=1 --zonemode=zbd --direct=1 \
+		>> "${logfile}.${test_number}" 2>&1 || return $?
+}
+
 SECONDS=0
 tests=()
 dynamic_analyzer=()
-- 
2.44.0

