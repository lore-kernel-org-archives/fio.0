Received: from mail-pz2-f12.google.com (mail-pz2-f12.google.com [74.125.228.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B11183A784A
	for <fio@vger.kernel.org>; Wed, 23 Sep 2026 17:36:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.228.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790184982; cv=pass; b=XXZuqxjRIJnZnpuyEnwr2FRqPIAmUxFaH9JLB2swEEprBMnQibKO4N4x+hPCh6K9K4/vY1fIBT8lQ6sHwrOTXHudeDIprMxGFwnz4Hfm36GV9yPXbT4Krp0lnwgVB9rqwqgNqWHI4kCpgAdxJhyXuXY+NqpVrelGWwyK/xsCEog=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790184982; c=relaxed/simple;
	bh=tz2p31VDfGAaFrGxQj0pyhL5UZzBuH/gyYjTX9YkVhA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=oXFv7L/5HnQsSgQ17rwYp4YprGYQPOlNZ7ZB4tkHY2qS+2IKbIBBmbikQS7DEgz6QhLiSbphEIpsvp/saaHWAUmX65RYrBc2tyf4MXxe0iie/kDf2t4LbU81G3NWT4Un55Z6rTMKbpIDvt2AZnINjsIqcy2ZrP/VhyrEc2s2zSs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gvOAObZp; arc=pass smtp.client-ip=74.125.228.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gvOAObZp"
Received: by mail-pz2-f12.google.com with SMTP id 41be03b00d2f7-cc1cea4ae2cso809118a12.0
        for <fio@vger.kernel.org>; Wed, 23 Sep 2026 10:36:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790184980; cv=none;
        d=google.com; s=arc-20260327;
        b=Y20+/ZmlhWaGJxMRxpLEHEllzmB1P+nh96msulfiGvU455u1j9wYWFB0hH2qcrhbW/
         utlftm8dGF8Co6BiDM0vyaEYBZ29Baowl9nXm7pVC1OOuRk0N2cxhmpQMVJkfdPz5o3k
         dGJzEbDntE6RIjafvCloPeVqPItaBhN+1aX7MFGnmaBvD8SdObIoalUUaZmLKiCXgu9d
         bCYt57AfkxdymHeqrSZ4oIrLizRECDj1sCZYIzLVuJA286IfIKpPggxs1P5sjm8NHl21
         IL+ThnSrfM+XazfDURu7UbUXgja4UhU+dwmSd+RBl54DQQvhfKtGATeCmRep4WS7jjJy
         zh/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=tz2p31VDfGAaFrGxQj0pyhL5UZzBuH/gyYjTX9YkVhA=;
        fh=NPmx+gUMvjsVH2/tb+WSAGcrfY9QgUyz59GgHDSNrdo=;
        b=nhYZUPXQuY31G1yu2L3Yv25fHEgVpAgcQwRq8oVocD0SkOsKpjz/WDOMlvZz2N4lG7
         IcgSVy5zm5V18XagI8lXa48oAIsnbyZTOzpMwWWXap9HGcFS0Dt6myrrtRXJY8Qlsigw
         6RtWr49AF9Fd4l85luKR4AapMZQd7LXWo5Q/rLPjSB6+/FKYHKXXFzIUw9ZQpv1QqTNB
         P1q9Hs7/JcA/s+GJ8NXNgyKC2BOQVfoY2qu0SeiEM97EoMnmKFHTn7JcNqa3aGqGtoRC
         fdRgjFtsPItRGD9ahUeyojOLmr6Rnhcp9SB4Dy+//iaZy0Co2ODWKa627Gsfg4DC3xOg
         hsuQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790184980; x=1790789780; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=tz2p31VDfGAaFrGxQj0pyhL5UZzBuH/gyYjTX9YkVhA=;
        b=gvOAObZpJZvSbn64wIWPQbkhIfQpZlaUSSe4tStWt8wMek5EhdpblLQIRPH/EcxPQK
         zz/BoL31c/rcqHUMdyxGyKzhIznsxQncIgw80AOFYlQkC6aGPM/ZLmxOGnfcxiGpVLpl
         FtiI9yKcTQjNuBrAbhWZqEaZKsh4iBU10jy5kaBQV1urhWjOr6OhcEND4oswzTNxGsyw
         luTskUK2L6ZGwwshWpMmbBHL3fd7TqKPcrgdf9gCy76Sy5x3MBlucvsiB1UDmzMknUGw
         0bGkm7EHhxwEC7Vy2fM3/5pTk53qYScWOf8sFnZH954fGzyIr72woX6XSTqRYWKln7oV
         udWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790184980; x=1790789780;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=tz2p31VDfGAaFrGxQj0pyhL5UZzBuH/gyYjTX9YkVhA=;
        b=OOXAYiPKwQAsGRPQV/0jqgYBe9oOBX9O/avlt+idbB7cFDFXt9tOv7XsPsQ4nVdWu0
         2PEb476+tGBc6W97nnIKJGqGZzKM8rgT4y23Il0OLVP9OFcMZ78/9PJPsU9fgvtULxky
         8K4l3Q/D3qelGXk9j2RqSZa2PDVqNsmJKr9xpBGvwFCV3v9sUN3B1uHIGOrPyvSNVycj
         jR3Y8g57oDjCIvQWGqhmXIrIgmP0WKIOt7bIKfsQuY1PVV3OGSQusckApahd4zoKMINF
         2wiFZ+JEOycLIPzm/OGEGatxX+hqxlWkHm/Sx94Cc1ABaDnswboP7HZejjyF6iu9NAzi
         fYCw==
X-Gm-Message-State: AFuF++n/5+oHUOgccbO14Ta6kH8Fw0EngnYUnfYKEjywDGNXPVZXMwDC
	WvbCg2guBE45sD9QJgXRWWPU/wBKym2IwaEkRKPe7EfgW3NEAGBYuKHsposUXF6yb6BJwIxC9zF
	HqMjcjzPJKV0WEoAsDOAovEZWx01FCHg=
X-Gm-Gg: AYBFou0c9ulOVBjK0/zk3mXrq6t9ExgO7t3tvReKllEXZ5YhV57NQV6q9b6MT4DOOBq
	hX1inQCdlEcwOC07M6gU9PVUdHxtgXM7io/mAlOuDDnxLToyNEou009vmuIiIkzOBnfYp4raqP/
	poXfk4ORyR+1hYLrXM4MQGPX3uWaE1HU2jugPHaF3MWrZCbV4RU/EeQyvXEeqqmc7Mixr3nRuN0
	BALs3uG+uWIs5i9OpU4WWhhd9eUJerfgV4DpqwZyPBLjDAdT3ixMKcGWNQ7vUnC+XcwsQSinvDX
	A4jtvcniPgI5WIcZNIFYLccO7CY78RdIZJaZ2JwRhpa8udAkBLpccFskew7Iqve4HerLZ1UvWA5
	a2ApAzVatrkM=
X-Received: by 2002:a05:6a21:8216:b0:3d3:aec2:4dc9 with SMTP id
 adf61e73a8af0-3ddf7e34105mr3732943637.21.1790184980000; Wed, 23 Sep 2026
 10:36:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CGME20260923114314epcms2p2b46e183f11d17a26e8e055132a47bdce@epcms2p2>
 <20260923114314epcms2p2b46e183f11d17a26e8e055132a47bdce@epcms2p2>
In-Reply-To: <20260923114314epcms2p2b46e183f11d17a26e8e055132a47bdce@epcms2p2>
From: Vincent Fu <vincentfu@gmail.com>
Date: Wed, 23 Sep 2026 13:36:04 -0400
X-Gm-Features: AclHuK85x783Qzd9HnbIt4rrUq2dHMzkGTJFmpiC2Ebx5Yw3n3NPEVnnT1pYFXg
Message-ID: <CAOp=CXnK6k_AygEOnsLLH0WdaLv3pyy_DZYiMMCfDppeROVUoA@mail.gmail.com>
Subject: Re: [PATCH v2] examples: add mobile storage test
To: jieon.seol@samsung.com
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>, Jinyoung Choi <j-young.choi@samsung.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 23, 2026 at 7:43=E2=80=AFAM Jieon Seol <jieon.seol@samsung.com>=
 wrote:
>
> Add an example job file for basic mobile storage performance testing.
>
> The sequential workloads use 512 KiB I/O with a single job and
> transfer 1 GiB. The random workloads use 4 KiB I/O with eight jobs,
> each transferring 128 MiB against the same 1 GiB test file.
>
> Use direct I/O and run the sequential read, sequential write, random
> read, and random write workloads serially.
>
> Signed-off-by: Jieon Seol <jieon.seol@samsung.com>
> ---

Applied. Thanks.

Vincent
