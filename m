Received: from mail-oi1-f180.google.com (mail-oi1-f180.google.com [209.85.167.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D125328DB
	for <fio@vger.kernel.org>; Wed, 28 Aug 2024 18:48:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724870882; cv=none; b=atmfKlZtZ7t+M4AEIz5CgecPCkCrNc3xEM7I4rl5H5EDkVzvWqFGbVzFPx6gAZSZNtCEbJ7Dme3VsvutNMdfgOiwxVcr7CUy/lCs6rp9ls94LUjM6fy3wb+fyKzSeB89MYIE1uI1odW+HIXH5SOJFKbmv1Y90EstJiuEmE9n6P0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724870882; c=relaxed/simple;
	bh=QmU8M1uMYBJau4+svl16v3K+n0vhXs/Nt0+GmyINp4E=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Hm0+nnJCwS52cJONVHp4JSkYW6nuMmzJ7krFcCy5qSelhSRHq0I2WWWg/qHZbKVb5tzmKI5Q/DXQaGWBUiL6cDZ1ZDkFjBS6oOavD7oTmugrZ8+wqo+wSOAVv887byFXrW/6v5ywcOwU0aek8TAdXBstvknPqOl8ehKaTu2JV2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZWW+wdMx; arc=none smtp.client-ip=209.85.167.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZWW+wdMx"
Received: by mail-oi1-f180.google.com with SMTP id 5614622812f47-3db157d3bb9so1352331b6e.2
        for <fio@vger.kernel.org>; Wed, 28 Aug 2024 11:48:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1724870880; x=1725475680; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=rHSK0HXQGlOtQRbUuMoEYYI+g13qtUnWw4QQX3QAgs4=;
        b=ZWW+wdMxHWcs2ZxlpIoYFnOIHagkSeH5eu1llgdwB9WdJhCHd9g+xduhTJ/UsPsL4B
         bxkSwe0QPEwIYaZv/fmJi1EzgB5Gq1581OH8rNyw+T09vS1dPY3OKfe7s3qwEClV0JgX
         i6RuP/PAmMHk4MGa9SQyCUzYbdkLjcqUu/xGU/w+Yiu7R+UGqLDdIjDeXweS9V60Y8Up
         mgXJuUKRF9Zaa6z0Yhs1svb7lC2l7DhRcT2X66MXMR8P+Zrb/DS6XHn5BYoIh1RpZKd1
         3f1ZlKnIOOLvRl5hXYGUw/ddkCGze8etelAJZpaXEHWgRCav8BObC2vhB3CJQkHPYcqk
         zvTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724870880; x=1725475680;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rHSK0HXQGlOtQRbUuMoEYYI+g13qtUnWw4QQX3QAgs4=;
        b=pk3GT5qOoh35dXNYdJgOWtbyaqW9zc2S6rD8Dkm36o4txA//q5vIl+ugn8fXN5kVN0
         KxV12IawvvceEQXGhfNx68d2YFgvL6Rh602eTpfVnTH8brZuF9LHn9YI26zuU4IX67/9
         LDpAs8JbGUM5GAU/26E+p6Vu0E/QC9I7ZRMUBA7cuFqDUNEZm8GSY0FQyB1udLfo6ZGh
         aRTOk0tKhTmT+5N2kVOBwZMrUwBOGG1jFtCqF/dQbHvskncLGIdGQbsgn4CT3kUlXfsD
         piQ6m+p07whdKbbzSOk3fjGsEp4tucxWIOChfG2sM6B40MUWhRsHqHsjiF9WLM+V5g1/
         HVpQ==
X-Forwarded-Encrypted: i=1; AJvYcCV/Cgs9yKfl4wUlBKkq7nPAmEwnzoBIFHkfSx5u+gzwPmj4ZuzFIqanGzG2F7/567q96v8=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz756g6HnMvmddvzeHfpDXlqE6RGQ7+e75jcD74cRR9c8cHh+Mn
	r8RotKm+mrQwNyMNnEro9eCmsmFFk1/mMlRT/p2ynC6ZWfsMxvKuVV8V1Q==
X-Google-Smtp-Source: AGHT+IEVgjDeF+gmK0oaHf2E7X97Ihpf16IfzbaFkLbF1rwVH1LJj/51wu0kKonidirL+ek0nSB9bg==
X-Received: by 2002:a05:6808:221a:b0:3dc:15b9:334a with SMTP id 5614622812f47-3df05daf821mr403418b6e.6.1724870880123;
        Wed, 28 Aug 2024 11:48:00 -0700 (PDT)
Received: from [192.168.1.220] (pool-173-79-40-147.washdc.fios.verizon.net. [173.79.40.147])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-454fe0f0512sm64271011cf.48.2024.08.28.11.47.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Aug 2024 11:47:59 -0700 (PDT)
Message-ID: <369de3f1-37b7-45aa-9e80-bad96f52c5bd@gmail.com>
Date: Wed, 28 Aug 2024 14:47:58 -0400
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 9/9] t/jobs/t0034: add test for the log_issue_time option
To: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>, fio@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>
Cc: Damien Le Moal <dlemoal@kernel.org>
References: <20240827070850.947037-1-shinichiro.kawasaki@wdc.com>
 <20240827070850.947037-10-shinichiro.kawasaki@wdc.com>
Content-Language: en-US
From: Vincent Fu <vincentfu@gmail.com>
In-Reply-To: <20240827070850.947037-10-shinichiro.kawasaki@wdc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/27/24 03:08, Shin'ichiro Kawasaki wrote:
> Add a test to check the newly added option 'log_issue_time'. Generate
> log files using the option and check that lines in the log files have
> the format described in the "Log File Format" section in HOWTO.rst.
> 
> This test case has the logic same as t0033 except the log file names and
> matching patterns. Factor out the logic to the new class
> FioJobFileTest_LogFileFormat.
> 
> Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
> ---
>   t/jobs/t0034.fio   | 27 ++++++++++++++++++++++++
>   t/run-fio-tests.py | 51 +++++++++++++++++++++++++++++++++++++---------
>   2 files changed, 68 insertions(+), 10 deletions(-)
>   create mode 100644 t/jobs/t0034.fio
> 
> diff --git a/t/jobs/t0034.fio b/t/jobs/t0034.fio
> new file mode 100644
> index 00000000..ca71b775
> --- /dev/null
> +++ b/t/jobs/t0034.fio
> @@ -0,0 +1,27 @@
> +[global]
> +rw=read
> +filename=t0034file
> +size=8k
> +time_based
> +runtime=100ms
> +ioengine=libaio
> +iodepth=1
> +
> +[job1]
> +write_lat_log=log
> +log_offset=1
> +log_issue_time=1
> +
> +[job2]
> +write_lat_log=log
> +log_offset=1
> +log_issue_time=1
> +log_avg_msec=20
> +log_window_value=both
> +
> +[job3]
> +write_lat_log=log
> +write_bw_log=log
> +write_iops_log=log
> +log_offset=1
> +log_issue_time=1
> diff --git a/t/run-fio-tests.py b/t/run-fio-tests.py
> index 8bc343cd..525f78ff 100755
> --- a/t/run-fio-tests.py
> +++ b/t/run-fio-tests.py
> @@ -554,29 +554,50 @@ class FioJobFileTest_t0029(FioJobFileTest):
>           if self.json_data['jobs'][1]['read']['io_kbytes'] != 8:
>               self.passed = False
>   
> -class FioJobFileTest_t0033(FioJobFileTest):
> +class FioJobFileTest_LogFileFormat(FioJobFileTest):
>       """Test log file format"""
> +    def setup(self, *args, **kws):
> +        super().setup(*args, **kws)
> +        self.patterns = {}
> +
>       def check_result(self):
>           super().check_result()
>   
>           if not self.passed:
>               return
>   
> -        patterns = {
> +        for logfile in self.patterns.keys():
> +            file_path = os.path.join(self.paths['test_dir'], logfile)
> +            with open(file_path, "r") as f:
> +                line = f.readline()
> +                if not re.match(self.patterns[logfile], line):
> +                    self.passed = False
> +                    self.failure_reason = "wrong log file format: " + logfile
> +                    return
> +
> +class FioJobFileTest_t0033(FioJobFileTest_LogFileFormat):
> +    """Test log file format"""
> +    def setup(self, *args, **kws):
> +        super().setup(*args, **kws)
> +        self.patterns = {
>               'log_bw.1.log': '\\d+, \\d+, \\d+, \\d+, 0x[\\da-f]+\\n',
>               'log_clat.2.log': '\\d+, \\d+, \\d+, \\d+, 0, \\d+\\n',
>               'log_iops.3.log': '\\d+, \\d+, \\d+, \\d+, \\d+, 0x[\\da-f]+\\n',
>               'log_iops.4.log': '\\d+, \\d+, \\d+, \\d+, 0, 0, \\d+\\n',
>           }
>   
> -        for logfile in patterns.keys():
> -            file_path = os.path.join(self.paths['test_dir'], logfile)
> -            with open(file_path, "r") as f:
> -                line = f.readline()
> -                if not re.match(patterns[logfile], line):
> -                    self.passed = False
> -                    self.failure_reason = "wrong log file format: " + logfile
> -                    return
> +class FioJobFileTest_t0034(FioJobFileTest_LogFileFormat):
> +    """Test log file format"""
> +    def setup(self, *args, **kws):
> +        super().setup(*args, **kws)
> +        self.patterns = {
> +            'log_clat.1.log': '\\d+, \\d+, \\d+, \\d+, \\d+, \\d+, \\d+\\n',
> +            'log_slat.1.log': '\\d+, \\d+, \\d+, \\d+, \\d+, \\d+, \\d+\\n',
> +            'log_lat.1.log': '\\d+, \\d+, \\d+, \\d+, \\d+, \\d+, 0\\n',
> +            'log_clat.2.log': '\\d+, \\d+, \\d+, \\d+, 0, 0, \\d+, 0\\n',
> +            'log_bw.3.log': '\\d+, \\d+, \\d+, \\d+, \\d+, \\d+, 0\\n',
> +            'log_iops.3.log': '\\d+, \\d+, \\d+, \\d+, \\d+, \\d+, 0\\n',
> +        }
>   
>   class FioJobFileTest_iops_rate(FioJobFileTest):
>       """Test consists of fio test job t0011
> @@ -913,6 +934,16 @@ TEST_LIST = [
>           'pre_success':      SUCCESS_DEFAULT,
>           'requirements':     [],
>       },
> +    {
> +        'test_id':          34,
> +        'test_class':       FioJobFileTest_t0034,
> +        'job':              't0034.fio',
> +        'success':          SUCCESS_DEFAULT,
> +        'pre_job':          None,
> +        'pre_success':      None,
> +        'pre_success':      SUCCESS_DEFAULT,
> +        'requirements':     [],

[Requirements.linux, Requirements.libaio] is needed here as well.

