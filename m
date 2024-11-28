Received: from mail-io1-f53.google.com (mail-io1-f53.google.com [209.85.166.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10D85433B1
	for <fio@vger.kernel.org>; Thu, 28 Nov 2024 02:43:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732761816; cv=none; b=F0wJVnuncbDjG8CdlQz8ddWjCPGp+qqNoWqQ3sT5dXfWKqLAd+qOBUPkO6TQxPm2p2gfGfSbY6Kbrsrk1aXV4oz1pL9ZXKvACmMbqxeqpgr9TOTM/Yz3AanvallvgGezu7p0VaOGPBe8nr1Yst5ylxv6uuM6mSYigoZr/FLrkU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732761816; c=relaxed/simple;
	bh=LbSVKZGmUxaRq1N9GIA9IUIwl4QumXjztzcKGiTeVrE=;
	h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version; b=dS99SaWzWW0dH98zx3q2oc2ZAGpUYPiDeyR9cP1f6amk777StcKW+mXj/hf+Br96Gx2WR/p2ixNqEZmiJ/RrAYV10R9rYYC04fD0g+QAKbgf9fCxuq3o6vl0JPRcD2TPIkx/aVx/1oJI7rlKGbmvF/g+6XSRxHxHZg13MNjjKEc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=innIyzf3; arc=none smtp.client-ip=209.85.166.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="innIyzf3"
Received: by mail-io1-f53.google.com with SMTP id ca18e2360f4ac-83e5dc9af36so47992039f.0
        for <fio@vger.kernel.org>; Wed, 27 Nov 2024 18:43:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1732761813; x=1733366613; darn=vger.kernel.org;
        h=mime-version:content-transfer-encoding:msip_labels:content-language
         :accept-language:message-id:date:thread-index:thread-topic:subject
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=LbSVKZGmUxaRq1N9GIA9IUIwl4QumXjztzcKGiTeVrE=;
        b=innIyzf3ThX/uMnsN9nB86lUVrMP25bEMUfDSv4Vwey3YpaHghVHRKHO12BofjBaFp
         ga5qHVa+oPU+1XYZrQlZnAyp83YfHw3Z2FINtFYfEo8mxow3eR8PrWsGvTUU3jTBGnQC
         e8D3uUdYM+IzWSCm0gNUu966+wbFvDgEIiVBfGPm6h18/4vuSUv8que2WRdOqw3SwlYE
         Y0PS3B8OIO9Cjzc36pHb/lbxKdZOM7TS5ja4rkDmlG3FzbZiQTFDUVCzsyOAKs73f/Nk
         a+E1mDoXHOeOZrSLdBQn+bx+aEkODnHVF90fFKJJeiCg+WvrkbY4OrFX+robn9xzNI/D
         WM0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732761813; x=1733366613;
        h=mime-version:content-transfer-encoding:msip_labels:content-language
         :accept-language:message-id:date:thread-index:thread-topic:subject
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LbSVKZGmUxaRq1N9GIA9IUIwl4QumXjztzcKGiTeVrE=;
        b=d5V9xI8pJ4c2LpeJhfVi+lBSaaurpm4mjx0aZ5HqqiTYzMQuMYOkBLoPf1FvJvukIC
         3B1UayZHgjjjURLvQurusN2nqzfBigjfUbcFBkesxSqAJBMKK/D0JDKg7RNS8e+ZB0Al
         46L8UQQA2jNnHn7ImUhI+eONHzeAYbXRq2h0iLW+DFw3Eap9QDuLC4V9MA7qgKMUZhdp
         IMPXkrK8Qw0OgN0lBK8sqbIrB3ads9gG8i9Gk9R0MkKyJBL/xxZwoGflIw1m696Y5O4r
         LK+wfmrWR/3dWODOtDSF+8tzbXZNbXbQ9iT47PUYqsPzGjE3Fh86XRl2HzfuqB1JSQPQ
         Hw4A==
X-Gm-Message-State: AOJu0YwWbmQIkeT/rNcsS87CE7er9pZv5ze08gHVbBSbWuEAw816E2tw
	fCri4mE/3y1QZx5XwLOexFGu4h3XgaYPU4sC82voaP5lM0Rv4eYNsOAmTtZIuYA=
X-Gm-Gg: ASbGncu0NUuoZZUytSeT255/OFh4v4o4YSzi/AQgUSjxxCja3GOQxeK4S+4mBxZTUbV
	rqMh0+DcPb8kxNEvkpH+z6ojvqmf3Pph3LuDA2Q7++u9xx9ibdfdMBJZR+19j1PNnC1nGQAeKNg
	wxSTOt9cunvw1uVa8KbEXVzC/XnND9jVyXsc8rFhWh7OlibJpQofI9z8Uh3qel5srj7uTuxLOIx
	+/TaCY9LWtaGQKiHHJiQZ9Jac0E0fbyPGbrt9U8OVdEIqLHSK47Suk0lg+CS0aS2a5ESWN4Ea7v
	NhkUhxXgyVFidbleBQCV7CsRUKCL7hY=
X-Google-Smtp-Source: AGHT+IEtFR2qyiVNsNNk76WQodRxIpRwhBhzwJpFGZ0nCZrjLIvVSEHPFaU4ob/mvz3sjPH0q/BPTg==
X-Received: by 2002:a6b:6102:0:b0:841:99cb:776f with SMTP id ca18e2360f4ac-844015af617mr136050139f.6.1732761813225;
        Wed, 27 Nov 2024 18:43:33 -0800 (PST)
Received: from DM5PR03MB3146.namprd03.prod.outlook.com ([2603:1036:4:3c::5])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4e230dcaa3esm89368173.40.2024.11.27.18.43.32
        for <fio@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Nov 2024 18:43:32 -0800 (PST)
From: =?gb2312?B?2MK5+tX+?= <guozhengmi@gmail.com>
To: "fio@vger.kernel.org" <fio@vger.kernel.org>
Subject: Could I use fio to send write zeroes command (NVM Command Set) to a
 block device (/dev/nvme0n1)? Not a character device (/dev/ng0n1).
Thread-Topic: Could I use fio to send write zeroes command (NVM Command Set)
 to a block device (/dev/nvme0n1)? Not a character device (/dev/ng0n1).
Thread-Index: AQHbQT9PCATEECLeM0GN9vhTbIdY1Q==
X-MS-Exchange-MessageSentRepresentingType: 1
Date: Thu, 28 Nov 2024 02:43:32 +0000
Message-ID:
	<DM5PR03MB31469D90F8C20E2B9844E808AF292@DM5PR03MB3146.namprd03.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-Exchange-Organization-SCL: -1
X-MS-TNEF-Correlator:
X-MS-Exchange-Organization-RecordReviewCfmType: 0
msip_labels:
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

SGkgYWxsCkNvdWxkIEkgdXNlIGZpbyB0byBzZW5kIHdyaXRlIHplcm9lcyBjb21tYW5kIChOVk0g
Q29tbWFuZCBTZXQpIHRvIGEgYmxvY2sgZGV2aWNlICgvZGV2L252bWUwbjEpPyBOb3QgYSBjaGFy
YWN0ZXIgZGV2aWNlICgvZGV2L25nMG4xKS4KSSBzdHVkaWVkIHRoZSBmaW8gY29kZSBhbmQgZGlk
IHNvbWUgdGVzdHMgb24gbnZtZSBzc2QsIGJ1dCBmb3VuZCB0aGF0IGl0IGRvZXNuJ3Qgd29yay4g
SSB3b25kZXIgaWYgdGhlcmUgaXMgc29tZXRoaW5nIHdyb25nIHdpdGggbXkgdW5kZXJzdGFuZGlu
Zz8KClRoYW5rcyBmb3IgdGhlIGZlZWRiYWNrIQpUaW0=
