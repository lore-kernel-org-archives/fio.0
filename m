Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66D9FC433EF
	for <fio@archiver.kernel.org>; Mon, 25 Oct 2021 15:37:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 45C3560E97
	for <fio@archiver.kernel.org>; Mon, 25 Oct 2021 15:37:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230070AbhJYPkJ (ORCPT <rfc822;fio@archiver.kernel.org>);
        Mon, 25 Oct 2021 11:40:09 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:48146 "EHLO
        out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229809AbhJYPkJ (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 25 Oct 2021 11:40:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=simple/simple; d=bsdio.com;
        s=xmission; h=Subject:Content-Transfer-Encoding:Content-Type:In-Reply-To:
        MIME-Version:Date:Message-ID:From:References:To:Sender:Reply-To:Cc:Content-ID
        :Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:
        Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe
        :List-Post:List-Owner:List-Archive;
        bh=5MZRRqZrtn2B8z00cU7gY/ZZUeuR4rHDCz2orUKK/+w=; b=Lin7ybf2aKoF2gWBtuTqJHJNpV
        l0ni+kJA3jlFAUojxBILUoPjqZsRMWLVNeygPQtrFixCxzen36NLA97NOyUXj1P19Rhxfw3UB9nEf
        4idlrv1dJR5CG4mdidwEiVtDRO6hheDZYWnRqHskDLil9x1gF9O3gPiIbJMjHecfkGi0=;
Received: from in01.mta.xmission.com ([166.70.13.51]:59918)
        by out02.mta.xmission.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <rebecca@bsdio.com>)
        id 1mf22k-00A5eY-9T; Mon, 25 Oct 2021 09:37:46 -0600
Received: from mta4.zcs.xmission.com ([166.70.13.68]:39882)
        by in01.mta.xmission.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <rebecca@bsdio.com>)
        id 1mf22j-00341h-GU; Mon, 25 Oct 2021 09:37:45 -0600
Received: from localhost (localhost [127.0.0.1])
        by mta4.zcs.xmission.com (Postfix) with ESMTP id 5067B500043;
        Mon, 25 Oct 2021 09:37:45 -0600 (MDT)
X-Amavis-Modified: Mail body modified (using disclaimer) -
        mta4.zcs.xmission.com
Received: from mta4.zcs.xmission.com ([127.0.0.1])
        by localhost (mta4.zcs.xmission.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id oDTPz2iI7VsP; Mon, 25 Oct 2021 09:37:45 -0600 (MDT)
Received: from [10.0.10.179] (c-174-52-16-57.hsd1.ut.comcast.net [174.52.16.57])
        by mta4.zcs.xmission.com (Postfix) with ESMTPSA id 26F3550033F;
        Mon, 25 Oct 2021 09:37:45 -0600 (MDT)
To:     Jens Axboe <axboe@kernel.dk>, fio@vger.kernel.org
References: <20211023120001.B33411BC0139@kernel.dk>
From:   Rebecca Cran <rebecca@bsdio.com>
Message-ID: <13b58f71-076c-02a8-985c-60294a6d35b4@bsdio.com>
Date:   Mon, 25 Oct 2021 09:37:44 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211023120001.B33411BC0139@kernel.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-XM-SPF: eid=1mf22j-00341h-GU;;;mid=<13b58f71-076c-02a8-985c-60294a6d35b4@bsdio.com>;;;hst=in01.mta.xmission.com;;;ip=166.70.13.68;;;frm=rebecca@bsdio.com;;;spf=none
X-SA-Exim-Connect-IP: 166.70.13.68
X-SA-Exim-Mail-From: rebecca@bsdio.com
Subject: Re: Recent changes (master)
X-SA-Exim-Version: 4.2.1 (built Sat, 08 Feb 2020 21:53:50 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On 10/23/21 6:00 AM, Jens Axboe wrote:
> The following changes since commit 09d0a62931df0bb7ed4ae92b83a245e35d04100a:
>
>    Merge branch 'patch-1' of https://github.com/sweettea/fio (2021-10-19 16:09:21 -0600)
>
> are available in the Git repository at:
>
>    git://git.kernel.dk/fio.git master

I just noticed this. Is it possible to change this to specify the https 
URL instead, since the git protocol is insecure?


-- 
Rebecca Cran


