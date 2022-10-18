Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9720C4332F
	for <fio@archiver.kernel.org>; Tue, 18 Oct 2022 16:16:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230304AbiJRQQq (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 18 Oct 2022 12:16:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229697AbiJRQQp (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 18 Oct 2022 12:16:45 -0400
Received: from mail-qv1-xf36.google.com (mail-qv1-xf36.google.com [IPv6:2607:f8b0:4864:20::f36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97E05B7F78
        for <fio@vger.kernel.org>; Tue, 18 Oct 2022 09:16:44 -0700 (PDT)
Received: by mail-qv1-xf36.google.com with SMTP id i9so9638021qvo.0
        for <fio@vger.kernel.org>; Tue, 18 Oct 2022 09:16:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=EOrJ5nH7kx6JrnQBjiwPJEK/YugWPPvCTkf97LsxvCo=;
        b=LfQqrmbup0/KSKPFCRQkEdIvkY9o+Y5ipWYvpTzfjpUnjcd626+ZIOzeCyqDSTF2HV
         UU7QbfORMPUG4va+9KPUbviz3rvOq8FfE6y3lwDTkcXzivZhLQcHDD+vnDFlcR3SzylY
         vOhLCDrSTWnu4Ft3K/HnyyUn195yb9m5H26ezfg4ikp6zAK49A0kr4ucQSZgRoX1rbrs
         2KVgCmmUX3MDuH5AwUCs8Ll53jjLCPuzCuDW98h6DLve9mtBOUrfTBBorUzA+CC8xDtG
         OD1CSfnHD5RW6rK4xhiGNy/6ADSGS9vgw11XunW8JvrPo5tUXvrzoLnHezH0BkA9oGjq
         7YZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EOrJ5nH7kx6JrnQBjiwPJEK/YugWPPvCTkf97LsxvCo=;
        b=CKWfzZLfLrlxF69LxjTFudxeJJS+lTK2Dfzaggna49qqmhKuUd8ekN8a+cNjaXMcFo
         jE3E8PfRSC9zkmYlsz14upcf1x+LBiImbyIM7XA3V+zHOq9z8GaljMTNYupj9RrWVs+a
         U/SdM+aMtI33JTa3mmLOWQD6kM3WEY702raV/Xg6O9Np1w3CcIdbvEZPxOKs7zhMl18k
         KTqGlbQCZQt8tSOiSYtzj9BGr0wEc59YDNeSkOFwqCDQE58MqUrY17GaFYavcaQhjT6A
         Yvl+JJD/H4JiB3MJRnr0aBtJbpXMNXNHT3E9bKH1CQVBUEA3id7A8ExOFbVaIRQksG/7
         NQzg==
X-Gm-Message-State: ACrzQf2D+uPBC9HRJDhPY494DaiwCBmk/d0JLuUM/op3/mJP/GLUkTZj
        E6NTyVlxK7r1jY+hxmefww0=
X-Google-Smtp-Source: AMsMyM69pDXsv4AvNoR7w4hz87pjsQhBltEAUFVOXlkV2/FuIzyylF98LmZpbqPSm2n9Sl6bEfiB2g==
X-Received: by 2002:a05:6214:4101:b0:4af:8cdc:20c4 with SMTP id kc1-20020a056214410100b004af8cdc20c4mr2864378qvb.6.1666109803644;
        Tue, 18 Oct 2022 09:16:43 -0700 (PDT)
Received: from [192.168.1.218] (pool-173-79-40-147.washdc.fios.verizon.net. [173.79.40.147])
        by smtp.gmail.com with ESMTPSA id b1-20020ac87fc1000000b0039cc47752casm2352578qtk.77.2022.10.18.09.16.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Oct 2022 09:16:43 -0700 (PDT)
Message-ID: <4640b1de-a98c-185e-e37c-770a895f1117@gmail.com>
Date:   Tue, 18 Oct 2022 12:16:42 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH 3/4] test: add test for verify read back of experimental
 verify
Content-Language: en-US
To:     Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
        fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>,
        Niklas Cassel <niklas.cassel@wdc.com>
References: <20221018041725.807940-1-shinichiro.kawasaki@wdc.com>
 <20221018041725.807940-4-shinichiro.kawasaki@wdc.com>
From:   Vincent Fu <vincentfu@gmail.com>
In-Reply-To: <20221018041725.807940-4-shinichiro.kawasaki@wdc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On 10/18/22 00:17, Shin'ichiro Kawasaki wrote:
> Add a test case to confirm fix of bytes_done accounting issue of
> experimental verify. The test job runs a simple workload with
> experimental verify and confirm read amount is not zero.
> 
> Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
> ---
>   t/jobs/t0025.fio   |  8 ++++++++
>   t/run-fio-tests.py | 22 ++++++++++++++++++++++
>   2 files changed, 30 insertions(+)
>   create mode 100644 t/jobs/t0025.fio
> 
> diff --git a/t/jobs/t0025.fio b/t/jobs/t0025.fio
> new file mode 100644
> index 00000000..2b35a9ac
> --- /dev/null
> +++ b/t/jobs/t0025.fio
> @@ -0,0 +1,8 @@
> +[job]
> +filename=t0025file
> +size=128k
> +readwrite=write
> +do_verify=1
> +verify=md5
> +experimental_verify=1
> +
> diff --git a/t/run-fio-tests.py b/t/run-fio-tests.py
> index df87ae72..0e15068d 100755
> --- a/t/run-fio-tests.py
> +++ b/t/run-fio-tests.py
> @@ -788,6 +788,18 @@ class FioJobTest_t0024(FioJobTest_t0023):
>           self.check_all_offsets("bssplit_bw.log", 512, filesize)
>   
>   
> +class FioJobTest_t0025(FioJobTest):
> +    """Test experimental verify read backs written data pattern."""
> +    def check_result(self):
> +        super(FioJobTest_t0025, self).check_result()
> +
> +        if not self.passed:
> +            return
> +
> +        if self.json_data['jobs'][0]['read']['io_kbytes'] == 0:
> +            self.passed = False

Instead of merely checking that it's nonzero why not check that it is 
equal to the size of the file?

> +
> +
>   class FioJobTest_iops_rate(FioJobTest):
>       """Test consists of fio test job t0009
>       Confirm that job0 iops == 1000
> @@ -1183,6 +1195,16 @@ TEST_LIST = [
>           'pre_success':      None,
>           'requirements':     [],
>       },
> +    {
> +        'test_id':          25,
> +        'test_class':       FioJobTest_t0025,
> +        'job':              't0025.fio',
> +        'success':          SUCCESS_DEFAULT,
> +        'pre_job':          None,
> +        'pre_success':      None,
> +        'output_format':    'json',
> +        'requirements':     [],
> +    },
>       {
>           'test_id':          1000,
>           'test_class':       FioExeTest,

