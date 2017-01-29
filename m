Return-Path: <fio-owner@vger.kernel.org>
Received: from muon.bluestop.org ([74.50.51.35]:61980 "EHLO muon.cran.org.uk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752780AbdA2ByQ (ORCPT <rfc822;fio@vger.kernel.org>);
        Sat, 28 Jan 2017 20:54:16 -0500
Subject: Re: Windows and TRIM support - files, not devices
References: <99e2bdcb-3067-cb48-90c8-c141191465d5@cran.org.uk>
 <CALjAwxiC91y8fXNDQ1a1sFeS_DQ1aVQ_jwWib+9xcr_oQ=5cgg@mail.gmail.com>
 <CALjAwxhnUSjE3EsUz_Q9uOLb-qTWn0FJ5S+97NLxHRL9UYfx1w@mail.gmail.com>
From: Rebecca Cran <rebecca@bluestop.org>
Message-ID: <9c363e2b-a1f0-466a-9238-c992ca921a29@bluestop.org>
Date: Sat, 28 Jan 2017 18:54:14 -0700
MIME-Version: 1.0
In-Reply-To: <CALjAwxhnUSjE3EsUz_Q9uOLb-qTWn0FJ5S+97NLxHRL9UYfx1w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Sitsofe Wheeler <sitsofe@gmail.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

On 1/28/2017 6:01 AM, Sitsofe Wheeler wrote:
>
> https://msdn.microsoft.com/en-us/library/windows/hardware/dn653576(v=vs.85).aspx
> hints that "applications should use the DSM IOCTLs to perform
> UNMAP/TRIM" but I've read elsewhere that "[DeviceDsmAction_Trim]
> is not supported for user-mode applications" -
> https://msdn.microsoft.com/en-us/library/windows/desktop/ee907416(v=vs.85).aspx
> .

Thanks. Since the former page is from 2012 and the latter has no date on 
it, I suspect the one saying it's not supported for applications is 
probably more recent and correct, unfortunately.

-- 
Rebecca
