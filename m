Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6BD627281C
	for <fio@vger.kernel.org>; Thu, 25 Sep 2025 08:13:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758788021; cv=none; b=CKMalcePsUpTuQOQ68RdK1EXXbWBz6KgbvRaQkYSw/SU5x6XHmasdfy1X0u7o3unojxwLgPs1i09dA5W3f8e+QuK2tzhu3qTvTwyuBIBSh0l/nVZ+MLWf+cvLSkkdYbqlRr0AVPY2HqIoDUGtXcSGS74xyzKyEYG0DoaqACLUBo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758788021; c=relaxed/simple;
	bh=VmZcyNPZMx8NvFuAjWAKnGJD/Q5aI4f95zF2XISTCEo=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Content-Type; b=Usk8rj4cVuaDpOv+drB4U7iV0Irx4nCdsHixBYzWV0qk7HmtFPA6oysmQcMHFRKy9E0MdCOpjkxLCzBFq39UmED2H9Evab2pbh+rLGVNCixNBih2Y69mjA9haifaH+IZjX2CO6iKUDdKjpsVwUHeNsFcApfSUdp2GBVmZ09YmW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=adaptech.cz; spf=fail smtp.mailfrom=adaptech.cz; dkim=pass (2048-bit key) header.d=adaptech-cz.20230601.gappssmtp.com header.i=@adaptech-cz.20230601.gappssmtp.com header.b=GvgLOFm/; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=adaptech.cz
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=adaptech.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=adaptech-cz.20230601.gappssmtp.com header.i=@adaptech-cz.20230601.gappssmtp.com header.b="GvgLOFm/"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-45ed646b656so4743685e9.3
        for <fio@vger.kernel.org>; Thu, 25 Sep 2025 01:13:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=adaptech-cz.20230601.gappssmtp.com; s=20230601; t=1758788014; x=1759392814; darn=vger.kernel.org;
        h=content-transfer-encoding:organization:content-language:to:subject
         :from:user-agent:mime-version:date:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=GRULAEaQhd9qhBvopE4x9nSHch5VYhW7HNUsg+WcC6U=;
        b=GvgLOFm/w0mYnsodKaquEALwQL0cmSN/lJd91qpS9QTvJI2FnFP2wKQffJp70zs3Id
         q43XGghSVppdfqxGETm+L4UWKouuLlHPDxnuinM2JbQRm5hdsD6EadC3k4MyNSs0EX0G
         ODbb5Z0FBimcHP0nwTLQ4WTB8bWjmAoHyMjjmYMo0bgyHV5kMEG1gUBVbc/r7nztr9qj
         yHZftZfo3pDyfc52r/Il87/pMsti8N2mebIaSWEYj+QXDAX0r5+B/s3SORdM3xBDpJum
         B5MSXB5wXtJp/6aRqaKZfpTxS8T4XjbDwg6AMjmhmYRz1p+bBEibqqlN5cb7EL3oF+M4
         XfbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758788014; x=1759392814;
        h=content-transfer-encoding:organization:content-language:to:subject
         :from:user-agent:mime-version:date:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=GRULAEaQhd9qhBvopE4x9nSHch5VYhW7HNUsg+WcC6U=;
        b=aqNfXnHTdGqNKys50BJ+Z9+iu0/iGQD95Iff+fwhTirjAapSqUwUAb0daANHKLyCZ7
         NyiO4N+jaj/ikSINGsh45lQmrqDHCrSbUxXPBEkPItli5yiPJlBQeGwcfGgoP/I5pAua
         96hF3W5KWVBPDvxJUoATjNiC0SbvbofiovJPUildxbbuhvpmyLozNorIPkPHId0RZGL6
         9b0HdCszDRp2m+4A5iTAsjzlR0hO1gQQgR/NAMU+BCcqCuycneJSi2hm3BPvKlwdtlfl
         QCB+TVgXRPGrufPNxcQ6x1uezr0VsxyyAAfEwda8PgFzn1pNlnh5rUZfwcu+vcW1Inu7
         wSIw==
X-Gm-Message-State: AOJu0YynHc+22CAAnwMcB3zgCHe/qbqa1VbmPo3JC/nriIEtkw0nBmSk
	yTV4FW7SaZHI3OoZIpuUaqfITRHvLbtaRhdhLmrIOwl/uX5qh/J7DhljMB7u8k+LI29zQE3jyjF
	5xXWT6S0=
X-Gm-Gg: ASbGncsPEJ0Sv8+sWeGLSZL0fAcWR14eof3Mlg83ciguY4OxqsANJ8LMseChulYXJRg
	5+VUXOwbjQNVkjXANN6IzCiB0rpAdU2wRIz5OwpvB7+akj5KDhOWIQ3ZjWXqq5w30a/UOx+nIHO
	kJvf/mRmbWdkQa3qEPcQb6WDlz0iGiO69/kLiJj5kGzMm/hw9EMj7+tJqaqOUQNVUJP61UqTCk3
	N6c+sP9FexnXlwTXW3pEU7VOJJr7jSu0ZAasOgPzxdJvc2PFqS2zSJckcjAPecUqorsisM1XS3V
	caOpNPKsyRR3WNYOQe9L//TbIqFX8PWzUuTySkTYuVPklpZpQ8V3QIAhOA5bC7oaTlL4+MsLFr7
	sQDA+ruI21bE2gasw4tJyoy8568+FH9nmeSRsrUtiuhJgA+votoXcaQcfINNgQKKOr9Y=
