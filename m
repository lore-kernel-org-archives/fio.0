Received: from mail-io1-f54.google.com (mail-io1-f54.google.com [209.85.166.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C98823E464
	for <fio@vger.kernel.org>; Mon, 22 Jan 2024 18:17:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705947463; cv=none; b=cf//Gr/NWuKxqWhkPoBk03uziJfFZXE7mbL0i5CtaKJFKkgwtzWQgNEHSOWG9Ov/scyAXL7uo6r3ty9OGOA/9X1CxtJHIYrVkNZyK7yNO3j4GElUPWhjTuRuUH6Y1qWc+er4yObnTj9S+2vpg8wXzoheZ+uubU1bMZTimwshQ04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705947463; c=relaxed/simple;
	bh=boRl+jQYxZF+GxYxHoB19YOxL1r3u6/+sEDq27tYMD8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qHrGxG5hGJ0LYEZKdcMT2/zKp6+RUNxWrGgIjzRyAwjYjf/A53btrxzh3Bgb1OctqzC3ZZdQK9s8BgqwJW104S48loZtZniACX5jqmAnP4cFS12mpCXjkaFGekHaXvXgYFRMDh6GYwE4+Gz3SDBG+Jtl9UCMTSw5o60eareD51Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=dQ8/9abE; arc=none smtp.client-ip=209.85.166.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="dQ8/9abE"
Received: by mail-io1-f54.google.com with SMTP id ca18e2360f4ac-7bf3283c18dso46192939f.0
        for <fio@vger.kernel.org>; Mon, 22 Jan 2024 10:17:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1705947458; x=1706552258; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=mqA+A0cpeOmJwOudWb45JEcwZyzHp8OXRieepcZXDoc=;
        b=dQ8/9abEMHlHZy3D6zYZouv3DtngedrNHxER5s43MGCqVTvkLsFj1bHkazeZCHYorP
         aZ113AaESFCzB9aMJzSY72FsKVAimB41W8KWhQM5JwZ7aBu59VIl/o70JR1DlgZN48ij
         csJpExmhmHTSON3e9dM3P8piojx8ci/es3e/YKFs/UKJvEiPSvBCrAQSjeiLIReQdmZa
         8cCrQThJFXp2lzkf4YjBOUeFaSRvQBs6usydOAZIpnAh24dGaR16m8ZoCRJroQz5le94
         I+LUv8IZiWyJgdxC3HKLaenNT0iYctx1aRRQVTnALZoX1fVfgCT48caTKhLhMpf6Chsj
         j48w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705947458; x=1706552258;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mqA+A0cpeOmJwOudWb45JEcwZyzHp8OXRieepcZXDoc=;
        b=LQDQmnPtQXmh3CkGrZvg8PzbiYfEyWYEZpokBAUINjIAEQhZjN+TjldKM3lPg03c5Y
         lK2IIBA/AhS15VqMNIexc+Zr8wm1mCvr2jWOfeEvj40LqP0Xa1ivpk46IDwvbQMOD+xW
         9g802JbEVDbhYucuA+Vjify/zZCwGzXZjNHOxWIWWFN4yf7gqrG6JO4Fhf6JGNijCSX/
         g/H7xjonteGvGtG1fyuJg5hhqOEe4KesdS+i7x3HbQ0dVWU2EHHJ/KtiB8eH6vyn+a6A
         PRoMYxlnBerpr7cINtscFjXM/reG7iGwL+XkxksdxwmJHDmEARw6CRzrqifMu+jNA6Qf
         +VNw==
X-Gm-Message-State: AOJu0YzZXCp3PV9AjHOVL8sjTcf+D37KQEynGReiKssYXghYe0xJ5Bn7
	aX/IkIJd3aHHVsPgbbG+zI5xMSea6mgom9uAsaozWIaU3CIaV+K5vywKgqhiZAY=
X-Google-Smtp-Source: AGHT+IFZaBS0rJHrGqCYkHUBkNY3OwCN6pGW4e8roq2KRhSKDbiQYAeihIuaIwKhBmO8/+ibu+Kxgw==
X-Received: by 2002:a5d:9304:0:b0:7be:e376:fc44 with SMTP id l4-20020a5d9304000000b007bee376fc44mr6633068ion.2.1705947458570;
        Mon, 22 Jan 2024 10:17:38 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id a8-20020a029408000000b0046edc723291sm1130019jai.78.2024.01.22.10.17.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Jan 2024 10:17:37 -0800 (PST)
Message-ID: <6f3a1f7e-29cd-4e58-af00-9d1be93261b3@kernel.dk>
Date: Mon, 22 Jan 2024 11:17:36 -0700
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] stat: log out both average and max over the window
Content-Language: en-US
To: Ankit Kumar <ankit.kumar@samsung.com>, vincentfu@gmail.com
Cc: fio@vger.kernel.org
References: <20240122112300.47805-1-ankit.kumar@samsung.com>
 <CGME20240122060525epcas5p17d417303b27a454e1db288a61e0642fc@epcas5p1.samsung.com>
 <20240122112300.47805-2-ankit.kumar@samsung.com>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20240122112300.47805-2-ankit.kumar@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/22/24 4:22 AM, Ankit Kumar wrote:
> Modify option log_max_value to report average, max or both the values, by
> setting it to 0, 1 or 2 respectively. There is no change to existing log
> formats while reporting only average or max values.

That would be much cleaner as a posval instead, where it takes a textual
description rather than magic 0/1/2 values.

-- 
Jens Axboe

