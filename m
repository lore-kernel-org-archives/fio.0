Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D98F9C433F5
	for <fio@archiver.kernel.org>; Sat, 13 Nov 2021 05:28:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A7DD560F26
	for <fio@archiver.kernel.org>; Sat, 13 Nov 2021 05:28:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230482AbhKMFbo (ORCPT <rfc822;fio@archiver.kernel.org>);
        Sat, 13 Nov 2021 00:31:44 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:34652 "EHLO
        out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229487AbhKMFbo (ORCPT <rfc822;fio@vger.kernel.org>);
        Sat, 13 Nov 2021 00:31:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=simple/simple; d=bsdio.com;
        s=xmission; h=Subject:Content-Transfer-Encoding:Content-Type:In-Reply-To:
        References:To:From:MIME-Version:Date:Message-ID:Sender:Reply-To:Cc:Content-ID
        :Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:
        Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe
        :List-Post:List-Owner:List-Archive;
        bh=HGj15aweRkyP9GeNuQIwuc3REGNjVtpnw1jPzrG7R/o=; b=LhH5cMVfru3UNbPl3A5E8kqqqy
        kHVBkn81Gy3kMjtJ5+QrHMREQJkur4hc3zBAz77j8dJwwCE0JI/qwbBXOm8fRO4Ryu6t9xxim1n6S
        DJSP9IaA0H8fJrbwvF3EqNMIlqZ03zIT9GLp+mXhQU1oUQAhHJ02/7h+mrvielXkMeBs=;
Received: from in02.mta.xmission.com ([166.70.13.52]:46490)
        by out01.mta.xmission.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <rebecca@bsdio.com>)
        id 1mllau-0010pP-2v
        for fio@vger.kernel.org; Fri, 12 Nov 2021 22:28:52 -0700
Received: from mta4.zcs.xmission.com ([166.70.13.68]:46470)
        by in02.mta.xmission.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <rebecca@bsdio.com>)
        id 1mllas-00Dm2O-Qc
        for fio@vger.kernel.org; Fri, 12 Nov 2021 22:28:51 -0700
Received: from localhost (localhost [127.0.0.1])
        by mta4.zcs.xmission.com (Postfix) with ESMTP id 9F0F0501AA8
        for <fio@vger.kernel.org>; Fri, 12 Nov 2021 22:28:50 -0700 (MST)
X-Amavis-Modified: Mail body modified (using disclaimer) -
        mta4.zcs.xmission.com
Received: from mta4.zcs.xmission.com ([127.0.0.1])
        by localhost (mta4.zcs.xmission.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id wCP63S2gq9eW for <fio@vger.kernel.org>;
        Fri, 12 Nov 2021 22:28:50 -0700 (MST)
Received: from [10.0.10.113] (c-174-52-16-57.hsd1.ut.comcast.net [174.52.16.57])
        by mta4.zcs.xmission.com (Postfix) with ESMTPSA id 9C8E9501A12
        for <fio@vger.kernel.org>; Fri, 12 Nov 2021 22:28:47 -0700 (MST)
Message-ID: <8bc95de8-554d-24c5-7563-e7ce640fa4ac@bsdio.com>
Date:   Fri, 12 Nov 2021 22:28:47 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Content-Language: en-US
From:   Rebecca Cran <rebecca@bsdio.com>
To:     "fio@vger.kernel.org" <fio@vger.kernel.org>
References: <7b4301f4-d03b-0e56-1997-8e5cb67d2faf@bsdio.com>
In-Reply-To: <7b4301f4-d03b-0e56-1997-8e5cb67d2faf@bsdio.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-XM-SPF: eid=1mllas-00Dm2O-Qc;;;mid=<8bc95de8-554d-24c5-7563-e7ce640fa4ac@bsdio.com>;;;hst=in02.mta.xmission.com;;;ip=166.70.13.68;;;frm=rebecca@bsdio.com;;;spf=none
X-SA-Exim-Connect-IP: 166.70.13.68
X-SA-Exim-Mail-From: rebecca@bsdio.com
Subject: Re: "failed to setup shm segment" on macOS Monterey with ipcs empty
X-SA-Exim-Version: 4.2.1 (built Sat, 08 Feb 2020 21:53:50 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On 11/10/2021 10:36 AM, Rebecca Cran wrote:
> I just tried to run fio (from master) on my new M1 Max MacBook Pro 
> running macOS Monterey. "./fio examples/tiobench-example.fio" quit 
> with the error "failed to setup shm segment" but "ipcs" doesn't show 
> any entries, so it doesn't appear to be the typical problem of 
> left-over segments.

It turns out that there's just not enough shared memory available by 
default (shmall is 1024). I installed the following SharedMemory.plist 
file into /Library/LaunchDaemons after which it worked.

<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" 
"http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>Label</key>
  <string>shmemsetup</string>
  <key>UserName</key>
  <string>root</string>
  <key>GroupName</key>
  <string>wheel</string>
  <key>ProgramArguments</key>
  <array>
  <string>/usr/sbin/sysctl</string>
  <string>-w</string>
  <string>kern.sysv.shmmax=33554432</string>
  <string>kern.sysv.shmmni=32</string>
  <string>kern.sysv.shmseg=8</string>
  <string>kern.sysv.shmall=8192</string>
  <string>kern.sysv.shmmin=1</string>
   </array>
  <key>KeepAlive</key>
  <false/>
  <key>RunAtLoad</key>
  <true/>
</dict>
</plist>


-- 
Rebecca Cran


