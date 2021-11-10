Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FFA4C433F5
	for <fio@archiver.kernel.org>; Wed, 10 Nov 2021 17:36:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 45FEA611C9
	for <fio@archiver.kernel.org>; Wed, 10 Nov 2021 17:36:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230230AbhKJRj2 (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 10 Nov 2021 12:39:28 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:43824 "EHLO
        out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230100AbhKJRj2 (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 10 Nov 2021 12:39:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=simple/simple; d=bsdio.com;
        s=xmission; h=Subject:Content-Transfer-Encoding:Content-Type:MIME-Version:
        Date:Message-ID:From:To:Sender:Reply-To:Cc:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=nRSOD4hKN6InD/LMUa4nnfBRjPcIKLss/Zss7gmcElo=; b=Fcou/of93NUvjh+37S3yYD2BMB
        MPalYL24cz/3tEjqWAELc2Z5Q3BIAAai270Grpgkz2gDIYlVgd4seFlN2bRYTzLp7PnAPNHUmOU4F
        HwMqbT4LEBszn1HXt8yfjPyC4TQ4lh6LCc9g51EIGvRs8JCG+mQA/g4um37JCz5qqXwY=;
Received: from in01.mta.xmission.com ([166.70.13.51]:34386)
        by out02.mta.xmission.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <rebecca@bsdio.com>)
        id 1mkrWZ-00DoDo-Vy
        for fio@vger.kernel.org; Wed, 10 Nov 2021 10:36:40 -0700
Received: from mta5.zcs.xmission.com ([166.70.13.69]:51494)
        by in01.mta.xmission.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <rebecca@bsdio.com>)
        id 1mkrWX-000NrK-Em
        for fio@vger.kernel.org; Wed, 10 Nov 2021 10:36:39 -0700
Received: from localhost (localhost [127.0.0.1])
        by mta5.zcs.xmission.com (Postfix) with ESMTP id 486691280776
        for <fio@vger.kernel.org>; Wed, 10 Nov 2021 10:36:37 -0700 (MST)
X-Amavis-Modified: Mail body modified (using disclaimer) -
        mta5.zcs.xmission.com
Received: from mta5.zcs.xmission.com ([127.0.0.1])
        by localhost (mta5.zcs.xmission.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id E9iJMFMy_Z3L for <fio@vger.kernel.org>;
        Wed, 10 Nov 2021 10:36:37 -0700 (MST)
Received: from [10.0.10.179] (c-174-52-16-57.hsd1.ut.comcast.net [174.52.16.57])
        by mta5.zcs.xmission.com (Postfix) with ESMTPSA id 27D1712810A0
        for <fio@vger.kernel.org>; Wed, 10 Nov 2021 10:36:37 -0700 (MST)
To:     "fio@vger.kernel.org" <fio@vger.kernel.org>
From:   Rebecca Cran <rebecca@bsdio.com>
Message-ID: <7b4301f4-d03b-0e56-1997-8e5cb67d2faf@bsdio.com>
Date:   Wed, 10 Nov 2021 10:36:36 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-XM-SPF: eid=1mkrWX-000NrK-Em;;;mid=<7b4301f4-d03b-0e56-1997-8e5cb67d2faf@bsdio.com>;;;hst=in01.mta.xmission.com;;;ip=166.70.13.69;;;frm=rebecca@bsdio.com;;;spf=none
X-SA-Exim-Connect-IP: 166.70.13.69
X-SA-Exim-Mail-From: rebecca@bsdio.com
Subject: "failed to setup shm segment" on macOS Monterey with ipcs empty
X-SA-Exim-Version: 4.2.1 (built Sat, 08 Feb 2020 21:53:50 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

I just tried to run fio (from master) on my new M1 Max MacBook Pro 
running macOS Monterey. "./fio examples/tiobench-example.fio" quit with 
the error "failed to setup shm segment" but "ipcs" doesn't show any 
entries, so it doesn't appear to be the typical problem of left-over 
segments.


-- 
Rebecca Cran


