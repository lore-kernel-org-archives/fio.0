Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E08CEB64D9
	for <fio@archiver.kernel.org>; Thu,  6 Jul 2023 08:58:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230125AbjGFI6D (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 6 Jul 2023 04:58:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229518AbjGFI6C (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 6 Jul 2023 04:58:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C56B1990
        for <fio@vger.kernel.org>; Thu,  6 Jul 2023 01:58:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A7A2C618CC
        for <fio@vger.kernel.org>; Thu,  6 Jul 2023 08:58:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52981C433C7;
        Thu,  6 Jul 2023 08:58:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1688633881;
        bh=MuQRF5K1TPpP+cxPoSVicxoke0y4U9nsXgqpstPZ0Pg=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=OzODhKcNzYT2i+ISzR2nDGfW4QwhBmbc935n1evY0+bOQWuwIFB+5hnpg4zVBKZxi
         +Eg0rvePm0Vza1yTMsEu7LEgqJMnYXUbVGxIsMdoIPinOQbmPPxifUooqnSnUEuASJ
         2F8G3DiVdiRR41KkDlBW1Bm6HOTy9tZrhdkBfrZ3KlZMZCgfUsv7y1KKH29/jXQnU2
         1boWcF4bG+B6BykDCc7C3WsRL38bJ+Xz6iS72jdL7dWeF+kpPAiXIo/uOaX31OBZ/z
         T4JK0p7u8m23fzIk8xtRue0GJD1UFgM1/jNKKPpw8dGB8UO2zUxrZbrD42yQ15B9V0
         gMAZjM/iIRL8Q==
Message-ID: <ff9cffeb-589a-621f-3c7e-a90e79988240@kernel.org>
Date:   Thu, 6 Jul 2023 17:57:58 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH 0/4] Add support for IO priority hints
Content-Language: en-US
To:     Avri Altman <Avri.Altman@wdc.com>,
        "fio@vger.kernel.org" <fio@vger.kernel.org>,
        Vincent Fu <vincentfu@gmail.com>, Jens Axboe <axboe@kernel.dk>
Cc:     Niklas Cassel <Niklas.Cassel@wdc.com>
References: <20230705221302.430678-1-dlemoal@kernel.org>
 <DM6PR04MB65757567C626F9E8AED14CBFFC2CA@DM6PR04MB6575.namprd04.prod.outlook.com>
From:   Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <DM6PR04MB65757567C626F9E8AED14CBFFC2CA@DM6PR04MB6575.namprd04.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On 7/6/23 17:43, Avri Altman wrote:
>> Linux kernel 6.5 will add support for IO priority hints, which can be used
>> for now to specify a command duration limit for block devices supporting
>> this feature.
>> 
>> This patch series extends fio IO priority options and adds new options to
>> allow users to specify IO priority hints.
> Maybe while at it, remove the write_hint option that was deprecated in the
> kernel a while ago.

write_hint is completely unrelated to IO priority. So removing that option
should be a different patch series.

In any case, write_hint is indeed not supported anymore by current kernels but
it can still be used with older kernels. Removing that option from fio is thus
not a good idea at all as that would prevent using write_hints with older
kernels and drives that support this feature. There are cases of that in the
field. So nack on removing write_hint.

> 
> Otherwise, this series looks good to me.
> 
> Thanks, Avri
> 
>> 
>> Damien Le Moal (4): os-linux: add initial support for IO priority hints 
>> options: add priohint option cmdprio: Add support for per I/O priority
>> hint stats: Add hint information to per priority level stats
>> 
>> HOWTO.rst          | 31 +++++++++++++++++++++++++++---- backend.c
>> |  9 ++++++--- cconv.c            |  2 ++ engines/cmdprio.c  |  9
>> ++++++--- engines/cmdprio.h  |  1 + engines/io_uring.c | 25
>> +++++++++++++++++++++++-- engines/libaio.c   | 21 +++++++++++++++++++++ 
>> fio.1              | 28 +++++++++++++++++++++++++--- options.c          |
>> 31 ++++++++++++++++++++++++++++--- os/os-dragonfly.h  |  4 ++-- 
>> os/os-linux.h      | 21 +++++++++++++++++---- os/os.h            |  7
>> +++++-- stat.c             | 10 +++++++--- thread_options.h   |  3 ++- 14
>> files changed, 172 insertions(+), 30 deletions(-)
>> 
>> -- 2.41.0
> 

-- 
Damien Le Moal
Western Digital Research

