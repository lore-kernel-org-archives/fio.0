Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A292D1D9663
	for <fio@vger.kernel.org>; Thu, 18 Sep 2025 09:39:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758188364; cv=none; b=cHzNw5yBvI2WvJ+nl/qgO1hK5sq3mErx6mnCcwVTAsS5k1F1SLPd8wdtr8Gbx4IGy7ir0hibVdzsrdWQpg0FW9tEXBwTKsGvz2GvO1pgmEsM3wr8xLQh8QnwY+sGv1SoRD+BVdhbet7hfQsqVZgs7nuELC4X13iwmi7Mf0Pv/wA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758188364; c=relaxed/simple;
	bh=izW4OLF31lxWTUIoOPNt8o+LopgisN3tTqD2ThyfOu8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Nsi8Hdk6HLJhslWH4XPCcVf2C61rrr7F3jjY4sAw04KiisQx5+x5Z3r7LuuJgDkvEDyirPk+aaRIZ5ozRBXb5fKsP0awJBgm6HA6p87nmnBsbOFiRdg/L1S5N+hwPQoJ7qESxXtdJYrM/Yx4AdfQoc802M1zb8B8lE9p5Ssom6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hpnNQ7ah; arc=none smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hpnNQ7ah"
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-3eb08d8d9e7so647568f8f.0
        for <fio@vger.kernel.org>; Thu, 18 Sep 2025 02:39:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758188361; x=1758793161; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=dHoh+SmwhX0qsHmn10JrPavT16LjgGHnvKoI0K1EMLI=;
        b=hpnNQ7ahbv7bx7L92a9TGqsTzFQTsTRBeoVG9la9txy1CVst8OlxRxQUjRIkOAhd9P
         TNEVsAuj/xE235CuLp7pM2upPhbJZ2WK0SdaFSYkvZHdpuONOD8mFE6IslwfhtLcpHMg
         nxtlbmhwMoQzAoQCkKJ1JXNRd5rgz7Z5m/4KVrXjwlPm+uTx7JVRk8y6oMCV57IXtJjU
         vrjOnzUVihr/6rlYomMZUCyFv+AYvLg2SuTod5xFJ1/dY9Al9nShFUlb73+UdsnB2wFX
         KwWOxL/lVxpyAtfa1XLJ6psXPAarAv41CPvbldsJz7IhzWVRUE6QvWbJDvPdyOZhxaVQ
         Kugw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758188361; x=1758793161;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dHoh+SmwhX0qsHmn10JrPavT16LjgGHnvKoI0K1EMLI=;
        b=cu6id5o3AOmYdUOkjTvQV2LJjtC8EicYFIPnDFYWzCfbSgJWUhwHlzDripl503VLmH
         eWmyHEgB0gdf0h5VKY2SjQqGOjBup4s9lmn2p74XJbxt8ipjuhjReOjI5NMoOuH5pEoK
         ES9C/HIzc51SOVrvVujYMGNgPlx6WUkv8iH88qDxm5M1OEQEzax51PqZ3PdjZ1hWLRZL
         3+j1dG8DGVbzA7rEDdK6in/q7At1q7JIqyCIoqy1zkQ5HRNrw6zcazw74oR3lGgO/FMZ
         AVedUoKtgTDnrvUkRG3L7MjhrwLytQy4LEuTXMWp4n41hqH0aCWpy0d1CD5yvWTwr4QZ
         ZNYA==
X-Forwarded-Encrypted: i=1; AJvYcCU+mtL3mS6NRT3Vp6ujdQW4eDIRqFpA3F7SoB4OweYJbmXrBuhKOlBOhu65K3SRs05O2q4=@vger.kernel.org
X-Gm-Message-State: AOJu0YzTqE1wR8b+esT7y24nC3Tq9QMdzwe443wssYxI4IpYCSY2Mysf
	/27NJP20w2lVYXwq4iB5lilMQ62j2ZgFityR/13Vmbz2hh7+zXfaXBlv
