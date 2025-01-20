Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D1641DF74C
	for <fio@vger.kernel.org>; Mon, 20 Jan 2025 11:58:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737374334; cv=none; b=YvcdP8B/psXN1g/LYOjUpZU68zbqSu9W+RwnFRP6RW7S1L7H8dn63Drtyhh7g+XMIkeX9YUGBJaCnvxxMUYwhND96g/ZUgha6wSWLX9knDHHq95sFKKrQ9aXXuK4n558zaewXh9oNLSNT+41DR5q5iulD9iwI3k7eDbVNCAOen4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737374334; c=relaxed/simple;
	bh=SrkUnVHP5DfiN/jMm8kbBkddABwFSX/v5/mZcv4B/9A=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=OAkQDfK/lElgzEaJpa5v5drOG0hXFNr6t9/+zxVuiK5aVsXO2sA+XcAOL5m3iV1cNaN7vtm4Hun4ngh5MIgcB0Y2nFyZlnKfYnrAaOdAIXGprHQHny4dKL/ObvsywDjV7E6BW8fPw4A9pOivx7pXcDYbtzbOQieJV/ikZr3uucM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SzwhtXwS; arc=none smtp.client-ip=209.85.216.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SzwhtXwS"
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-2f42992f608so6056762a91.0
        for <fio@vger.kernel.org>; Mon, 20 Jan 2025 03:58:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1737374332; x=1737979132; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=SrkUnVHP5DfiN/jMm8kbBkddABwFSX/v5/mZcv4B/9A=;
        b=SzwhtXwShj8vXeH7clMtYeVqhNnefO9k7j60qaxE4XeQ46cxBaPcmEjfbQGHB7j3Ke
         V+qc6JPnlKz0pViOgiWbQ+Xa/D/0BBFsKk8de/xrqGas9GIiCLkJBnB7IZhg0WImO9DS
         HAhLAfu4sDyvnXFQLIQeHQdcgUHz2BxdX6mEy6zw8HEw8Ep6n2fXt8WkHmBkD7Txbk4a
         24iRftUVbSU923nV1M/oac6LLD5IhSQ5UeuVSITa1hSCnlWSMz+7l/L2XXG3MFxQIzvx
         gBH80FByzXwhM0/DOF7QyD53T9JA8ww7FiNeVCjD2sNOtWsB81YDTHwybW9I/9ZIueHL
         c4rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737374332; x=1737979132;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=SrkUnVHP5DfiN/jMm8kbBkddABwFSX/v5/mZcv4B/9A=;
        b=wqWUW+gtjCy9WLnPra3OIkZzzjtrVrfypiTzxeMt+5OOwKfrc1oIHPS2HAHhxy6hOT
         u7dJKG7h0AQZsXFh7i0bkITFe8m1Cf8MRinFYK6YvO4WfSefLJzpYLcb2p/8+yAQBiQy
         WudYVmeaPh6B8R5V3KbuqxYx6T5NyFbMvcsB6zHzJemO3w3r6Fx7Lhg6hwNW88jXSfU0
         x0M8wKmswwP5OUWRVUfsNBzze38R8UCrSPaDGbKcjnOYV6upl1pIABhZDiS/7O+bfDfC
         iNLCEaeduG98pNA9dFh2ftxgLDFl7v3WsXGPe+pVf/RDrO/bmW87cdzv5mKR26FHTA85
         yHBA==
X-Gm-Message-State: AOJu0YzaE7AWNA2oPJyoQlduaB3Af6kCgfdFXcck8x6M+jGpHHtHkdIu
	5Ie1T9mqVluQKiZNakTy0Uq2QHq9ITiqYCZ13wRTjWEDZUBYkrAEoHxFasRfh/kk8EDLwFXqDz4
	L9SyfyQ5zgs9kFG9ksmxCg61E8e1NI6RS
X-Gm-Gg: ASbGnctOSvg8LV4WcDUPs1pQq6UNSrDuUIpeNGBgmSVEiqhJRRnJbSUQhN2nh1aNfQa
	h5/q7+jaidvIJkklqMKonNyodJ9CZb2bQsRcqh9dUppbFstFCXttqmKCoYXPX2cDIDBzKAwdGVq
	zDuLl2PQ==
X-Google-Smtp-Source: AGHT+IEhR1BULUQmiyB2dbn7pmWDHm5Iekd70Gv8VT5N1x4p10iAEd6+b4kl6b4kZMxdohpOaeNULMMSzc26rKhAucg=
X-Received: by 2002:a17:90b:51cd:b0:2ee:d186:fe48 with SMTP id
 98e67ed59e1d1-2f782d323b3mr18882810a91.28.1737374332034; Mon, 20 Jan 2025
 03:58:52 -0800 (PST)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Giuliano G Motter <mottergiuliano@gmail.com>
Date: Mon, 20 Jan 2025 08:58:40 -0300
X-Gm-Features: AbW1kvbQcy0N49h-OblKG0JSxe13yM1e8QbVQ8iV5iZ9gfFBmEb_S4hvQxR1QUw
Message-ID: <CAK0q08N-yCNKK9Jsg5h2_Kmm9iEhc95fPuGxYYC-BhK8dkeboQ@mail.gmail.com>
Subject: How do I characterize my usecase so that I can simulate it with fio
 the closest?
To: fio@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hello all,

The company I work with uses USB Sticks as a crucial part of the
product and I was assigned a task to bring up a pragmatic method to
characterize USB Sticks from different models/vendors/manufacturers.

I intend to write a simple pytest based framework that will use fio to
characterize the USB sticks systematically.
This would allow me to perform hundreds of tests in sampled devices to
either approve or reprove that model/vendor/manufacturer, based on the
performance parameters.

To start with, I plan to perform a series of synthetic tests - where I
don't intend to simulate the real use case, but rather, just to
compare different device's performances against each other in a
handful of made-up stress scenarios.

At a second moment, tough, I would in fact like to implement a test
that is the closest as possible to the real process we have during USB
stick flashing

Question:
How do I characterize my use case so that I can simulate it with fio?

My process is something like "./proprietary_script.sh --device
/dev/sdc", where "proprietary_script.sh" is a single threaded app that
mounts the USB Stick and performs a series of copies (with cp) from
the host's SSD to the USB Stick fs.

How can I know what are the values of IO type, IO engine, IO size,
block size, etc to call fio with, so that fio will simulate my process
the closest? How can I gather such information?

By the way, the OS is a Ubuntu 14.

Thank you!

Giuliano Galhardi Motter
mottergiuliano@gmail.com
