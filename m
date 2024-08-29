Received: from mail-io1-f48.google.com (mail-io1-f48.google.com [209.85.166.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1166615CD62
	for <fio@vger.kernel.org>; Thu, 29 Aug 2024 13:16:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724937395; cv=none; b=ZK3J4kLqZ9Yqx8dtEwYEkp6HybMyqvHlCVF384Nxh2hYvcvfvIanEeKfCh+Dcp3EthNuHS6lPaDnuEXez5dVOkJqQqw82FJxN+iYIE1mM2Gpk320+qcPOPsFXedeRuRU4t0FsFkLFZL2nekbanKr+iJDAmkXR+lrK6VhZFM29Yw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724937395; c=relaxed/simple;
	bh=9oY0N1p5wzVdlUBFV73GM7c+TpQ+zJriwmDM5qEaF/Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XZtBAjDl6XNU/j94q+rySX/9P89Wmoqy+zPalxYuG6brZgLtGavcLvg1XOYoB9z0RSisDaRUYMbmi+AledYZAKbJ6NBwz4sTE55gwLfeIn7sH+i2g2xVjxUYoC/tRm0jVqy6t6t+Uit2BClatiaydVlnXSbcTYdnawc4d5+RyPg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=FsBJBD1O; arc=none smtp.client-ip=209.85.166.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="FsBJBD1O"
Received: by mail-io1-f48.google.com with SMTP id ca18e2360f4ac-829e8718502so30487539f.3
        for <fio@vger.kernel.org>; Thu, 29 Aug 2024 06:16:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1724937392; x=1725542192; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=pk9WvI4ZT9gNNpe2ApntPfDP6ZIqu5I3IA6ZQjYdOy0=;
        b=FsBJBD1OxHwQDB4rsfAxYzSL+n7pjG42+3t6++W5wNPw6b7lHChHwHAxpU2F/Z2GB2
         LnLjgT8iYf4rkHYSvTqXtO/Otgxkosk0ZgXsVE1m/0Bs5wHj3ag9pawbXeb8yrpsPf2z
         9rOK5mETa+iKZ+oe6ZS0pUX1r0bov3WZvtQV4ryXp7wPJlCAegYHHsW4FIWmicrEIe5g
         /6meaSKe51nIUqKzwc23rRi6RWOYxW1aVdpSJm/AniQN2fNRRtudNzbSaIUa/uWPWhNE
         QsiPJkLhnVjuDU98ydX/wGc8qjsXRhuiyd07zM2hifU6nt2PrR79BfgW9y38Nfu9C7tF
         m7HA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724937392; x=1725542192;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pk9WvI4ZT9gNNpe2ApntPfDP6ZIqu5I3IA6ZQjYdOy0=;
        b=PvAgOBH1Eex795LPXOUe1qQ1iVU0DOYsl1MGR83Iv9R6L/cuS4gDeic07dbTYQHmkT
         57fYBjckHSGkBdYxOXTB2fhroiPfbKU0L6jSUUQ/CvuEP6X+oRVo/oXqPXzQytkMnQLu
         WoVrNu55J5LSFa4zv0XmBYwmtDsQWpS7MvI6rTwkrYe0IZWPHuRrMb4qCDyYcdKV/ars
         ronXLZ6TfhS/Dt/g82aAWfts28wImnFpIEvZGbz3pLy7YHyD86g/yWd4LpKknxE33N9y
         qJtqY6+iLK4U9Q5cBGSqk4j1ivqNauu0p6fmov58s2bi2IagqrG83KJx1OYgNROYTmcG
         g1lw==
X-Forwarded-Encrypted: i=1; AJvYcCVzqUlqBo9FFv/3kajs4eBDoYiVaqHNu6vZ1KuGgeDpa0Mr42wE9x95OwEaBec8CUp+xlE=@vger.kernel.org
X-Gm-Message-State: AOJu0YyZiveqxo+ztmck6kPb5jyEqjkhf/vRZ+29p+4DfhpTp3drFU1z
	0d+5elKwyBWEUFm+2+qgz6lOBRazhzG0O5lYdHlxxv1Hvf/EBZQztUGucjwh3h0X5F97cplldsY
	l
X-Google-Smtp-Source: AGHT+IHul3Ws4FV701AOhRgpTa4o5lpbiXyxBZ7Ro76msl2xQYLlCMSFtif7jecJxdi6FKFBQMAysg==
X-Received: by 2002:a05:6602:619a:b0:804:1579:182c with SMTP id ca18e2360f4ac-82a11011423mr346295439f.5.1724937392011;
        Thu, 29 Aug 2024 06:16:32 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4ced2eab562sm237834173.134.2024.08.29.06.16.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Aug 2024 06:16:31 -0700 (PDT)
Message-ID: <b761e02d-8c75-4b48-af09-67fb2ca86b4b@kernel.dk>
Date: Thu, 29 Aug 2024 07:16:30 -0600
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/7] os-linux: Renumber RWF_UNCACHED
To: John Garry <john.g.garry@oracle.com>, fio@vger.kernel.org
Cc: martin.petersen@oracle.com, djwong@kernel.org, mcgrof@kernel.org
References: <20240829123107.520005-1-john.g.garry@oracle.com>
 <20240829123107.520005-2-john.g.garry@oracle.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20240829123107.520005-2-john.g.garry@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 8/29/24 6:31 AM, John Garry wrote:
> This now conflicts with RWF_ATOMIC.

Still plan on resurrecting that at some point, but I think
for now we should just drop it. Let me commit something
for that...

-- 
Jens Axboe


