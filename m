Received: from mail-qk1-f171.google.com (mail-qk1-f171.google.com [209.85.222.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27DF4423A84
	for <fio@vger.kernel.org>; Fri,  6 Feb 2026 17:57:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770400664; cv=none; b=bF3KAQuBlQtNVq7+VJpJx99ge7wUhm4hIZs28GkqcQCWQ6LDeDbggQQmu+FeX7QkcR67upnNYfw5Fw/S9saQ5U6/On8SeVUDtn7UgYCMtdpxOD3bBt1yh73ODgG79KQf5/GCOXXg2ruyxcmZRozhFDrHvgRvNaMhmv/9mE+40D0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770400664; c=relaxed/simple;
	bh=+Rx7MJUAHjgEd1j3UaUqfxQZlb2xi2HF95GPi7Sosd8=;
	h=Date:Content-Type:MIME-Version:From:To:Subject:In-Reply-To:
	 References:Message-ID; b=npPFWwyK9Zd1tqT4mKkVkr4Ott6CaD4flKmYTkXYAd7AuMsIeZQdXMVfZJ1yi2XrFf+evp3NDoJ6ndBGystFZm+PwUrN9pURcjKjbqReyeJ0D8cQ/7gEtuVxnps08hum0mjeAZubWSb6slxHxlBxxOWKTC9NUBrZeVnR3ICtzZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XX3o3CBX; arc=none smtp.client-ip=209.85.222.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XX3o3CBX"
Received: by mail-qk1-f171.google.com with SMTP id af79cd13be357-8c70ce93afaso245191585a.0
        for <fio@vger.kernel.org>; Fri, 06 Feb 2026 09:57:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770400663; x=1771005463; darn=vger.kernel.org;
        h=message-id:references:in-reply-to:subject:to:from:mime-version:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+Rx7MJUAHjgEd1j3UaUqfxQZlb2xi2HF95GPi7Sosd8=;
        b=XX3o3CBXcsXMN2mJJ/dpQp6IZjBo+6kNa3bihWSArMXs+fbZ2nRJ8+7HbKTuXOL/sJ
         wf3sjueLqBCIC1cbBZ18TjP3uPbXh/bvmUglueEbdHS4xPt5oqMNqiin/yw0xUBB28xo
         VStq8Zo6flWthtbDo7wtGMJYo6sCl7sH6DXrK+aXHs/AoXvLLMeYm6vRfJMJTT+aV6XO
         zx16ThYyuImEEJc+e6CEABXq9vetT7Yf5gwqglSaDXr1dBypzcbb+oKMdTC+quDqMcCg
         Od9fB8pwSjLsFiBf9MYpZMGDS2aPPJGr3cCK6z5vv2l3V6BxWfZw4BR5M4BEXU9MlfyN
         oGAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770400663; x=1771005463;
        h=message-id:references:in-reply-to:subject:to:from:mime-version:date
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+Rx7MJUAHjgEd1j3UaUqfxQZlb2xi2HF95GPi7Sosd8=;
        b=c1MrZDuL2iXZCpxJLOM6rOt/FXklLO2IvVbXjRs+6gA+/GIHK8qjoDF5eVJz/rv8d6
         ay6E5sneWkIoVLGlFsDRL8SCIdOPDa7DE5bBi4bQPCxbLNOdjp/z6skj2LQKTw9izDV6
         favyKDtXi4MnbjLapoBkpS2PTFKluTlkaf57U/ROtDj3IDUTh4lgoHw74rOFGo8E5Az/
         PP45+piCA1MxS/e7UYq3T3FLo7Okj/t06jtuCgGBVkGcSprld1hKlqBMmMW8yxfdZWcx
         uW0GN972eq0tiVWdKShwLNoM2yq8TlzQmuhQt70iTbtvsgRUTq+5Scwg5DL+XC2N73fE
         QOfw==
X-Gm-Message-State: AOJu0YyeB0FdYlFoHyK2Zoc9kLa6VH4Ah/b+UfuplQrMFzYPjOud7TCH
	Un4PXcw1XX/i52CpGM9npTgzWj0t57igM94CQbVo4THqsjC/W3bsjoCzoZot
X-Gm-Gg: AZuq6aKy495CdhqaLs2GciJJFPXON08diJ9Lun4QaqqllT6K9dQtZnwaWIYP+ey1ovE
	Iun4mUHqOYd7YENjKjh8a9FmTW2mOY8q/pSn0miXRvVI3W5PqO+yvasJYHE4hR4bjYg0foshein
	BrcA+QpKg1v5QQemWjitJLkr+boBZL/f/cpHJ5DWQA0I5vmz7EZRAiMKkiwh/ZI1T/LOWEO+LzL
	cuAkkjghn1+cKaTPPUj8PvhK8JbCtc6rZm2NqBSR1CUbOOFtzoItKF/8pJAE+kmTpXJ/sS5jiwX
	cZ0QhfsTQ0gNuLqIsBrUknUYyF4TWll9HcvJkL9WqA2KIn6tjdo78pZKas7lN1eSF/mGDgyN0CI
	xbxwnbmDuaTPIJ/0RZyuhaA1IQ9iYHi+FTU6UcsGhBzRUOEvhGrIBRreTFUXrmuib2XPiG+PBop
	kifcZlamE7nJqUV6nEXlrHBH1Cwg42Kyo4/5bpxdcTnVgkvmdEHcCqrE112Z3h74Z6nH/FD79Mn
	hiMIgHj9g==
X-Received: by 2002:a05:620a:2804:b0:8a2:234a:17be with SMTP id af79cd13be357-8caefccb4a1mr463761885a.7.1770400662984;
        Fri, 06 Feb 2026 09:57:42 -0800 (PST)
Received: from runnervmwffz4.kbq1lgvzfpve3fkttrmyipmlzh.cx.internal.cloudapp.net ([172.203.38.241])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8953c055458sm22508996d6.38.2026.02.06.09.57.42
        for <fio@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Feb 2026 09:57:42 -0800 (PST)
Date: Fri, 06 Feb 2026 09:57:42 -0800 (PST)
Content-Type: multipart/mixed; boundary="===============1608800566678269724=="
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: fiotestbot@gmail.com
To: fio@vger.kernel.org
Subject: =?utf-8?q?Re=3A_=5BPATCH_0/3=5D_fio=3A_Avoid_errno_and_errno_string_mismatch?=
In-Reply-To: <20260206164058.3105327-1-cassel@kernel.org>
References: <20260206164058.3105327-1-cassel@kernel.org>
Message-ID: <177040066244.2822.12630738825832899651@runnervmwffz4.kbq1lgvzfpve3fkttrmyipmlzh.cx.internal.cloudapp.net>

--===============1608800566678269724==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit


The result of fio's continuous integration tests was: success

For more details see https://github.com/fiotestbot/fio/actions/runs/21758930735

--===============1608800566678269724==--
