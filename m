Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7A391E526
	for <fio@vger.kernel.org>; Tue, 23 Apr 2024 08:59:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713862761; cv=none; b=tlQy3p2eov6Fho/AVWHi0T31RGl7RhiKUuohcv1G7ZuUmgJJjxeuPXTwwTnSk/gNjfJFm6nkycFC7wh1FKJcho8Y5DItUPKIiHBrzSaDuAg5AS5jgTNURIj+L6OeqFMxNoTogS8sUmUVDHOcK8jMjwrsp3VZzcmENEjtvmePhAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713862761; c=relaxed/simple;
	bh=kJn57FjlzpmQg3bZxzxJEpZppsZF4hnK9+C/OzvAJaA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ZV15sUCnoP//9wUjoB414PgPK4gfHZ3hRVsPDgiYm4Vs1PZcyTERiswNa56mpqsT2euWxYR/vew+SPo47LqrYFS920JDohOYbyA1hSBYmzrH3C76HkBAFbZDhc4xI5mVt50L+1ZetmXky/zm5EiqqpiUheMIm83R6fBX7JaXckU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VrQBzhdB; arc=none smtp.client-ip=209.85.208.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VrQBzhdB"
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-57222fc625aso176283a12.3
        for <fio@vger.kernel.org>; Tue, 23 Apr 2024 01:59:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1713862758; x=1714467558; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=kJn57FjlzpmQg3bZxzxJEpZppsZF4hnK9+C/OzvAJaA=;
        b=VrQBzhdBGvVDEJuY2/Ub9m1EekHUm6jUh+l4FtFElUk27H4jgyCmcpj0yyg1G5QWtw
         Qqot4NRes+lLLW+4SSkH7J8rS2ck6vw39gEbfAWHF4OTeLxNBOjQKoXLs5urYuWRwynV
         v+d2F8LblwBtJHhzUYyFbgWWmJm5Sx0m5JzBSFcDEJCBs4WUvfuxkZ48Y+oJmSAzEwGr
         i7uNiYJTOseHug/8KauiYY9fb9Yt72wR6Dd/n70Sowubj3WsozFX8/PimZG5u/FZptVS
         Pb5CGa1fdfTrhLBjPeo1rzwEnPSMDy4tfuQuHAXEnmI8A9bdHdSQF/1YHzrKmoqWIZO/
         vTeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713862758; x=1714467558;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kJn57FjlzpmQg3bZxzxJEpZppsZF4hnK9+C/OzvAJaA=;
        b=DGjZZvvfmtnzw9LL581He/czK680fTWfvvAQvO3tub0sMdVkrV+Ka0+ogbUFoH8XLe
         qNHhlEiwgAVTpvETQezzZWD7g3csLKw6aFUejZqnvghgiabp9tVXrT6hjAj+3A5bOu30
         HdP+KQBrc2tZUdSroL9Aipgz1EpR2JZ6RlWf4nCTtFUmBM74SmbXKQqoqAlLFv6ucUDa
         ZxHU8IHfh412q1F80HDcbtk07WeJOb4famV04aR6pS1J2ZUTBBhLvDzJMi1STS0qi7hh
         RfHnHT05Mcy/HxSVV9LBlfOyQGhv7j8qtZ30IiCXGvO9Zdv5pM3/FhZkQI4Dzq6E/Vrd
         1zKA==
X-Forwarded-Encrypted: i=1; AJvYcCUkmPCKqRHLrms55KH7wejStm3uX6L6pTqCHCYjI/jIyhDFGu3whP9UtfO8Sl4Gk43u/SPCe6kKZ4raABPHovrmQBAs
X-Gm-Message-State: AOJu0YyeKqspzzsOI+zDjqtWCHiakwObKLXrLleB4SeeutzAqPQ87wmG
	vbNacUvr/YJ0qnmBu4aU6bHHPPur5oui7aEOqR9mEQORZLSbI15LnEaDjfe5p8vJu4OY6P0srRP
	xrubtZFV4JeYvMJb8QgxgqX9Sl/bkO+pd
X-Google-Smtp-Source: AGHT+IFU0xPdoF/jrtANdM2aJjmbN894+hR9F0CYSOfYRseK1vS1qOXKOSCvsD5hNZjldqLuoLQGCERXPUI+7mHb12c=
X-Received: by 2002:a50:bac2:0:b0:56c:4db:33f7 with SMTP id
 x60-20020a50bac2000000b0056c04db33f7mr11546657ede.10.1713862757979; Tue, 23
 Apr 2024 01:59:17 -0700 (PDT)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240422175522.4614-1-vincent.fu@samsung.com>
In-Reply-To: <20240422175522.4614-1-vincent.fu@samsung.com>
From: Ankit Kumar <ankit1455@gmail.com>
Date: Tue, 23 Apr 2024 14:19:48 +0530
Message-ID: <CAKi7+wco_sbPbWp3_V0p4UOzBXnaQ7KhvTnGcSbFy+VWZr899A@mail.gmail.com>
Subject: Re: [PATCH 0/9] FDP tweaks, NVMe streams support
To: Vincent Fu <vincentfu@gmail.com>
Cc: axboe@kernel.dk, ankit.kumar@samsung.com, kbusch@kernel.org, 
	fio@vger.kernel.org, Vincent Fu <vincent.fu@samsung.com>
Content-Type: text/plain; charset="UTF-8"

Overall changes look good to me. I was thinking maybe in future we
should add a new group for all the data placement options, debug logs.
