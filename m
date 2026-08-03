Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE035314D13
	for <fio@vger.kernel.org>; Mon,  3 Aug 2026 19:59:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785787177; cv=pass; b=YHYLHvNU4ZfU8Yzn4wwlV5M9maepaPXjmednSDkEW9qGH6t7pjwqBRj2aqncJkA35u0Kx7E55K/qXQsWR2Nwuu6OTqq7n2Wak8i0BD4CRr8spDlVW+1MRYhuIVCmdUEPsh4w30eNF5nGjMABsKb+2ikvg8cFT4d3lq8yw2K9cQ4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785787177; c=relaxed/simple;
	bh=XqNsZF/6gs7Xip+Jsp+An6szJ7II9k45sGOHoLTbc2E=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=DorrYYynyWC0zLWv7HsmwefM5s/gQ54So4zwvtM4oiPAVYPJr+7ONdGeqaCZy+53b5ZXEguSyxwKobWgWuArMD3/JsbKIa2VoVR9nhZtmdmxms9KDg19WcfhQvULnzYaG4JqJI2S+mdEFK5/2UO2yau3FLZ57HE3iqccE771lfY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dDzEb1Rf; arc=pass smtp.client-ip=209.85.218.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dDzEb1Rf"
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-c15cf78d1a2so447243366b.1
        for <fio@vger.kernel.org>; Mon, 03 Aug 2026 12:59:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785787174; cv=none;
        d=google.com; s=arc-20260327;
        b=DCy+Brdt7LdHzih1xrOsJh+wt/KvGEamfqj6v1K1P4v/Xh/8J6nLuq83cM52anIDO+
         rmogZ21ZKB2ifcrj98dLcBsP9pFzeVqKBNU776m/nfotwTBL+TV1H5ldjDnUwUixFqEr
         8sh1adEk4cjB1dvzC1HMh1znV02U7yKBwbahBpsy8oxiaXvjm4xojOhTMw4vi7ljFHUB
         nJP22zaAJcBPXdUaykbNHwOWUXzAJyKRVjxrHGu6ziQdNsft5uPdS/JSHNI3u4CYL5X2
         vCqRq/sW6bMlSNaRI34tlB/yqeNvNQGlyYIQXpaJvML1JiG2BdEQJYM6/RZHrnBJ4gUA
         iFBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=a9wbvFHBl0jtLukNZokupQ2VUjGmThHjme1ypZacbvY=;
        fh=UWyfjCpRWGeNjH/MpHuJOpVjpGU4pIk7MkJx2k7AjZM=;
        b=DY3L0aDmGeBKUpmRYp2BX8Qpb2xf/QYuPicYdZaPIEULnZButKUFbAJp56DLla9RzC
         8fZfLnJDi2SfSt0ImDUOTcDhl2izbVYoWv6m+44d97xETP4YJMgaNZerR/WJAMB1EAhV
         S/cKjDOYD/SkDm9EfaWjwdgczkhDdSqf+ubVukst8WT+AVsu3UIimS5Ik99iYmEAlAcB
         ruetxZEdCBWUI9qH3fTrWi+KyoL3Uvt2QEvxr5G/FtrDX8r6HumRGfhW1RbGiFAUCFMu
         EOENzYQpBjx2a06RAi+oUDzXJ5DYCDgbuhju9y9giQQDk8agEYQArjPRAaLWEkHR99JQ
         j/ZQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785787174; x=1786391974; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=a9wbvFHBl0jtLukNZokupQ2VUjGmThHjme1ypZacbvY=;
        b=dDzEb1Rfj9f+U76G+41/+LO0eIxh4KkALZiw6bGHNJJkm0XaYQ4TOfmJREJXrpXgCv
         8Jfjg01JUiWFoiIC9mYiPJaRbgf/5KkErIh3kXrJZZ51BXoCx6EQqrLelbohaVKuIZRA
         kRNLVgPzFBJX/UqzRxpwmqfESvuBmVRa+GoAiEYxJPn7kb5LonrCKum8Ya6vcE3CRmE1
         LNdMajDtwH1QZswNreo9yLLE6oDikg4/AQ9hlB4RydESTO041Vxg04zFwXWQP/F3x2u9
         dj1GoNpeP1bJop3l1zFWRMQzv/M6ph9X0QCloq4NXcpna8rPIetL/Awpp+UyrVbgz8/1
         vP7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785787174; x=1786391974;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=a9wbvFHBl0jtLukNZokupQ2VUjGmThHjme1ypZacbvY=;
        b=EQ6st0ED7f+H6bS41hZXDyJwTUldnxDEe+iCXlHHLJVUsQ8mM33CgIZFm3xFJcYQz9
         mn22PrKYs7mwYzsV0FAF2BHnwFNy/tDjErZD5sA4PuG37WkATTI2ZSHH/uizpLvEhFen
         G49w6e5P82NS9F237VaZCpno8ul1k+NOPfMj2iDQaxxvYAl6yx2j2GIUSlM7CXoTKu/a
         y1g1TEc8uCdDo/DycwrkR7Qw7aabIvdws5o2XMunMFxyeG2MyyX322R/5DA/Yys1NKs7
         kPwgvcwnjufCmTTdQVEUmO6YpA1t6bUQL8LA6utcAJIkXKKlppQOsPWvkxf1RxiJHIPh
         RniQ==
