Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04DCE53E0F
	for <fio@vger.kernel.org>; Thu, 25 Jan 2024 13:09:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706188164; cv=none; b=NoA99CV76jrHjyyO0XBDILerwXKnB8gLQ28EosN7EokLmDXAn/UERFO4FU/IxeQJ62WJq3a23icguHk2EGlxOnLsCj0xVDAEJ6iCuVaG0Zi7fAxkJJ/gusOfUXUqvFMG2tLtW+AOYvgpFxzCc916yvAAS8ZQuRbE3SKEAfSonl8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706188164; c=relaxed/simple;
	bh=EDGzu8wPC3wt4bX1BXJYLbF7XgkG4PGk/Ay6tLdZP64=;
	h=Subject:From:To:Message-Id:Date; b=kUzcU+xu/5rfghf3M7WJSeK3ZmoQcsgWxdDb9wNM3XPO8N3NPsuWmiSom/ljOvqMMt/TzJrv3NJlnZ9slsILAaL1XdHqtYM3Pa0fXZ50r+tikpTxolpzEJ5+a6wvv6WAd9VkeQbvqmkZeQjXAyM+/89+ggwAkyBzqpqh4pyPuBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=fail smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=oBgG6jQ2; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="oBgG6jQ2"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=Date:Message-Id:To:From:Subject:Sender
	:Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=P+WK4f2DXM0zwuee1ZsAGNl+DTkbE/0yjmO1VWpFvMs=; b=oBgG6jQ2yHtpOjQkgp8M2KJezq
	FpqclDt5o1jXg2WtUViXBEINwOIGfxUfxpRX54KFs1DNtuVrotZaqois4IMjoOJx74RdrFKc3P1dH
	ULuyMmwf9gTXUIdNuBzw2/IZ/vKQ2Do9QcUZ/NYloLqjWqO66Kh4/ZXOvcQ4AhyfkOx07W7xn/JuG
	+irOSl7+uMsy5BnEB2KyZJuzNTXMR47+lc/K9iOJ+TaAvbqgm18dOqnBhHB98HTzZoYg5siQm+BtG
	s17CxVXz7iI/pzh25JRyR6zpACNjbHNNBsSLk1CQ19VwupmERiuMdqY1/4rSxSA54Z51bxbdi3B3f
	36edp6BA==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by desiato.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rSzTl-00000005Nut-0FTi
	for fio@vger.kernel.org;
	Thu, 25 Jan 2024 13:09:13 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id 54DE91BC0148; Thu, 25 Jan 2024 06:00:01 -0700 (MST)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20240125130001.54DE91BC0148@kernel.dk>
Date: Thu, 25 Jan 2024 06:00:01 -0700 (MST)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>

The following changes since commit 1ee0469f6d180a98d31196bea787f37269ff9cdd:

  configure: Don't use cross_prefix when invoking pkg-config (2024-01-23 16:28:31 -0700)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 7f250f7514bacef1a3cea24a22ecce8bd30378bd:

  ci: resolve GitHub Actions Node.js warnings (2024-01-24 19:45:33 +0000)

----------------------------------------------------------------
Vincent Fu (1):
      ci: resolve GitHub Actions Node.js warnings

 .github/workflows/ci.yml | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

---

Diff of recent changes:

diff --git a/.github/workflows/ci.yml b/.github/workflows/ci.yml
index b8000024..e53082c3 100644
--- a/.github/workflows/ci.yml
+++ b/.github/workflows/ci.yml
@@ -64,7 +64,7 @@ jobs:
       if: ${{ contains( matrix.build, 'windows' ) }}
       run: git config --global core.autocrlf input
     - name: Checkout repo
-      uses: actions/checkout@v3
+      uses: actions/checkout@v4
     - name: Install Cygwin toolchain (Windows)
       if: ${{ startsWith(matrix.build, 'windows-cygwin') }}
       uses: cygwin/cygwin-install-action@master
@@ -110,7 +110,7 @@ jobs:
 
     - name: Upload installer as artifact (Windows)
       if: ${{ contains( matrix.build, 'windows' ) }}
-      uses: actions/upload-artifact@v3
+      uses: actions/upload-artifact@v4
       with:
         name: ${{ matrix.build }}-installer
         path: os\windows\*.msi
