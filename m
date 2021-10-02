Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5240FC433EF
	for <fio@archiver.kernel.org>; Sat,  2 Oct 2021 15:00:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 356CD61A81
	for <fio@archiver.kernel.org>; Sat,  2 Oct 2021 15:00:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229560AbhJBPBp (ORCPT <rfc822;fio@archiver.kernel.org>);
        Sat, 2 Oct 2021 11:01:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233438AbhJBPBo (ORCPT <rfc822;fio@vger.kernel.org>);
        Sat, 2 Oct 2021 11:01:44 -0400
Received: from mail-il1-x12c.google.com (mail-il1-x12c.google.com [IPv6:2607:f8b0:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01C46C0613EF
        for <fio@vger.kernel.org>; Sat,  2 Oct 2021 07:59:59 -0700 (PDT)
Received: by mail-il1-x12c.google.com with SMTP id l20so1351745ilk.2
        for <fio@vger.kernel.org>; Sat, 02 Oct 2021 07:59:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=TZyxmNqQL1CC4WybscJw+J5zGLbeE6TRONeXrpjz2XM=;
        b=nNSsV3kB7ba8hMKcUsSX4vjxFB31RED4GJ56HAc0HWFShst1etFI/AaqqZWF9or6fw
         VyUxTtqLqCqHKz7divvkwk+2UsJHnbqltJkZhBqdLtZ5SO1yP2fe+tIqZZgwnLko9vWe
         AEggyzQ0Pb8T56jyQ4+PKeHmzpfeb4I/+DCw52jHmOWXr7J7AB0QiWSeDmM/f+bkYCm2
         ZZmglHfjMnRXI09Q5YxfLhBYq5NwZOhZ9am6Bu4CbeQJESC2I25xXYnyI5YLIYejOIoG
         75467Y9pwHykYSB21PZHBoXQeitsFYgPifaST25FEE0LTPHsBPcSewRSYdMkZz5Qjlbf
         EIeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=TZyxmNqQL1CC4WybscJw+J5zGLbeE6TRONeXrpjz2XM=;
        b=d11iJHsrl209nDb//9Ymb3ifppB8/QJedugs/jhuakVwIh0qdQn+ZxZbHqdkX9xkaO
         mWomMFuFkxZKwSsSs5TxAkd6HWYOVQOGAmj9rSsVU9rlo4hOpTxs/Tyh6++FN/Iw48wK
         Xhimm+GOEqPVIt1a3kHB47hYDfTq5zpFeDBGV86di5PKIoD5l1b8LLQzErpFXBpf4PuZ
         qjCHWURBIretYVo741oPcFHJ45oGEcwXUmjClSToFO+WpJ6Ku/C6dxNRI1xdhssEXsEe
         Ji5ubWN5/Cx32ySmQKWyngO2bcD6coRhae0yULRgBmHXZxNodDz5G3z08pDmDPQ4NApE
         ExnA==
X-Gm-Message-State: AOAM533GtHbcTrbdZTdVgPSWYj7kTPIeJ8nhIDX9nuC/5oA6PqmNgIdg
        IeLlKEjo3Waq9O2Kzb8G6lU8Hw0VHw8wfQ==
X-Google-Smtp-Source: ABdhPJzbYUpAN8B/MpO9vd19t1yCY2RrvnpHjiSHmr92ytS7935IiGxvcEZgDNpN0F7/QLiX/cWlsg==
X-Received: by 2002:a92:c605:: with SMTP id p5mr2161798ilm.218.1633186798102;
        Sat, 02 Oct 2021 07:59:58 -0700 (PDT)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id a12sm5642413ilb.66.2021.10.02.07.59.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 02 Oct 2021 07:59:57 -0700 (PDT)
Subject: Re: generic/095 failing in ext4 and xfs
To:     Luis Henriques <lhenriques@suse.de>, Theodore Ts'o <tytso@mit.edu>
Cc:     fstests@vger.kernel.org, fio@vger.kernel.org
References: <YVdBVdOjPLCayG1k@suse.de>
 <882f4c20-2e21-219b-0ca3-7e215e2d7cfa@kernel.dk> <YVeE2ZVkpGbTKZpG@mit.edu>
 <86ee93vijj.fsf@orpheus.olymp>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <6f867fa0-c3e9-6f65-d97f-4779c029ef81@kernel.dk>
Date:   Sat, 2 Oct 2021 08:59:57 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <86ee93vijj.fsf@orpheus.olymp>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On 10/2/21 4:16 AM, Luis Henriques wrote:
> "Theodore Ts'o" <tytso@mit.edu> writes:
> 
>> On Fri, Oct 01, 2021 at 02:46:09PM -0600, Jens Axboe wrote:
>>>
>>> Hmm, do older versions fail? I see Ted suggested that 3.27 doesn't, can
>>> you give that a go? If that does work, would be great if you could try
>>> and bisect it.
>>
>> I just tried fio 3.28, and it worked for me.  So I don't think it's
>> fio.
> 
> Awesome, thank you both for checking it out.  So, it's definitely
> something in my test environment.
> 
>> Luis, could it be related to a  kernel config option?
> 
> Yeah, it could be.  I've tested this on a rolling release (openSUSE TW),
> so it's definitely quite different from Debian 10.  It may take me a bit
> to figure out what's going on, but I'll start with this kernel config and
> report back any finding.
> 
> Again, thank you both for confirming it's working on your side.

Do you have a core file from fio? Would be interesting to get a
backtrace from it.

In terms of why it's failing, a guess would be that your device is using 4k
sectors and the test is trying to do 1k aligned dio. That would fail, but
it should not cause fio to crash...

-- 
Jens Axboe

