Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0213332B999
	for <fio@vger.kernel.org>; Fri,  6 Feb 2026 16:41:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770396071; cv=none; b=ToAOw/vVfs/t9vkMQCeGY5Bp9FkOKV/0Hg1s63kMPlNFw8FVYpReFr5YXAl4K+J8o1pghjH61toswCalMFYWR7wIlXa1eeYRpugHZuXB7DOql3wzIwIDJgBj5GtFFIuZhr0XmvIvSeCj28lp04wHNgHz+L22Jlq5VFnUBBx7wqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770396071; c=relaxed/simple;
	bh=GIyO1aRQn85K5UVesASXAVZ2XmRUyiRgaCNtrVodLek=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lorLnQPd9R+s0GIpG/7hzOXBXfbML//vnNNw5+qwHMnpfQThRDtAluJ9+fwKmkw5QqVmlo7gtF74FbBiYQfCuq1iIMBMRfEFLHtRAxSYNVHuj32faZRY36TvjPnHhDdyQ2SMWI3zpd0NKQbPw98fgB1pZHofHsJT+8QW1nCfi9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ohxB1FQV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ohxB1FQV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51C04C19422;
	Fri,  6 Feb 2026 16:41:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770396070;
	bh=GIyO1aRQn85K5UVesASXAVZ2XmRUyiRgaCNtrVodLek=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ohxB1FQVT7Wf/+XxX9ir049NFs7rM/WeGzOww815XkZeXzTBiNxrhViV7PiRFikLB
	 7gAKxGxDQOsjraDxAsp65Hx7K7lXp9GkvZ8e3V901A0D5vtGeao4LkEDIXqH4hOB7G
	 5yw1BhMnhCcJblz7L5dwptLHZft9aiY2rdTVsmXwdrOfmWbVc5AYkmaTdLDbAazLwI
	 fIKZrx6vIMHmDCisEo3f9lidrxUdMEWge4+OovAxWAleSKj/UeYITeQ8WxNgluMEko
	 vwhn8dnHnv62MrXtnA/iagT1oICZLc9tLqxx91KleiRhRPxI7hLYdTWb/ujmMWDvlz
	 NcQU2wTTcqGfw==
From: Niklas Cassel <cassel@kernel.org>
To: Jens Axboe <axboe@kernel.dk>,
	Vincent Fu <vincent.fu@samsung.com>
Cc: fio@vger.kernel.org,
	Damien Le Moal <dlemoal@kernel.org>,
	Jorgen S Hansen <jorgen.hansen@wdc.com>,
	Niklas Cassel <cassel@kernel.org>
Subject: [PATCH 3/3] stat: Remove duplicate space in __show_run_stats()
Date: Fri,  6 Feb 2026 17:40:58 +0100
Message-ID: <20260206164058.3105327-4-cassel@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260206164058.3105327-1-cassel@kernel.org>
References: <20260206164058.3105327-1-cassel@kernel.org>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Remove duplicate space in __show_run_stats().

Signed-off-by: Niklas Cassel <cassel@kernel.org>
---
 stat.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/stat.c b/stat.c
index b999eb4b..620b4626 100644
--- a/stat.c
+++ b/stat.c
@@ -2604,7 +2604,7 @@ void __show_run_stats(void)
 				ts->error = td->first_error;
 				snprintf(ts->verror, sizeof(ts->verror), "%s",
 					 td->verror);
-			} else  if (td->error) {
+			} else if (td->error) {
 				ts->error = td->error;
 				snprintf(ts->verror, sizeof(ts->verror), "%s",
 					 td->verror);
-- 
2.53.0

