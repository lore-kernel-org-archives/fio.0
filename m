Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96D901AFB2E
	for <fio@vger.kernel.org>; Thu, 26 Sep 2024 22:54:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727391263; cv=none; b=oWLl6m3zeT7t9JHhjL4juH+ahv4BYhuo/6DP9+w3jyV050K4+Z73thUiPe+JpDhNfBmET8H5xu7YpuPmTLDx4mVHGxofU8Q8tTHCWme9Xv0nTxWG163ddi4ZUISwMUcUdNAOiluSVrYgpx97SxvJv8BzT0eDVaQD0BRLLR3NWTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727391263; c=relaxed/simple;
	bh=y6A14Xv8nFG/DvCqu3Ei8egTYNvbYKW+ySiGyIsMSlc=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Us2h9u1zTNlzNmP4MgTtIiLsb2LiRTgqUBmDacFlx+pxwLIkGrEqYgR+a22adpBTTtCcYgwFiDWO3UxWFhXyHMt8P/Yj9ButkTNrY1AGiKDJXEFuW5DaDYB7GGhl2qcIF59jTpjA0XFgYXd34FI6mjg8SSfsmA1SP4bxIeQ/6Ns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=W5+PKdvM; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="W5+PKdvM"
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-20b2093f1cbso1830165ad.0
        for <fio@vger.kernel.org>; Thu, 26 Sep 2024 15:54:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1727391261; x=1727996061; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=wOmeH+e4D/vzISobx49sH1EmdhDXdibd0n48Z50WjCM=;
        b=W5+PKdvMmerPW3BIpAMsDAhFLnHKER9omGLTu331kvW6vfFvmyE2zv11xAe0u97l1j
         SeRgluQLzBsCit5b9Ck1ljnIEtOF0vsSdVLGdanVTNW9yk7DZmTz3Ugv7M/APwk8vmos
         7GHZRhMkn8Sd9k71Fe7cFUTkaYIQL+5YPTIiAMiVvldvKQTxJsRwjGiERjVjY+yaAaxW
         ij7ry/sgXk0F3RJf9Dcl9PLUsO2whhDf4bXBuAi4ZxPXzV8XrSZDpC1V1J/VV3inZ4Pr
         MPXs6b+5c47CNArg+zfFAZuckT0ditc+ljbl9vvoZABDeWbySMW1cE0Y6JFnfPMrmpOK
         slbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727391261; x=1727996061;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wOmeH+e4D/vzISobx49sH1EmdhDXdibd0n48Z50WjCM=;
        b=pln4yHiLKZdqh64rCTUsLuQeJ3/nJC3MpsTAgdlgnmCT/or4fGdN3aORpOR8MdEnlm
         qMouSIdf/rJCNTHxGPb/QSiSEZVHSU+jk6HH/jOdWgk5Dnijw3bRzjAbFkEa51+gKBeY
         jhCwSDSVXx6bfwFap8Q2lpL2yZ1BlDw7PtbOyRQmhk13YtobXxCkmi8Jtx9mglZDDcVG
         zmSUsA1xsL+l+4A9WDDt4VIw4i4gdiYCPKrfIqLhHbb6Bxvn/osg9sWFxvzmoWsx1ygD
         kczJNryik2YPQan4l5JO1yFjUuSwXeaSLRHN9qXX9t6E3pa2RlJNTKa486mYkMS/s09S
         TE0Q==
X-Gm-Message-State: AOJu0Yw8m4bHZIs8E+DBZGDkCrrXuywNUnFv/N08cHkE3SauGBBg9zTG
	oQ4Bjs2y7lTfqYmUkX7kDVhAVVDhLysz+TrCyt3Lb0fSTx+Qp69K9Avhnw==
X-Google-Smtp-Source: AGHT+IG4WCk6zg4oZcyPdubxCOTkvu9FNsEQgLtoWKmott826DhfAYA7luWOtvbZzP9GAYqjfU27sw==
X-Received: by 2002:a17:902:e5d0:b0:207:14c1:c8de with SMTP id d9443c01a7336-20b37bbc525mr7253505ad.13.1727391261436;
        Thu, 26 Sep 2024 15:54:21 -0700 (PDT)
Received: from localhost ([116.121.76.56])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2e06e2fd905sm4082077a91.50.2024.09.26.15.54.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Sep 2024 15:54:21 -0700 (PDT)
From: Minwoo Im <minwoo.im.dev@gmail.com>
To: fio@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	Vincent Fu <vincent.fu@samsung.com>,
	Minwoo Im <minwoo.im@samsung.com>,
	Minwoo Im <minwoo.im.dev@gmail.com>
Subject: [PATCH] HOWTO: update 'verify_mode' for io_uring_cmd
Date: Fri, 27 Sep 2024 07:54:11 +0900
Message-Id: <20240926225411.13754-1-minwoo.im.dev@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

'verify_mode' option has been added by Commit 6170d92a61da
("io_uring: Support Compare command for verification").  Added
description for this option.

Signed-off-by: Minwoo Im <minwoo.im.dev@gmail.com>
---
 HOWTO.rst | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/HOWTO.rst b/HOWTO.rst
index 4f071484bdc3..539bce194301 100644
--- a/HOWTO.rst
+++ b/HOWTO.rst
@@ -2883,6 +2883,15 @@ with the caveat that when used on the command line, they must come after the
                 **verify**
                         Use Verify commands for write operations
 
+.. option:: verify_mode=str : [io_uring_cmd]
+
+        Specifies the type of command to be used in the verification phase.  Defaults to 'read'.
+
+                **read**
+                        Use Read commands for data verification
+                **compare**
+                        Use Compare commands for data verification
+
 .. option:: sg_write_mode=str : [sg]
 
 	Specify the type of write commands to issue. This option can take ten values:
-- 
2.34.1

