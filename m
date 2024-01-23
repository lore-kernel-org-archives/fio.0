Received: from gate2.alliedtelesis.co.nz (gate2.alliedtelesis.co.nz [202.36.163.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1588960EE4
	for <fio@vger.kernel.org>; Tue, 23 Jan 2024 20:26:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.36.163.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706041609; cv=none; b=q+zueUvACncR+YEneuY7G8cHq7otaz3LpV75D5AZeAwjjPeRrZktsiZr5rLxf8IKSxsiq3uE2DXQGcSKTdWXMiSVo3tC8fFeqy8EWbYyhJT1G3FC+0xdWZ5A24Fl3G5TnJPPCcxR1BkSo42e3yfBiRuzzu8eKOIVEu4/pv1eUuA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706041609; c=relaxed/simple;
	bh=jf2ngdPT5jgE64xoEwOAqy6ZV8xfh0KvJMpDiFw9aFc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=H9/97ZHcpvm02U51/AFYu8wFjBEBBZJLG6tRdlzB88VE7bEXw4wsQ0jLVFONQe41OOS1JV0SrPi2at5qXL/hQi/zus6ZwLUa2/egBi87KILlLf1G9E89sCOu5Cl5GcvNQmMTvs5xDcWrGRSyxNqX5uQmboI+h6RxHQjBZAMsMq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=alliedtelesis.co.nz; spf=pass smtp.mailfrom=alliedtelesis.co.nz; arc=none smtp.client-ip=202.36.163.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=alliedtelesis.co.nz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alliedtelesis.co.nz
Received: from svr-chch-seg1.atlnz.lc (unknown [10.32.18.43])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(Client did not present a certificate)
	by gate2.alliedtelesis.co.nz (Postfix) with ESMTPS id 80A5E2C0F0B;
	Wed, 24 Jan 2024 09:26:43 +1300 (NZDT)
Received: from pat.atlnz.lc (Not Verified[10.32.16.33]) by svr-chch-seg1.atlnz.lc with Trustwave SEG (v8,2,6,11305)
	id <B65b021030000>; Wed, 24 Jan 2024 09:26:43 +1300
Received: from chrisp-dl.ws.atlnz.lc (chrisp-dl.ws.atlnz.lc [10.33.22.30])
	by pat.atlnz.lc (Postfix) with ESMTP id 5068713ED4A;
	Wed, 24 Jan 2024 09:26:43 +1300 (NZDT)
Received: by chrisp-dl.ws.atlnz.lc (Postfix, from userid 1030)
	id 493792804E6; Wed, 24 Jan 2024 09:26:43 +1300 (NZDT)
From: Chris Packham <chris.packham@alliedtelesis.co.nz>
To: axboe@kernel.dk
Cc: fio@vger.kernel.org,
	Chris Packham <chris.packham@alliedtelesis.co.nz>
Subject: [PATCH] configure: Don't use cross_prefix when invoking pkg-config
Date: Wed, 24 Jan 2024 09:26:36 +1300
Message-ID: <20240123202636.179467-1-chris.packham@alliedtelesis.co.nz>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-SEG-SpamProfiler-Analysis: v=2.3 cv=LZFCFQXi c=1 sm=1 tr=0 a=KLBiSEs5mFS1a/PbTCJxuA==:117 a=dEuoMetlWLkA:10 a=eQiGBhThhFXdbhsHayAA:9
X-SEG-SpamProfiler-Score: 0
x-atlnz-ls: pat

pkg-config doesn't need to have a cross prefixed version. It can be
pointed at alternate sysroots with environment variables like
PKG_CONFIG_SYSROOT_DIR. The configure script was already inconsistent
with using `pkg-config` in some places and `${cross_prefix}pkg-config`
in others. Make check_min_lib_version() and the gtk checks consistent
with the rest by dropping the `${cross_prefix}` usage with pkg-config.

Signed-off-by: Chris Packham <chris.packham@alliedtelesis.co.nz>
---

Notes:
    I ran into an issue cross-compiling fio where it couldn't find libxnv=
me
    in my cross sysroot. pkg-config shouldn't need to have a target tuple
    prefix and I see that the configure script was already inconsistent w=
ith
    using it hence this patch which resolves the build issue for me.

 configure | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/configure b/configure
index 742cb7c5..cba0ce5f 100755
--- a/configure
+++ b/configure
@@ -155,11 +155,11 @@ output_sym() {
 check_min_lib_version() {
   _feature=3D$3
=20
-  if "${cross_prefix}"pkg-config --atleast-version=3D"$2" "$1" > /dev/nu=
ll 2>&1; then
+  if pkg-config --atleast-version=3D"$2" "$1" > /dev/null 2>&1; then
     return 0
   fi
   : "${_feature:=3D${1}}"
-  if "${cross_prefix}"pkg-config --version > /dev/null 2>&1; then
+  if pkg-config --version > /dev/null 2>&1; then
     if test "$(eval echo \"\$$_feature\")" =3D "yes" ; then
       feature_not_found "$_feature" "$1 >=3D $2"
     fi
@@ -1627,14 +1627,14 @@ int main(void)
   return GTK_CHECK_VERSION(2, 18, 0) ? 0 : 1; /* 0 on success */
 }
 EOF
-GTK_CFLAGS=3D$(${cross_prefix}pkg-config --cflags gtk+-2.0 gthread-2.0)
+GTK_CFLAGS=3D$(pkg-config --cflags gtk+-2.0 gthread-2.0)
 ORG_LDFLAGS=3D$LDFLAGS
 LDFLAGS=3D$(echo $LDFLAGS | sed s/"-static"//g)
 if test "$?" !=3D "0" ; then
   echo "configure: gtk and gthread not found"
   exit 1
 fi
-GTK_LIBS=3D$(${cross_prefix}pkg-config --libs gtk+-2.0 gthread-2.0)
+GTK_LIBS=3D$(pkg-config --libs gtk+-2.0 gthread-2.0)
 if test "$?" !=3D "0" ; then
   echo "configure: gtk and gthread not found"
   exit 1
--=20
2.43.0