X-Google-Smtp-Source: AGHT+IHrybSKgHPNJlzF8kFE8PfxLYCuUjvJgcpLwoX0lMFnME3fBr2E1YLoZhaCOlc4B8zkkdtqTQ==
X-Received: by 2002:a05:600c:45d4:b0:45b:88d6:8db5 with SMTP id 5b1f17b1804b1-46e329ea378mr24790985e9.12.1758788013855;
        Thu, 25 Sep 2025 01:13:33 -0700 (PDT)
Received: from [192.168.0.57] (cst2-114-212.cust.vodafone.cz. [31.30.114.212])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46e33bed6basm22341355e9.16.2025.09.25.01.13.33
        for <fio@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Sep 2025 01:13:33 -0700 (PDT)
Message-ID: <a2c4c120-47f6-43c7-a917-3da7e6cd450a@adaptech.cz>
Date: Thu, 25 Sep 2025 10:13:43 +0200
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: =?UTF-8?B?UGV0ciDFmGVow6Fr?= <rehak@adaptech.cz>
Subject: Poor Linux sequential read performance
To: fio@vger.kernel.org
Content-Language: cs
Organization: Adaptech s.r.o.
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hello,

sorry if posting something that has been already said but I am new on 
this list.

My computer is ASUS NUC 15 Pro+ with 128 GB RAM, PCIe gen 5 bus running 
two attached NVMe drives - a 2TB PCIe 4 WD_BLACK SN770M 2TB (running the 
testing OS), the other PCIe 5 WD_BLACK SN8100 4000GB (the tested disk), 
each occupying four PCIe lanes.

I am running Ubuntu 24.04.3 with the 6.14 kernel. My main interest (and 
now concern) is the NVMe sequential read speed of large data.

I tested with the following command, taking the Seq1M-Q8T1-Read job into 
consideration for now:
fio --loops=5 --size=10Gi --filename="mnt/disktest.tmp" --stonewall 
--ioengine=libaio --direct=1 --group_reporting --time_based=1 --runtime=10 \
         --name=Seq1M-Q8T1-Read --bs=1Mi --iodepth=8 --numjobs=1 --rw=read \
         --name=Seq128K-Q32T1-Read --bs=128Ki --iodepth=32 --numjobs=1 
--rw=read \
         --name=Rnd4K-Q32T16-Read --bs=4Ki --iodepth=32 --numjobs=16 
--rw=randread \
         --name=Rnd4K-Q1T1-Read --bs=4Ki --iodepth=1 --numjobs=1 
--rw=randread \
         --name=Seq1M-Q8T1-Write --bs=1Mi --iodepth=8 --numjobs=1 
--rw=write \
         --name=Seq128K-Q32T1-Write --bs=128Ki --iodepth=32 --numjobs=1 
--rw=write \
         --name=Rnd4K-Q32T16-Write --bs=4Ki --iodepth=32 --numjobs=16 
--rw=randwrite \
         --name=Rnd4K-Q1T1-Write --bs=4Ki --iodepth=1 --numjobs=1 
--rw=randwrite

Although the 2TB PCIe4x4 NVMe disk scored 5 GB/s, the 4TB PCIe5x4 scored 
just 8.2 GB/s (below the PCIe 5 specification where current_link_width = 
4 and current_link_speed is 32 GT/s per udevadm report, and the disk 
should reach 15 GB/s).

Why I am worried about this result? I have made this exact test under 
Windows, exchanging systems on the same computer and gen 4 disk, first 
in WSL with the same Ubuntu distro with fio 3.36, then also with the 
native Windows fio 3.41 binary, performing the same benchmark on a 
mounted drive. Although the PCIe 4x4 disk scored similarly, the PCIe 5x4 
disk scored stunning 15.4 GB/s in both cases! The WSL kernel was the 6.6 
kernel supplied by Microsoft. I understand that the WSL disk access is 
virtualized and this should brake the benchmark, but it is greatly 
outperforming the native Linux distro. I am interested in reasons and 
ways to remedy that issue, or tell why it can't be remedied at worst. 
Thanks for your help.


Just what I've tried, with results unchanged or worse (however, I was 
unable to change interrupt coalescing):

PCIe Gen 5 Storage Array Optimization: Overcoming the Obstacles to Get 
the Best Performance | Blog | Xinnor 
<https://xinnor.io/blog/pcie-gen-5-storage-array-optimization-overcoming-the-obstacles-to-maximize-performance/>


-- 

Best regards

	*Petr Řehák*
/specialista sw Dolphin, programátor/
E-mail: rehak@adaptech.cz 	*Adaptech s.r.o.*
www.adaptech.cz <https://www.adaptech.cz>
Telefon: +420 605 321 321
E-mail: info@adaptech.cz 	*Sledujte nás na FB:*
Facebook <https://www.facebook.com/pages/Adaptech/1581295688751091>


_DŮLEŽITÉ SDĚLENÍ_: Tato zpráva elektronické komunikace včetně jakýchkoliv k ní připojených souborů je důvěrná a určená výhradně k použití osobě nebo subjektu, kterému byla adresována. V případě, že jste dostali tuto zprávu omylem, vymažte ji z vašeho systému. Žádným způsobem neužívejte a nesdílejte informace v této zprávě a informujte info@adaptech.cz. Jakékoliv názory nebo vyjádření v této zprávě jsou názory a vyjádření odesilatele a nemusí se shodovat s vyjádřeními Adaptech s.r.o.

_IMPORTANT INFORMATION_: This e-mail and any files transmitted with it are confidential and intended solely for the use of the individual or entity to whom they are addressed. If you have received this email in error please delete it from your system, do not use or disclose the information in any way and notify info@adaptech.cz. Any views or opinions expressed in this e-mail are those of the sender and do not necessarily coincide with those of Adaptech s.r.o.



