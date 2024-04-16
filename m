Received: from TWHMLLG3.macronix.com (twhmllg3.macronix.com [122.147.135.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2462085272
	for <fio@vger.kernel.org>; Tue, 16 Apr 2024 08:56:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=122.147.135.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713257770; cv=none; b=Di2m9rKqRbCQUD4/iZ6q+rSPx4eTjSVEts7RGblMFZaZ76+AcM9zWNAyHDPJQnLJe1+/EvU1QdG28iYg6p/7mYizKl6na0i/CdJv4++UuLd6pJlEdljKK1yRS2LFcsUnMAJzcAVCOauuW7WvcnIEJ9osdTTWsX+g2E9iBbaEaVg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713257770; c=relaxed/simple;
	bh=E5ktKbtWR1rb32Tk3pEdphYCBDdiUliAl9VbqJag+BY=;
	h=To:Subject:MIME-Version:Message-ID:From:Date:Content-Type; b=mryHyg4rqcLXxaktNqAKChM7EiwWT6n6gmtBEAyPih/Nua9nTranVBbLOu5DV8fKkCEj44KHehoasdkBTtxcKMAL6+1sZzPMF205h0PyGeuvYWeZ4HRi7FL8XZXuDnnxTb3r17oKYzrAsQj/UwU34GtybWmZ7x/2oaZk+fbKHeg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mxic.com.tw; spf=pass smtp.mailfrom=mxic.com.tw; dkim=pass (2048-bit key) header.d=mxic.com.tw header.i=@mxic.com.tw header.b=AmlK7v6M; arc=none smtp.client-ip=122.147.135.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mxic.com.tw
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mxic.com.tw
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mxic.com.tw header.i=@mxic.com.tw header.b="AmlK7v6M"
Received: from twhfmlp1.macronix.com (twhfmlp1.macronix.com [172.17.20.91])
	by TWHMLLG3.macronix.com with ESMTP id 43G8ttUN061704
	for <fio@vger.kernel.org>; Tue, 16 Apr 2024 16:55:55 +0800 (GMT-8)
	(envelope-from ylhsieh@mxic.com.tw)
Received: from MXML06C.mxic.com.tw (mxml06c.mxic.com.tw [172.17.14.55])
	by Forcepoint Email with ESMTP id 31D32A137A018327F14E
	for <fio@vger.kernel.org>; Tue, 16 Apr 2024 16:55:56 +0800 (CST)
To: fio@vger.kernel.org
Subject: fio output percentile latency seems upper bounded
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-KeepSent: A9096527:7152DEBE-48258B01:0030FF36;
 type=4; name=$KeepSent
X-Mailer: Lotus Notes Release 8.5.3FP6 SHF907 April 26, 2018
Message-ID: <OFA9096527.7152DEBE-ON48258B01.0030FF36-48258B01.003110F5@mxic.com.tw>
From: ylhsieh@mxic.com.tw
Date: Tue, 16 Apr 2024 16:55:56 +0800
X-MIMETrack: Serialize by Router on MXML06C/TAIWAN/MXIC(Release 9.0.1FP10 HF265|July 25, 2018) at
 2024/04/16 PM 04:55:56,
	Serialize complete at 2024/04/16 PM 04:55:56
Content-Type: text/plain; charset="US-ASCII"
X-MAIL:TWHMLLG3.macronix.com 43G8ttUN061704
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mxic.com.tw;
	s=mxictw; t=1713257757;
	bh=f/hsKleZgRW8NlQ8YD0vlmCgStbQJs0tGk5S0miNttM=;
	h=To:Subject:From:Date;
	b=AmlK7v6MNxTjCpWXvSD3gGPQrPmSnj9S6AGa9y2/MmI3v9EgZZZIOAHbQHgxWeNI7
	 Rpe+DMie24WjXiwIYKzL08gx8CbUckdXHyzIVqiT49xHE+VkLtRbl9MsYaVSlqf1ph
	 n0DfOSHtO0cTW7/UxPL9AZfgO+m1r01jHasPFzcmlwZlJ8U+iNamEb/7IhENLYFPtx
	 IUijFMeXYJszLtjZt2AH3fBLRK/pQh3GLaimV3L1E6C0xlY/ds0bl77gQSY3dTaclL
	 uw7TGenksTo+ob/rQ9F2ST6urRRxurE10oed5VACwcpDcPhm6IC9uDnwj5ivhru+wC
	 70pp/cef14C2Q==

Hi, there

In fio output, sometimes I see tail percentile latency to be 17112760320, 
and it remains this value to 99.99%, why? Also, the mean latency is larger 
than this value? (intuitively, tail latency should be larger than mean 
latency...?) What's the reason and how to make it reasonable?

"clat_ns" : {
  ...
  "mean" : 41081227631.728256,
  ...
  "percentile" : {
    "1.000000" : 1669332992,
    "5.000000" : 10536091648,
    "10.000000" : 17112760320,
    "20.000000" : 17112760320,
    ...
    "99.950000" : 17112760320,
    "99.990000" : 17112760320
  }
},
"lat_ns" : {
  ...
  "mean" : 41087031313.177292,
  ...
}

Thank you
YL


CONFIDENTIALITY NOTE:

This e-mail and any attachments may contain confidential information 
and/or personal data, which is protected by applicable laws. Please be 
reminded that duplication, disclosure, distribution, or use of this e-mail 
(and/or its attachments) or any part thereof is prohibited. If you receive 
this e-mail in error, please notify us immediately and delete this mail as 
well as its attachment(s) from your system. In addition, please be 
informed that collection, processing, and/or use of personal data is 
prohibited unless expressly permitted by personal data protection laws. 
Thank you for your attention and cooperation.

Macronix International Co., Ltd.

=====================================================================

