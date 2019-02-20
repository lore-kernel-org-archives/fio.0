Return-Path: <bart.vanassche@gmail.com>
Return-Path: <bart.vanassche@gmail.com>
Message-ID: <1550678772.93548.23.camel@acm.org>
Subject: Re: [PATCH 4/8] t/zbd: Fix test 2 and 3 result handling
From: Bart Van Assche <bvanassche@acm.org>
Date: Wed, 20 Feb 2019 08:06:12 -0800
In-Reply-To: <20190220071725.8487-5-damien.lemoal@wdc.com>
References: <20190220071725.8487-1-damien.lemoal@wdc.com>
	 <20190220071725.8487-5-damien.lemoal@wdc.com>
Content-Type: text/plain; charset="UTF-7"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
To: Damien Le Moal <damien.lemoal@wdc.com>, fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: Matias Bjorling <matias.bjorling@wdc.com>, Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>, Dmitry Fomichev <dmitry.fomichev@wdc.com>
List-ID: <fio@vger.kernel.org>

On Wed, 2019-02-20 at 16:17 +-0900, Damien Le Moal wrote:
+AD4 Removal of the message +ACI-No I/O performed+ACI when fio does not execute any
+AD4 I/O broke zbd tests 2 and 3 as this message is looked after to test for
+AD4 success. Fix this by looking for a +ACI-Run status+ACI line starting with
+AD4 +ACI-WRITE:+ACI for test 2 and +ACI-READ:+ACI for test 3. The run status lines are not
+AD4 printed when no I/O is performed. Testing for the absence of these
+AD4 strings thus allows to easily test if I/Os where executed or not.
+AD4 
+AD4 Fixes: ff3aa922570c (+ACI-Kill +ACI-No I/O performed by ...+ACI message+ACI)
+AD4 Signed-off-by: Damien Le Moal +ADw-damien.lemoal+AEA-wdc.com+AD4
+AD4 ---
+AD4  t/zbd/test-zbd-support +AHw 12 +-+-+-+-+-+-------
+AD4  1 file changed, 6 insertions(+-), 6 deletions(-)
+AD4 
+AD4 diff --git a/t/zbd/test-zbd-support b/t/zbd/test-zbd-support
+AD4 index d316d880..c6391169 100755
+AD4 --- a/t/zbd/test-zbd-support
+AD4 +-+-+- b/t/zbd/test-zbd-support
+AD4 +AEAAQA -141,9 +-141,9 +AEAAQA test2() +AHs
+AD4      if +AFs -z +ACIAJA-is+AF8-zbd+ACI +AF0AOw then
+AD4  	opts+-+AD0(+ACI---zonesize+AD0AJAB7-zone+AF8-size+AH0AIg)
+AD4      fi
+AD4 -    run+AF8-fio +ACIAJAB7-opts+AFsAQABdAH0AIg 2+AD4AJg-1 +AHw
+AD4 -	tee -a +ACIAJAB7-logfile+AH0.+ACQAew-test+AF8-number+AH0AIg +AHw
+AD4 -	grep -q 'No I/O performed'
+AD4 +-    run+AF8-fio +ACIAJAB7-opts+AFsAQABdAH0AIg +AD4APg +ACIAJAB7-logfile+AH0.+ACQAew-test+AF8-number+AH0AIg 2+AD4AJg-1 +AHwAfA return +ACQ?
+AD4 +-    grep -q 'WRITE:' +ACIAJAB7-logfile+AH0.+ACQAew-test+AF8-number+AH0AIg
+AD4 +-    +AFs +ACQ? +ACEAPQ 0 +AF0
+AD4  +AH0

Can the last two lines be changed into the following single line?

+ACE grep -q 'WRITE:' +ACIAJAB7-logfile+AH0.+ACQAew-test+AF8-number+AH0AIg

Thanks,

Bart.

