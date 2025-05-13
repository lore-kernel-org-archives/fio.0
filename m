Received: from mail-io1-f41.google.com (mail-io1-f41.google.com [209.85.166.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4099F1E8328
	for <fio@vger.kernel.org>; Tue, 13 May 2025 18:07:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747159640; cv=none; b=ADMqEIMyNFRGxUXa8Ztpp7naKsoLktpm5jlwyyQOfOp8WpitQ30rbrKutuT/AUbzCiNHEwNY6XmE20Xz4qr/92ZIrq1i8f6MVtd6/SQWzAq8Y1RJ0qHSmVnGhSvQwI/uLyr16DhEoj1a5p26K9Zw19Y7I4ODtH0BRRD2mfjdhYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747159640; c=relaxed/simple;
	bh=mxuu6BpTg332TYu4Kwok/j7wMJSDfTpzr7wW9uIWzlw=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=tEaXOZHI/RiOc9ZoLlGS+veXItR9VTXFE1O4YDXt3UBfYDYAWUnaXctwtDSpHdNiyjLKFZkWzWoX7HBzbjoX601OREpzSp+JG1X2Fj1KLQH4zixtkeMWyh/Pc+e3klRFsiLI8Ic/RVNtCtLkWnDgoLJzbewggQ/UAm3HQQk6dnk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=oQK1Wfxn; arc=none smtp.client-ip=209.85.166.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="oQK1Wfxn"
Received: by mail-io1-f41.google.com with SMTP id ca18e2360f4ac-86135ac9542so5633139f.1
        for <fio@vger.kernel.org>; Tue, 13 May 2025 11:07:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1747159635; x=1747764435; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aVr01JCveL7c+t3oKnRb3toDx1qxjgvKJfVeaWFm1GU=;
        b=oQK1WfxnVWTfFo6QcIPu9t2s4dXti4GwXPVDZyTa8SsQIACClSk0Uf4Agll7rtluLh
         dPDfRNC1v7JKxkiJ6aK3iEf3I/axflrw5nK1M5CvMPm7VdzKS6WjU1yTKGYNmvGe0m1A
         PElkAtN3isRomcQCFx8lBUCoMYIb17VsOSMRMxPax+RDNNW7rnd55tx654NumY8oFd03
         hu7KRnKwzoiQOoYxg1K/GBTMlmEy79kQBGqkKtIbJEBGAGC7P5U7soqHRgKVZ8d9DbrB
         rz1uILWsIxzmZgF10Ek6C24VmEDpiJnc5GsldNeY5zfOImJXG9hd1DQsZUU4/IRyoTio
         Ob7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747159635; x=1747764435;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aVr01JCveL7c+t3oKnRb3toDx1qxjgvKJfVeaWFm1GU=;
        b=e8ZTxy2zycYqHyz9bsXdxH9rTWt4zSaUbNTzxRMK5Tocs3K09pfRBZ6FKZdd7cyLZT
         yjMDwkLusGlL3CihRMvYhb04xUd4exaab8e/HDKqVrvT4ILzf7tzkWncOdMj+6WXzknu
         6JpxL6XUXpUgw4dkuoGwMpELBmhjDiGLZMpuk8NnGcttyB+pJqbW+16aVZv6o/VAPs/0
         dvz/opaduzPRxSSwqUiPehbC11jhR4+rg/3wzdRgPZvGKnHskNHFXeTP4vJL6+no0bQ3
         KQ8HFi1uoMjNKKZuOfzfJS3ac/QWbvayd2CSngUV10XbOHgB7/PpMnTHRvmy8GLHIt1m
         oODw==
X-Gm-Message-State: AOJu0YwNwkeiC3xTfaNfYY/SphwUajF5QkWZ5cLds2560BnORdk7nLjm
	L5DbIV3HQDXf9eCeuqoRiGCQ+JMpxTcRJ4Rtvap1eCgRrrTp3Mv67kq6PPAFfuNtXdwhmWcYgo/
	t
X-Gm-Gg: ASbGncuV8FZmwfIKH6QdvWtO8PBrrh3EX3EU0wC9HjI8AA7E7UUfQpSaFfERPIrhu0O
	19c3TDGgN6d85o8qn7VoVRrr/I+4GA8jE+92oHjzQwzEtcqoIgU5VIhzZNs7MVhSaKjeoHnCxk1
	hRZ7geBRO2lrQ4iYasLcnMdE7YZjfJrucCX7u97jtdWwyyMYEVyMN5dv2eKxQ9L4j6fZiv2SKvo
	G0wh+KtMjHo5hITbuJhlobR6IprjCWDEmYfFuSbLd/gFkzYdqnUBm3ykfoCLq8Ig7taTtI2MY5O
	ocGTt1fPA+Ijtb/236EuN0wZu/WpPfXf36PJdHqWk5cz9+T9h1Gx
X-Google-Smtp-Source: AGHT+IHb0xJ+VAz83wh8umB2HG61jEbKqR8e6njSxZhjUcociMLc69xM1v0cYCx0AR51CSPQxDx/DA==
X-Received: by 2002:a5d:9f51:0:b0:85e:dbe3:137f with SMTP id ca18e2360f4ac-869f9576f93mr463912339f.0.1747159634722;
        Tue, 13 May 2025 11:07:14 -0700 (PDT)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4fa2249edb0sm2195676173.25.2025.05.13.11.07.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 May 2025 11:07:14 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: fio@vger.kernel.org, Vincent Fu <vincentfu@gmail.com>, 
 Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Cc: Damien Le Moal <dlemoal@kernel.org>
In-Reply-To: <20250513031837.74780-1-shinichiro.kawasaki@wdc.com>
References: <20250513031837.74780-1-shinichiro.kawasaki@wdc.com>
Subject: Re: [PATCH v2] fio_sem, diskutil: introduce fio_shared_sem and use
 it for diskutil lock
Message-Id: <174715963384.431924.28807087420248562.b4-ty@kernel.dk>
Date: Tue, 13 May 2025 12:07:13 -0600
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-7b9b9


On Tue, 13 May 2025 12:18:37 +0900, Shin'ichiro Kawasaki wrote:
> To report disk utilization statistics, fio allocates struct disk_util
> objects for each disk of the I/O target files. These struct disk_util
> objects are allocated via smalloc() from the fio shared memory, allowing
> them to be allocated or freed by any fio process. The disk_util objects
> are managed with the global list disk_list and are all freed by the fio
> main process at the end of fio_backend() through
> disk_util_prune_entries().
> 
> [...]

Applied, thanks!

[1/1] fio_sem, diskutil: introduce fio_shared_sem and use it for diskutil lock
      commit: 21628ec537c7228a5df62751d228b6af585f882d

Best regards,
-- 
Jens Axboe



