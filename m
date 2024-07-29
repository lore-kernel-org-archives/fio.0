Received: from mail-qk1-f180.google.com (mail-qk1-f180.google.com [209.85.222.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E20D74420
	for <fio@vger.kernel.org>; Mon, 29 Jul 2024 18:51:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722279083; cv=none; b=Nto5lmHE8AuwhA1iuCtV60oL9ChLgRXHcLTa2aKkequ3q98+vwJDguK2EZ5xf8G1n9eqLfWJm2xc+T236P0gEJwLOTGPmLeo0Jo429bdwS8Bz5dTfQuy4WspjvGl2he2H+C3HrHmWcjo+M59/Z2VIsUgIM+ul2vFhuULuZMjTkc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722279083; c=relaxed/simple;
	bh=GOTxbFy1g591nu4oSZVqL0dhU4oXgRk0jxgkpvquq2o=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:Content-Type; b=UnquOBMSXcWH22Z4Uhgv4NrMi3rIb8paa0MftXCR2SSLGrc89IR1bYatRPOgiV1LfK2CqP+nHio6IbiKGhMXNlDf55FF830xc1i0NWhlHu/nQPrTL8v5TaaQV11S6KHPrElCXjXGQZvj5Rjqhg93i6BEneYFChZriHlY8E1XCcg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GlQIqsnS; arc=none smtp.client-ip=209.85.222.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GlQIqsnS"
Received: by mail-qk1-f180.google.com with SMTP id af79cd13be357-79ef72bb8c8so150565385a.2
        for <fio@vger.kernel.org>; Mon, 29 Jul 2024 11:51:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1722279080; x=1722883880; darn=vger.kernel.org;
        h=content-transfer-encoding:content-language:cc:to:subject:from
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=peSNkRtke9a85pKGBC26s90WxoaKg+cDKC3nXFratl0=;
        b=GlQIqsnSjTfqAzFpHoe4syziC9X4AnysT9cfIEuicDrK9YXXcuyyWbf1Fmmj4q9dZR
         Pzitl6hKT0E2R/c1coGG80GW2a2R8QDZASCEyo87XsrC0DOs5Djf6lcl1CzjRUNxjkoI
         sSepbuRGbXKg7c+d/szOcbmk0j0yA8Cz91GnrNrBo0yfTv80MDC3xPwAsLSg+lw5UM5x
         qTCjo2zX3MBZUgQL9k/rJ40buZAQ6sUKTHO8XJM0/zFe5xyBmeJcdMsIRftpewDhkGCw
         nKHGn+ksHw982f1R8X+A2d6vYS2KNE7kTMJbHluH6tmdvN+EyX5aCllBEqrXAb4go3b9
         w7cQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722279080; x=1722883880;
        h=content-transfer-encoding:content-language:cc:to:subject:from
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=peSNkRtke9a85pKGBC26s90WxoaKg+cDKC3nXFratl0=;
        b=cGcxCv5w/TCgYgqIJfO384AV/g7YWPeg1wNGG/+V7sHRD8ROZp+NvtfmDA6SkJsilK
         /IdC1JTG8ajdntqUERPk1AER0E8iKxdMgWWRQMvvERb2sxKitwqJXP4FTdCQqJdD9aY3
         MKsr8Nk2OB2fzVX3lWx3ENkLK449Jfs21cbpE/MM2oCx913TVOY8ZFjq32cQ1Sj1Attt
         mMWxr9HayPav1KtGjDmQplydjUA9bNyGSpaCl/UJgpPjqiDW043TO+pW+kcCE1ZE3NGV
         nLh3NS33jEo9B/IXt2YIWIZmXXtJbh0QuCdUm2sIxN9vrfII+8xo0loLYKzcThk+zpI+
         7WqQ==
X-Gm-Message-State: AOJu0YwMlKwbfRrlwpLCP59uwsSnYTWCcFp11GTOE3LOlCyp35GvNhtk
	rmjcyBwbnmeV1vTDk5L7rl4YiJnrdEM/Lwwghsaxg8p0v/k/mhzZOK27fQ==
X-Google-Smtp-Source: AGHT+IHynnFAmthWjL6i6OZS4gY25tpzY9gDT6FiITsFHj+WcSktLzAQLvibKE/oH8V0LNbMP0FvZQ==
X-Received: by 2002:a05:620a:4083:b0:7a1:dcc5:9aeb with SMTP id af79cd13be357-7a1e524c611mr1183059285a.20.1722279080030;
        Mon, 29 Jul 2024 11:51:20 -0700 (PDT)
Received: from [192.168.1.220] (pool-173-79-40-147.washdc.fios.verizon.net. [173.79.40.147])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7a1df4a3490sm443284485a.122.2024.07.29.11.51.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 Jul 2024 11:51:19 -0700 (PDT)
Message-ID: <e81984c5-2758-4283-a066-9303887c4e8e@gmail.com>
Date: Mon, 29 Jul 2024 14:51:18 -0400
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Vincent Fu <vincentfu@gmail.com>
Subject: blog post on fio's CPU clock test
To: "fio@vger.kernel.org" <fio@vger.kernel.org>
Cc: gost.dev@samsung.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

I am pleased to share a blog post about a recently resolved issue with 
fio's CPU clock test:

https://github.com/vincentkfu/fio-blog/wiki/Clock-test-issue

This issue was triggered by a compiler change and exposes a difference 
in how AMD and Intel CPUs behave.

Take a look! Feedback is welcome.

Vincent
