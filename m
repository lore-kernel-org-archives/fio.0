Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44BA477F05
	for <fio@vger.kernel.org>; Wed, 24 Jan 2024 13:00:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706101208; cv=none; b=acWwuTxCbe394AnQgHSBKjJasKbBxtEnmoT5SYaRdG2201RlYfbaCBRTRHLwiqBNB//zexP6yUUkKfrL5k9LnyPD87O7uufHGM/c5hAxjmwIhvOZd0z9eJFBICEp6Ti3quiroHhNlVZImvEaJUp21JFJZq+9kZijifvshfZuA6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706101208; c=relaxed/simple;
	bh=hXNnteEYR6rRQounrGAtwrB+c2dcvxTotschxfzJ+8w=;
	h=Subject:From:To:Message-Id:Date; b=W6eSU1dRL2MMOp6XkJA+isC1ok+7EdaT2vIt/2AVxJQpGnsZmfucvBkdNq0TrYc0r2+F7roVUywtfi49xskbX25Z3lBH+BF8eEMLVjLntP2Kvw7Np959BMHNAgjBdWOZ7QX546xbMLTT5jlX30RVfJAVEKeDXYYSlLtJ3hQtXwI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=fail smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Nj+0iziw; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Nj+0iziw"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=Date:Message-Id:To:From:Subject:Sender
	:Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=3pL2HyOYmpRYj0GvOrObmiK5+aCmn4AWtrB8tuWuEH4=; b=Nj+0iziwws9OCrhGQQ4c31XT/9
	sMyhGoc1O1yMulHxZcs1zcaPIKgLJodn7ZWDJrdduOh2UkwJp5uAqxb1dlMBqa4ZGOfgIr927ecbT
	5afqiB3/EjhXYf2VAyf4Aa8v0iNGMgUwk/ckxEIQCy0LbxMumNGb2MMFsqP7Yks0THY2mCqFgzBFo
	+2Gc4OZhtoYG1mIYe6NtFV9eenxoai68KQF+udpGniWVbkWwdbHBwVXKlqIpz1ETMBFrZYA9Mk3Ny
	OuoIepiWMWpEbgvvtntxmIU2JKq0817ucDoePUTKA7Sfn5lG6Hw5d+KIXtphUrYebwNjenDZPE1yV
	POtQGdjQ==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by desiato.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rScrM-00000004VbF-0wqz
	for fio@vger.kernel.org;
	Wed, 24 Jan 2024 13:00:04 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id 9FFB51BC0150; Wed, 24 Jan 2024 06:00:01 -0700 (MST)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20240124130001.9FFB51BC0150@kernel.dk>
Date: Wed, 24 Jan 2024 06:00:01 -0700 (MST)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>

The following changes since commit 8b3190c3ea38af87778a68c576947f8797215d33:

  filesetup: clear O_RDWR flag for verify_only write workloads (2024-01-22 11:51:05 -0500)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 1ee0469f6d180a98d31196bea787f37269ff9cdd:

  configure: Don't use cross_prefix when invoking pkg-config (2024-01-23 16:28:31 -0700)

----------------------------------------------------------------
Chris Packham (1):
      configure: Don't use cross_prefix when invoking pkg-config

 configure | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

---

Diff of recent changes:

diff --git a/configure b/configure
index f86fcf77..dea8d07d 100755
--- a/configure
+++ b/configure
@@ -155,11 +155,11 @@ output_sym() {
 check_min_lib_version() {
   _feature=$3
 
-  if "${cross_prefix}"pkg-config --atleast-version="$2" "$1" > /dev/null 2>&1; then
+  if pkg-config --atleast-version="$2" "$1" > /dev/null 2>&1; then
     return 0
   fi
   : "${_feature:=${1}}"
-  if "${cross_prefix}"pkg-config --version > /dev/null 2>&1; then
+  if pkg-config --version > /dev/null 2>&1; then
     if test "$(eval echo \"\$$_feature\")" = "yes" ; then
       feature_not_found "$_feature" "$1 >= $2"
     fi
@@ -1631,14 +1631,14 @@ int main(void)
   return GTK_CHECK_VERSION(2, 18, 0) ? 0 : 1; /* 0 on success */
 }
 EOF
-GTK_CFLAGS=$(${cross_prefix}pkg-config --cflags gtk+-2.0 gthread-2.0)
+GTK_CFLAGS=$(pkg-config --cflags gtk+-2.0 gthread-2.0)
 ORG_LDFLAGS=$LDFLAGS
 LDFLAGS=$(echo $LDFLAGS | sed s/"-static"//g)
 if test "$?" != "0" ; then
   echo "configure: gtk and gthread not found"
   exit 1
 fi
-GTK_LIBS=$(${cross_prefix}pkg-config --libs gtk+-2.0 gthread-2.0)
+GTK_LIBS=$(pkg-config --libs gtk+-2.0 gthread-2.0)
 if test "$?" != "0" ; then
   echo "configure: gtk and gthread not found"
   exit 1
