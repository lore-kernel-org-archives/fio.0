Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE9323A8D0
	for <fio@vger.kernel.org>; Wed, 28 Aug 2024 18:46:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724870774; cv=none; b=kzhGlJ+YspP6GqJhalXhuEE20gMYKQUBwU8JigkXpZBjovNvqE7c/JC7Z099Co58DwXZls0WrQeT5eWOBpQZdvsBV8gnJ95uwVl/Um5wpvwdUraq9HJeU/96o12cVl+FIsrmJnhyAw0tEEA+vLtvHjrY9D5Q+dZvIZpoJ/r5z04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724870774; c=relaxed/simple;
	bh=6LZdCafTTO/H+jXrqom1mB1FdZHO799mekNXCOzr9x4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Wbkwx4WYcr22gIt0ucDvFLk1HmXGVy3x8EGx3j40xPeKGBk6gmg+xgLOQmULd1iT/VRINlotcHyM4oZlAXBQIoEWcfNOUaAUtfEJaDjX4+usdpYSnTYwAlmkh0NmHtbmm+EtzjXFok5ulOZLO42QVO7h0fOzGg4UBPkuEj43Py8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aAJWcm7Y; arc=none smtp.client-ip=209.85.160.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aAJWcm7Y"
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-45019dccc3aso42452991cf.1
        for <fio@vger.kernel.org>; Wed, 28 Aug 2024 11:46:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1724870772; x=1725475572; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=uG+icK7Pi3/jlBsyWxoy1hII3p77QSBTBty0eCrXVH0=;
        b=aAJWcm7YmZprefaTTjcKciNsfqZ6mLLkQK0sZ73Blh8StUTKjoS3KB0RiFEZhaKanY
         YQNEI851Y2A9IvOxhWicYLcChVEVjZ81uflBlI13sjNHGtLSQMR7/S40a4Nf3CSShRkd
         Mxwn68JaQPUb8iuRqCIlNPgLXcmO9nMA10JvucFslI/63riRtXttJIz13scegHh8L53k
         IRlWwjw7WfBM+tb3kYvNfBLFKanht9loVveg9k63S5DvMsL4kGlPNzpyUAlaLCdB07l1
         Py5fpgytc82/Tntw4QGAvWt+RU72/C1jdwWpuUhbRLI809OlwG+BYIhkX+y79hHCuSTf
         Ngqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724870772; x=1725475572;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uG+icK7Pi3/jlBsyWxoy1hII3p77QSBTBty0eCrXVH0=;
        b=no8CaDlE1P+w1Xt3bkWNSs97D4ix9dIhC3Q+qtkdLK1PNjrqbtLHwTwnASj82k2Cqm
         e1RTRdqzx9bw7PZB5dzEySYhJMwniOXWsClCZOK7XUaSErmJ3tbVmnnmyYJ838GtOfQ1
         OGq7N3GWQxJIX7V+0gbKecFhB16pImvMn1s/Av/Idn0CeRg8C0fJuVMUjkGmEC4uwrLY
         f0zF0v5vGsckArHtIuXViwvvgsItd2DaNwMCivgGLvVbgGwN55kmuDdbI47vNQfL35kv
         SGzW0vIv3FwnSbuZw2r5iElinb4W3boCuBgCMJPZ3PWqDFtKqVM2AIAYcZXcag41jnVT
         9Abg==
X-Forwarded-Encrypted: i=1; AJvYcCXOzYSm9E6LFDYSesasJkUFmLDdhgxKxHc09imQtF2rimK73m0L9hJPx13wYuD4dijmX8o=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyne4DafS47CT4kQEPq0MAy0G78dw/8xFr2zJefiUBcE44chvSO
	dxKkjqgRho/iSb/qp9iUNoWs3LgmqiHN7hcOXCp7b9cT38KM/0Hc
X-Google-Smtp-Source: AGHT+IGKSXZP8UiFHa7qByIQ6bULjOfkobHp19bFnaR09ZJ0IZhHXZZXSusMreUPIFqgvAndILL46Q==
X-Received: by 2002:ac8:6f12:0:b0:456:6538:ace7 with SMTP id d75a77b69052e-4567f55c784mr5259311cf.26.1724870771553;
        Wed, 28 Aug 2024 11:46:11 -0700 (PDT)
Received: from [192.168.1.220] (pool-173-79-40-147.washdc.fios.verizon.net. [173.79.40.147])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4567490932fsm5225391cf.29.2024.08.28.11.46.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Aug 2024 11:46:10 -0700 (PDT)
Message-ID: <ef2f71cb-825d-47d9-8d81-50c296aef165@gmail.com>
Date: Wed, 28 Aug 2024 14:46:10 -0400
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 8/9] t/jobs/t0033: add test for the log file format
To: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>, fio@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>
Cc: Damien Le Moal <dlemoal@kernel.org>
References: <20240827070850.947037-1-shinichiro.kawasaki@wdc.com>
 <20240827070850.947037-9-shinichiro.kawasaki@wdc.com>
