Received: from mail-oi1-f172.google.com (mail-oi1-f172.google.com [209.85.167.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94E8A18DF81
	for <fio@vger.kernel.org>; Thu,  5 Sep 2024 18:53:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725562420; cv=none; b=MvAhXcm6PyTAzSDhMwlT6+Bx8ulINjScitsYGHs1F8hPlzhBdecEg8Svzh+LiA5f3tBauR2ZNq8nr3vf2cWqX+aGKHYMcR2SLjtONEfF4W+Agijkfm5dnR7c9IfZtOrjhkk3n3LotemltQ9QeYIqW8Zpz341L9CkJbSf0RY/W7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725562420; c=relaxed/simple;
	bh=N7hoF1wB+MFOXV93Yz73uOg9Y374CZwVt2jVgCPUcBc=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=u/BB/fz2H6o5hORFTgu99rYQq6BoxVTh85gQfuz/DeIKh/NZclwie4X0Opsk76JvjmiasgVrkN6M/2UET8aez8n9E63Rbt5l2mqo4j29J3KTeZym1ScDTkmwrqlyWHHv5bODF0rrcLV7NOXzG78o9fabobWPswrKRCD7XhVavds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FPHBEzCo; arc=none smtp.client-ip=209.85.167.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FPHBEzCo"
Received: by mail-oi1-f172.google.com with SMTP id 5614622812f47-3e0059dc06bso759641b6e.0
        for <fio@vger.kernel.org>; Thu, 05 Sep 2024 11:53:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1725562417; x=1726167217; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YYna/auDy6TetQ/89HgKb4PNOA1PwftrMUEyClTQMD0=;
        b=FPHBEzCoK3YSdJ28I73mK/tFGpBxWe7S5fxlpg4pYJTJtIJnFGuUxKa7Wml7kvOt2i
         dvHWs55DZuURmjnMr9CTuk+vNr7axIt9R78JLgFeWM+1J5suhimCsG76UanRinXD8uDH
         0opt6NfbQzYzhYiIA/bFbqvq0e6JgVGJvffh0H+N1Ta2X/40oWnBeKlHmDIETHpZlJYA
         uKlgeLGodWOzBmZDukPL6/ETCO+1c65o8E/fypKGDjTxVYfdFjkFBHZK04FNf20gbntr
         9ipXTuATlGJee2Z8afFfUEveFBhMrcbFiiHObQ0SZokFNwJP0T+fusk/QTtET+IDB9Cv
         2RKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725562417; x=1726167217;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=YYna/auDy6TetQ/89HgKb4PNOA1PwftrMUEyClTQMD0=;
        b=V/YOKp3Sd1/aq+D2UrGoNGV6XcMceiWVt0q9VLHoDcZUo63n1YpttX7nY4LaCL5SPl
         0foehL9PcMPK/9gSkdFTxo6nYf3Gz65g/TYpg/3ZinmiNgL+oFLrHznN+omDev2/Ia68
         MoniGsSCaBKyYt5B4VWL34OtrLvEDvIZ8M9lQwdkK5nOb/CBOfs6BRuT3wo+du8t1jLf
         948djkYH0HwzpLj9wTfi3neBGD17+QSJ/kgG7kfPIqU+pJBIcYO50lTSqQk5ombpSWAK
         M1QWlIz8s1JpbHsD4/0g39agBt8lq4mqK3Sfyw14CF6wI3Wt/D1Wgc9TEtDvRwKAGOmK
         0Obg==
X-Gm-Message-State: AOJu0YziRA890V//xwEv681uFiVnHQL96RagmG6BEo3D53JIayhKv+cb
	Qi7gnyyueK+N/h+yRjOe+aDP4zCF5oAc2LC6nxLnnGG+DZYJc1n+CWuWeA==
X-Google-Smtp-Source: AGHT+IGtZTitnHqNVkqalBBi6MoQKoFibR26k5NXTEXcfaPC9EFuZDSlq/QKNQro0tbDFmoY0C4OrA==
X-Received: by 2002:a05:6808:152b:b0:3d9:28d0:fcd4 with SMTP id 5614622812f47-3e029ce81dbmr352057b6e.5.1725562416896;
        Thu, 05 Sep 2024 11:53:36 -0700 (PDT)
Received: from [192.168.1.220] (pool-173-79-40-147.washdc.fios.verizon.net. [173.79.40.147])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-45801a15271sm9648701cf.5.2024.09.05.11.53.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Sep 2024 11:53:36 -0700 (PDT)
Message-ID: <0e2c84c9-f9e4-4073-a075-016393ca7bde@gmail.com>
Date: Thu, 5 Sep 2024 14:53:35 -0400
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: "fio@vger.kernel.org" <fio@vger.kernel.org>
Cc: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
From: Vincent Fu <vincentfu@gmail.com>
Subject: latency logging with file operation IO engines
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hello Shin'ichiro,

Coverity reported the issue below with the "stat: reduce arguments of 
add_log_sample()" commit.

** CID 509196:  Null pointer dereferences  (FORWARD_NULL)

________________________________________________________________________________________________________
*** CID 509196:  Null pointer dereferences  (FORWARD_NULL)
/stat.c: 3342 in add_clat_sample()
3336     	 */
3337     	if (!ts->lat_percentiles)
3338     		add_stat_prio_sample(ts->clat_prio[ddir], clat_prio_index,
3339     				     nsec);
3340
3341     	if (td->clat_log) {
 >>>     CID 509196:  Null pointer dereferences  (FORWARD_NULL)
 >>>     Passing null pointer "&io_u->issue_time" to "ntime_since", 
which dereferences it.
3342     		struct log_sample sample = { sample_val(nsec), ddir, bs,
3343     			offset, ioprio,
3344     			ntime_since(&td->epoch, &io_u->issue_time) };
3345
3346     		add_log_sample(td, td->clat_log, &sample);
3347     	}

It appears that with the refactoring it is no longer possible to carry 
out latency logging with the file operation ioengines since their calls 
set io_u to NULL. Would you be able to devise a way to restore this?

Vincent
