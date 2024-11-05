Received: from mail-qv1-f51.google.com (mail-qv1-f51.google.com [209.85.219.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9ED2C1D2B02
	for <fio@vger.kernel.org>; Tue,  5 Nov 2024 19:41:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730835667; cv=none; b=KNkt/Hx5If62yy2YAf9MO7gXdDNr5Xh4VgvtGSxSIaOreeBrqX32mqdVTSJgqe7eYY4Iz+twc4GV2Om3yRJKygL4+Nz3o4AR5WhsjU3daKDL3Qh5dEHmd749zRgfv9J+tNaGi6/OQtoAWcr5K7UWzekdCupEAN4oOu14PKAPSCY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730835667; c=relaxed/simple;
	bh=4thEF6DrmNbt8v5TCcFEQN0EUA0bS/emVEtHiWIh9qY=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:Content-Type; b=d9XIb1p3njeFUcEzOKlOwtzwDv7awwzV0DfHQ/sr9z6cXiy7xfe3nmBzbcXOI/fgGbQnVkzNCEucUmlnQKphAM4CHINtDRgd2IyLuYb/uwx661vaWW059fTuKNKbEIokGolePIsf6QJke9jWhH1BCyzmEos+DOOkfcdXTUPQq0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TGMBFszT; arc=none smtp.client-ip=209.85.219.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TGMBFszT"
Received: by mail-qv1-f51.google.com with SMTP id 6a1803df08f44-6cc250bbc9eso44507206d6.2
        for <fio@vger.kernel.org>; Tue, 05 Nov 2024 11:41:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1730835663; x=1731440463; darn=vger.kernel.org;
        h=content-transfer-encoding:content-language:cc:to:subject:from
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WJKX98FSX+BoBJJLBX2ym5u93K6DUsIlrRlZiwJIu+8=;
        b=TGMBFszTSlJDNYDqg7e+T1OZR7WSBJ4lJU84gZbv9Io9Y0s0MgxRogZHwP7yxwM18o
         1pWjMB4ONN+Ar77MDPKKoKOd6iSwTrQQvJBI4j8j6UzhVtlek2WXZJEO1x4R7uHsbr/l
         vKYbp0/8hYE5KJ01dTGwAPywaFlazZLeBYJRdbDYVztjZqqCWV9numQPqx+3L30nhwUN
         mgiNPKuW2YXeLN8ZXBs+bXXDrcoT98c7DYJWbvpmObhVt+LnVueURbdD85uHLYhE+2mq
         2ms0uYfQY2sHjObYFjRXP1DmL599rjqA/hqlNaoLiVZfp9Zg1Qse5ATX3G4W+6Ho1zRQ
         Pf2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730835663; x=1731440463;
        h=content-transfer-encoding:content-language:cc:to:subject:from
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=WJKX98FSX+BoBJJLBX2ym5u93K6DUsIlrRlZiwJIu+8=;
        b=YCiS0/085qFqieMqalHIMNcaARH/XiOsixREASOFPEcdN82SuH1U9AWOa8hIzw8v1n
         kJBT+xIsfvisJE0bvemZycl8hJrpYcuU1uLa+aEaPQWziYpAoIrUvm3ujha99IN9Ceq4
         pjD1QGiCxN03MGoy6fKGgZ+F6DjhB5+JgGSyAQcfU5aiSX268QKYl5Zp3GgT0TqLKQWe
         SOsLkpeGvhlYVPQTrNni96mfL3B7jOgnO5INDUQOStfAAdKSSLPL61/HvbyZLIsJKAUz
         XUVWUoZlki0HYfYpqdVq74EpjWL/XhEZ6ByVWnYlu8UOXWiRX9t64Brq3v2hE/UnW6IB
         h3zQ==
X-Gm-Message-State: AOJu0Yx6NRmuq/IAc8bbH/Z8Q8TcVWyBHtrpSFNd0iWDT4OTpSO4iiSm
	e85pVScagZb/1Edkf6vULgGIwCOXusBcKZniFnUbCz7yGw20jlhxaDEUGQ==
X-Google-Smtp-Source: AGHT+IFb50Xx5QyuWdPd3X44tOJPNEiX2tJX1Gybhb/H4AtknF+LqxIse9aoe02Bdm0u9RThPITFBw==
X-Received: by 2002:a05:6214:5542:b0:6d3:89d5:fadb with SMTP id 6a1803df08f44-6d389d6026fmr6161716d6.44.1730835663330;
        Tue, 05 Nov 2024 11:41:03 -0800 (PST)
Received: from [192.168.1.220] (pool-173-79-40-147.washdc.fios.verizon.net. [173.79.40.147])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6d353fc4a3esm63963786d6.30.2024.11.05.11.41.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Nov 2024 11:41:02 -0800 (PST)
Message-ID: <5c833f46-a124-4d0d-ae07-5e9ecb4648d8@gmail.com>
Date: Tue, 5 Nov 2024 14:41:01 -0500
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Vincent Fu <vincentfu@gmail.com>
Subject: blog post on fio write zeroes performance
To: "fio@vger.kernel.org" <fio@vger.kernel.org>
Cc: gost.dev@samsung.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

I am pleased to share a blog post about fio write zeroes performance:

https://github.com/vincentkfu/fio-blog/wiki/How-could-write-zeroes-performance-be-worse-at-higher-queue-depths

Read about the unexpected performance issue we encountered. Feedback is 
welcome.

Vincent
