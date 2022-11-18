Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B2DFC4332F
	for <fio@archiver.kernel.org>; Fri, 18 Nov 2022 18:09:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235435AbiKRSJs (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 18 Nov 2022 13:09:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235396AbiKRSJr (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 18 Nov 2022 13:09:47 -0500
Received: from mail-qt1-x829.google.com (mail-qt1-x829.google.com [IPv6:2607:f8b0:4864:20::829])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2EA3C5D
        for <fio@vger.kernel.org>; Fri, 18 Nov 2022 10:09:45 -0800 (PST)
Received: by mail-qt1-x829.google.com with SMTP id z6so3632787qtv.5
        for <fio@vger.kernel.org>; Fri, 18 Nov 2022 10:09:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=CsY3ibqz1GUMHSUMOyqY1lmT4lh+rxkgGijqVxXVKLU=;
        b=S2EjLKLFjFBc74lHm+dyKzGi+BudToR5Js3TGM+SWz0LCJtDeBQ4LilVc9HQEKMJQd
         LwVmvYNR3S+HhAUbYs2g5cUcCpQxx0Gwt+qxlxWCbIBX58YnWOJ264hhAmULJODtDjB0
         NwmybvdcpcTWP9PGDD6zd5BOzjddyApjgYX9eWh8fC6Fw5UNZnHjSlFFrichJGZ+HG9h
         r+64GufS9/kOojR4z3pJaiab0VvKosIdzV8qxWcz6kZLVbVLLwCSYHZYX1T5OyyRB+Ur
         dMYcBy5s7MURVac4pFOpixYTzk9xjk8V+qKBbg41mGXXgUBQZERBH8vjS19zauipnhSs
         Jlkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CsY3ibqz1GUMHSUMOyqY1lmT4lh+rxkgGijqVxXVKLU=;
        b=QQK1kcqSdeQ0s1AMBUIudV5Sx6dmStoQ0UpYO9LH1dAnRsf290lhNqXZ4mi7BrgYJz
         jTCIb2gpfM5R96ee2sWCqlcVOqYcY7nWmnAy84p3kMWZGzqdq8HEtuqnItgdOuAB6eB1
         Uy+PW0qQIMxXp0p3RFX849Yn+RZpC3DMEfRHND9UJ4xhgdG1Sk7B5kXvz+XacdRq6rrr
         4UPN7DyM3N9fIzv4TEkfop1Xay6obJs3YwBKhsq9UaG9bJQD/dsBVXZyJ49OO+D552ot
         LHxpF+daG2wjkun0UtVqkSD2dp2grlv0IJjm9apEkEQ9u+Ser8Y1hs4kIEMUYvIB4rdH
         4Z7A==
X-Gm-Message-State: ANoB5plsNUhry2GrrwU+DkaeX0y9H1fixu7x3CSp6qiqobX24DOyTYsQ
        GMXhQ5cRuzvOyt+gRZ9FMYQ=
X-Google-Smtp-Source: AA0mqf5h9nRGK7hFe3QcuL2sOwlk5CGqsCrMG1GBcHsJpWb2y1BSfy/CZnsFw86g/3qEw6Na+vZBAA==
X-Received: by 2002:a05:622a:388:b0:35b:b6f9:5b38 with SMTP id j8-20020a05622a038800b0035bb6f95b38mr7711063qtx.242.1668794984889;
        Fri, 18 Nov 2022 10:09:44 -0800 (PST)
Received: from [192.168.1.218] (pool-173-79-40-147.washdc.fios.verizon.net. [173.79.40.147])
        by smtp.gmail.com with ESMTPSA id bn39-20020a05620a2ae700b006fa16fe93bbsm2812433qkb.15.2022.11.18.10.09.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 18 Nov 2022 10:09:44 -0800 (PST)
Message-ID: <f53d47a2-9fa8-be2f-42c0-ad401cd572b6@gmail.com>
Date:   Fri, 18 Nov 2022 13:09:43 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH v2 5/5] test: add large pattern test
Content-Language: en-US
To:     Logan Gunthorpe <logang@deltatee.com>, fio@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>
Cc:     David Sloan <David.Sloan@eideticom.com>,
        Stephen Bates <sbates@raithlin.com>
References: <20221117220523.83501-1-logang@deltatee.com>
 <20221117220523.83501-6-logang@deltatee.com>
From:   Vincent Fu <vincentfu@gmail.com>
In-Reply-To: <20221117220523.83501-6-logang@deltatee.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On 11/17/22 17:05, Logan Gunthorpe wrote:
> Add a test which writes a file with a 16KB buffer pattern, then
> verify the file with the same pattern.
> 
> The test writes a single 16KB block and thus should be the same as
> the patttern file. Verify that this is the case after the test is
> run.
> 
> Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
> ---
>   t/jobs/t0027.fio   | 14 ++++++++++++++
>   t/run-fio-tests.py | 29 +++++++++++++++++++++++++++++
>   2 files changed, 43 insertions(+)
>   create mode 100644 t/jobs/t0027.fio
> 
> diff --git a/t/jobs/t0027.fio b/t/jobs/t0027.fio
> new file mode 100644
> index 000000000000..b5b97a30d3d7
> --- /dev/null
> +++ b/t/jobs/t0027.fio
> @@ -0,0 +1,14 @@
> +[global]
> +filename=t0027file
> +size=16k
> +bs=16k
> +
> +[write_job]
> +readwrite=write
> +buffer_pattern='t0027.pattern'
> +
> +[read_job]
> +stonewall=1
> +readwrite=read
> +verify=pattern
> +verify_pattern='t0027.pattern'
> diff --git a/t/run-fio-tests.py b/t/run-fio-tests.py
> index e5b307ac0db8..a06f812683cb 100755
> --- a/t/run-fio-tests.py
> +++ b/t/run-fio-tests.py
> @@ -799,6 +799,26 @@ class FioJobTest_t0025(FioJobTest):
>           if self.json_data['jobs'][0]['read']['io_kbytes'] != 128:
>               self.passed = False
>   
> +class FioJobTest_t0027(FioJobTest):
> +    def setup(self, *args, **kws):
> +        super(FioJobTest_t0027, self).setup(*args, **kws)
> +        self.pattern_file = os.path.join(self.test_dir, "t0027.pattern")conv
> +        self.output_file = os.path.join(self.test_dir, "t0027file")
> +        self.pattern = os.urandom(16 << 10)
> +        with open(self.pattern_file, "wb") as f:
> +            f.write(self.pattern)
> +
> +    def check_result(self):
> +        super(FioJobTest_t0027, self).check_result()
> +
> +        if not self.passed:
> +            return
> +
> +        with open(self.output_file, "rb") as f:
> +            data = f.read()
> +
> +        if data != self.pattern:
> +            self.passed = False
>   
>   class FioJobTest_iops_rate(FioJobTest):
>       """Test consists of fio test job t0009
> @@ -1214,6 +1234,15 @@ TEST_LIST = [
>           'pre_success':      None,
>           'requirements':     [Requirements.not_windows],
>       },
> +    {
> +        'test_id':          27,
> +        'test_class':       FioJobTest_t0027,
> +        'job':              't0027.fio',
> +        'success':          SUCCESS_DEFAULT,
> +        'pre_job':          None,
> +        'pre_success':      None,
> +        'requirements':     [],
> +    },
>       {
>           'test_id':          1000,
>           'test_class':       FioExeTest,

This test fails on Windows because Windows open() converts line endings 
and treats Ctrl-Z as end of file:

https://ci.appveyor.com/project/vincentkfu/fio/builds/45418556

This diff resolves the problem:

diff --git a/lib/pattern.c b/lib/pattern.c
index 1ae05758..9be29af6 100644
--- a/lib/pattern.c
+++ b/lib/pattern.c
@@ -47,7 +47,11 @@ static const char *parse_file(const char *beg, char *out,
  	if (file == NULL)
  		goto err_out;

+#ifdef _WIN32
+	fd = open(file, O_RDONLY | O_BINARY);
+#else
  	fd = open(file, O_RDONLY);
+#endif
  	if (fd < 0)
  		goto err_free_out;

-- 

https://ci.appveyor.com/project/vincentkfu/fio