X-Gm-Gg: ASbGncujWDp5wD+o57wgAsbnf3LdXLFGtrtnJyYxpGbmTAqtw2gAZYi2sWnlpoIuNOV
	Tw5A2JHTuaa0T5Dq5cOu+ybw7qL9zdM5ukw7ZyRfqw6OLMs9QIog077KzlIKMygDF7SBEF37sf1
	ccrA9hatOQx3BIRHOlYRJOiQ/QVOHuvadNtVI5nZ2rgic5irWXn3MIt0H8M++w1gm9aI7gl8htk
	r9gGh0nFFpoFRuCsDhHDzCIni5AtvIV4mS31jP+wqEMrPy62eJ+c6PQxmB7qGuQ7+PASPxunya/
	2DGZDLkpWMTxLRQ6DNi0h9PJb1TI4PQSrn4FTOf8q0l7UOEIxEMz1hVRcV0QBS1mJy+T3b476O1
	7dxkkgicwBYvOW0aoBRx0fUNJU4UWQIC/pPsLw+RB8yk0hqxj1ot/wAhXtqJMMIXHhBjcFN0F7w
	==
X-Google-Smtp-Source: AGHT+IFePHniVcO9+6X8MEKq8bGaP6MXCsV9j5WvNAhfGtJQemwMSO1pVt5F0ikCtXGnSkZRy1f9Rw==
X-Received: by 2002:a05:6000:4181:b0:3ea:6680:8fb9 with SMTP id ffacd0b85a97d-3edd43b6dddmr2847974f8f.3.1758188360790;
        Thu, 18 Sep 2025 02:39:20 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:325:77fd:1068:74c8:af87? ([2620:10d:c092:600::1:5265])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3ee0740841dsm2861317f8f.23.2025.09.18.02.39.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Sep 2025 02:39:20 -0700 (PDT)
Message-ID: <90588d86-0f34-40d9-bb21-3ed492d0304d@gmail.com>
Date: Thu, 18 Sep 2025 10:40:51 +0100
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] t/io_uring: Vectored fixed buffer test support for
 nvme passthrough path
To: Xiaobing Li <xiaobing.li@samsung.com>, fio@vger.kernel.org,
 axboe@kernel.dk, vincentfu@gmail.com
Cc: kun.dou@samsung.com, peiwei.li@samsung.com, joshi.k@samsung.com,
 xue01.he@samsung.com
References: <CGME20250917070310epcas5p37da73fbce2e0571548a0d840e20a445f@epcas5p3.samsung.com>
 <20250917065838.6204-1-xiaobing.li@samsung.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20250917065838.6204-1-xiaobing.li@samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/17/25 07:58, Xiaobing Li wrote:
> The current kernel NVMe passthrough path already supports vectored IO
> when using fixed buffers, but fio has not yet adapted it. This patch
> aims to add a corresponding test interface in fio.

Great to have, and good to see that the performance impact is
not noticeable. It'd also be nice to add support for vectored
OP_READV with registered buffers, unless I'm missing sth and
it's already enabled.

> 
> Test results:
> 
> taskset -c 1 t/io_uring -b512 -d64 -c2 -s2 -p1 -F1 -B1 -O0 -n1 -V1 -u1 -r4 /dev/ng1n1
> submitter=0, tid=6179, file=/dev/ng1n1, nfiles=1, node=-1
> polled=1, fixedbufs=1, register_files=1, buffered=1, QD=64
> Engine=io_uring, sq_ring=64, cq_ring=64
> IOPS=289.78K, BW=141MiB/s, IOS/call=1/1
> IOPS=294.68K, BW=143MiB/s, IOS/call=1/1
> IOPS=295.26K, BW=144MiB/s, IOS/call=1/1
> Exiting on timeout
> Maximum IOPS=295.26K
> 
> taskset -c 1 t/io_uring -b512 -d64 -c2 -s2 -p1 -F1 -B1 -O0 -n1 -V0 -u1 -r4 /dev/ng1n1
> submitter=0, tid=6183, file=/dev/ng1n1, nfiles=1, node=-1
> polled=1, fixedbufs=1, register_files=1, buffered=1, QD=64
> Engine=io_uring, sq_ring=64, cq_ring=64
> IOPS=292.31K, BW=142MiB/s, IOS/call=1/1
> IOPS=295.79K, BW=144MiB/s, IOS/call=1/1
> IOPS=290.78K, BW=141MiB/s, IOS/call=1/1
> Exiting on timeout
> Maximum IOPS=295.79K
> 
> Signed-off-by: Xiaobing Li <xiaobing.li@samsung.com>
-- 
Pavel Begunkov