Content-Language: en-US
From: Vincent Fu <vincentfu@gmail.com>
In-Reply-To: <20240827070850.947037-9-shinichiro.kawasaki@wdc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/27/24 03:08, Shin'ichiro Kawasaki wrote:
> Add a test to check the log file format which is described in the "Log
> File Format" section in HOWTO.rst. Generate log files using combination
> of options relevant to log files, and check that lines in log files have
> the format expected. This test helps to confirm that the changes in the
> log file related functions do not cause regressions.
> 
> Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
> ---
>   t/jobs/t0033.fio   | 28 ++++++++++++++++++++++++++++
>   t/run-fio-tests.py | 35 +++++++++++++++++++++++++++++++++++
>   2 files changed, 63 insertions(+)
>   create mode 100644 t/jobs/t0033.fio
> 
> diff --git a/t/jobs/t0033.fio b/t/jobs/t0033.fio
> new file mode 100644
> index 00000000..038e388f
> --- /dev/null
> +++ b/t/jobs/t0033.fio
> @@ -0,0 +1,28 @@
> +[global]
> +rw=read
> +filename=t0033file
> +size=8k
> +time_based
> +runtime=100ms
> +ioengine=libaio
> +iodepth=1
> +
> +[job1]
> +write_bw_log=log
> +log_prio=1
> +
> +[job2]
> +write_lat_log=log
> +log_avg_msec=20
> +log_window_value=both
> +
> +[job3]
> +write_iops_log=log
> +log_offset=1
> +log_prio=1
> +
> +[job4]
> +write_iops_log=log
> +log_avg_msec=20
> +log_window_value=both
> +log_offset=1
> diff --git a/t/run-fio-tests.py b/t/run-fio-tests.py
> index 22580613..8bc343cd 100755
> --- a/t/run-fio-tests.py
> +++ b/t/run-fio-tests.py
> @@ -47,6 +47,7 @@ import time
>   import shutil
>   import logging
>   import argparse
> +import re
>   from pathlib import Path
>   from statsmodels.sandbox.stats.runs import runstest_1samp
>   from fiotestlib import FioExeTest, FioJobFileTest, run_fio_tests
> @@ -553,6 +554,30 @@ class FioJobFileTest_t0029(FioJobFileTest):
>           if self.json_data['jobs'][1]['read']['io_kbytes'] != 8:
>               self.passed = False
>   
> +class FioJobFileTest_t0033(FioJobFileTest):
> +    """Test log file format"""
> +    def check_result(self):
> +        super().check_result()
> +
> +        if not self.passed:
> +            return
> +
> +        patterns = {
> +            'log_bw.1.log': '\\d+, \\d+, \\d+, \\d+, 0x[\\da-f]+\\n',
> +            'log_clat.2.log': '\\d+, \\d+, \\d+, \\d+, 0, \\d+\\n',
> +            'log_iops.3.log': '\\d+, \\d+, \\d+, \\d+, \\d+, 0x[\\da-f]+\\n',
> +            'log_iops.4.log': '\\d+, \\d+, \\d+, \\d+, 0, 0, \\d+\\n',
> +        }
> +
> +        for logfile in patterns.keys():
> +            file_path = os.path.join(self.paths['test_dir'], logfile)
> +            with open(file_path, "r") as f:
> +                line = f.readline()
> +                if not re.match(patterns[logfile], line):
> +                    self.passed = False
> +                    self.failure_reason = "wrong log file format: " + logfile
> +                    return
> +
>   class FioJobFileTest_iops_rate(FioJobFileTest):
>       """Test consists of fio test job t0011
>       Confirm that job0 iops == 1000
> @@ -878,6 +903,16 @@ TEST_LIST = [
>           'pre_success':      SUCCESS_DEFAULT,
>           'requirements':     [Requirements.linux, Requirements.libaio],
>       },
> +    {
> +        'test_id':          33,
> +        'test_class':       FioJobFileTest_t0033,
> +        'job':              't0033.fio',
> +        'success':          SUCCESS_DEFAULT,
> +        'pre_job':          None,
> +        'pre_success':      None,
> +        'pre_success':      SUCCESS_DEFAULT,
> +        'requirements':     [],

Add [Requirements.linux, Requirements.libaio] here so that the script 
does not try to run this test on platforms where it is not supported.

There were also some test failures where the job was able to run:

https://github.com/fiotestbot/fio/actions/runs/10573766613

Consider increasing the job duration and making log_avg_msec larger.
