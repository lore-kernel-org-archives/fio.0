Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 435C9C433F5
	for <fio@archiver.kernel.org>; Fri, 27 May 2022 18:07:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350018AbiE0SHR (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 27 May 2022 14:07:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230493AbiE0SHQ (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 27 May 2022 14:07:16 -0400
Received: from mail-il1-x12d.google.com (mail-il1-x12d.google.com [IPv6:2607:f8b0:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9674119C29
        for <fio@vger.kernel.org>; Fri, 27 May 2022 11:07:15 -0700 (PDT)
Received: by mail-il1-x12d.google.com with SMTP id l13so2939016ilj.0
        for <fio@vger.kernel.org>; Fri, 27 May 2022 11:07:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language
         :from:to:cc:references:in-reply-to:content-transfer-encoding;
        bh=++SNtG9HLbvzAsVJqQ2cChVYbxgpYI7KsChQyn1Eoos=;
        b=BirimYCGyYYmwoWmKWpag72bIrIPqOsl4D9DAjnkDlag0ND3msOjCGrrQ7vIcTr7WW
         4H9h4r3dWar0afYeW9J5GFLTDxttIg07CQvOwFjR4T/ZM0mWQ15zuL8tV3HeHV1zH8hw
         YZ3YAB8TGe/dAtiqm8OSIsPEHpTaF3mzevkrfzDlLNKQVhxumnqzptzfRbDNvUBfoUMb
         W5Lotr0gFOjd55wC/Nn1/HpEmXieT7Bq49/map5DOWARo8xUL0nhsIypsJbaBrVGqGeD
         QbsF8cuG380I4/y3VE3+hPzTbj61sip5r5qMXQzOQrgackMeK+/Zd12e+PfplM4brtzU
         J+5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:cc:references:in-reply-to
         :content-transfer-encoding;
        bh=++SNtG9HLbvzAsVJqQ2cChVYbxgpYI7KsChQyn1Eoos=;
        b=lx9OJfu7yhayUGk40PXoflpExZcxyCHWlyMB4riLiZ3l/PHIY98x1BvBfSP+Oa2Fxb
         fiaj8+DfbPxTlYFtMaXZeHWa/LgpDXANVmf+ruJUyBXhEp4PvCTWi7lxeoJrgKD+74sV
         yG07mBv/flr1WBNkRtQ+7FFPZ9KeoBAH1Qq+7iZRZn2oixXl1if+pkV2CZkLsxVuDdOK
         DdmELUVsX7kR8c8sDM/qe7MvZcOWAd3n2UJhrdui3f465yVNp94DjUhbXAAtMR0HfKWD
         d0VTpvFBmOtWo1GcTbz63yRi1z7iAcFqnxpGAJgRPaDzgPflzlUkJpE2sVaQj4EH4qdN
         3LFA==
X-Gm-Message-State: AOAM533eYAQW4Grx0sbaI5IoLVBHjhSfOH6x2nsmH3qjmRHoB96UBjjG
        7bo2T1PTld88LmBe9kqCXrY0/Q==
X-Google-Smtp-Source: ABdhPJwIbOm4Wz6Q4ODhGHJPmw90k6BhCrEQGWRQBFlYQochvCnrrQodvWHoxXA111T6KKWLxG7dDg==
X-Received: by 2002:a05:6e02:1bc1:b0:2d1:96b3:b961 with SMTP id x1-20020a056e021bc100b002d196b3b961mr16436953ilv.213.1653674834889;
        Fri, 27 May 2022 11:07:14 -0700 (PDT)
Received: from [192.168.1.172] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id s12-20020a92cbcc000000b002d1eb84e4fasm1456987ilq.83.2022.05.27.11.07.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 27 May 2022 11:07:13 -0700 (PDT)
Message-ID: <de6bb4ab-1f2f-2465-8f93-c19261f0dc4e@kernel.dk>
Date:   Fri, 27 May 2022 12:07:12 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH v2 3/8] nvme: add nvme opcodes, structures and helper
 functions
Content-Language: en-US
From:   Jens Axboe <axboe@kernel.dk>
To:     Vincent Fu <vincent.fu@samsung.com>,
        Ankit Kumar <ankit.kumar@samsung.com>
Cc:     "fio@vger.kernel.org" <fio@vger.kernel.org>,
        "krish.reddy@samsung.com" <krish.reddy@samsung.com>,
        "joshi.k@samsung.com" <joshi.k@samsung.com>,
        "anuj20.g@samsung.com" <anuj20.g@samsung.com>
References: <20220526144809.14877-1-ankit.kumar@samsung.com>
 <CGME20220526145400epcas5p348be0238746b1cc70fae627a63a43eba@epcas5p3.samsung.com>
 <20220526144809.14877-4-ankit.kumar@samsung.com>
 <9e2905ec01eb4350b1896491fc29dc8b@samsung.com>
 <f2c8a94b-7c54-7b87-f417-602a134eef04@kernel.dk>
In-Reply-To: <f2c8a94b-7c54-7b87-f417-602a134eef04@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On 5/27/22 8:54 AM, Jens Axboe wrote:
> On 5/27/22 8:45 AM, Vincent Fu wrote:
>>> -----Original Message-----
>>> From: Ankit Kumar [mailto:ankit.kumar@samsung.com]
>>
>>> +
>>> +	if (io_u->ddir == DDIR_READ)
>>> +		cmd->opcode = nvme_cmd_read;
>>> +	if (io_u->ddir == DDIR_WRITE)
>>> +		cmd->opcode = nvme_cmd_write;
>>
>> Consider changing this to a switch statement and adding a default:
>> case in case someone tries to send an unsupported command.
>>
>> Since this is in the  fast path a switch statement would also reduce
>> the number of times ddir is checked.
> 
> A switch or if/else won't make any difference there, the compiler should
> generate the same code. But I do agree that it's nicer to use a switch
> so that unhandled cases are done properly.

How I'd do this:

make the prep handler return an error, and then do:

if (io_u->ddir == DDIR_READ)
	cmd->opcode = nvme_cmd_read;
else if (io_u->ddir == DDIR_WRITE)
	cmd->opcode = nvme_cmd_write;
else
	return appropriate error;

after you do the command memset, before all the other logic. Now make
sure that whoever calls the prep handler will check for an error and
error the io_u in that case.

-- 
Jens Axboe

