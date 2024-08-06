Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95579376E6
	for <fio@vger.kernel.org>; Tue,  6 Aug 2024 18:27:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722968863; cv=none; b=VAamkn6zf3jsqMvDru5/ZWT46UCRR9r7wW7nmlpYntMXiuYcxpS1aldf7cbtIj/3pnthZf9X3Pu/y62WZECzGk/ySyizuImNUYzBIpSt5z84tguvqNoHLBY4r4uY5zwPmfqzAvIsZqtKQZODXaUsPq9F4hvyhj4O3V7fKGwZZrQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722968863; c=relaxed/simple;
	bh=t8cvA7ACsoRqtlf+1cIWeBrNsN8/Wwzin/LSoLCK2js=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=QzTiCtIU3taQ7G+fJMi906H/POMfTDbL3iexI3NYuyjTcAhGC9svAFTXnq0/OqqVNFAzoA8gP1G0e3529qWZoU52GEuXjjGIz5gv3B93eRIMOyp9l5Mz/DLsrgmXNZTSCgt5kGSaUnk/sK14hP78n7sBwJ9KVz4JwTg6JfTGtw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=pcpartpicker.com; spf=pass smtp.mailfrom=pcpartpicker.com; dkim=pass (2048-bit key) header.d=pcpartpicker.com header.i=@pcpartpicker.com header.b=HfduvtUY; arc=none smtp.client-ip=209.85.208.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=pcpartpicker.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pcpartpicker.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pcpartpicker.com header.i=@pcpartpicker.com header.b="HfduvtUY"
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-5ba43b433beso1058155a12.1
        for <fio@vger.kernel.org>; Tue, 06 Aug 2024 11:27:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pcpartpicker.com; s=google; t=1722968856; x=1723573656; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=t8cvA7ACsoRqtlf+1cIWeBrNsN8/Wwzin/LSoLCK2js=;
        b=HfduvtUYVAituFqbp4RvFGUR3q1/Mc9bPoOQ/1Kz4ILmDctDE9aEfeNt6nhKtddG8k
         Q9L0JTqtp4zVaUU+XcQ91VzIuScL9GAps+NG+jHJjfD6Ks1SCl5xgl/vHqZIet+Xs10B
         edJZtwDfJTJx4MIER8u+gZZn256a8a+OaNqQ6sddHKTvWLRal7+MkgEC+1ISTL6s/kqw
         urEWHsxy8IYtGt3xfeXPfjx408yvbDz7P5jfp2SLQnWXE5FCOotg18Ydm3nSn6iWXIlP
         y9bM4bTWZSI31dQnVKHvt/tgP0Ds+w7XgbWIXm6td6zY3KFP3tRkyYKjBKNroZmDqSny
         0eoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722968856; x=1723573656;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=t8cvA7ACsoRqtlf+1cIWeBrNsN8/Wwzin/LSoLCK2js=;
        b=LANUR2TbKV5LfCGJejU3spwCaaMDfUGnAPgrJ/zh/BbC9NUpVZ+/hBbTKBO/bUQJb6
         oEwyQr+yzZVU8D00w/SrpknrtGzfsuoY1hsRU38c/pyik0kVgtanHFqDLAuT1YKvjAT3
         zVNYOFkLczmj5sREAxD2tXhXtlb6eAxyIhori0s5XUdK6Q0X2SPg68yEjHjBaumuwGdK
         fl51+ue8ud9YfCP0II55/0H+kI6YivJ8Ct4yiSnzEaJtYIEO3MMU+OVLMdd2u3cBCQci
         mUdiXPVnhm9p2Y0GaOR+x/Lrkh0AGb04BCqWj76bevJQOjvCkndgxCtJxnmTMFWXNb1Z
         28hA==
X-Gm-Message-State: AOJu0YxALZ/KlwOWzGUSwa6QUWAsfmteIu6cDwppZmz9mIWcR32GIfeT
	XQ3qrIboUnUvrg6Gk+6lVenQrGOwZbrMch3wHPffLF/G1LwkiE8srJO51KXUomgBMittJgCMbba
	X9qgKTBFKQb+7ULwE7KxCZq4HuvJWSuIAYmqMpdYp/UoYaQroT4o=
X-Google-Smtp-Source: AGHT+IF4iMTmqOJrVZXVH/DG4o7u5F7ZpFyR3lFx2hFVvFoDcZqh4aFD7S8auB/V7bjquM6p7b3q/UWdlQ19+pz+MHQ=
X-Received: by 2002:a17:907:983:b0:a7a:b977:4c9e with SMTP id
 a640c23a62f3a-a7dc50203e0mr1041783366b.21.1722968856037; Tue, 06 Aug 2024
 11:27:36 -0700 (PDT)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Nick Neumann <nick@pcpartpicker.com>
Date: Tue, 6 Aug 2024 13:27:24 -0500
Message-ID: <CADqNVTqgZUs83yTKG_nJnbcg0JgO7y9n=zwk8rh=jr8SwHmVZw@mail.gmail.com>
Subject: fio and cpu vulnerability mitigation best practices
To: fio@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

We recently moved to Ubuntu 23.10 from 20.04 as our main image for
benchmarking SSDs. In doing so, we noticed that many devices showed a
significant drop in random I/O tests, with the drop more pronounced
the faster the device was. We determined the root cause of the drop
was the mitigation for the recent AMD SRSO vulnerability:
https://docs.kernel.org/admin-guide/hw-vuln/srso.html

A notable example is random reads on an m.2 Optane device:

sudo fio --filename=/dev/nvme0n1 --name=job --ioengine=libaio
--direct=1 --rw=randread --bs=4K --iodepth=8 --runtime=15
--time_based=1

With AMD SRSO mitigated: 1249 MiB/s, 320k IOPS
With AMD SRSO mitigation disabled: 1682 MiB/s, 430k IOPS

I was looking for feedback on best practices for deciding to disable
mitigations when benchmarking SSDs. In general I'm hesitant to disable
mitigations, and all devices are benchmarked with the same settings.
It can be argued that yes, bandwidth is reduced, but the mitigation is
similar to using benchmark hardware with a slower CPU, etc. As long as
all SSDs are benchmarked with the same hardware and settings, all that
is happening is a compression of the results - faster devices should
still be faster, just not by as much.

But this particular mitigation has such a big effect that it makes me
consider disabling it.

Thoughts?
