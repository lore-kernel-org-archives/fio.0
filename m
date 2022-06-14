Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D179C43334
	for <fio@archiver.kernel.org>; Tue, 14 Jun 2022 16:25:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237549AbiFNQZL (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 14 Jun 2022 12:25:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241888AbiFNQZK (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 14 Jun 2022 12:25:10 -0400
Received: from mail-qt1-x82d.google.com (mail-qt1-x82d.google.com [IPv6:2607:f8b0:4864:20::82d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA95B2980F
        for <fio@vger.kernel.org>; Tue, 14 Jun 2022 09:25:06 -0700 (PDT)
Received: by mail-qt1-x82d.google.com with SMTP id b3so1037962qtp.4
        for <fio@vger.kernel.org>; Tue, 14 Jun 2022 09:25:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=Ui2tpIkZYo3fQaHgdPMRAxe/Tn9gFgyNecgcJzn1pCA=;
        b=opRy0iH9etIHkbJdVgHDv7Fg5lp2YlUZF0kAGBSg8M6e2oIllf+KakB+9pd6PejSjK
         o9T7AA56dJykPpvf+oKewf7SUT6PX5r5ZujBWhu1BVMAU7Am7fN3pXvIw0qm+s+CTIek
         FcvRvOvJmNJOwJkg3QuEymXoPOCr1zqpRz3wfKSnd5/9t5qAVD1DMLdySARp2vUlDCEg
         WodZ4WW+MzNSKINEF0ZT9x3Vpggssp1Yd7SIM1hHpN0omUJAc4ayb5c/KAKG5vnQJJk9
         kdNPJRf1gI4Incj76jIrggXsRF0BdYiOJNnU2ts838UWUQgKcu6qcYVPtrndlQsM4H4+
         sGKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Ui2tpIkZYo3fQaHgdPMRAxe/Tn9gFgyNecgcJzn1pCA=;
        b=lvMyvHbsaJo00TjJ/zWr6w1MIa6MFo7d1RT7tEhmUK+Zq9ZqrisFcGQm4PdCw97JuW
         3cCbDBZ0gJhl6NQ5hTZC6ooaIHcTLXeygGUJytEtZ6C0DC9Zs/wz0Eo3GVLpcvhK1IKD
         bd/vcAg/r7ysbBclCazmALRB2XbBBdpmGZRZJLeQVnBMeG/gjpbVkYquecXTrc/zy0nb
         Wb4BeGD5HrtjAyLtLPdFNepREaYCGgSa/sbN8htoE64D/ZK8dCSv4qSllx6hZPPkAUNw
         AjP0uIKr5By4fNeP/tkjjhosQynurqpxjbFN16URwVTnHqbOTaFiMpJoIVbrCgWtYDoN
         GM+w==
X-Gm-Message-State: AOAM530lxflmcB/DpIC7n/mkapudWZ25jY/MaXsvExKsym2jE1TaiXVc
        89NxVEJEab25AA2Sl7WgO1Y=
X-Google-Smtp-Source: ABdhPJxjUeLkNgE8uYIfylCzMPOdiOYJ2lb8vclV7DX5qdGVoHtelaW20YQKYNsz6A+oiPOFGmDBwQ==
X-Received: by 2002:ac8:5783:0:b0:305:32:700d with SMTP id v3-20020ac85783000000b003050032700dmr4946819qta.31.1655223905778;
        Tue, 14 Jun 2022 09:25:05 -0700 (PDT)
Received: from [192.168.1.218] (pool-173-79-46-23.washdc.fios.verizon.net. [173.79.46.23])
        by smtp.gmail.com with ESMTPSA id t16-20020ac87390000000b00304edcfa109sm7221988qtp.33.2022.06.14.09.25.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Jun 2022 09:25:05 -0700 (PDT)
Message-ID: <c2751d31-c91f-dad0-d248-cf7ee312232a@gmail.com>
Date:   Tue, 14 Jun 2022 12:25:04 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: Blog post on how fio measures latency
Content-Language: en-US
To:     Erwan Velu <e.velu@criteo.com>,
        "fio@vger.kernel.org" <fio@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>, gost.dev@samsung.com
References: <b862c6ba-ba87-bf1d-b695-4529e19335a6@gmail.com>
 <19a2559f-05e5-b597-fa28-2822af13bd85@criteo.com>
From:   Vincent Fu <vincentfu@gmail.com>
In-Reply-To: <19a2559f-05e5-b597-fa28-2822af13bd85@criteo.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On 6/14/22 10:28, Erwan Velu wrote:
> Le 09/06/2022 à 15:46, Vincent Fu a écrit :
>> I have a new blog post describing how fio measures latency:
>>
>> https://eur03.safelinks.protection.outlook.com/?url=https%3A%2F%2Fgithub.com%2Fvincentkfu%2Ffio-blog%2Fwiki%2FHow-does-fio-measure-latency&amp;data=05%7C01%7Ce.velu%40criteo.com%7C6463c5b6ca2548d415dd08da4a1e7138%7C2a35d8fd574d48e3927c8c398e225a01%7C1%7C0%7C637903791846076175%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C3000%7C%7C%7C&amp;sdata=1XZ6jj%2FgOHjDGolytLdXxv%2FA8OR6CmqHKCj%2FgRGUgjw%3D&amp;reserved=0 
>>
>>
>> Feedback is welcome!
>>
> Thanks, that's awesome to get such details.
> 
> Why not having this as part of the doc/ directory of the project ? That 
> could be used by new comers to learn about fio.
> 
> Erwan,
> 
> 

Thanks for the feedback Erwan. I did consider something along those 
lines but for the fio repository I feel there is pressure to keep the 
material up to date. I don't want to feel responsible for updates every 
time there is a relevant change in the code.

Blog posts hosted separately have an associated date and readers should 
be aware that they are snapshots of behavior at a particular point in time.
