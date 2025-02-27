Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90D362288E3
	for <fio@vger.kernel.org>; Thu, 27 Feb 2025 11:29:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740655751; cv=none; b=KfY8cleERvLq7lamFOtX9R91kVEQ3UJ+Zrmm6Jvs27XPSKs2ECCPx2GfCfKBipMVMYPUxSHAZtv7/ym+lSGNlyCn4+XKuuZ/XIKrpycCqIK8mb5QCu0Jskd2tRJ5j7vpGD32Newuf645asOpLn1QAv6aeHOccvWgYhPNAWwAXjo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740655751; c=relaxed/simple;
	bh=DA3K/tnYkObmkPeNmmS1VevmrWVIY0qXpVqBeBPlpZk=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=sCnA5tkoDa0J3gIeWHOK9GiF+VhJYre8HOI22EySKuwIV0W9ZUTRTCT+S5BCfBCWislg4cXykYD8x8ekuYd7KqEQHqQXEcy87H9Hbi7dQkMOdcR5Wlkum95CVyH6cnpMGG2LbX5I6l/lvoXjFCoZX/CsBvCD1f0vbRr7Zgx9idQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KfM71AVH; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KfM71AVH"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-439a1e8ba83so8088995e9.3
        for <fio@vger.kernel.org>; Thu, 27 Feb 2025 03:29:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740655748; x=1741260548; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=8geHr5hoMO6wgVmsoq5wkZm1VbLTLmFqwv64EcWnrY4=;
        b=KfM71AVHMx49WOvfOhu3ep7vmhVjCBcAJ9PqPx7JFU1B4JIK4E6jm05KJnbzrs/rsu
         ZS5pjuUGe+tMHn2/0lZKPYSdXQwWiwA/uM0Vr9Y5kB6pmotDdujrPHfJTz1gybB+wSt2
         ls4+jMC6SWi/nEupwU3Wqd+DwaKxk1QEyxcCjc2MYOLvCjky5Fvt5igieODuOKyj0k4x
         8MDt3tN1QohwsMy/6elK1ldvB8Cbf8BxtUfVuZ1ndXqT4L9q9RFfh1nNFyK8PvWbz5aV
         eEisWwjg8Ojo9kiO00crC5aiWZXHk/RuAcQUapxr4wMo8Vo4VnfBL9KoYdsxPxkLhkwz
         0CuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740655748; x=1741260548;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8geHr5hoMO6wgVmsoq5wkZm1VbLTLmFqwv64EcWnrY4=;
        b=t4onUeZV+Zp+c5Syy3YGaDbD1/bMjyn+p1rq/fHzsC7EU0BX5wgciSJCKn8qwLWK8f
         dJYSGCGbvGGFwA2lxwtDKgqL5H8IWcXTH7vUNku41q3cb5ycbRvDDveFY5olpJ0zbvNH
         kjs3yA+1oD78Dqef9ckP1HFmioqcofeIdI+HZ7uhVuYsOdMWY0rYOmykdiZChNrn1X8F
         4PwENBS+OY4yX1LCU1QEzlXNSrTGq5ANiEoIFZS6dNNzOpmA8lcAqLe+rBq1KtelQXnM
         bvLUTah+1iqNiQck5WAD9q7fyWM+bfO5XIeBF7MWtc8ckNsUqXbYoCx1+pH+M4W4GuRe
         Jd6g==
X-Gm-Message-State: AOJu0YxcX05SO6AGsCWh6b0w6fLvdVCSwoq2OVsXGZFeqiM+vDaUb4Jb
	kPkii2iAWlQJN4JMMzoB8PDJ1fOtzhDMwNSdb56wTn9/vNioy0jDv9SuLg==
X-Gm-Gg: ASbGncvKr4gOyMwttrmN4FqpJs0V1tv9h3cy3+phznq8LCOxe5CkGkc1CEriHN0w2Ml
	UTnuLcnmYGYgT9D2kibCx6N5TaYyBns9K+ibkgf5S06EsliSnEjzpymHDFP9GxFykuDyXiTi7c+
	tcXuo5KcyhujfMsUxN2/qFMQGJx1ZnZPq5k9MagbSMRoQPUvrw7jGBRDKInfXF65kXW2uCtlrf4
	SIxc/nOBqNPiEA3TAcPI7h2aFoufbdN36ewZlR0Hb1fONG1rvOdecN9wQDE2+PihUiDiWQdvklG
	d3CNjux4NN+QEl9RcUiilvrVHw==
X-Google-Smtp-Source: AGHT+IFYNWPwtCUIFLPVyEIKX/b9ib5wMyjtmtpyp4z2bwl2DLudiwN+oJYu57Wqcdqy7man+P7aOA==
X-Received: by 2002:a05:600c:358c:b0:439:84ba:5760 with SMTP id 5b1f17b1804b1-439aeae1c8bmr223375655e9.5.1740655747659;
        Thu, 27 Feb 2025 03:29:07 -0800 (PST)
Received: from ed.ac.uk ([2001:630:3c1:90:97e6:f326:b9e:1a85])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43b7a28b6fbsm19251565e9.35.2025.02.27.03.29.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Feb 2025 03:29:07 -0800 (PST)
Date: Thu, 27 Feb 2025 11:29:05 +0000
From: Karim Manaouil <kmanaouil.dev@gmail.com>
To: fio@vger.kernel.org
Cc: kmanaouil.dev@gmail.com
Subject: A question about fio flows
Message-ID: <20250227112905.egy7rsoa3bhw44xk@ed.ac.uk>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi all,

I am working on some experiments where I need to have 12 jobs. Each
job is reading from a different file (job1 -> file1, job2 -> file2,
etc).

Now, some files should receieve more I/O than others. To implement this
bias between files, I opted for flows. Basically, I start from 100 and I
assign a percentage to each file. For example, a snippet of my fio job
file below:

[private-0]
flow=37
filename=/srv/dax/private/private-0
[private-1]
flow=23
filename=/srv/dax/private/private-1
[private-2]
flow=10
filename=/srv/dax/private/private-2
[private-3]
flow=9
filename=/srv/dax/private/private-3
[private-4]
flow=7
filename=/srv/dax/private/private-4
[private-5]
flow=3
filename=/srv/dax/private/private-5
[private-6]
flow=3
filename=/srv/dax/private/private-6

I am not sure if this is properly achieving what I want to achieve.

I have a doubt that having too many files and many flows will reduce
scheduling precision or introduce scheduling overhead. I don't know how
this feature is implemented internally, thus my question.

Can you please briefly explain how the feature works. And Do you think
this is a sane approach? If not, what better alternative can I use?

-- 
Best,
Karim
Edinburgh University
