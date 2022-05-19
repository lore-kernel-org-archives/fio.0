Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 720A9C433F5
	for <fio@archiver.kernel.org>; Thu, 19 May 2022 14:03:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239259AbiESODT convert rfc822-to-8bit (ORCPT
        <rfc822;fio@archiver.kernel.org>); Thu, 19 May 2022 10:03:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238688AbiESOCu (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 19 May 2022 10:02:50 -0400
X-Greylist: delayed 65889 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 19 May 2022 07:02:46 PDT
Received: from submit-01.torproject.org (submit-01.torproject.org [IPv6:2a01:4f8:fff0:4f:266:37ff:fe18:2abe])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3E1563C6
        for <fio@vger.kernel.org>; Thu, 19 May 2022 07:02:46 -0700 (PDT)
Received: from localhost (localhost [::1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (Client did not present a certificate)
        (Authenticated sender: anarcat)
        by submit-01.torproject.org (Postfix) with ESMTPSA id 7A6F7801A2;
        Thu, 19 May 2022 14:02:44 +0000 (UTC)
Received: by curie.anarc.at (Postfix, from userid 1000)
        id 4F4A6120387; Thu, 19 May 2022 10:02:43 -0400 (EDT)
From:   =?utf-8?Q?Antoine_Beaupr=C3=A9?= <anarcat@torproject.org>
To:     Vincent Fu <vincent.fu@samsung.com>,
        "fio@vger.kernel.org" <fio@vger.kernel.org>
Subject: RE: running jobs serially
In-Reply-To: <f4da48b19d4f4d36aa238ca582a351d6@samsung.com>
Organization: Tor
References: <CGME20220518195544uscas1p2df5012297be87e1151c9b1f2ea33ff01@uscas1p2.samsung.com>
 <87pmkaeicg.fsf@curie.anarc.at>
 <ab0612e1ab8a40aaa8d6eaed69c5985b@samsung.com>
 <87tu9mqq2l.fsf@angela.anarc.at>
 <f4da48b19d4f4d36aa238ca582a351d6@samsung.com>
Date:   Thu, 19 May 2022 10:02:43 -0400
Message-ID: <878rqxei2k.fsf@curie.anarc.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On 2022-05-19 13:35:02, Vincent Fu wrote:
>> -----Original Message-----
>> From: Antoine Beaupré [mailto:anarcat@torproject.org]

[...]

>> Speaking of which, it's not clear to me if I need to add stonewall to
>> each job or if I can just add it to the top-level global options and be
>> done with it...
>
> The stonewall option is needed only in the global section and will apply
> to all of the jobs.

That's great to hear, thanks. That makes total sense. It can still be
applied only to a single job if I want too, right?

>> So maybe the bug is *just* 1 and 2: (1) the timestamps in the final
>> report are incorrect, and (2) processes are all started at once (and 1
>> may be related to 2!)
>
> The timestamp is actually the time at which the summary output was generated,
> not the time the job started or stopped.
>
> https://github.com/axboe/fio/blob/fio-3.30/stat.c#L1161

Aaah... so that's why I was confused.

Could this be changed? It looks like neither the group_run_stats or the
thread_stat structs have the start timestamps, although thread_stat has
the runtime... Maybe it could be extended so that the display is a
little less confusing?

Or maybe I'm the only one confused by this?

> All of the processes are created when fio starts up but they do not start issuing IO
> until it is their turn.

Couldn't this affect metrics, especially on low-end systems with lots of
jobs? I would think that some processes could end up being swapped in
and out... If a process is stonewalled, I would have assumed it only
*starts* after the stonewall.

-- 
Antoine Beaupré
torproject.org system administration