X-Gm-Message-State: AOJu0YxZAI+iY9qsXWy2SbaIAiXnl9vW1sgC8NEBLKQ3rwfcdVDGTP2r
	ib2iwiFu09hllX+2hDSmAET0KvHQBdWmqOp5FmJbY5n/Bo5yaWADBHBrRGJ9xFSamoCxX7qvn8S
	Ud3j2TdSuEarxV4fASWs0tu2xVzwEmMgCoeKe
X-Gm-Gg: AR+sD12LYC3hkghvhNFYJYAE6kUinyw4dU551ceWyQM7JT9T9jMh2YiJPmE7binp2ma
	7q1xaxA1IS57VmGLqQj5E1/0uxjGYNQy8wTNvadauiSuY1aMWpWWnJP6u1utoMWgfxZM09Fiavm
	S+Ms3NsXEvwaW87uhy4nZiIh63A9G201yIBLWBBQZSunR7cxQE9Yzu/2gD0zVggODqzO5KOPzbW
	AEY3pmSN8JARqXkYNK1FmoEq7sQjziKcktVlDNMFecoDDgb33KRGJ1hHZOzFbhJutVcALMGfntw
	k3xMCJsQFf59Kp4gtxTmx/WKU8H6yseTYuesMwBZFpzJ/g==
X-Received: by 2002:a17:907:d59c:b0:c19:473b:dc8f with SMTP id
 a640c23a62f3a-c1fe7ea80ccmr888890566b.3.1785787173811; Mon, 03 Aug 2026
 12:59:33 -0700 (PDT)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <984fc666-48fe-4212-96e7-6740a270d755@cs.utexas.edu>
In-Reply-To: <984fc666-48fe-4212-96e7-6740a270d755@cs.utexas.edu>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Mon, 3 Aug 2026 20:59:07 +0100
X-Gm-Features: AUfX_myPX7VFvaGEOv9aRNHDCPt-zTqhQJiQnfpIMU3VxhmEfIQsQG1gv0FTp1o
Message-ID: <CALjAwxjRNkYidXgnhLH8O-qoBaWK5K-j4v=eQjCKgOT0fFZ4kg@mail.gmail.com>
Subject: Re: Consistent core dump of fio 3.36
To: Patrick Goetz <pgoetz@cs.utexas.edu>
Cc: fio@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi,

On Mon, 3 Aug 2026 at 20:28, Patrick Goetz <pgoetz@cs.utexas.edu> wrote:
>
> Running this command:
>
> # fio --name=filecreate --directory=/data/fio-test \
>    --nrfiles=100000 --filesize=4k --rw=write --bs=4k \
>    --ioengine=sync --create_on_open=1 \
>    --openfiles=128 --numjobs=8 --group_reporting
>
> results in a consistent core dump:

<snip>

> smalloc: OOM. Consider using --alloc-size to increase the shared memory
> available.

<snip>

> Is there something wrong with my syntax?

I think your syntax is fine and at first glance it just looks like
you're asking for a lot of files. Did you try fio's suggestion to
tweak --alloc-size
(https://fio.readthedocs.io/en/latest/fio_doc.html#cmdoption-alloc-size
) to be bigger and if so what was the outcome?

-- 
Sitsofe
