Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5C7AC433F5
	for <fio@archiver.kernel.org>; Thu,  3 Feb 2022 01:47:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235064AbiBCBrD (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 2 Feb 2022 20:47:03 -0500
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:65403 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230436AbiBCBrC (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 2 Feb 2022 20:47:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1643852822; x=1675388822;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=51k7B6+fQ/jNOdJPAdzCAcwtMMoAmNhOAGJ0+ROPErM=;
  b=q6rFIiQdOFRhaDgoPRioPu3jbkFs0XIxS961K9FVG3/CszK6uZlyioGY
   6IAEK3lMTzXzKOFg1TCuaz/FPe5VDQTm/kWPj8lA4IExCpfhpk7+5Ri/r
   db2QnV1ZlGn0YEGirsFcQocGPOXycf7bN92LcmKjiJTf+54J27R9VY2ch
   0sxi46SjXYCzwm5qqzKUL+0kWkJ0L+3bdPDejEXyHVomqKbjqcz5rhcsZ
   XOk8ekACtuaBNrOqKJFp9BbPS2eZ2T8XPPsGdbK/OPfdSqsUHaorKPuco
   abjwaYnHq0qkM9mGaYS8JRa2HJOF1rsl67jWTESc1P1HoEgVQdKz3Nsl8
   g==;
X-IronPort-AV: E=Sophos;i="5.88,338,1635177600"; 
   d="scan'208";a="192031060"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 03 Feb 2022 09:47:01 +0800
IronPort-SDR: G/oTHXGbyuNZF8Je3JfXyKMZTLdsZK8pTvPKhicLjyZQC8kKWSJyDdQztFR/VkEATTUabQ5xEI
 fPGMEhwwqKLbwCH7yYFWtZrih2KyYZgywjG5UNb+8lpFI24L5/SIvSEHVHdJbZl7QU2Yppb0ms
 3hA7iC/9/SADbTCnDraMmGN2BfDS4wPOU86D2IrIJA22HTaj0V1qu+gSfC+e32+HowBzV1shBn
 V3b0vSGlD//UFfUn/aHlmpnwLSJ4euFCu/PNL9kfmusfsU1fNBL/dxsXCblyowFO5pk5NJUyc/
 BQk8f1nwpOtT/jg/Y/E8fmPg
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2022 17:18:58 -0800
IronPort-SDR: DqrIweV0O7Rzv+/4ISoXxwUoJBMDBWPzig26FzBw2KWXczbnhzB76rR4nHafhDwEcoVHrOKHun
 /iWswq5z1hVLpY2jwU4wbBQqTq3U+1difoqz3iCTMRGzEtRMriZggxJdHW8NzsTDXnYMb4ldkI
 WBXuZ6JipoZ3E7L8AMdAAEL36iytqjcvEL6o/dbRkq895U7iCWfWU8i5LIhgWP9q7aaOZ8cPPY
 GSkIp+DTr4kD7oOhC+sOYPOqGdd51rVJ1c0a5FmBl3TklhE3LpW7uYr6MFxdpcWLPTqcCY7JGC
 whg=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2022 17:47:03 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4Jq1kF5pzjz1SVnx
        for <fio@vger.kernel.org>; Wed,  2 Feb 2022 17:47:01 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1643852821; x=1646444822; bh=51k7B6+fQ/jNOdJPAdzCAcwtMMoAmNhOAGJ
        0+ROPErM=; b=PgyXr44rdx2ylRX1zb2xdgg3IWwt7jUfG35iQKWLOLDOzBkW8aT
        xQFqYGzAfVTn4JVqW4FyxFZjR7V7s/58bB4BEaLv3H3I9xSRFFCZxxb5BlMvjZHS
        t8u4a0joQwi4qJ/f1CGfaI6aW1eqPSoUjpLsYlTsZiVnQrPKfhWZHcrI8B8hC7R0
        Vek5I32Is0wSikHoukz5skExQQ4LlsLhk4AphEAp7wt889uJB64b6bmS/nUETllh
        uayTKsrtWu3tA3qB1PTu+S08nRY4k1Yai2NzjSZ3mpc+fy8K4d6IvcEa+v4kxNhe
        F0VzS5GG7IIOtQnN3xfx3xpNR+T3YPIwlbQ==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id WSp1BNZOVmny for <fio@vger.kernel.org>;
        Wed,  2 Feb 2022 17:47:01 -0800 (PST)
Received: from [10.225.163.63] (unknown [10.225.163.63])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4Jq1kD2xMVz1Rwrw;
        Wed,  2 Feb 2022 17:47:00 -0800 (PST)
Message-ID: <9a2f221c-d44a-aa03-ddf1-2ef494e42aa1@opensource.wdc.com>
Date:   Thu, 3 Feb 2022 10:46:59 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH 17/17] t/latency_percentiles.py: add tests for the new
 cmdprio_bssplit format
Content-Language: en-US
To:     Niklas Cassel <Niklas.Cassel@wdc.com>,
        "axboe@kernel.dk" <axboe@kernel.dk>
Cc:     "fio@vger.kernel.org" <fio@vger.kernel.org>
References: <20220131211249.106820-1-Niklas.Cassel@wdc.com>
 <20220131211249.106820-18-Niklas.Cassel@wdc.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <20220131211249.106820-18-Niklas.Cassel@wdc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On 2/1/22 06:13, Niklas Cassel wrote:
> From: Niklas Cassel <niklas.cassel@wdc.com>
> 
> Add two new test cases for the new cmdprio_bssplit format.
> 
> While at it, fixup some small typos in the existing code.
> 
> Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
> ---
>  t/latency_percentiles.py | 93 ++++++++++++++++++++++++++++++++--------
>  1 file changed, 75 insertions(+), 18 deletions(-)
> 
> diff --git a/t/latency_percentiles.py b/t/latency_percentiles.py
> index 62c4cc91..9e37d9fe 100755
> --- a/t/latency_percentiles.py
> +++ b/t/latency_percentiles.py
> @@ -126,7 +126,8 @@ class FioLatTest():
>              "--output-format={output-format}".format(**self.test_options),
>          ]
>          for opt in ['slat_percentiles', 'clat_percentiles', 'lat_percentiles',
> -                    'unified_rw_reporting', 'fsync', 'fdatasync', 'numjobs', 'cmdprio_percentage']:
> +                    'unified_rw_reporting', 'fsync', 'fdatasync', 'numjobs',
> +                    'cmdprio_percentage', 'bssplit', 'cmdprio_bssplit']:
>              if opt in self.test_options:
>                  option = '--{0}={{{0}}}'.format(opt)
>                  fio_args.append(option.format(**self.test_options))
> @@ -761,7 +762,7 @@ class Test008(FioLatTest):
>          job = self.json_data['jobs'][0]
>  
>          retval = True
> -        if 'read' in job or 'write'in job or 'trim' in job:
> +        if 'read' in job or 'write' in job or 'trim' in job:
>              print("Unexpected data direction found in fio output")
>              retval = False
>          if not self.check_nocmdprio_lat(job):
> @@ -953,7 +954,7 @@ class Test019(FioLatTest):
>          job = self.json_data['jobs'][0]
>  
>          retval = True
> -        if 'read' in job or 'write'in job or 'trim' in job:
> +        if 'read' in job or 'write' in job or 'trim' in job:
>              print("Unexpected data direction found in fio output")
>              retval = False
>  
> @@ -963,6 +964,27 @@ class Test019(FioLatTest):
>          return retval
>  
>  
> +class Test021(FioLatTest):
> +    """Test object for Test 21."""
> +
> +    def check(self):
> +        """Check Test 21 output."""
> +
> +        job = self.json_data['jobs'][0]
> +
> +        retval = True
> +        if not self.check_empty(job['trim']):
> +            print("Unexpected trim data found in output")
> +            retval = False
> +
> +        retval &= self.check_latencies(job['read'], 0, slat=False, tlat=False, plus=True)
> +        retval &= self.check_latencies(job['write'], 1, slat=False, tlat=False, plus=True)
> +        retval &= self.check_prio_latencies(job['read'], clat=True, plus=True)
> +        retval &= self.check_prio_latencies(job['write'], clat=True, plus=True)
> +
> +        return retval
> +
> +
>  def parse_args():
>      """Parse command-line arguments."""
>  
> @@ -1007,7 +1029,7 @@ def main():
>              # randread, null
>              # enable slat, clat, lat
>              # only clat and lat will appear because
> -            # because the null ioengine is syncrhonous
> +            # because the null ioengine is synchronous
>              "test_id": 1,
>              "runtime": 2,
>              "output-format": "json",
> @@ -1047,7 +1069,7 @@ def main():
>          {
>              # randread, aio
>              # enable slat, clat, lat
> -            # all will appear because liaio is asynchronous
> +            # all will appear because libaio is asynchronous
>              "test_id": 4,
>              "runtime": 5,
>              "output-format": "json+",
> @@ -1153,9 +1175,9 @@ def main():
>              # randread, null
>              # enable slat, clat, lat
>              # only clat and lat will appear because
> -            # because the null ioengine is syncrhonous
> -            # same as Test 1 except
> -            # numjobs = 4 to test sum_thread_stats() changes
> +            # because the null ioengine is synchronous
> +            # same as Test 1 except add numjobs = 4 to test
> +            # sum_thread_stats() changes
>              "test_id": 12,
>              "runtime": 2,
>              "output-format": "json",
> @@ -1170,9 +1192,9 @@ def main():
>          {
>              # randread, aio
>              # enable slat, clat, lat
> -            # all will appear because liaio is asynchronous
> -            # same as Test 4 except
> -            # numjobs = 4 to test sum_thread_stats() changes
> +            # all will appear because libaio is asynchronous
> +            # same as Test 4 except add numjobs = 4 to test
> +            # sum_thread_stats() changes
>              "test_id": 13,
>              "runtime": 5,
>              "output-format": "json+",
> @@ -1187,8 +1209,8 @@ def main():
>          {
>              # 50/50 r/w, aio, unified_rw_reporting
>              # enable slat, clat, lata
> -            # same as Test 8 except
> -            # numjobs = 4 to test sum_thread_stats() changes
> +            # same as Test 8 except add numjobs = 4 to test
> +            # sum_thread_stats() changes
>              "test_id": 14,
>              "runtime": 5,
>              "output-format": "json+",
> @@ -1204,7 +1226,7 @@ def main():
>          {
>              # randread, aio
>              # enable slat, clat, lat
> -            # all will appear because liaio is asynchronous
> +            # all will appear because libaio is asynchronous
>              # same as Test 4 except add cmdprio_percentage
>              "test_id": 15,
>              "runtime": 5,
> @@ -1278,8 +1300,8 @@ def main():
>          {
>              # 50/50 r/w, aio, unified_rw_reporting
>              # enable slat, clat, lat
> -            # same as Test 19 except
> -            # add numjobs = 4 to test sum_thread_stats() changes
> +            # same as Test 19 except add numjobs = 4 to test
> +            # sum_thread_stats() changes
>              "test_id": 20,
>              "runtime": 5,
>              "output-format": "json+",
> @@ -1293,6 +1315,40 @@ def main():
>              'numjobs': 4,
>              "test_obj": Test019,
>          },
> +        {
> +            # r/w, aio
> +            # enable only clat
> +            # test bssplit and cmdprio_bssplit
> +            "test_id": 21,
> +            "runtime": 5,
> +            "output-format": "json+",
> +            "slat_percentiles": 0,
> +            "clat_percentiles": 1,
> +            "lat_percentiles": 0,
> +            "ioengine": aio,
> +            'rw': 'randrw',
> +            'bssplit': '64k/40:1024k/60',
> +            'cmdprio_bssplit': '64k/25/1/1:64k/75/3/2:1024k/0',
> +            "test_obj": Test021,
> +        },
> +        {
> +            # r/w, aio
> +            # enable only clat
> +            # same as Test 21 except add numjobs = 4 to test
> +            # sum_thread_stats() changes
> +            "test_id": 22,
> +            "runtime": 5,
> +            "output-format": "json+",
> +            "slat_percentiles": 0,
> +            "clat_percentiles": 1,
> +            "lat_percentiles": 0,
> +            "ioengine": aio,
> +            'rw': 'randrw',
> +            'bssplit': '64k/40:1024k/60',
> +            'cmdprio_bssplit': '64k/25/1/1:64k/75/3/2:1024k/0',
> +            'numjobs': 4,
> +            "test_obj": Test021,
> +        },
>      ]
>  
>      passed = 0
> @@ -1304,9 +1360,10 @@ def main():
>             (args.run_only and test['test_id'] not in args.run_only):
>              skipped = skipped + 1
>              outcome = 'SKIPPED (User request)'
> -        elif (platform.system() != 'Linux' or os.geteuid() != 0) and 'cmdprio_percentage' in test:
> +        elif (platform.system() != 'Linux' or os.geteuid() != 0) and \
> +             ('cmdprio_percentage' in test or 'cmdprio_bssplit' in test):
>              skipped = skipped + 1
> -            outcome = 'SKIPPED (Linux root required for cmdprio_percentage tests)'
> +            outcome = 'SKIPPED (Linux root required for cmdprio tests)'
>          else:
>              test_obj = test['test_obj'](artifact_root, test, args.debug)
>              status = test_obj.run_fio(fio)

Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>



-- 
Damien Le Moal
Western Digital Research
