Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A21BC433EF
	for <fio@archiver.kernel.org>; Tue, 21 Dec 2021 09:35:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234483AbhLUJfC (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 21 Dec 2021 04:35:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233216AbhLUJfC (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 21 Dec 2021 04:35:02 -0500
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B16FC061574
        for <fio@vger.kernel.org>; Tue, 21 Dec 2021 01:35:01 -0800 (PST)
Received: by mail-lf1-x131.google.com with SMTP id g26so12140561lfv.11
        for <fio@vger.kernel.org>; Tue, 21 Dec 2021 01:35:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudlinux.com; s=google;
        h=message-id:date:mime-version:user-agent:content-language:to
         :references:from:cc:subject:in-reply-to:content-transfer-encoding;
        bh=L1kNy/Yk2Alca0sRyppWLHfueHwm+xlWq1FT77KWDmc=;
        b=V72Ang9dIiJX35Byv5I51bOuNB6ssb/0xCKK3cUlaHMNfcOLBfb+DzvGDIehnBanJ7
         03JXJFsPXmcq0UfvFetWD6w8JexIb9JLhzp1qdmHrezTFc2+NFn7MdZPTZ1RTYjKKlQb
         I0DhoWGpfZI9nkqTk3idyTYU01VD64XvtIR8u4NJlgOqDVFzrPfj/TVDOwcUxeskKFEp
         /wLmX30L+pmKAZO/IDuTeibdvkreVznRaaGy1/4rCTI9pHdwk8JhbQ59GrlPYvxFDqpF
         4TsIrfXSGZ3zmvEEzaf5nP5UW1wMH7MbeqAwG87ik1mhgU8LJqjoxDxjzzaAS1aXkceq
         1QnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:references:from:cc:subject:in-reply-to
         :content-transfer-encoding;
        bh=L1kNy/Yk2Alca0sRyppWLHfueHwm+xlWq1FT77KWDmc=;
        b=O0PBO8+xsu5DbqIW0rirM3tRcc7S8hhwRUULLYr1bt1SKxOYlV69WR/hv/eGFiYDAr
         hJs52SyFlMtH/XGfDufXLbEBnjhwbJ1VhjyVRRPz3rTNeK3i6rQ8/OsUKf6oA6wbQHSs
         xm9sKJFHupih9t1C84TnmktE1kGpKipJ6744Qt0Nnia7u1SV3jwo/XehDJEBYdxCkw3J
         oSwLzT+BzvtgTqsIiPB9jDB+KlZOCJW/qFYM5jf4T8U8mfp7uKUTfGnV/jAg6Vw64XUV
         gxZDeFrkeqokU/omgT66vEMb5c98ttF/A4eyyWrRaxH8RRTmU5BIqsGLh2J22gCM1dP4
         4+PQ==
X-Gm-Message-State: AOAM531/dSuEBENR01KjRP3mguqbXMyAWtkmsIuzWiHz8LKdvhcxhBBv
        oFGqcRzNIOTab6QP31d5IyHWEQ==
X-Google-Smtp-Source: ABdhPJwAozkPWRKifr9TumTwTlMM9NNbmu/J2nRHKJjPu1ksvSqm2I+CboTRNlHPyVGHGnBjU3h99A==
X-Received: by 2002:a05:6512:3048:: with SMTP id b8mr2363261lfb.677.1640079299850;
        Tue, 21 Dec 2021 01:34:59 -0800 (PST)
Received: from [192.168.222.111] ([37.139.80.10])
        by smtp.gmail.com with ESMTPSA id f18sm84211lfj.56.2021.12.21.01.34.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Dec 2021 01:34:59 -0800 (PST)
Message-ID: <f3ac3012-b641-d95c-5b73-315979842114@cloudlinux.com>
Date:   Tue, 21 Dec 2021 12:34:58 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Content-Language: en-US
To:     Seyed Mohammad Fakhraie <fk.smoh@gmail.com>
References: <CACzyWQx0YZgwyJLRzBESL-8EoLzWzyFrqWMsVb0hs1Z-K7TMSA@mail.gmail.com>
 <d3c7a9ca-af7e-9d70-f229-74558d17cfe2@cloudlinux.com>
 <CACzyWQzih6gCQ4vYGA9Hwj-Zq4_d+YKC1j=secP8W9nr7bZCgg@mail.gmail.com>
 <44a99ee0-4856-51eb-0172-9d635582223e@cloudlinux.com>
 <CACzyWQwCvsCkh=Ui_cr5Hh8jqZGEkX4B1YwujEnR6nYutjPveA@mail.gmail.com>
 <7cc48a89-7bc3-bd55-733b-c9d40fecb0ab@cloudlinux.com>
 <CACzyWQwe2SYR_W=XyuCk=THBZ-0frnh5u1gtjALfnZBpu6EerA@mail.gmail.com>
From:   Dmitry Antipov <dantipov@cloudlinux.com>
Cc:     fio@vger.kernel.org
Subject: Re: Using FIO to benchmark Gluster
In-Reply-To: <CACzyWQwe2SYR_W=XyuCk=THBZ-0frnh5u1gtjALfnZBpu6EerA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On 12/20/21 19:11, Seyed Mohammad Fakhraie wrote:

> Hello Dmitry, Thanks for reaching out.
> by "reproduced", you mean that you're getting the same error during
> randomread workloads using gfapi? This is the error that I'm getting
> on all the setups that I've tested (3x Replica & 2x Replica with
> Arbiter) during randomread + gfapi:
> 
> failed fio extend file 4vm-1G-randrw.1.0 to 18446744073709551615

Definitely. What I'm seeing is:

# cat test0.fio
[global]
ioengine=gfapi
volume=test0
brick=localhost
direct=1
create_on_open=1
ramp_time=1m
iodepth=1
numjobs=1
openfiles=1
bs=4k
[1vm-1G-rand-read-3rep]
filesize=1G
time_based
runtime=3min
rw=randread
write_bw_log=4k-read-3replica-ro.results
write_iops_log=4k-read-3replica-ro.results
write_lat_log=4k-read-3replica-ro.results

# fio --debug=file test0.fio
fio: set debug option file
file     155116 dup files: 0
file     155116 add file 1vm-1G-rand-read-3rep.0.0
file     155116 resize file array to 2 files
file     155116 file 0x7fb75dbfa110 "1vm-1G-rand-read-3rep.0.0" added at 0
1vm-1G-rand-read-3rep: (g=0): rw=randread, bs=(R) 4096B-4096B, (W) 4096B-4096B, (T) 4096B-4096B, ioengine=gfapi, iodepth=1
fio-3.28
Starting 1 process
file     155116 setup files
file     155116 get file size for 0x7fb75dbfa110/0/1vm-1G-rand-read-3rep.0.0
file     155116 get file size 1vm-1G-rand-read-3rep.0.0
file     155126 fio setup 0x1962ea0
file     155126 trying file 1vm-1G-rand-read-3rep.0.0 280
file     155126 fio file 1vm-1G-rand-read-3rep.0.0 open mode rw td rw read
file     155126 fio extend file 1vm-1G-rand-read-3rep.0.0 from 0 to 18446744073709551615
failed fio extend file 1vm-1G-rand-read-3rep.0.0 to 18446744073709551615
file     155126 fio 0x1962ea0 created 1vm-1G-rand-read-3rep.0.0
file     155126 error 1 on open of 1vm-1G-rand-read-3rep.0.0
file     155126 get_next_file_rr: (nil)
file     155126 get_next_file: NULL
file     155126 close files

This looks like a weird error parsing job file. I didn't get the logic
behind get_file_sizes(), but the job file definitely requests 1G ant not
18446744073709551615, which is -1ULL.

Dmitry
