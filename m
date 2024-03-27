Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C63A74BE8
	for <fio@vger.kernel.org>; Wed, 27 Mar 2024 12:00:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711540811; cv=none; b=nb/Zz1iXOjDat2ztEXhxvaGQprzHFA4n78WyfIFr61YUN2wEBmKALS7RcgEhLt1GInfBLrYfIHwbMDPanFbd3XlcYZCDJJguOUYGv5uvN6SRolKfGpXwJCNLrDk/xAJTs8LBxfX2uo9Mea7TjAsvaf82x0HS7p7D/uIiK4qCBbg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711540811; c=relaxed/simple;
	bh=puxGV43gfbc4V6zHhf8ZKRWSaWhnTOdO1LrwJGVnGA8=;
	h=Subject:From:To:Message-Id:Date; b=MJ7+2jewd4ytXF6XJIo7FD5FErqsehD+OJP4Awlpt/IAn2Rr04RgVksFUwWzu6yiJfVG9NmxVIZKOwKDAC09j9HYZ1Zq/SokFSejeh0TRy1/hXWIexd/Mf51oPAaVp9fW2+FwPhVv5FC/X2ewwvhcgF3OW0vq9yE1wqHfQlr1pA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=fail smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=mMMrrlYC; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="mMMrrlYC"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Date:Message-Id:To:From:Subject:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=ILpD8Fl+qgyN4AYDz+0dgZxmADaKbBd3gnWfwN3ezqc=; b=mMMrrlYCtZuF8OcTntwlQntOJ3
	g9oHj8BFi4H2i2/oTvu/rWwxjiiJkyI25OheLb1Ik8IPsPt23aXfcoFWe5BiuiqKIL7JCTBY3o5rK
	RovT4M1/pBpg3OTKUy8rIMgRHQnMnPbZFrKq+QRnY3UnRlPZoDIKE+U5ydgW46I5JD2Im6iWtDoQc
	cDDZSu1kMIHoNKxtgm0xPtBbrVhwfIh1muefXqY8wun5mpjd6XSDEcim8l2nAtq8nb7kI9iImkWvK
	Bf8YE6QBzN9TWrjkbOiMLR4iKIShNX81/7V9u5rgy8FdMsPRjjcuTrotSaFDamt+i/KFi6WjhkZoS
	Nkc8hx2A==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by casper.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rpRwq-00000003mnX-2cHa
	for fio@vger.kernel.org;
	Wed, 27 Mar 2024 12:00:04 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id 955881BC0120; Wed, 27 Mar 2024 06:00:01 -0600 (MDT)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20240327120001.955881BC0120@kernel.dk>
Date: Wed, 27 Mar 2024 06:00:01 -0600 (MDT)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>

The following changes since commit b2403d413ee734e8835539319d8bc3429a0777ac:

  Merge branch 'delete-instead-of-unlink' of https://github.com/edigaryev/fio (2024-03-25 10:45:13 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 9213e16d98b0e9d2f8d4f7e760ed0fd45c8960f6:

  Fio 3.37 (2024-03-26 15:13:51 -0600)

----------------------------------------------------------------
Jens Axboe (1):
      Fio 3.37

 FIO-VERSION-GEN | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

---

Diff of recent changes:

diff --git a/FIO-VERSION-GEN b/FIO-VERSION-GEN
index cf8dbb0e..be0d7620 100755
--- a/FIO-VERSION-GEN
+++ b/FIO-VERSION-GEN
@@ -1,7 +1,7 @@
 #!/bin/sh
 
 GVF=FIO-VERSION-FILE
-DEF_VER=fio-3.36
+DEF_VER=fio-3.37
 
 LF='
 '
